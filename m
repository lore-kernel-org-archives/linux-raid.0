From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
Date: Tue, 4 May 2004 12:07:24 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16534.64220.901221.482562@cse.unsw.edu.au>
References: <012001c430c5$a3e12b70$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from me@heyjay.com on Sunday May 2
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 2, me@heyjay.com wrote:
> Hi,
> 
> I did a fresh install of Sarge, updated the kernel to 2.4.26.  then did:
> 
> platinum:~#  mdadm -C /dev/md0 --level raid1 --raid-disks 2 missing
> /dev/hdc1
> mdadm: /dev/hdc1 appears to contain an ext2fs file system
>     size=117218240K  mtime=Wed Dec 31 18:00:00 1969
> Continue creating array? y
> mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
> 
> Anyone know why am I getting this error?  This is the first time (for this
> install) that I'm trying to build a raid.  Where does this file exist?  On
> my system disk or on the second disk I'm trying to build the raid
> on?

What does
  cat /proc/mdstat
show?  I suspect /dev/md0 has already been assembled somehow.

NeilBrown

> 
> Thanks
> Jay
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
