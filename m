From: Chris Murphy <lists@colorremedies.com>
Subject: Re: problems with dm-raid 6
Date: Mon, 21 Mar 2016 15:26:30 -0600
Message-ID: <CAJCQCtQDWdZPBvB1Q2Mh_AOBZpWSPoqK42meWvARhQi3hE5uzw@mail.gmail.com>
References: <trinity-235b76ed-571d-4615-b6f7-b4d5ed6a116d-1458509365312@3capp-gmx-bs09>
	<trinity-dd5fc296-8c28-4b99-85de-889a495e6956-1458510296940@3capp-gmx-bs09>
	<20160320223727.GA29895@EIS>
	<56EFEC28.7020207@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56EFEC28.7020207@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Patrick Tschackert <Killing-Time@gmx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Original thread on btrfs list (the OP links here didn't work for me):
http://www.spinics.net/lists/linux-btrfs/msg53143.html



On Mon, Mar 21, 2016 at 6:42 AM, Phil Turmel <philip@turmel.org> wrote:
> Hi Patrick,
>
> On 03/20/2016 06:37 PM, Andreas Klauer wrote:
>> On Sun, Mar 20, 2016 at 10:44:57PM +0100, Patrick Tschackert wrote:
>>> After rebooting the system, one of the harddisks was missing from my md raid 6 (the drive was /dev/sdf), so i rebuilt it with a hotspare that was already present in the system.
>>> I physically removed the "missing" /dev/sdf drive after the restore and replaced it with a new drive.
>
> Your smartctl output shows pending sector problems with sdf, sdh, and
> sdj.  The latter are WD Reds that won't keep those problems through a
> scrub, so I guess the smartctl report was from before that?

From what I understand, no, the smartctl are after the scrub check.
The dmesg shows read errors but no md attempt to fix up those errors,
which I thought was strange but might be a good thing if the raid is
not assembled correctly.


>> Your best bet is that the data is valid on n-2 disks.
>>
>> Use overlay https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>>
>> Assemble the overlay RAID with any 2 disks missing (try all combinations) and see if you get valid data.
>
> No.  Something else is wrong, quite possibly hardware.  You don't get a
> mismatch count like that without it showing up in smartctl too, unless
> corrupt data was being written to one or more disks for a long time.
>
> It's unclear from your dmesg what might have happened.  Probably bad
> stuff going back years.

Seems unlikely because this was a functioning raid6 with Btrfs on top.
So there'd have been a ton of Btrfs complaints.

I think something wrong happened with the device replace procedure, I
just can't tell what because all the devices are present and working
according to the -D output.

In that first message on the btrfs list you can see what things work
and don't work in more detail. The summary is, all three Btrfs super
blocks are found. This wouldn't be possible if the array weren't at
least partially correct, and also the LUKS volume were being unlocked
correctly. Unless there's something very nuanced and detailed we're
not understanding yet.

But as soon as commands are used to look for other things, there are
immediate failures, lots of metadata checksum errors, an inability to
read the chunk and root trees. So it's like there's a hole in the file
system. I just can't tell if it's a small one like the size of a drive
or a big one.


> Otherwise you are at the mercy of fsck to try to fix your volume.  I
> would use an overlay for that.

At this point I'm skeptical this will work. Also, I'm not familiar
with this overlay technique. I did look at the URL provided by
Andreas, my concern is whether it's possible for the volume UUID to
appear more than once to the kernel? There are some very tricky things
about Btrfs's dependency on volume UUID that can make it get confused
where it should be writing when it sees more than one device with the
same UUID. This is a problem with for example Btrfs on LVM, taking a
snapshot of an LV, and both LV's being active means in effect two
Btrfs instances with the same UUID and Btrfs can clobber them both in
a bad way.
https://btrfs.wiki.kernel.org/index.php/Gotchas

I really think the Btrfs file system, based on the OP's description on
the Btrfs list, is probably OK. The issue is raid6 assembly somehow
being wonky. Even if it were double degraded by pulling any two
suspect drives, I'd expect things to immediately get better and a
nomodify 'btrfs check' will then come up clean. The OP had a clean
shutdown. But it's an open question how long after device failure he
actually noticed it before doing the rebuild and how he did that
rebuild; and whether there's missing critical data on any of the other
bad sectors on the three remaining drives. Chances are, those sectors
don't overlap though.

But at this point we need to hear back from Patrick.

-- 
Chris Murphy
