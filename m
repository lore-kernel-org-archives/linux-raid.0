From: "liyiming" <liyiming@nrchpc.ac.cn>
Subject: There is an advice
Date: Fri, 5 Jan 2007 16:11:10 +0800
Message-ID: <200701051611098594960@nrchpc.ac.cn>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

In the stop function of any level raid device driver such as faulty, multipath, and raidx
It would better set the mddev->private NULL before free the conf structure. 

 
 				
--------------
liyiming
2007-01-05

