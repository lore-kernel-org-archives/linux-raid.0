From: Terry <td3201@yahoo.com>
Subject: raid 5 catastrophy
Date: Wed, 31 Mar 2004 20:42:31 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040401044231.92394.qmail@web60309.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I made a mistake on a raid 5 array.  I accidentally
tried to “raidhotadd” 2 of the 3 drives from the raid
5 array into another array.  Now the two partitions
FROM the raid 5 think they are part of the other
array.  The raidtab for the array is:

raiddev			/dev/md4
raid-level		5
nr-raid-disks		3
chuck-size		64k
oersustebt-superblock	1
nr-spare-disks		0
device			/dev/hda2
raid-disk		0
device			/dev/hdb2
raid-disk		1
device			/dev/hdc2
raid-disk		2

Ultimately, the raid5 array is broken.  It won't start
because it only has one good disk to its name right
now.  How can I fix this?  I assume the data on the
other two drives is still intact (bad assumption?)

Thanks for the help!

=====
Terry

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
