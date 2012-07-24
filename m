From: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: smarter md minor search  than "find_free_devnum" needed
Date: Tue, 24 Jul 2012 17:39:05 +0200
Message-ID: <500EC199.5040204@profitbricks.com>
References: <500D4D1C.6070103@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <500D4D1C.6070103@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi all,

I've found a faster solution by reading the names of active MD devices
from sysfs into memory and processing them from there. With 500 devices
this lasts approx. 70 ms instead of 3 s with "find_free_devnum()" in mdadm.

Here I've got it as shell code. In C it can be implemented better.

#!/bin/bash
cd /sys/block
LIST=`ls -1d md* 2>/dev/null | egrep -o '[0-9]*' | sort -n`
LIST_ARR=($LIST)

if [ "$LIST" == "" ]; then
  echo "md0"
  exit 0
fi

for ((i=0; i<1048575; i++)); do
  if [ $i -ge ${#LIST_ARR[*]} ]; then
    echo "md$i"
    exit 0
  elif [ ${LIST_ARR[$i]} -gt $i ]; then
    echo "md$i"
    exit 0
  fi
done
exit 1

Of cause this needs locking until the MD device is created (further 0.8s).

Cheers,
Sebastian



On 23.07.2012 15:09, Sebastian Riemer wrote:
> Hi list,
>
> I'm thinking about creation of many MD RAID 1 devices by automatic
> scripts. The MD minor numbers should be auto-determined. But if I do
> this with mdadm 3.2.5 and kernel 3.4.2 without udev, then it gets slower
> the more devices I create. I also had to patch mdadm to make
> "--symlinks=no" really work (preventing "/dev/md/*" symlinks to be created).
>
> Looks like this:
> # MDADM_NO_UDEV=1 mdadm -C auto --symlinks=no --assume-clean --force -l
> 1 -n 2 /dev/loop$i /dev/loop$j
>
> Btw.: With udev it hangs for some seconds.
>
> With this it is fast but can't use it for production (I only have the
> UUIDs):
> # MDADM_NO_UDEV=1 mdadm -C /dev/md$k --assume-clean --force -l 1 -n 2
> /dev/loop$i /dev/loop$j
>
> What about caching the next free minor number in kernel space, taking
> it, finding the next free and updating it?
> Or is there another possibility (putting this into a custom daemon
> should be avoided)?
>
> If I identify the MD devices by UUID, I don't want to care which minor
> number they actually have upon creation/assembly.
>
> Cheers,
> Sebastian
