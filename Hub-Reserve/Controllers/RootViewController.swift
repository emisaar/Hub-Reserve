//
//  RootViewController.swift
//  Hub-Reserve
//
//  Created by Emi Saucedo on 17/09/22.
//

import UIKit

class RootViewController: UIViewController {
    
    var pages : [View] {
        get {
            let page1: View = Bundle.main.loadNibNamed("View", owner: self, options: nil)?.first as! View
            page1.headerLabel.text = "Acerca del Hub de Ciberseguridad"
            page1.image.image = UIImage(named: "SH1")
            page1.text.text = "El Hub de Ciberseguridad del Tecnológico de Monterrey abona a la visión estratégica rumbo al 2030, que busca el florecimiento humano a través del liderazgo, el emprendimiento y la innovación. Además, suma al modelo educativo Tec21 para formar a líderes con los valores y competencias necesarias para resolver los retos y capturar las oportunidades que tendremos en el siglo XXI."
            
            let page2: View = Bundle.main.loadNibNamed("View", owner: self, options: nil)?.first as! View
            page2.headerLabel.text = "El Hub como plataforma de trabajo"
            page2.image.image = UIImage(named: "SH2")
            page2.text.text = "El Hub forma parte de la Escuela de Ingeniería y Ciencias, cuenta con una superficie de 278 metros cuadrado. Con una muy prominente presencia tanto en México como en Latinoamérica con el Hub de Ciberseguridad nos hemos presentado como una plataforma de trabajo abierta interactiva colaborativa multi organizacional"
            
            let page3: View = Bundle.main.loadNibNamed("View", owner: self, options: nil)?.first as! View
            page3.headerLabel.text = "Espacios especializados"
            page3.image.image = UIImage(named: "SH3")
            page3.text.text = "Contará con espacios especializados como el cyberlink, laboratorio de ciberseguridad en internet de las cosas, un área de emprendimiento, para incentivar la innovación y generación de conocimiento, así como una incubadora de empresas."
            
            let page4: View = Bundle.main.loadNibNamed("View", owner: self, options: nil)?.first as! View
            page4.headerLabel.text = "Objetivo y Visión"
            page4.image.image = UIImage(named: "SH4")
            page4.text.text = "Brindar soporte para organizaciones que demandan salvaguarda en sus redes de información estratégica y que lo hace a través de programas de innovación tecnológica de consultoría de capacitación. Es por ello que en el Tec hemos apostado en desarrollar recursos y capital humano en esta disciplina qué tanta demanda tiene la actualidad y que estamos seguros se va expandir hacia el futuro."
            
            return [page1, page2, page3, page4]
        }
    }
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.bringSubviewToFront(pageControl)
        
        setUpScrollView(pages: pages)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
    }
    
    func setUpScrollView(pages: [View]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(pages.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< pages.count {
            pages[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(pages[i])
        }
    }
}

extension RootViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
}
