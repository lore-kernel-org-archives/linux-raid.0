From: Richard Michael <rmichael@edgeofthenet.org>
Subject: Re: After RAID0 grow: inconsistent superblocks and /proc/mdstat
Date: Tue, 14 Jan 2014 12:09:49 -0500
Message-ID: <CABR0jETF0PvWTJ9fhoAvB00rE0q6cf7MyomVOp+nar+qrom5KA@mail.gmail.com>
References: <CABR0jETBgOtu8EbR0oT0TNP_ixg0-vBQUyPZbrDTFBYU3KTL4Q@mail.gmail.com>
 <20140113160324.189c96bd@notabene.brown> <CABR0jEQO7f4DCMbY1zVMDxxyUD3usVTK4Jt4L9p=QN+fb6P3Uw@mail.gmail.com>
 <20140114171116.048211eb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140114171116.048211eb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 14, 2014 at 1:11 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 13 Jan 2014 00:19:28 -0500 Richard Michael
> <rmichael@edgeofthenet.org> wrote:
>
>> Neil,
>>
>> Thank you for the quick reply.
>>
>> I have a few followup questions and comments, inlined below.
>
> I assume it was by mistake that you didn't copy the list on this follow
> and I've taken the liberty of copying the list for this reply.

Yes (typical reply v. reply-all) ; thank you.

>> On Mon, Jan 13, 2014 at 12:03 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Sun, 12 Jan 2014 23:37:57 -0500 Richard Michael
>> > <rmichael@edgeofthenet.org> wrote:
>> >
>> >> Hello list,
>> >>
>> >> I grew a RAID0 by one-disk, and it re-shaped via RAID4 as expected.
>> >>
>> >> However, the component superblocks still RAID4, while /proc/mdstat,
>> >> /sys/block/md0/md/level and "mdadm -D" all indicate RAID0.
>> >>
>> >> I am reluctant to stop the array, in case auto-assemble can't put it
>> >> back together.  (I suppose I could create a new array, but I'd want to
>> >> be quite confident about the layout of the disks.)
>> >>
>> >>
>> >> Is this a bug?  Should/can I re-write the superblock(s)?
>> >>
>> >>
>> >> # cat /proc/mdstat
>> >> Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
>> >> md0 : active raid0 sdc1[2] sdd1[0]
>> >>       5860268032 blocks super 1.2 512k chunks
>> >>
>> >> # cat /sys/block/md0/md/level
>> >> raid0
>> >>
>> >> # mdadm -D /dev/md0
>> >> /dev/md0:
>> >>         Version : 1.2
>> >>   Creation Time : Fri Jan 10 13:02:25 2014
>> >>      Raid Level : raid0
>> >>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>> >>    Raid Devices : 2
>> >>   Total Devices : 2
>> >>     Persistence : Superblock is persistent
>> >>
>> >>     Update Time : Sun Jan 12 20:08:53 2014
>> >>           State : clean
>> >>  Active Devices : 2
>> >> Working Devices : 2
>> >>  Failed Devices : 0
>> >>   Spare Devices : 0
>> >>
>> >>      Chunk Size : 512K
>> >>
>> >>     Number   Major   Minor   RaidDevice State
>> >>        0       8       49        0      active sync   /dev/sdd1
>> >>        2       8       33        1      active sync   /dev/sdc1
>> >>
>> >>
>> >>
>> >> But,
>> >>
>> >>
>> >> # mdadm -E /dev/sd[cd]1
>> >> /dev/sdc1:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : 8f51352a:610d0ecd:a1e28ddd:86c8586c
>> >>            Name : anvil.localdomain:0  (local to host anvil.localdomain)
>> >>   Creation Time : Fri Jan 10 13:02:25 2014
>> >>      Raid Level : raid4
>> >>    Raid Devices : 3
>> >>
>> >>  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
>> >>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>> >>   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>> >>     Data Offset : 260096 sectors
>> >>    Super Offset : 8 sectors
>> >>    Unused Space : before=260008 sectors, after=2959 sectors
>> >>           State : clean
>> >>     Device UUID : ad6e6c88:0f897bc1:1f6ec909:f599bc01
>> >>
>> >>     Update Time : Sun Jan 12 20:08:53 2014
>> >>   Bad Block Log : 512 entries available at offset 72 sectors
>> >>        Checksum : 1388a7b - correct
>> >>          Events : 9451
>> >>
>> >>      Chunk Size : 512K
>> >>
>> >>    Device Role : Active device 1
>> >>    Array State : AA. ('A' == active, '.' == missing, 'R' == replacing)
>> >> /dev/sdd1:
>> >>           Magic : a92b4efc
>> >>         Version : 1.2
>> >>     Feature Map : 0x0
>> >>      Array UUID : 8f51352a:610d0ecd:a1e28ddd:86c8586c
>> >>            Name : anvil.localdomain:0  (local to host anvil.localdomain)
>> >>   Creation Time : Fri Jan 10 13:02:25 2014
>> >>      Raid Level : raid4
>> >>    Raid Devices : 3
>> >>
>> >>  Avail Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
>> >>      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
>> >>     Data Offset : 260096 sectors
>> >>    Super Offset : 8 sectors
>> >>    Unused Space : before=260008 sectors, after=2959 sectors
>> >>           State : clean
>> >>     Device UUID : b3cda274:547919b1:4e026228:0a4981e7
>> >>
>> >>     Update Time : Sun Jan 12 20:08:53 2014
>> >>   Bad Block Log : 512 entries available at offset 72 sectors
>> >>        Checksum : e16a1979 - correct
>> >>          Events : 9451
>> >>
>> >>      Chunk Size : 512K
>> >>
>> >>    Device Role : Active device 0
>> >>    Array State : AA. ('A' == active, '.' == missing, 'R' == replacing)
>> >>
>> >>
>> >>
>> >> Somewhat aside, I grew the array with:
>> >>
>> >> "mdadm --grow /dev/md0 --raid-devices=2 --add /dev/sdc1"
>> >
>> > That is the correct command.
>> >
>> >>
>> >> I suspect I should not have used "--add".  Looking at the superblock,
>> >> there is a 3rd unknown device, which I did not intend to add.
>> >>
>> >> Did I convince mdadm to add two devices at the same time, sdc1 *and* a
>> >> missing device?  (This surprises me a bit, in the sense that
>> >> --raid-devices=2 would pertain to the added devices, rather than the
>> >> total devices in the array.)
>> >>
>> >> Or, perhaps mdadm add a "dummy" device as part of the temporary RAID4
>> >> conversion?
>> >
>> > Exactly.  The RAID4 had 1 more device than the RAID0.  What is what you are
>> > seeing.
>> >
>> > I'm a bit confused ... did you grow this from a 1-device RAID0 to a 2-device
>> > RAID0?  That seems like an odd thing to do, but it should certainly work.
>>
>> Yes.  I'm disk/data juggling.  I will copy the data from a third 3TB
>> into the new 2-disk 6TB RAID0, then convert it to RAID5 re-using the
>> third disk for parity.  (Perhaps there's a method with fewer hoops to
>> hop through.)
>
> Seems not-unreasonable.
>
>>
>> >
>> > This should work and I think I've tested it.  However looking at the code I
>> > cannot see how it ever would have done.  I cannot see anything that would
>> > write out the new metadata to the RAID0 after the reshape completes.
>> > Normally md will never write to the metadata of a RAID0 so it would need
>> > special handling which doesn't seem to be there.
>>
>> "never write to the metadata of a RAID0":  is this why there is no
>> Name, UUID or Events stanza in the "mdadm -D /dev/md0" output?
>>
>
> No.. That's just because the level recorded in the metadata is different from
> the level that md thinks the array is.  mdadm detects this inconsistency and
> decides not to trust the metadata.

