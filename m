From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: ISW fakeraid: fail to add back a disk previously removed
Date: Mon, 28 Oct 2013 07:18:28 +0100
Message-ID: <CAC9WiBiz+PTNQtv00RZUoBS30CaZwST+9W9K1SiPsVuze2MEcA@mail.gmail.com>
References: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC9WiBj5UO76MN3s0TgTLVKVAXJzY+eBxCMCYJWTp0JgdYogaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: dan.j.williams@intel.com
List-Id: linux-raid.ids

Hi,


[ Adding Dan Williams in CC since it appears to be the author of the
intel fake raid support. ]


On Wed, Oct 23, 2013 at 11:24 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> Hello,
>
> I'm testing ISW fake-raid with mdadm 3.3 and I can't add back a disk
> to a container previously marked as failed and removed.
>
> Also I'm testing ISW inside a VM so I'm not sure my test case is valid.
>
> So basically my ISW array was created with dmraid. I then installed my
> system on this array and rebooted to switch to mdadm. So far so good
> everything seems to work perfectly:
>
> # export IMSM_NO_PLATFORM=1
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sda[1] sdb[0]
>       2092375 blocks super external:/md127/0 [2/2] [UU]
>
> md127 : inactive sda[1](S) sdb[0](S)
>       6306 blocks super external:imsm
>
> unused devices: <none>
>
> # mdadm -E /dev/sdb
> /dev/sdb:
>           Magic : Intel Raid ISM Cfg Sig.
>         Version : 1.1.00
>     Orig Family : ef92cdd9
> [ ... ]
>
> Now I'm marking sda as failed and remove it:
>
> # mdadm --fail /dev/md126 sda
> # mdadm --remove /dev/md127 sda
>
> everything works fine until I add back sda to the container:
>
> # mdadm --add /dev/md127 /dev/sda
> mdadm: add /dev/sda
>
> # cat /proc/mdstat
> Personalities : [raid1]
> md126 : active raid1 sdb[0]
>       2092375 blocks super external:/md127/0 [2/1] [_U]
>
> md127 : inactive sda[1](S) sdb[0](S)
>       6306 blocks super external:imsm
>
> sda is not added anymore to the array md126 and therefore no resynchro happens.
>
> # mdadm -E /dev/sda
> /dev/sda:
>    MBR Magic : aa55
> Partition[0] :      3612577 sectors at         2048 (type 83)
> Partition[1] :       560133 sectors at      3616767 (type 05)
>
> Could anybody tell me if that's expected and if so could you englight me ?
>
> Thanks.
> --
> Francis



-- 
Francis
