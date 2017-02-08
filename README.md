# AttributedLabel
An attributed label using CoreText.
let login = TSAttributedLabel(frame: CGRectMake(20, 50, 300, 60))
        
        login.numberOfLines = 1
        
        let loginText: NSString = "已有账号，立即登录"
        
        let loginLinkText = "立即登录"
        
        login.textAlignment = .Center
        
        login.setText(loginText as String)
        
        login.addCustomLink(loginLinkText, forRange: loginText.rangeOfString(loginLinkText))
        
        view.addSubview(login)
        
        login.delegate = self
        
        let pro = TSAttributedLabel(frame: CGRectMake(20, 150, 300, 60))
        
        pro.numberOfLines = 1
        
        let proText: NSString = "*点击注册表示已同意《助牙医相关协议》"
        
        let proLinkText = "《助牙医相关协议》"
        
        pro.textAlignment = .Center
        
        pro.setText(proText as String)
        
        pro.addCustomLink(proLinkText, forRange: proText.rangeOfString(proLinkText))
        
        view.addSubview(pro)
        
        pro.delegate = self
        // 点赞
        let users = [
            [
                "name":"王磊",
                "uid":"123456"
            ],
            [
                "name":"王三石",
                "uid":"1234567"
                
            ]
        ]
        //
        let arr = TSUserBean.mj_objectArrayWithKeyValuesArray(users)
        
        let fansLabel = TSAttributedLabel(frame: CGRectMake(20, 250, 300, 60))
        
        fansLabel.numberOfLines = 1
        
        fansLabel.textAlignment = .Left
        
        view.addSubview(fansLabel)
        
        fansLabel.setText("")
        
        var totalFansText: String = ""
        
        for user in arr {
            
            let someUser: TSUserBean = user as! TSUserBean
            
            totalFansText += someUser.name!
            
            fansLabel.appendText(someUser.name!)
            
            let index = arr.indexOfObject(user)
            
            if index + 1 < arr.count {
                totalFansText += ","
                
                fansLabel.appendText(",")
            }
        }
        
        for user in arr {
            
            let someUser: TSUserBean = user as! TSUserBean
            
            let range = (totalFansText as NSString).rangeOfString(someUser.name!)
            
            fansLabel.addCustomLink(someUser.name!, forRange: range)
            
        }
        
        let comments = [
            [
                "user":[
                    "name":"王磊",
                    "uid":"123456"
                ],
                "remark":"今天天气不错",
                "cid":"评论id"
            ],
            [
                "user":[
                    "name":"王三石",
                    "uid":"1234567"
                ],
                "remark":"今天天气真的很不错",
                "cid":"评论id"
            ]
        ]
        
        let commentArray = TSCommentBean.mj_objectArrayWithKeyValuesArray(comments)
        
        let commentLabel = TSAttributedLabel(frame: CGRectMake(20, 350, 300, 100))
        
        commentLabel.numberOfLines = 0
        
        commentLabel.textAlignment = .Left
        
        view.addSubview(commentLabel)
        
        commentLabel.setText("")
        
        var totalCommentText: String = ""
        
        for comment in commentArray {
            
            let someComment: TSCommentBean = comment as! TSCommentBean
            
            totalCommentText += someComment.user!.name!
            
            commentLabel.appendText(someComment.user!.name!)
            
            totalCommentText += ":"
            
            commentLabel.appendText(":")
            
            totalCommentText += someComment.remark!
            
            commentLabel.appendText(someComment.remark!)
            
            let index = commentArray.indexOfObject(comment)
            
            if index + 1 < commentArray.count {
                totalCommentText += "\n"
                
                commentLabel.appendText("\n")
            }
        }
        
        for comment in commentArray {
            
            let someComment: TSCommentBean = comment as! TSCommentBean
            
            let range = (totalCommentText as NSString).rangeOfString(someComment.user!.name!)
            
            commentLabel.addCustomLink(someComment.user!.name!, forRange: range)
            
        }
        
        let someData = [
            "appointCount":"1",
            "remarkCount":"2",
            "fansCount":"5"
        ]
        
        let someBean = TSSomeBean.mj_objectWithKeyValues(someData)
        
        let someLabel = TSAttributedLabel(frame: CGRectMake(20, 450, 300, 60))
        
        someLabel.numberOfLines = 1
        
        someLabel.textAlignment = .Left
        
        view.addSubview(someLabel)
        
        someLabel.setText("")
        
        if let appointCount = someBean.appointCount {
            
            someLabel.appendText("\(appointCount)人预约 ")
        }
        if let remarkCount = someBean.remarkCount {
            
            someLabel.appendImage(UIImage(named: "评论")!, maxSize: CGSizeMake(30, 30), margin: UIEdgeInsetsZero, alignment: .Center)
            
            someLabel.appendText(" \(remarkCount)人")
            
        }
        if let fansCount = someBean.fansCount {
            
            someLabel.appendImage(UIImage(named: "关注")!, maxSize: CGSizeMake(30, 30), margin: UIEdgeInsetsZero, alignment: .Center)
            
            someLabel.appendText(" \(fansCount)人 ")
            
        }
