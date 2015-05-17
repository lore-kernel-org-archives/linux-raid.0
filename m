From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID5 assemble fails after reboot while reshaping
Date: Sun, 17 May 2015 14:51:59 -0400
Message-ID: <5558E34F.4060708@turmel.org>
References: <5558C551.80203@die-fuckners.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5558C551.80203@die-fuckners.de>
Sender: linux-raid-owner@vger.kernel.org
To: Marco Fuckner <marco@die-fuckners.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Marco,

On 05/17/2015 12:44 PM, Marco Fuckner wrote:
> Hi everybody,
> 
> first of all, I'm using mdadm 3.3.2 on linux 4.0.1, all of my disks are
> partitioned with the same geometry.
> 
> I wanted to grow my 4 disk RAID5 array to 7 disks. After adding the
> disks and initiating the grow, the reshape didn't seem to start:
> 
>     md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
> sdc1[0]
>         11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
> [7/7] [UUUUUUU]
>         [>....................]  reshape =  0.0% (0/3906681600)
> finish=166847860.0min speed=0K/sec
>         bitmap: 0/30 pages [0KB], 65536KB chunk

Do you have the exact command you used to start the grow available?  Did
you include a backup file?  Was it on a device outside the raid?

> I waited about three hours and checked again:
> 
>     md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
> sdc1[0]
>         11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
> [7/7] [UUUUUUU]
>         [>....................]  reshape =  0.0% (0/3906681600)
> finish=9599856140.0min speed=0K/sec
>         bitmap: 0/30 pages [0KB], 65536KB chunk

That's not good.  Looks like it is choking on the very first critical
section backup.

> Unfortunately, I forgot to save the output of the grow command, but it
> exited with 0.

[trim /]

> As it looked like it wouldn't be ready until long after my death and I
> also wrote a backup file, somehow restarting and continuing afterwards
> seemed reasonable to me.
> The source I was reading suggested running /mdadm /dev/md0 --continue
> --backup-file=$FILE/. Apparently this command was wrong, and I couldn't
> reassamble the array:
> 
> # mdadm --assemble /dev/md0 --verbose /dev/sd[b-h]1
> --backup-file=/root/grow7backup.bak

Ah.  That looks like a backup file in an appropriate location. :-)

>     mdadm: looking for devices for /dev/md0
>     mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
>     mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 5.
>     mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 6.
>     mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 2.
>     mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 3.
>     mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 1.
>     mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
>     mdadm: :/dev/md0 has an active reshape - checking if critical
> section needs to be restored
>     mdadm: No backup metadata on /root/grow7backup.bak
>     mdadm: No backup metadata on device-4
>     mdadm: No backup metadata on device-5
>     mdadm: No backup metadata on device-6
>     mdadm: Failed to find backup of critical section
>     mdadm: Failed to restore critical section for reshape, sorry.

So nothing (or garbage) was written to your backup in the first place.
Try again with the "--invalid-backup" option to skip trying to read the
supposedly backed up critical section.  You may have corruption to fix
for that small section.

> I started searching for answers but didn't find anything helpful except
> the hint on the raid.wiki.kernel.org page to send an email here. The
> last sentence from mdadm sounds a bit pessimistic, but I hope someone in
> here can help me. The output of /mdadm --examine /dev/sd[bh]1 /is in the
> attachment.

Good report.  Unfortunately, it sounds like a bug.

If the --invalid-backup option doesn't help, my next suggestion would be
to temporarily boot with a system rescue CD and continuing the --grow
operation with a more stable kernel.  If your backup file isn't empty,
put it on a thumb drive or somewhere accessible to a rescue boot.

If it works with a slightly older kernel, we'll need Neil.

Phil
