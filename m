From: <me@heyjay.com>
Subject: mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
Date: Sun, 2 May 2004 23:18:06 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <012001c430c5$a3e12b70$6705a8c0@a30>
Reply-To: <me@heyjay.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I did a fresh install of Sarge, updated the kernel to 2.4.26.  then did:

platinum:~#  mdadm -C /dev/md0 --level raid1 --raid-disks 2 missing
/dev/hdc1
mdadm: /dev/hdc1 appears to contain an ext2fs file system
    size=117218240K  mtime=Wed Dec 31 18:00:00 1969
Continue creating array? y
mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists

Anyone know why am I getting this error?  This is the first time (for this
install) that I'm trying to build a raid.  Where does this file exist?  On
my system disk or on the second disk I'm trying to build the raid on?

Thanks
Jay

