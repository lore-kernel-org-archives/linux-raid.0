From: Neil Brown <neilb@suse.de>
Subject: Re: read errors corrected
Date: Thu, 30 Dec 2010 20:15:01 +1100
Message-ID: <20101230201501.2f39a85f@notabene.brown>
References: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimmuxMU1yVHcg8fjB6CUtkhq_dxAkm_+Hv+UoTX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: James <jtp@nc.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 30 Dec 2010 03:20:48 +0000 James <jtp@nc.rr.com> wrote:

> All,
> 
> I'm looking for a bit of guidance here. I have a RAID 6 set up on my
> system and am seeing some errors in my logs as follows:
> 
> # cat messages | grep "read erro"
> Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
> sectors at 974262528 on sda4)
> Dec 15 15:40:34 nuova kernel: md/raid:md4: read error corrected (8
> sectors at 974262536 on sda4)
.....

> 
> I've Google'd the heck out of this error message but am not seeing a
> clear and concise message: is this benign? What would cause these
> errors? Should I be concerned?
> 
> There is an error message (read error corrected) on each of the drives
> in the array. They all seem to be functioning properly. The I/O on the
> drives is pretty heavy for some parts of the day.
> 
> # cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
> [raid4] [multipath]
> md1 : active raid6 sdb1[1] sda1[0] sdd1[3] sdc1[2]
>       497792 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> md2 : active raid6 sdb2[1] sda2[0] sdd2[3] sdc2[2]
>       4000000 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> md3 : active raid6 sdb3[1] sda3[0] sdd3[3] sdc3[2]
>       25992960 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> md4 : active raid6 sdb4[1] sda4[0] sdd4[3] sdc4[2]
>       2899780480 blocks level 6, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> unused devices: <none>
> 
> I have a really hard time believing there's something wrong with all
> of the drives in the array, although admittedly they're the same model
> from the same manufacturer.
> 
> Can someone point me in the right direction?
> (a) what causes these errors precisely?

When md/raid6 tries to read from a device and gets a read error, it try to
read from other other devices.  When that succeeds it computes the data that
it had tried to read and then write it back to the original drive.  If this
succeeded is assumes that the read error has been correct by a write, and
prints the message that you see.


> (b) is the error benign? How can I determine if it is *likely* a
> hardware problem? (I imagine it's probably impossible to tell if it's
> HW until it's too late)

A few occasional messages like this are fairly benign.  The could be a sign
that the drive surface is degrading.  If you see lots of these messages, then
you should seriously consider replacing the drive.

As you are seeing these message across all devices, it is possible that the
problem is with the sata controller rather than the disks.  Do know which you
should check the errors that are reported in dmesg.  If you don't understand
these message, then post them to the list - feel free to post several hundred
lines of logs - too much is much much better than not enough.

NeilBrown



> (c) are these errors expected in a RAID array that is heavily used?
> (d) what kind of errors should I see regarding "read errors" that
> *would* indicate an imminent hardware failure?
> 
> Thoughts and ideas would be welcomed. I'm sure a thread where some
> hefty discussion is thrown at this topic will help future Googlers
> like me. :)
> 
> -james
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

