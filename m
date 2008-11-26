From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: Updated MDADM, array dies.
Date: Wed, 26 Nov 2008 15:13:53 -0700
Message-ID: <e9c3a7c20811261413h5102bb7ay2d0dcf60235a25aa@mail.gmail.com>
References: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <29a863790811260840w2533f6dcy244ce58d81bbc27e@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 26, 2008 at 9:40 AM, Greg Cormier <gcormier@gmail.com> wrote:
> I have a RAID5 array of 4 disks. Was working well. I did a "yum
> update" and noticed it updated mdadm to mdadm 2.6.7.1, amongst other
> things (new kernel 2.2.27 instead of .26) , and now my array won't
> mount.
>
> mdadm --assemble /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1
> mdadm: cannot open device /dev/sdb1: Device or resource busy
> mdadm: /dev/sdb1 has no superblock - assembly aborted
>
> [root@zeus ~]# cat /proc/mdstat
> Personalities :
> md_d0 : inactive sdb1[0](S) sdd1[2](S)
>      976766976 blocks
>
> unused devices: <none>

Looks like you have some partially assembled array there.  perhaps the
initrd tried to assemble the array before all devices were
available...?  It shows up in your dmesg at this point:

> NVRM: loading NVIDIA UNIX x86 Kernel Module  177.80  Wed Oct  1
> 14:38:10 PDT 2008
> md: bind<sdd1>
> md: bind<sdb1>
> NET: Registered protocol family 10

You can clean that up with "mdadm -Ss" and then try to assemble the
array again, but I suspect that at the next reboot you may be in the
same boat.  What are the contents of /etc/mdadm/mdadm.conf?
