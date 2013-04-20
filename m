From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sat, 20 Apr 2013 03:26:43 +0200
Message-ID: <5171EED3.8030505@bucksch.org>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171CB91.1040708@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Maarten <maarten@ultratux.net>
List-Id: linux-raid.ids

linux.news@bucksch.org wrote, On 20.04.2013 00:56:
> Maarten wrote, On 18.04.2013 15:58:
>> On 18/04/13 15:17, Ben Bucksch wrote:
>>> To re-summarize (for full info, see first post of thread):
>>> * There are 2 RAID5 arrays in the machine, each have 8 disks.
>>> * I upgraded Ubuntu 10.04 to 12.04.
>>> * After reboot, both arrays had each ejected one disk.
>>>    The ejected disks are working fine (at least now).
>>> * During the resync mandated by above ejection,
>>>     one other drive failed, this one fatally with a real hardware 
>>> failure.
>>> * The second array resynced fine, further proving that the
>>>     disks ejected during upgrade were working.
>>> * Now I am left with: originally 8-disk RAID5, 6 disks are healthy,
>>>    1 disk with hardware failure, and 1 disk that was ejected, but is
>>> working.
>>> * The latter is currently marked "spare" by md and has an event count
>>>    (only) 2 events lower than the other 6 disks.
>>> * My task is to get the latter disk back online *with* its data, 
>>> without
>>> resync.
>>>
>>> I desperately need help, please.
>>>
>>> Based on suggestions here by Oliver and on forums, I did (and the 
>>> result
>>> is):
>>>
>>>> # mdadm --stop /dev/md0
>>>> mdadm: stopped /dev/md0
>>>> # mdadm --assemble --run --force /dev/md0 /dev/sd[jlmnopq]
>>>> mdadm: failed to RUN_ARRAY /dev/md0:
>>>> mdadm: Not enough devices to start the array.
>> At this point, does dmesg show anything pointing to that input/output
>> error ? The procedure is correct
>
> [dmesg]
> The problem is:
> md: kicking non-fresh sdl from array!
> thus:
> raid5: not enough operational devices for md0 (2/8 failed)
>
> So, the question is: How do I convince md not to be so anal retentive 
> and prevent me from accessing any of my data? The drive ***is fine***, 
> has practically all the data (I don't care about these 2 events), just 
> use it already. Nobody seems to know the magic shell commands to do that.

Good news:
In my desperation, I now ran the following dangerous command:
mdadm --create /dev/md0 --assume-clean --level=raid5 -n 8 --chunk=64 
--layout=left-symmetric --metadata=0.90 /dev/sdj missing /dev/sdl 
/dev/sd[mopnq]
and that worked. I can read my files again, without problem, all is happy.

Before doing that, I saved the superblock, using (no warranty!):
1. mdadm -E /dev/sdj
2. "Used Dev Size" (in KB) * 1024 / 64 - 1 (use this as <skip blocks>)
3. dd if=/dev/sdl of=/root/sdj.mdsuperblock  ibs=64 skip=<skip blocks>

---

Thanks, Maarten and Oliver, for your help and moral support.

---

I still maintain that all of this represents 2 design bugs in the md 
implementation:
1. ejecting devices out that are working
1.1. individual sectors not readable/writable, but rest of device working
      (This is very common these days with large drives)
1.2. temporary errors, e.g. disk not connected, loose cable, bad 
controller etc.
1.3. Linux distro upgrade, no disk problem at all (my case)
2. not allowing me to re-add ejected disks, with data, without resync

The result of this is:
1. a device is ejected for no good reasons
2. a resync is triggered
3. the resync discovers a disk that is *really* broken

I am left with 2 disks marked "failed", but only 1 actually failed, so 
normally I should be able to recover, yet I cannot read anything. This 
fails the very definition of RAID5, therefore is a bug. I have to do 
risky operations like re-create that can easily destroy all data. 
Effectively, md achieves the opposite that is intended: It actively 
risks and destroys my data.

I am BEGGING you md raid devs to fix these.

Ben Bucksch
