From: "bo" <bo@sosnetwork.net>
Subject: Invalid argument error on raid5 create
Date: Mon, 8 Jul 2002 16:57:15 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <00cd01c226db$2f71ddc0$5701a8c0@bomoon>
References: <001f01c22632$ad349580$0200a8c0@gandalf> <15657.19046.986108.967800@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

I am trying to create the RAID 5 array with

>mdadm -C /dev/md0 -l5 -n6 -x1 -prs /dev/hd[bcdefgh]

However, I am getting the following error message;

>mdadm: RUN_ARRAY failed: Invalid argument

Because I used these devices as raid1, I ran ">mdadm --zero-superblock
/dev/hdx" on all of these
devices. But no help. Even I tried with "mkraid & raidtab" it still has the
same error.
Also, I tried with -f option, and with or without space between option and
its value on mdadm -C.

All of these devices are used as the whole disk without partition.

I had no problem with RAID 0 or 1.

Any clue?

Thanks,

Bo

