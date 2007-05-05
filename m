From: "Guy Watkins" <linux-raid@watkins-home.com>
Subject: RE: raid10 on centos 5
Date: Sat, 5 May 2007 00:41:35 -0400
Message-ID: <200705050441.l454fe713100@www.watkins-home.com>
References: <463BBFFF.70000@istandfor.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463BBFFF.70000@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Ruslan Sivak' <rsivak@istandfor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

} -----Original Message-----
} From: Ruslan Sivak [mailto:rsivak@istandfor.com]
} Sent: Friday, May 04, 2007 7:22 PM
} To: Guy Watkins
} Cc: linux-raid@vger.kernel.org
} Subject: Re: raid10 on centos 5
} 
} Guy Watkins wrote:
} > } -----Original Message-----
} > } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
} > } owner@vger.kernel.org] On Behalf Of Ruslan Sivak
} > } Sent: Friday, May 04, 2007 12:22 PM
} > } To: linux-raid@vger.kernel.org
} > } Subject: raid10 on centos 5
} > }
} > } I am trying to set up raid 10 and so far with no luck.  I have 4
} drives,
} > } and Anaconda will not let me do raid 10.  mdadm doesn't have the raid
} 10
} > } personality loaded.  When I create the array manually like so:
} > }
} > } 2 drives in /dev/md11 as raid1
} > } 2 drives in /dev/md12 as raid1
} > } md11 and md12 in /dev/md10 as raid0
} > }
} > } Everything looks fine from the shell, but anaconda only sees md11 and
} > } md12.
} > }
} > } The only choice I see is to set up LVM over md11 and md12.  Is this
} > } really raid10?
} > }
} > } Russ
} >
} > You are making a RAID1+RAID0 array.
} > Try making a real RAID10 array with 4 drives.  This way you would only
} have
} > 1 array with 4 drives.
} >
} > >From the mdadm man page:
} > Currently, Linux supports LINEAR md devices,  RAID0  (striping),  RAID1
} >        (mirroring), RAID4, RAID5, RAID6, RAID10, MULTIPATH, and FAULTY.
} >
} > Notice RAID10 is listed, use that.  Man mdadm for more info.
} >
} > However, I would (and do) use RAID6.  With RAID6 any 2 disks can fail
} > without data loss.  With RAID1+RAID0, any one disk can fail, a second
} > failure has a 1 in 3 chance of vast data loss.
} >
} > I hope this helps,
} > Guy
} >
} > -
} >
} 
} 
} Guy,
} 
} That's what I've been trying to do.  Unfortunatelly, my distro, CentOS 5
} (based on RHEL 5, I believe), does not have the RAID10 personality in
} the kernel.  I guess I would have to compile my own kernel and load the
} module through a driver disk.  Would that work?  Are there some
} instructions somewhere I can follow?
} 
} Russ

I don't know how to make a driver disk.  Also not much on making modules.
From what I know, linux only loads the RAID modules it needs.  My system
does not have raid0 or raid10 loaded.  But both loaded when I used modprobe.
I have FC6, upgraded from FC5 using yum, so maybe not 100% FC6.

Anyway, you were not making a RAID10 array.  You were making 2 RAID1 arrays
and then 1 RAID0 array.  That does not need the RAID10 module (AFAIK).

If I recall, there is an issue of nesting arrays like you were doing.  The
problem was related to auto starting them.  But I don't recall any details,
and maybe it has been corrected.

Guy

