From: Sharif Islam <mislam@ux1.cso.uiuc.edu>
Subject: Array Size
Date: Sun, 11 Jan 2004 21:48:39 -0600 (CST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.31.0401112145170.19340-100000@staff1.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have 6 IDE hard drives, each 120 GB.
I am bit confused by the reported array size.

# mdadm -D /dev/md0
/dev/md0:
        Version : 00.90.00
  Creation Time : Fri Jan  9 13:52:20 2004
     Raid Level : linear
     Array Size : 703324416 (670.74 GiB 720.25 GB)

[....]

# df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda1              26G  1.2G   23G   5% /
/dev/hda5             2.6G   33M  2.4G   2% /tmp
/dev/hda3             3.9G   59M  3.6G   2% /var
/dev/md0              661G   33M  627G   1% /ppa


Shouldn't the above be ~720GB?

Thanks.

-Sharif


