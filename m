From: Yann Ormanns <yann-ormanns@web.de>
Subject: Re: RAID6 simply does not start as /dev/md8
Date: Mon, 11 Apr 2011 10:19:17 +0200
Message-ID: <4DA2B985.2010905@web.de>
References: <0E.11.05159.1B082AD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0E.11.05159.1B082AD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

First of all:
I finally solved the problem by creating an initrd, which assembles all
arrays, so I could deactivate CONFIG_MD_AUTODETECT in the kernel. I also
do not need /etc/mdadm.conf anymore - and it works like a charm.

Thanks to everybody who attended to this problem!
The summary can be found here:
https://forums.gentoo.org/viewtopic-t-868017-highlight-.html

Subject: RE: RAID6 simply does not start as /dev/md8
From: Leslie Rhorer <lrhorer@satx.rr.com>
To: Yann Ormanns <yann-ormanns@web.de>
Date: 2011-04-11 10:06 (-0500)

> From your description, it sounds to me like md8 is built using
> the whole disk on all 6 drives.  If so, there's really no need to partition
> the drives.
> 

That is correct. I simply wanted to eliminate possible mistakes - after
6 or 7 "useless" syncs of the array I tried _everything_, just to get
this thing work.

>> Unfortunately, I have to keep "CONFIG_MD_AUTODETECT" enabled, because /
>> and the whole system runs on a RAID1. But why does the kernel start the
>> array, although the used partition type of the disks in my RAID6 is NOT
>> "linux raid autodetect"?
> 
> 	Mdadm builds any arrays local to the system at boot.  Why do you
> have grief with the kernel starting the array?
> 

The problem was, that - although I did not use the filesystem type
"linux raid autodetect" for my RAID6 - the kernel still seemed to
assemble it. Now, without its autodetection, it works fine.

Best regards,
Yann