Might be informative to include a comment in the mdadm -D output to
that effect.  (Although in this specific case, I gather once you've
fixed the RAID0/metadata write-out, there will no longer be this
inconsistency and therefore the stanza would have been present.)

>
>> >
>> > I just tried testing it on the current mainline kernel and it crashes  :-(
>> >
>> > So it looks like I need to do some fixing here.
>> >
>> > Your array should continue to work.  If you reboot, it will be assembled as a
>> > RAID4 with the parity disk missing.   This will work perfectly but may not be
>> > as fast as RAID0.  You can "mdadm --grow /dev/md0 --level=0" to convert it to
>> > RAID0 though it probably won't cause the metadata to be updated.
>>
>> How can I update the superblock?
>
> I look at the code some more and experimented and if you simply stop the
> array the metadata will be written out.  So after stopping the array it will
> appear to be RAID0.

This worked, thank you.  (Stopped and re-assembled without problem.)

>
>>
>> As I mentioned, the next step is convert to RAID5.  Will the RAID4
>> superblock confuse [in fact ] RAID0 to RAID5 re-shape?
>>
>
> Shouldn't do.  But if you can stop and restart the array to get the metadata
> updated, that would be safer.

Currently re-shaping to RAID5, no problems encountered.  (I notice in
the case of RAID0 to RAID5 re-shape, all the metadata has been updated
during the re-shape; mdadm -D/-E now report RAID5 with the spare
rebuilding.)

Thanks again for the reply.

Regards,
Richard


>
>>
>> >
>> > Thanks for the report.
>>
>> You're most welcome ; thank you!
>>
>> Regards,
>> Richard
>> >
>> > NeilBrown
>
> NeilBrown
