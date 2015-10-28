From: Phil Turmel <philip@turmel.org>
Subject: Re: How to recover after md crash during reshape?
Date: Wed, 28 Oct 2015 12:42:45 -0400
Message-ID: <5630FB05.5070902@turmel.org>
References: <04cdcd6bd69b3aa1f8f24465f8485c90@tantosonline.com>
 <5626464D.9000502@turmel.org>
 <3baf849321d819483c5d20c005a31844@tantosonline.com>
 <562660EE.9020504@turmel.org>
 <72dc24dd30c19517d19887d794fd341b@tantosonline.com>
 <562D5F91.5040300@turmel.org> <5630F862.5040308@tantosonline.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5630F862.5040308@tantosonline.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andras Tantos <andras@tantosonline.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/28/2015 12:31 PM, Andras Tantos wrote:
> Thanks again Phil!
> 
> I'm almost there...
> 
>>>     [ 5859.527778] EXT4-fs (md1): bad geometry: block count 1831419920
>>> exceeds size of device (1831419760 blocks)
>>
>>Yep. You'll need to use the --size option on a create. Note that it
>>specifies the amount of each device to use, not the overall array size.
>>According to "man mdadm", its units is k == 1024 bytes.  Use the exact
>>size from your original => --size=1465135936
> 
> When I try to do that, I get the following message:
> 
>     root@bazsalikom:~# mdadm --create --assume-clean --verbose
> --metadata=1.0 --raid-devices=7 --size=1465135936 --chunk=64 --level=6
> /dev/md1 /dev/sde2 /dev/sdc2 /dev/sdf1 /dev/sdd1 /dev/sdb1 /dev/sdg1
> /dev/sdh2
>     mdadm: layout defaults to left-symmetric
>     mdadm: /dev/sde2 appears to contain an ext2fs file system
>         size=-1216020180K  mtime=Wed Dec  8 11:55:07 1954
>     mdadm: /dev/sde2 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdc2 appears to contain an ext2fs file system
>         size=-1264254912K  mtime=Sat Jul 18 15:26:57 2015
>     mdadm: /dev/sdc2 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdf1 is smaller than given size. 1465135808K <
> 1465135936K + metadata
>     mdadm: /dev/sdd1 is smaller than given size. 1465135808K <
> 1465135936K + metadata
>     mdadm: /dev/sdb1 is smaller than given size. 1465135808K <
> 1465135936K + metadata
>     mdadm: /dev/sdg1 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdh2 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: create aborted
> 
> To be able to re-assemble the array, I *have* to specify metadata
> version 0.9:
> 
>     root@bazsalikom:~# mdadm --create --assume-clean --verbose
> --metadata=0.9 --raid-devices=7 --size=1465135936 --chunk=64 --level=6
> /dev/md1 /dev/sde2 /dev/sdc2 /dev/sdf1 /dev/sdd1 /dev/sdb1 /dev/sdg1
> /dev/sdh2
>     mdadm: layout defaults to left-symmetric
>     mdadm: /dev/sde2 appears to contain an ext2fs file system
>         size=-1216020180K  mtime=Wed Dec  8 11:55:07 1954
>     mdadm: /dev/sde2 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdc2 appears to contain an ext2fs file system
>         size=-1264254912K  mtime=Sat Jul 18 15:26:57 2015
>     mdadm: /dev/sdc2 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdf1 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdd1 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdb1 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdg1 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: /dev/sdh2 appears to be part of a raid array:
>         level=raid6 devices=7 ctime=Wed Oct 28 09:17:55 2015
>     mdadm: largest drive (/dev/sdg1) exceeds size (1465135936K) by more
> than 1%
>     Continue creating array? y
>     mdadm: array /dev/md1 started.
> 
> Is this a problem? Can I upgrade my array to 1.0 metadata? Should I?

Hmm. Interesting.  Your version of mdadm is insisting on reserving much
more space between end of content and the v1.0 metadata than when using
v0.90 metadata.

I'm curious how much.  Please show the output of "cat /proc/partitions".

If you stop the array cleanly and then manually re-assemble with
--update=metadata, you might get around it.  (Specify all of the devices
explicitly to ensure you don't get burned by v0.90's problems with last
partitions.)

You definitely don't want to stay on v0.90, but you may need to for now
to get out of trouble.

Phil

