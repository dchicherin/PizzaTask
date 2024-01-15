//
//  ViewController.swift
//  PizzaApp
//
//  Created by Dmitry Chicherin on 12/1/2567 BE.
//

import UIKit


protocol ViewControllerOutput {
    func updateInfo(menuItems: [MenuItem])
    func updateRowImage(menuPositionForImage: MenuItem, image: UIImage)
    func scrollToCategory(indexPath: IndexPath)
    func setHeightAndSpace(newSpacer: CGFloat, newHeight: CGFloat)
}

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var interactor: ViewInteractorInput?
    //Баннеры-плейсхолддеры
    private var banners: [Banner] = [Banner(), Banner()]
    //Порядок категорий
    let mapping: [String: Int] = ["pizza": 0, "combo": 1, "desert": 2, "drink": 3]
    //Данные для заполнения
    private var menuItems = [MenuItem]()
    var imagesDict: [Int: UIImage] = [:]
    //Изменяемыйе констрейны
    var heightConstrain: NSLayoutConstraint?
    var bottomConstraint: NSLayoutConstraint?
    //Текущая категория
    private var checkedCategory = 0
    
    
    /*       Создание элементов          */
    
    
    let tabsBarController: UITabBarController = {
        let tabsBarController = UITabBarController()
        //Создание иконок для таббара
        let items: [UITabBarItem] = [
            UITabBarItem(title: "Меню", image: UIImage(systemName: "takeoutbag.and.cup.and.straw.fill"), tag: 0),
            UITabBarItem(title: "Контакты", image: UIImage(systemName: "heart"), tag: 1),
            UITabBarItem(title: "Профиль", image: UIImage(systemName: "person"), tag: 2),
            UITabBarItem(title: "Корзина", image: UIImage(systemName: "basket.fill"), tag: 3)
        ]
        
        // Настройка цветов и стиля
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.foregroundColor: Constants.shared.redColor
        ]
        for item in items {
            item.setTitleTextAttributes(selectedAttributes, for: .selected)
        }
        tabsBarController.tabBar.tintColor = Constants.shared.redColor
        
        tabsBarController.viewControllers = [UIViewController(), UIViewController(), UIViewController(), UIViewController()]
        for (index, item) in items.enumerated() {
            tabsBarController.viewControllers?[index].tabBarItem = item
        }
        var tabBar = tabsBarController.tabBar
        //Настройка тени
        tabBar.layer.shadowColor = UIColor.black.cgColor
        tabBar.layer.shadowOpacity = 0.2
        tabBar.layer.shadowOffset = CGSize.zero
        tabBar.layer.shadowRadius = 2
        tabBar.layer.borderColor = UIColor.clear.cgColor
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = UIColor.white
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().backgroundImage = UIImage()
        return tabsBarController
    }()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = Constants.shared.tableViewBackgroundColor
        //Настройка таблицы
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = Constants.shared.tableCornerRadius
        tableView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        return tableView
    }()
    
    private let collectionView: UICollectionView = {
        //Коллекция с банерами
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = Constants.shared.backgroundColor
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets.zero
        return collectionView
    }()
    

    lazy private var scrollView: UIScrollView = {
        //Scrollview с кнопками для выбора категорий
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsHorizontalScrollIndicator = true
        scrollView.isScrollEnabled = true
        scrollView.isDirectionalLockEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInset = .zero
        // Создание и добавление кнопок
        let labels = ["Пицца", "Комбо", "Десерты", "Напитки"]
        var previousButton: UIButton?
        for (index, text) in labels.enumerated() {
            let button = UIButton()
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setTitle(text, for: .normal)
            button.setTitleColor(Constants.shared.bleakRedColor, for: .normal)
            button.backgroundColor = .clear
            button.layer.cornerRadius = CGFloat(Constants.shared.categoryButtonsHeight / 2)
            button.layer.borderWidth = 1
            button.layer.borderColor = Constants.shared.bleakRedColor.cgColor
            button.titleLabel?.font = UIFont.systemFont(ofSize: Constants.shared.smallTextSize)
            scrollView.addSubview(button)

            //Констрейны для кнопок
            button.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
            button.heightAnchor.constraint(equalToConstant: CGFloat(Constants.shared.categoryButtonsHeight)).isActive = true
            button.widthAnchor.constraint(equalToConstant: CGFloat(Constants.shared.categoryButtonWidth)).isActive = true
            //Отступ 16 справа по умолчанию
            if let previousButton = previousButton {
                button.leadingAnchor.constraint(equalTo: previousButton.trailingAnchor, constant: 8).isActive = true
            } else {
                button.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16).isActive = true
            }
            previousButton = button

            // Установка цвета для первой категории
            if index == checkedCategory {
                button.setTitleColor(Constants.shared.redColor, for: .normal)
                button.layer.borderColor = Constants.shared.redColor.cgColor
                button.backgroundColor = Constants.shared.redBGColor
                button.layer.borderWidth = 0
            }

            // Установка действия для подстветки и скролла
            button.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
            button.tag = index
        }
        return scrollView
    }()

    private let dropdownControl: UIButton = {
        
        //Дропдаун с выбором города
        let dropdownControl = UIButton()
        dropdownControl.setTitle("Москва ", for: .normal)
        dropdownControl.setTitleColor(.black, for: .normal)
        dropdownControl.titleLabel?.font = UIFont.systemFont(ofSize: Constants.shared.bigTextSize) 
        dropdownControl.contentHorizontalAlignment = .left
        dropdownControl.translatesAutoresizingMaskIntoConstraints = false
        dropdownControl.heightAnchor.constraint(equalToConstant: Constants.shared.dropdownControlHeight).isActive = true
        dropdownControl.widthAnchor.constraint(equalToConstant: Constants.shared.dropdownControlWidth).isActive = true
        dropdownControl.addTarget(self, action: #selector(showDropdownMenu), for: .touchUpInside)
        
        //Добавление картики справа
        let chevronImage = UIImage(systemName: "chevron.down")
        dropdownControl.tintColor = .black
        dropdownControl.setImage(chevronImage, for: .normal)
        dropdownControl.semanticContentAttribute = .forceRightToLeft
        return dropdownControl
    }()
    
    
    /* Функционал кнопок */

    @objc func showDropdownMenu() {
        //Выбор из 2 городов в стандартом системном меню и установка его в дропдаун
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let moscowAction = UIAlertAction(title: "Москва", style: .default) { _ in
            self.dropdownControl.setTitle("Москва ", for: .normal)
        }
        alertController.addAction(moscowAction)
        let stPetersburgAction = UIAlertAction(title: "Санкт-Петербург", style: .default) { _ in
            self.dropdownControl.setTitle("Санкт-Петербург ", for: .normal)
        }
        alertController.addAction(stPetersburgAction)
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = dropdownControl
            popoverController.sourceRect = dropdownControl.bounds
        }
        present(alertController, animated: true, completion: nil)
    }
    
    @objc private func buttonClicked(_ sender: UIButton) {
        checkedCategory = sender.tag
        //Перекрашивание кнопок
        for subview in scrollView.subviews {
            if let button = subview as? UIButton {
                if button.tag == checkedCategory {
                    button.setTitleColor(Constants.shared.redColor, for: .normal)
                    button.layer.borderColor = Constants.shared.redColor.cgColor
                    button.backgroundColor = Constants.shared.redBGColor
                    button.layer.borderWidth = 0
                } else {
                    button.setTitleColor(Constants.shared.bleakRedColor, for: .normal)
                    button.layer.borderColor = Constants.shared.bleakRedColor.cgColor
                    button.layer.borderWidth = 1
                    button.layer.backgroundColor = UIColor.clear.cgColor
                }
            }
        }
        //Скролл к нужной категории
        interactor?.initScrolling(tag: sender.tag, menuItems: self.menuItems)
    }
    
    override func viewDidLoad() {
        //Получение данных
        interactor?.fetchData()

        super.viewDidLoad()
        view.backgroundColor = Constants.shared.backgroundColor
        
        //Добавление таббара
        addChild(tabsBarController)
        view.addSubview(tabsBarController.view)
        tabsBarController.didMove(toParent: self)
        
        //Добавление дропдауна
        view.addSubview(dropdownControl)
        
        // Добавление баннеров
        view.addSubview(collectionView)
        
        // Регистрация карточки банера
        collectionView.register(BannerCell.self, forCellWithReuseIdentifier: "BannerCell")
        
        // Set collection view delegate and data source
        collectionView.delegate = self
        collectionView.dataSource = self
       
        //Добавление вью с категориями
        view.addSubview(scrollView)
        
        // Добавление и настройка таблицы
        view.addSubview(tableView)
        tableView.register(MenuTableCell.self, forCellReuseIdentifier: "MenuTableCell")
        //tableView.contentInset = UIEdgeInsets(top: 20,left: 0,bottom: 0,right: 0)
        tableView.dataSource = self
        tableView.delegate = self
        
        
        
        //Констрейны
        //Дропдаун
        dropdownControl.topAnchor.constraint(equalTo: view.topAnchor, constant: Constants.shared.topDistance).isActive = true
        dropdownControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.shared.leadingPadding).isActive = true
        
        //Банеры
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.shared.leadingPadding).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        heightConstrain = NSLayoutConstraint(item: collectionView, attribute: .height, relatedBy: .equal, toItem: .none, attribute: .notAnAttribute, multiplier: 1, constant: Constants.shared.collectionViewHeight)
        //Эти констрейны сделаны так чтобы динамически скрывать банеры
        bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .top, relatedBy: .equal, toItem: dropdownControl, attribute: .bottom, multiplier: 1, constant: Constants.shared.elementSpacing)
        view.addConstraint(bottomConstraint!)
        collectionView.addConstraint(heightConstrain!)
        
        //Кнопки категорий
        scrollView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: Constants.shared.elementSpacing).isActive = true
        scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalToConstant: Constants.shared.scrollViewHeight).isActive = true
        
        //Таблица
        tableView.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: Constants.shared.elementSpacing).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: tabsBarController.tabBar.topAnchor, constant: -2).isActive = true
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = CGSize(width: Constants.shared.scrollViewWidth, height: Constants.shared.scrollViewHeight)
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    //Настройка для коллеции с банерами
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return banners.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BannerCell", for: indexPath) as! BannerCell
        cell.configure(with: banners[indexPath.item])
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let widthPerItem = Constants.shared.collectionViewWidth
        return CGSize(width:Int(widthPerItem), height: Int(Constants.shared.collectionViewHeight))
        }
    
    
}
extension ViewController:  UITableViewDataSource, UITableViewDelegate {
    //Настройка работ таблицы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuTableCell", for: indexPath) as! MenuTableCell
        cell.configure(with: menuItems[indexPath.item], image: imagesDict[menuItems[indexPath.item].id])
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UITableView {
            interactor?.updateHeights(heightConstrain: heightConstrain!.constant, spacerContrant: bottomConstraint!.constant, offsetY: scrollView.contentOffset.y)
            //Подсветка нужной категории
            if !tableView.visibleCells.isEmpty {
                let cellsOnScreen = tableView.visibleCells as! [MenuTableCell]
                var categories = [Int]()
                for cell in cellsOnScreen {
                    categories.append(mapping[cell.type] ?? 0)
                }
                if !categories.contains(where: {$0 == checkedCategory}){
                    let firstVisibleCell = tableView.visibleCells.first as! MenuTableCell
                    let categoryNow = mapping[firstVisibleCell.type]!
                    //Перекрашивание кнопок
                    for subview in self.scrollView.subviews {
                        if let button = subview as? UIButton {
                            if button.tag == categoryNow {
                                button.setTitleColor(Constants.shared.redColor, for: .normal)
                                button.layer.borderColor = Constants.shared.redColor.cgColor
                                button.backgroundColor = Constants.shared.redBGColor
                                button.layer.borderWidth = 0
                            } else {
                                button.setTitleColor(Constants.shared.bleakRedColor, for: .normal)
                                button.layer.borderColor = Constants.shared.bleakRedColor.cgColor
                                button.layer.borderWidth = 1
                                button.layer.backgroundColor = UIColor.clear.cgColor
                            }
                        }
                    }
                    checkedCategory = categoryNow
                }
            }
        }
    }
}
extension ViewController: ViewControllerOutput{
    func updateInfo(menuItems: [MenuItem]){
        self.menuItems = menuItems
        tableView.reloadData()
    }
    func updateRowImage(menuPositionForImage: MenuItem, image: UIImage) {
        //Непсредственнно обновление строки
        self.imagesDict[menuPositionForImage.id] = image
        self.tableView.beginUpdates()
        let rowToUpdate = self.menuItems.firstIndex(where: {$0.id == menuPositionForImage.id})!
        let indexPosition = IndexPath(row: rowToUpdate, section: 0)
        self.tableView.reloadRows(at: [indexPosition], with: UITableView.RowAnimation.none)
        self.tableView.endUpdates()
    }
    func scrollToCategory(indexPath: IndexPath){
        tableView.scrollToRow(at: indexPath as IndexPath, at: .top, animated: true)
    }
    func setHeightAndSpace(newSpacer: CGFloat, newHeight: CGFloat){
        bottomConstraint!.constant = newSpacer
        heightConstrain!.constant = newHeight
    }
}
