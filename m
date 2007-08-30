From: chee <cheeming81@gmail.com>
Subject: Using my Mirror disk to boot up.
Date: Wed, 29 Aug 2007 20:25:59 -0700 (PDT)
Message-ID: <12399907.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


i,

This is my Filesystem:

Filesystem Size Used Avail Use% Mounted on
/dev/md0 9.7G 6.6G 2.7G 72% /
none 189M 0 189M 0% /dev/shm
/dev/md2 103G 98G 289M 100% /home

and this is mirror settings:

Personalities : [raid1]
md1 : active raid1 hda2[0] hdd2[1]
512000 blocks [2/2] [UU]

md2 : active raid1 hdd3[1] hda3[0]
109298112 blocks [2/2] [UU]

md0 : active raid1 hdd1[1] hda1[0]
10240128 blocks [2/2] [UU]

The problem i am facing is my mirror disk does not seem to boot up when i
swap hard disk to test where my mirroring disk is working. The only thing i
see was this 'LI' in the monitor and hangs there.

I am quite new to mirror disk. PLease do advise me. Thanks
-- 
View this message in context: http://www.nabble.com/Using-my-Mirror-disk-to-boot-up.-tf4351751.html#a12399907
Sent from the linux-raid mailing list archive at Nabble.com.

