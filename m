From: Eli Stair <estair@ilm.com>
Subject: Re: raid10 on centos 5
Date: Fri, 04 May 2007 16:29:38 -0700
Message-ID: <463BC1E2.6090301@ilm.com>
References: <200705042313.l44NDL712377@www.watkins-home.com> <463BBFFF.70000@istandfor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463BBFFF.70000@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ruslan Sivak <rsivak@istandfor.com>
Cc: Guy Watkins <linux-raid@watkins-home.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


You shouldn't need to build a new kernel, just extract the SRPM for the initial 
install (CentOS 5, no updated kernels), use the config for the appropriate kernel 
(SMP, UP, i386/x86_64), enable the raid10 module and do a 'make modules'.  You may 
need to do a minor amount of tweaking in the installer image to include this, but 
nothing serious.  Alternately, just building a driver disk with the module and 
source it in the install.  Interesting that it's not enabled in the installer 
image, because it's present in a fully-booted system... space limitations?


/eli

Ruslan Sivak wrote:
> Guy Watkins wrote:
>  > } -----Original Message-----
>  > } From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>  > } owner@vger.kernel.org] On Behalf Of Ruslan Sivak
>  > } Sent: Friday, May 04, 2007 12:22 PM
>  > } To: linux-raid@vger.kernel.org
>  > } Subject: raid10 on centos 5
>  > }
>  > } I am trying to set up raid 10 and so far with no luck.  I have 4 
> drives,
>  > } and Anaconda will not let me do raid 10.  mdadm doesn't have the 
> raid 10
>  > } personality loaded.  When I create the array manually like so:
>  > }
>  > } 2 drives in /dev/md11 as raid1
>  > } 2 drives in /dev/md12 as raid1
>  > } md11 and md12 in /dev/md10 as raid0
>  > }
>  > } Everything looks fine from the shell, but anaconda only sees md11 and
>  > } md12.
>  > }
>  > } The only choice I see is to set up LVM over md11 and md12.  Is this
>  > } really raid10?
>  > }
>  > } Russ
>  >
>  > You are making a RAID1+RAID0 array.
>  > Try making a real RAID10 array with 4 drives.  This way you would 
> only have
>  > 1 array with 4 drives.
>  >
>  > >From the mdadm man page:
>  > Currently, Linux supports LINEAR md devices,  RAID0  (striping),  RAID1
>  >        (mirroring), RAID4, RAID5, RAID6, RAID10, MULTIPATH, and FAULTY.
>  >
>  > Notice RAID10 is listed, use that.  Man mdadm for more info.
>  >
>  > However, I would (and do) use RAID6.  With RAID6 any 2 disks can fail
>  > without data loss.  With RAID1+RAID0, any one disk can fail, a second
>  > failure has a 1 in 3 chance of vast data loss.
>  >
>  > I hope this helps,
>  > Guy
>  >
>  > -
>  >  
> 
> 
> Guy,
> 
> That's what I've been trying to do.  Unfortunatelly, my distro, CentOS 5
> (based on RHEL 5, I believe), does not have the RAID10 personality in
> the kernel.  I guess I would have to compile my own kernel and load the
> module through a driver disk.  Would that work?  Are there some
> instructions somewhere I can follow?
> 
> Russ
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

