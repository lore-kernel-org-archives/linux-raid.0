From: "Martin Bene" <martin.bene@icomedias.com>
Subject: AW: raid1 reconfig failed to work! help!
Date: Wed, 2 Oct 2002 15:01:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4D618F6493CE064A844A5D496733D66703132C@freedom.icomedias.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
content-class: urn:content-classes:message
To: Alex <devel@qnet.ro>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> [root@server root]# cat /etc/raidtab
> raiddev /dev/md0
>         raid-level      1
>         nr-raid-disks   2
>         nr-spare-disks  0
>         chunk-size     32
>         persistent-superblock 1
>         device          /dev/sdb1
>         raid-disk       0
>         device          /dev/sdc1
>         raid-disk       1
> 
> Now i tryed to add a spare hdd. For this, i edited a newraidtab file:
> [root@server root]# cat /etc/newraidtab
> raiddev /dev/md0
>         raid-level      1
>         nr-raid-disks   2
>         nr-spare-disks  1
>         chunk-size     32
>         persistent-superblock 1
>         device          /dev/sdb1
>         raid-disk       0
>         device          /dev/sdc1
>         raid-disk       1
> 	device	/dev/sdb1
> 	spare-disk	0

> [root@server root]# raidreconf -o /etc/raidtab -n /etc/newraidtab -m 

You don't need raidreconf to add a spare disk; just add it with raidhotadd to
the running array.

Bye, Martin
