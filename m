From: Marco Fuckner <marco@die-fuckners.de>
Subject: Re: RAID5 assemble fails after reboot while reshaping
Date: Mon, 18 May 2015 01:14:05 +0200
Message-ID: <555920BD.1000201@die-fuckners.de>
References: <5558C551.80203@die-fuckners.de> <5558E34F.4060708@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5558E34F.4060708@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey Phil,

Am 17.05.2015 um 20:51 schrieb Phil Turmel:
> Hi Marco,
>
> On 05/17/2015 12:44 PM, Marco Fuckner wrote:
>> Hi everybody,
>>
>> first of all, I'm using mdadm 3.3.2 on linux 4.0.1, all of my disks are
>> partitioned with the same geometry.
>>
>> I wanted to grow my 4 disk RAID5 array to 7 disks. After adding the
>> disks and initiating the grow, the reshape didn't seem to start:
>>
>>     md0 : active raid5 sdf1[7] sde1[6] sdd1[5] sdg1[3] sdb1[4] sdh1[1]
>> sdc1[0]
>>         11720044800 blocks super 1.2 level 5, 256k chunk, algorithm 2
>> [7/7] [UUUUUUU]
>>         [>....................]  reshape =  0.0% (0/3906681600)
>> finish=166847860.0min speed=0K/sec
>>         bitmap: 0/30 pages [0KB], 65536KB chunk
> Do you have the exact command you used to start the grow available?  Did
> you include a backup file?  Was it on a device outside the raid?
I used mdadm --grow --raid-devices=7 /dev/md0
--backup-file=/root/grow7backup.bak, the system is on a single disk
outside of the RAID.
> So nothing (or garbage) was written to your backup in the first place.
> Try again with the "--invalid-backup" option to skip trying to read the
> supposedly backed up critical section.  You may have corruption to fix
> for that small section.
With the --invalid-backup switch it looks like this:
    mdadm: looking for devices for /dev/md0
    mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 3.
    mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
    mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 6.
    mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 5.
    mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
    mdadm: /dev/sdg1 is identified as a member of /dev/md0, slot 2.
    mdadm: /dev/sdh1 is identified as a member of /dev/md0, slot 1.
    mdadm: :/dev/md0 has an active reshape - checking if critical
section needs to be restored
    mdadm: No backup metadata on device-4
    mdadm: No backup metadata on device-5
    mdadm: No backup metadata on device-6
    mdadm: Failed to find backup of critical section
    mdadm: continuing without restoring backup
    mdadm: added /dev/sdh1 to /dev/md0 as 1
    mdadm: added /dev/sdg1 to /dev/md0 as 2
    mdadm: added /dev/sdb1 to /dev/md0 as 3
    mdadm: added /dev/sdf1 to /dev/md0 as 4
    mdadm: added /dev/sde1 to /dev/md0 as 5
    mdadm: added /dev/sdd1 to /dev/md0 as 6
    mdadm: added /dev/sdc1 to /dev/md0 as 0
    mdadm: failed to RUN_ARRAY /dev/md0: Invalid argument

This was the case with either my normal system or using a rescue CD
(mdadm 3.3.1-r2 and linux 3.14.35).
> Good report.  Unfortunately, it sounds like a bug.
>
> If the --invalid-backup option doesn't help, my next suggestion would be
> to temporarily boot with a system rescue CD and continuing the --grow
> operation with a more stable kernel.  If your backup file isn't empty,
> put it on a thumb drive or somewhere accessible to a rescue boot.
>
> If it works with a slightly older kernel, we'll need Neil.
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
The backup file itself is about 1,6M in size. Commands with --grow fail
as the array is marked as inactive:
    mdadm: /dev/md0 is not an active md array - aborting

I forgot to include the current status in the last mail:
    md0 : inactive sdf1[7](S) sdg1[3](S) sdc1[0](S) sde1[6](S)
sdh1[1](S) sdd1[5](S) sdb1[4](S)
      27346771700 blocks super 1.2

It seems like every disk is falsely recognized as a spare?

Regards,

Marco

