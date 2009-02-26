From: PGNet <pgnet.trash+raid@gmail.com>
Subject: can metadata type be changed for an active array?
Date: Thu, 26 Feb 2009 11:12:37 -0800
Message-ID: <dbd51810902261112h26ca8429l835272401f555c54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i've created an array,

    mdadm --create /dev/md5 --level=1 --raid-devices=2 /dev/sda1 /dev/sdb1

checking,

	cat /proc/mdstat
	Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] [linear]
	md5 : active raid1 sda2[0] sdb2[1]
		  341991616 blocks [2/2] [UU]
		  bitmap: 0/164 pages [0KB], 1024KB chunk

i realized that it defaulted to metadata type = 0.90.

is it possible to _modify_ this array to use "super 1.x" metadata
type, rather than the default 0.90?

neither 'manage' or 'grow' modes seem to allow it,

	mdadm --manage --metadata=1.2 /dev/md5
		mdadm:option --metadata not valid in manage mode
	mdadm --grow --metadata=1.2 /dev/md5
		mdadm:option --metadata not valid in grow mode

thanks.
