From: Sam Bingner <sam@bingner.com>
Subject: Re: RAID5 recovery
Date: Thu, 6 Jun 2013 12:28:09 +0000
Message-ID: <1BEDF6AF-9B64-4290-8018-9C69C2A6B7C0@bingner.com>
References: <51AF28F2.3010701@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AF28F2.3010701@gmail.com>
Content-Language: en-US
Content-ID: <D22A61620390F043B4658B534B85ED2A@ds.sbdhi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Philipp Frauenfelder <philipp.frauenfelder@gmail.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Jun 5, 2013, at 2:02 AM, Philipp Frauenfelder <philipp.frauenfelder@gmail.com> wrote:

> Hi
> 
> I am new to this list and RAID problems (but not to Linux).
> 
> My RAIDs run well but one of my colleague in a Synology has failed. It was a 4-disk RAID5 and the hot-spare disk and one of the used disks (the middle one) failed. Unfortunately, he returned the disks to the vendor the get new ones.
> 
> So, we ended up with 2 out of 4 disks and trying to get the data of the disks now. My colleague copied the disks and we were trying to rebuild the RAID5 on the copies. We tried to do the rebuild on a PC runing a fairly recent Knoppix:
> 
> root@Microknoppix:~# mdadm --create --assume-clean --level=5 --raid-devices=4 --size=1948662272 /dev/md2 missing /dev/sda3 missing /dev/sdb3
> mdadm: /dev/sda3 appears to be part of a raid array:
>    level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
> mdadm: /dev/sdb3 appears to be part of a raid array:
>    level=raid5 devices=4 ctime=Thu May  9 22:47:08 2013
> Continue creating array? y
> mdadm: Defaulting to version 1.2 metadata
> mdadm: RUN_ARRAY failed: Input/output error
> 
> Apparently, this did not work. :-(
> 
> In the RAID wiki, it says one should ask here before trying a destroying to much, that's why I am asking here....
> 
> Btw, attached is the raid.status and the dmesg output.
> 
> Is there a hint what we need to do?
> 
> Thanks in advance,
> Philipp
> <output.txt><raid.status>

Yup - as everybody else said it's toasty - hopefully you have a backup.

If not, I will offer you another suggestion - contact the vendor and try to see if they can return your failed drives to you.... if you can get them back there is a high likelihood that you can recover a majority, if not all, of your data.

Sam