//
//  ViewController.swift
//  test
//
//  Created by 李能 on 15/10/13.
//  Copyright © 2015年 李能. All rights reserved.
//

import UIKit


struct ScreenSize
{
    let width  = UIScreen.mainScreen().bounds.size.width
    let height = UIScreen.mainScreen().bounds.size.height
    func min(x:CGFloat,y:CGFloat) ->CGFloat
    {
        return x > y ? y:x
    }
}

struct Edges
{
    let left:CGFloat = 20
    let right:CGFloat = 20
    let bottom:CGFloat = 100
}


class ViewController: UIViewController,UIScrollViewDelegate {

    var buttonHeight:CGFloat = 0
    var scrollView           = UIScrollView()
    var scrollBgView         = UIView()
    var pageControl          = UIPageControl()
    var bgImageArr           = []
    var buttonImageArr       = []
    var bigImageArr          = []
    var scrollImage          = []
    var backgroundImage1     = UIImageView()
    var backgroundImage2     = UIImageView()
    let screenSize           = ScreenSize()
    let edge                 = Edges()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "嘿嘿嘿嘿"
        self.preferredStatusBarStyle()
        self.initDataSource()
        self.creatTheButton()
        self.initScoll()
    
    }
    private func initDataSource()
    {
        buttonImageArr = ["strokeImg.png","waveImg.png","appleImg.png","cherriesImg.png","snowflakeImg.png"]
        
        bgImageArr = ["purplebg.png","bluebg.png","redbg.png","lightRedbg.png","graybg.png"]
        
        bigImageArr = ["strokeBigImg.png","waveBigImg.png","appleBigImg.png","cherriesBigImg.png","snowflakeBigImg.png"]
        scrollImage = ["light1@2x.png","light2@2x.png","light3@2x.png","light4@2x.png","light5@2x.png"]
        buttonHeight = (screenSize.height - 64) / CGFloat(buttonImageArr.count)
    }
    private func creatTheButton()
    {
        for var i = 0;i < buttonImageArr.count;i++
        {
            let bgImageView = UIImageView(frame: CGRect(x: 0, y: buttonHeight * CGFloat (i), width: screenSize.width, height: buttonHeight))
            bgImageView.image = UIImage(named: bgImageArr[i] as! String)
            self.view.addSubview(bgImageView)
            
            let btn = UIButton(type: UIButtonType.Custom)
            btn.frame = CGRect(x:0, y: buttonHeight * CGFloat (i) , width: screenSize.width, height: buttonHeight)
            btn.setImage(UIImage(named: buttonImageArr[i] as! String), forState: UIControlState.Normal)
            btn.tag = i + 10
            btn.addTarget(self, action: "buttonResponse:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(btn)
        }
        
    }
    private func initScoll()
    {
        scrollBgView = UIView(frame: self.view.bounds)
        scrollBgView.backgroundColor = UIColor.blackColor()
        self.view .addSubview(scrollBgView)
        backgroundImage1 = UIImageView(frame: scrollBgView.frame)
        backgroundImage1.contentMode = UIViewContentMode.ScaleAspectFill
        self.scrollBgView.addSubview(backgroundImage1)
        backgroundImage2 = UIImageView(frame: scrollBgView.frame)
        backgroundImage2.contentMode = UIViewContentMode.ScaleAspectFill
        self.scrollBgView.addSubview(backgroundImage2)
        
        scrollView = UIScrollView(frame: scrollBgView.frame)
        scrollView.backgroundColor = UIColor.clearColor()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.contentSize = CGSize(width: bigImageArr.count * Int(screenSize.width), height: Int(screenSize.height))
        scrollView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "handleTap:"))
        self.scrollBgView.addSubview(scrollView)
        self.initBigImage()
        
        
        pageControl = UIPageControl(frame: CGRect(x: edge.left, y: screenSize.height - edge.bottom, width: screenSize.width - edge.left * 2.0, height: 20))
        pageControl.numberOfPages = scrollImage.count
        self.scrollBgView.addSubview(pageControl)
        scrollBgView.hidden = true
        
        
        self.checkShow()
    }
    private func initBigImage()
    {
        for var i = 0;i < bigImageArr.count;i++
        {
//          可以添加其他的自定义的view
            let imageView = UIView()
            imageView.backgroundColor = UIColor .clearColor()
            imageView.frame = CGRectOffset(scrollView.frame, CGFloat(i) * scrollView.frame.size.width, 0)
            self.scrollView.addSubview(imageView)
        }
    }
    
    func buttonResponse(sender:UIButton)
    {
        scrollBgView.hidden = false
        self.scrollView.contentOffset = CGPoint(x: CGFloat(sender.tag - 10) * scrollView.frame.size.width, y: 0)
        self.pageControl.currentPage = sender.tag - 10
    }

    func handleTap(gesture:UITapGestureRecognizer)
    {
        scrollBgView.hidden = true
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        self.checkShow()
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        self.checkShow()
    }
    
    func checkShow()
    {
//      pageController 分开控制是为了保证滑动结束的时候换页而不是滑动就开始换页
        let currentIndex = Int(self.scrollView.contentOffset.x / scrollView.frame.size.width)
        
        backgroundImage1.image = UIImage(named: scrollImage[currentIndex] as! String)
        
        if currentIndex == scrollImage.count - 1
        {
            backgroundImage2.image = nil
        }
        else
        {
            backgroundImage2.image = UIImage(named: scrollImage[currentIndex + 1] as! String)
        }
        
        var offset:CGFloat = scrollView.contentOffset.x - CGFloat(currentIndex) * scrollView.frame.size.width
        if offset < 0
        {
            offset = scrollView.frame.size.width - screenSize.min(-offset, y: scrollView.frame.size.width);
            self.pageControl.currentPage = 0
            backgroundImage2.alpha = 0;
            backgroundImage1.alpha = (offset / scrollView.frame.size.width);

        }
        else if offset == 0
        {
            backgroundImage1.alpha = 1.0
            backgroundImage2.alpha = 0.0
            self.pageControl.currentPage = currentIndex
        }
        else
        {
            if currentIndex == scrollImage.count - 1
            {
                backgroundImage1.alpha = 1.0 - (offset / scrollView.frame.size.width)
                self.pageControl.currentPage = scrollImage.count - 1
            }
            else
            {
                backgroundImage2.alpha = offset / scrollView.frame.size.width;
                backgroundImage1.alpha = 1.0 - backgroundImage2.alpha;
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

