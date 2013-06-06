From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 growing interrupted, array won't assemble or resume growing
Date: Thu, 06 Jun 2013 13:31:21 -0400
Message-ID: <51B0C769.1070009@turmel.org>
References: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGjXdAhMHEFFc1C0XUSY_K1ZxwaRG-x=NEw9H2Aiv+YtNat-tw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nic Wolfe <nic@wolfeden.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/06/2013 02:41 AM, Nic Wolfe wrote:
> First a little bit of background about my setup and how I got into this state:

Very good report.

> I'm running an older version of ubuntu with a 2.6.24.5 kernel and
> mdadm 2.6.3. I had a 5x2TB raid6 array which I attempted to grow to a
> 6x2TB array. While it was growing I had some hardware problems and the
> disks in the array sporadically connected/disconnected. This put the
> array in a bad state.

The old kernel and mdadm concern me.  Patches go through the mailing
list pretty steadily, both for features and bugs.

> After fixing my hardware issues and getting the PC back up I had a
> problem where after booting mdadm would consume all my RAM trying to
> assemble my array (oom_killer started killing indiscriminately and I
> couldn't get on the PC to shut it down, had to power cycle it). I
> added some more memory (from 2GB to 4GB) and mdadm now only takes up
> about 70% before it exits with no results that I can tell. Below are
> the processes which run when I boot:

This sounds like an udev issue.  Probably not a problem on a stable
system, but you have an intermediate state.

[trim /]

> So anyway now that I have the system stable and all 6 drives hooked up
> I would very much like to get the array working again.
> 
> I have the following in my mdadm.conf: ARRAY /dev/md1 level=raid6
> num-devices=5 UUID=4672ced4:81401dbc:52723fc8:3fe02f5a
> (it is currently commented out, note that it didn't get updated after
> growing to 6)

mdadm is never updated automatically by the vanilla tools.  You get to
do that yourself.  Although you'd be fine to simply remove the level=
and num-devices= clauses.  (Remember to update your initramfs, too.)

> Below is the --examine for all 6 drives:

Yes!  The most important data you could report.

> midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sda
> mdadm: No md superblock detected on /dev/sda.
> midgetspy@MidgetNAS:~$ sudo mdadm --examine /dev/sdb
> /dev/sdb:
>           Magic : a92b4efc
>         Version : 00.91.00
                    ^^^^^^^^
This means a normally v0.90 array has a reshape in progress.  That
prevents really old kernels from mistakenly assembling it.

>            UUID : 4672ced4:81401dbc:52723fc8:3fe02f5a (local to host MidgetNAS)
>   Creation Time : Wed Jun  2 21:11:18 2010
>      Raid Level : raid6
>   Used Dev Size : 1953431488 (1862.94 GiB 2000.31 GB)
>      Array Size : 7813725952 (7451.75 GiB 8001.26 GB)
>    Raid Devices : 6
>   Total Devices : 6
> Preferred Minor : 1
> 
>   Reshape pos'n : 665856 (650.36 MiB 681.84 MB)
>   Delta Devices : 1 (5->6)

Your reshape is barely started.  Presumably you specified a --backup
clause in the original --grow command.  You will need that file.

[trim /]

> How should I proceed? I'm far enough out of my depth that I'm hesitant
> to try anything for fear of causing more damage. Should I update my
> mdadm.conf to have num-devices=6 and see if it sorts itself out?

No.

> Try to force assemble the 5 drives with superblocks?

Yes, but see below.

> Create a "new" array out of them?

Absolutely not.

> Any input would be greatly appreciated.

Modern mdadm should be able to force assemble this and continue without
problems.  Rather than operate within a questionable environment, I
would strongly encourage you to perform the forced assembly with a
recent live cd.  I personally use "SystemRescueCD", and I know it has
the appropriate kernel support and tools.

But.  You need to share more information about your hardware problems.
Dmesg, etc.  There are commonly-encountered configuration problems that
appear to be mysterious drive failures.  If you know all about error
recovery control, please elaborate.  Otherwise, please share the output
of "smartctl -x /dev/sdX" for all of your member devices.

Phil
