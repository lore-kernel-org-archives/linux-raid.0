From: Stephan van Hienen <raid@a2000.nu>
Subject: mdadm monitor keeps device locked ?
Date: Tue, 17 Feb 2004 13:59:53 +0100 (CET)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0402171353040.7525@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

]# raidstart /dev/md0
]# mdadm --monitor --scan --daemonise > /var/run/mdadm
]# raidstop /dev/md0
/dev/md0: Device or resource busy

I first have to kill the mdadm monitor process befor i can stop the md0
(if i don't stop the raid has to resync after reboot?)

is there a better way of stopping the raid, without doing killing the
mdadm (i use killall mdadm now) ?
