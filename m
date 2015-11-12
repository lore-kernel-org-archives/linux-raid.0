From: Joshua Kinard <kumba@gentoo.org>
Subject: Re: Problem w/ commit ac8fa4196d20 on older, slower hardware
Date: Thu, 12 Nov 2015 17:28:41 -0500
Message-ID: <56451299.6090107@gentoo.org>
References: <87twq0527k.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87twq0527k.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/08/2015 20:13, Neil Brown wrote:
> 
>> Per commit ac8fa4196d20:
>>
>>> md: allow resync to go faster when there is competing IO.
>>>
>>> When md notices non-sync IO happening while it is trying to resync (or
>>> reshape or recover) it slows down to the set minimum.
>>>
>>> The default minimum might have made sense many years ago but the drives have
>>> become faster. Changing the default to match the times isn't really a long
>>> term solution.
>>
>> This holds true for modern hardware, but this commit is causing problems on
>> older hardware, like SGI MIPS platforms, that use mdraid.  Namely, while trying
>> to chase down an unrelated hardlock bug on an Onyx2, one of the arrays got out
>> of sync, so on the next reboot, mdraid's attempt to resync at full speed
>> absolutely murdered interactivity.  It took close to 30mins for the system to
>> finally reach the login prompt.
>>
>> Revert this patch was working to mitigate the problem at first, but it appears
>> that in recent kernels, this is no longer the case, and reverting this commit
>> has no noticeable effect anymore.  I assume I'd have to hunt down newer commits
>> to revert, but it's probably saner to just highlight the problem and test any
>> proposed solutions.
>>
>> Is there some way to resolve this in such a way that old hardware maintains
>> some level of interactivity during a resync, but that won't inconvenience the
>> more modern systems?
>>
>> http://git.linux-mips.org/cgit/ralf/linux.git/commit/?id=ac8fa4196d20
>>
>> Thanks!,
>>
> 
> Hmmm... this change shouldn't have that effect.
> It should allow resync to soak up a bit more of the idle time, but when
> there is any other IO, resync should still back off.
> 
> I wonder if there is some other change which has confused the event
> counting for the particular hardware you are using.
> 
> How did you identify this commit as a possible cause?

Sorry for the late response.  I pinned down this particular commit as the cause
on an SGI Onyx2 (IP27), which is a MIPS big-endian platform that supports
ccNUMA.  The SCSI chip is a QLogic ISP1040B.  It's been supported in the
mainline kernel for a long time, but has suffered from bit-rot over the years.
 There's an unidentified bug somewhere in the architecture code that, under
heavy disk I/O or memory operations (I am not sure which, yet), the machine
will completely lock up hard.

I have three ~50GB SCA SCSI drives plugged into it, running MD RAID5 and the
XFS filesystem.  I have /, /home, /usr, /var, and /tmp on separate partitions,
each a RAID5 setup.  After one of these hard lockups, on the next reboot, the
kernel detected that my largest partition, /usr, needed to be rebuilt, so it
launched a background resync.  The other partitions were fine.

I noticed after several minutes that the kernel had still not proceeded to
execute /init, and that XFS hadn't even mounted the rootfs yet.  I thought the
machine had hardlocked again.  The lockup bug normally does not happen with a
resync (which takes place entirely within the kernel), but more so when running
commands from userspace.  Physically checking the machine, the disk lights were
showing drive activity, so I let it sit for a good half-hour, and when I later
checked the serial console out, it had gotten most of the way through the
bootup process and was still bringing up runlevel 3 services.

Logging into the root console several minutes later showed the resync was
almost complete, but interactivity remained very sluggish until the resync
finished.  So I dug into gitweb on linux-mips.org and looked for any recent
commits to md.c that might have something to do with resync operations, and
this one stood out the most.  Reverting it, then forcing the lockup bug to
happen several times until another background resync took place showed
drastically-improved bootup speed.  The machine was able to boot to userland
within ~4-6 mins with the background resync happening on /usr.

I think this was on 3.19 or 4.0 (I forget).  It was on the next version up that
I noticed the revert was no longer having an effect, and a resync slowed I/O
down enough that booting to userland was back into the ~30min range.  I have
also noticed that the lockup bug is also happening, randomly, during a resync
now too.  I suspect whatever issue is causing the lockup is getting worse.

The last kernel I booted on this platform was a 4.2-rcX release.  I have not
had time to test 4.3.x out.

I have also reproduced the same issue on an SGI Octane (IP30), which needs
out-of-tree patches to work.  It's basically the smaller cousin of an
Origin/Onyx2, using the same CPU, SCSI chip, same partition layout, same
filesystem.  Only the disks, 3x 73GB SCA SCSI disks, and some internal hardware
architecture, are different between the two.  It does not suffer from any
lockup bugs whatsoever, and I only triggered a background resync when I got
frustrated at an unrelated issue and powered the machine off out of annoyance.

Per hdparm -tT, the average I/O speed is ~160MB/sec reading from cache, and
~18.3MB/sec reading from the /dev/mdX devices.  Reading from the individual
/dev/sdX drives is slightly faster at ~18.5MB/sec.  This is true for both machines.


> The fact that reverting it no longer helps strongly suggests that some
> other change is implicated.  I don't think there have been other changes
> in md which could affect this.

The changes to the code that this commit affected seems to play some role in
the issue, but I agree that it does not appear to be the sole participant anymore.


> Have you tried adjusting /proc/sys/dev/raid/speed_limit_m{ax,in} ??
> Did that have any noticeable effect?

Hard to do when your kernel takes 30+ minutes to boot up :)  Once I got to
userland in one instance, though, I did touch one of the /proc parameters (I
for get which one, but it had something to do w/ the minimum background I/O
speed) and dropped it down to 1,000K/sec, the machine's responsiveness improved
dramatically.

The real issue of what's causing the lockups in the first place ultimately
needs to be chased down, but I lack the debugging skills necessary to do that.
 I tend to stop for the night when the resync needs to take place and power the
machine down, as it drinks ~700W+, and I save the long resync for a day when
utility rates are low.

--J
