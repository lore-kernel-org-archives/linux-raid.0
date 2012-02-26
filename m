From: "kedacomkernel" <kedacomkernel@gmail.com>
Subject: how to use badsector function
Date: Sun, 26 Feb 2012 18:06:58 +0800
Message-ID: <201202261806556873919@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 I noted md add a function about badsector.But I did not found how to using.
1:when create a raid5 and superblock is load:
    in function super_1_load:
	 if (sb->bblog_offset == 0)
		rdev->badblocks.shift = -1;
2:when runing raid5,meet badsector. Because shift=-1,not add 
3:mdadm can't provide a parameter to set.

						Thanks!
 				
--------------
kedacomkernel
2012-02-26

