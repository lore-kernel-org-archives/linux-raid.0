From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: raid10 on centos 5
Date: Fri, 4 May 2007 19:13:16 -0400
Message-ID: <200705042313.l44NDL712377@www.watkins-home.com>
References: <463B5DB3.6020502@istandfor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463B5DB3.6020502@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ruslan Sivak' <rsivak@istandfor.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



} -----Original Message-----
} From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} owner@vger.kernel.org] On Behalf Of Ruslan Sivak
} Sent: Friday, May 04, 2007 12:22 PM
} To: linux-raid@vger.kernel.org
} Subject: raid10 on centos 5
} 
} I am trying to set up raid 10 and so far with no luck.  I have 4 drives,
} and Anaconda will not let me do raid 10.  mdadm doesn't have the raid 10
} personality loaded.  When I create the array manually like so:
} 
} 2 drives in /dev/md11 as raid1
} 2 drives in /dev/md12 as raid1
} md11 and md12 in /dev/md10 as raid0
} 
} Everything looks fine from the shell, but anaconda only sees md11 and
} md12.
} 
} The only choice I see is to set up LVM over md11 and md12.  Is this
} really raid10?
} 
} Russ

You are making a RAID1+RAID0 array.
Try making a real RAID10 array with 4 drives.  This way you would only have
1 array with 4 drives.

From the mdadm man page:
Currently, Linux supports LINEAR md devices,  RAID0  (striping),  RAID1
       (mirroring), RAID4, RAID5, RAID6, RAID10, MULTIPATH, and FAULTY.

Notice RAID10 is listed, use that.  Man mdadm for more info.

However, I would (and do) use RAID6.  With RAID6 any 2 disks can fail
without data loss.  With RAID1+RAID0, any one disk can fail, a second
failure has a 1 in 3 chance of vast data loss.

I hope this helps,
Guy

