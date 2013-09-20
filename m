From: Martin Wilck <mwilck@arcor.de>
Subject: Re: Question on DDF degraded array
Date: Fri, 20 Sep 2013 20:18:12 +0200
Message-ID: <523C9164.6030604@arcor.de>
References: <CAC9WiBjRic8x3ech59pEEFSojtXM=6DX7kHECLW3xZYXg2kugA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBjRic8x3ech59pEEFSojtXM=6DX7kHECLW3xZYXg2kugA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/19/2013 06:05 PM, Francis Moreau wrote:
> Hello Martin,
> 
> My system is using RAID1 DDF with 2 disks.
> 
> I tried to boot my system with only disk and it worked. After that I
> powered off the system put back the second disk en booted again.
> 
> As expected the array is degraded:
> 
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[0]
>       2064384 blocks super external:/md127/0 [2/1] [_U]
> 
> md127 : inactive sdb[0](S)
>       32768 blocks super external:ddf
> 
> Now I'm trying to add back the disk in the array which shoud trigger a
> synchro but I can't:
> 
> # mdadm /dev/md127 --add /dev/sda
> mdadm: added /dev/sda
> 
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[0]
>       2064384 blocks super external:/md127/0 [2/1] [_U]
> 
> md127 : inactive sda[1](S) sdb[0](S)
>       65536 blocks super external:ddf
> 
> the second disk is in the container but not used by the array. I'm not
> sure what '(S)' means above.
> 
> Could you tell me what should be done to add back the second disk into
> the array and trigger the sycnhro ?

Is mdmon running?
Could you compile mdadm and mdmon with CXFLAGS="-DDEBUG=1 -g" and
capture the debug output of mdadm and mdmon?

Martin

> 
> Thanks

