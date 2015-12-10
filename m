From: George Rapp <george.rapp@gmail.com>
Subject: Re: RAID 6 "Failed to restore critical section for reshape, sorry." -
 recovery advice?
Date: Thu, 10 Dec 2015 17:34:30 -0500
Message-ID: <CAF-KpgYe9Vxgcy2E5T1_9HdEM0YMfATMzN7WcjHra_EE+sOOTg@mail.gmail.com>
References: <CAF-Kpgb57-LoNy=-jy76ZcE=YPABmARzfsHNitJNZyw3v2AShw@mail.gmail.com>
 <alpine.DEB.2.02.1512100918520.20919@uplift.swm.pp.se> <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-KpgaLr-qA_RJiDYstFv-=EoHH-Ea3o1q3G3tXC4nX=Wt2XA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 10, 2015 at 5:05 PM, George Rapp <george.rapp@gmail.com> wrote:
> On Thu, Dec 10, 2015 at 3:22 AM, Mikael Abrahamsson <swmike@swm.pp.se> wrote:
>>
>> Just a shot in the dark, what happens if you add a backup file to the above
>> command, but without revert-reshape? Ie state both --invalid-backup but also
>> supply a backup-file. The text above could indicate that this might help.
>
> Mikael -
>
> First, thanks for the reply.
>
> I tried that and got a different error message:
>
> # mdadm --assemble --verbose --invalid-backup --force
> --backup-file=/home/gwr/2015/2015-08/grow_md6.bak /dev/md4 $OVERLAYS
> mdadm: looking for devices for /dev/md4
> mdadm: /dev/mapper/sdd4 is identified as a member of /dev/md4, slot 0.
> mdadm: /dev/mapper/sdc4 is identified as a member of /dev/md4, slot 1.
> mdadm: /dev/mapper/sdg4 is identified as a member of /dev/md4, slot 2.
> mdadm: /dev/mapper/sdh1 is identified as a member of /dev/md4, slot 3.
> mdadm: /dev/mapper/sdi1 is identified as a member of /dev/md4, slot 5.
> mdadm: /dev/mapper/sdj1 is identified as a member of /dev/md4, slot 4.
> mdadm: /dev/md4 has an active reshape - checking if critical section
> needs to be restored
> mdadm: No backup metadata on /home/gwr/2015/2015-08/grow_md6.bak
> mdadm: Failed to find backup of critical section
> mdadm: continuing without restoring backup
> mdadm: added /dev/mapper/sdc4 to /dev/md4 as 1
> mdadm: added /dev/mapper/sdg4 to /dev/md4 as 2
> mdadm: added /dev/mapper/sdh1 to /dev/md4 as 3
> mdadm: added /dev/mapper/sdj1 to /dev/md4 as 4
> mdadm: added /dev/mapper/sdi1 to /dev/md4 as 5
> mdadm: added /dev/mapper/sdd4 to /dev/md4 as 0
> mdadm: failed to RUN_ARRAY /dev/md4: Invalid argument

Forgot to include the contents of the system log:

[  928.679299] md: bind<dm-1>
[  928.679809] md: bind<dm-2>
[  928.681957] md: bind<dm-3>
[  928.693345] md: bind<dm-5>
[  928.694155] md: bind<dm-4>
[  928.696251] md: bind<dm-0>
[  928.709133] md/raid:md4: reshape_position too early for
auto-recovery - aborting.
[  928.709159] md: pers->run() failed ...
[  928.709425] md: md4 stopped.
[  928.709442] md: unbind<dm-0>
[  928.709449] md: export_rdev(dm-0)
[  928.709462] md: unbind<dm-4>
[  928.709468] md: export_rdev(dm-4)
[  928.709477] md: unbind<dm-5>
[  928.709483] md: export_rdev(dm-5)
[  928.709493] md: unbind<dm-3>
[  928.709499] md: export_rdev(dm-3)
[  928.709510] md: unbind<dm-2>
[  928.709515] md: export_rdev(dm-2)
[  928.709524] md: unbind<dm-1>
[  928.709529] md: export_rdev(dm-1)
[  928.831905] md: bind<dm-0>
[  928.859783] md: bind<dm-3>
[  928.864100] md: bind<dm-1>
[  928.872128] md: bind<dm-4>
[  928.878222] md: bind<dm-5>
[  928.886799] md: bind<dm-2>

I appear to be too early in the reshape for auto-recovery, but too far
along to just say "never mind on that whole reshape business". Any
other thoughts?

-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
