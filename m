From: George Rapp <george.rapp@gmail.com>
Subject: Re: recovery from selinux blocking --backup-file during RAID5->6
Date: Wed, 6 Apr 2016 12:32:42 -0400
Message-ID: <CAF-KpgYDQL5yDVk=pQbcZc8L_hWMLXCmJrp1fa38Z1eWSnmPeA@mail.gmail.com>
References: <CAFAW0zxisX2Db_YdJxtNpF4YKayy=AnKnWcGdAgw6piy1Jjyng@mail.gmail.com>
 <CAF-Kpgaj2ycfxLumyXw1FwX+NetPa3XN0zhr6EM5O-qvnm6jrA@mail.gmail.com>
 <CAF-KpgYqa9hB7m=pNAc8GFrTuKF8YwToHXvU4U2uCncs77Jx5g@mail.gmail.com>
 <CAFAW0zyNS3m4ZZ59xCkznxopo0d4soWQZrd2eBVfovfNCoX6Sg@mail.gmail.com> <CAFAW0zzauYrAd-v3Yq03-XSpO9KCSXcUtXnGWKMvd-VYQj5O5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFAW0zzauYrAd-v3Yq03-XSpO9KCSXcUtXnGWKMvd-VYQj5O5g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Noah Beck <noah.b.beck@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Apr 6, 2016 at 10:16 AM, Noah Beck <noah.b.beck@gmail.com> wrote:
> Update:
>
> I backed up locally all data I cared about from the "raid5" array while it was
> stuck in the state:
>
> md127 : active raid6 sde1[3] sda1[2] sdd1[0] sdf1[1]
>       5860535808 blocks super 0.91 level 6, 64k chunk, algorithm 18
> [5/4] [UUUU_]
>       [>....................]  reshape =  0.0% (1/1953511936)
> finish=1895.2min speed=16642K/sec
>
>  <....snip....>
> I stopped the array:
> # mdadm --stop /dev/md127
>
> Then tried re-assembling it (using the locally-built mdadm):
> # mdadm --assemble --verbose --update=revert-reshape /dev/md127 $devices
> mdadm: looking for devices for /dev/md127
> mdadm: /dev/sdd1: Can only revert reshape which changes number of devices
>
> Is the mdadm code only looking for the case where a new device was added but
> the raid level was not modified?  Recall, this was a 4-device raid5 that was
> attempted to be converted to a 5-device raid6.

Noah -

That's what I was afraid of. NeilBrown's patch was specific to the
corner case I encountered (SELinux' interruption of a RAID 6 change in
number of devices).

However, I was worse off than you are - I couldn't even find a way to
mount the filesystem to recover the data.

> Out of curiosity, from looking at the patch Neil committed to the tree, I also
> tried adding the --invalid-backup option:
>
> # ./md127/mdadm --assemble --verbose --update=revert-reshape
> --invalid-backup /dev/md127 $devices
> mdadm: looking for devices for /dev/md127
> mdadm: --update=revert-reshape not understood for 0.90 metadata
>
> I see the current metadata version is something like 1.2 now?  This array (now
> running on a Fedora 22 system) was originally created on a much older Fedora,
> at least as old as Fedora 9.

This is another delta from my situation. My RAID metadata was (and is)
version 1.2.

> I can create a new array out of the disks and dump my data back onto it if the
> array is really stuck in a state it can't get out of.  Is there anything else I
> should try first, or any other experiment to run?

I'll let others weigh in (I wouldn't say "never" until Neil says it
first 8^) -- but I can't see any easy outs.

George
-- 
George Rapp  (Pataskala, OH) Home: george.rapp -- at -- gmail.com
LinkedIn profile: https://www.linkedin.com/in/georgerapp
Phone: +1 740 936 RAPP (740 936 7277)
