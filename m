From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Array Size
Date: Sun, 11 Jan 2004 23:19:23 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200401120419.i0C4JRi21932@dns1.watkins-home.com>
References: <Pine.GSO.4.31.0401112145170.19340-100000@staff1.cso.uiuc.edu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.31.0401112145170.19340-100000@staff1.cso.uiuc.edu>
To: 'Sharif Islam' <mislam@ux1.cso.uiuc.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Overhead!
If filesystem is ext3:
	Reserved for root user, default 5%
	Inodes
	Journal
	Superblocks

I don't know the exact numbers.

Why RAID0?  You lose a disk and game over!

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Sharif Islam
Sent: Sunday, January 11, 2004 10:49 PM
To: linux-raid@vger.kernel.org
Subject: Array Size

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


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


