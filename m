From: "majianpeng" <majianpeng@gmail.com>
Subject: Add set bad lba function in md-faulty module.
Date: Tue, 15 May 2012 19:49:18 +0800
Message-ID: <201205151949130004425@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all:
	In order to test md code, sometime we need  simulate read/write harddisk error.
	Using hdparm --make-bad-sector to  simulate  read error.But I did not find way of  simulating write-error.
	I tested md-faulty module, it can do this.But it is not provide the function link hdparm --make-bad-sector,which did not set lba.
	Using hdpamr --make-bad-sector to  simulate read error can cause some problem.
	It will cause ata commnd reset,disk reset and so on.It take too log time.
	So I think add a function in md-faulty which can set read/write lba.
	How about ?
											
 				
--------------
majianpeng
2012-05-15

