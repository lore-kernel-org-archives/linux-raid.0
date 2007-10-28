From: Luca Berra <bluca@comedia.it>
Subject: Re: Time to  deprecate old RAID formats?
Date: Sun, 28 Oct 2007 15:13:36 +0100
Message-ID: <20071028141336.GC22861@percy.comedia.it>
References: <1192813877.1666.79.camel@firewall.xsintricity.com> <18200.63987.514073.184865@stoffel.org> <20071019212303.GB2013@teal.hq.k1024.org> <1192830129.1666.103.camel@firewall.xsintricity.com> <20071020075349.GA17431@teal.hq.k1024.org> <1192885917.1666.112.camel@firewall.xsintricity.com> <20071026095417.GC32550@percy.comedia.it> <1193424779.10336.287.camel@firewall.xsintricity.com> <20071026223046.GB8210@boogie.lpds.sztaki.hu> <1193531160.10336.397.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1193531160.10336.397.camel@firewall.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Oct 27, 2007 at 08:26:00PM -0400, Doug Ledford wrote:
>On Sat, 2007-10-27 at 00:30 +0200, Gabor Gombas wrote:
>> On Fri, Oct 26, 2007 at 02:52:59PM -0400, Doug Ledford wrote:
>> 
>> > In fact, no you can't.  I know, because I've created a device that had
>> > both but wasn't a raid device.  And it's matching partner still existed
>> > too.  What you are talking about would have misrecognized this
>> > situation, guaranteed.
>> 
>> Maybe we need a 2.0 superblock that contains the physical size of every
>> component, not just the logical size that is used for RAID. That way if
>> the size read from the superblock does not match the size of the device,
>> you know that this device should be ignored.
>
>In my case that wouldn't have helped.  What actually happened was I
>create a two disk raid1 device using whole devices and a version 1.0
>superblock.  I know a version 1.1 wouldn't work because it would be
>where the boot sector needed to be, and wasn't sure if a 1.2 would work
>either.  Then I tried to make the whole disk raid device a partitioned
>device.  This obviously put a partition table right where the BIOS and
>the kernel would look for it whether the raid was up or not.  I also
the only reason i can think for the above setup not working is udev
mucking with your device too early.

>tried doing an lvm setup to split the raid up into chunks and that
>didn't work either.  So, then I redid the partition table and created
>individual raid devices from the partitions.  But, I didn't think to
>zero the old whole disk superblock.  When I made the individual raid
>devices, I used all 1.1 superblocks.  So, when it was all said and done,
>I had a bunch of partitions that looked like a valid set of partitions
>for the whole disk raid device and a whole disk raid superblock, but I
>also had superblocks in each partition with their own bitmaps and so on.
OK

>It was only because I wasn't using mdadm in the initrd and specifying
>uuids that it found the right devices to start and ignored the whole
>disk devices.  But, when I later made some more devices and went to
>update the mdadm.conf file using mdadm -Eb, it found the devices and
>added it to the mdadm.conf.  If I hadn't checked it before remaking my
>initrd, it would have hosed the system.  And it would have passed all
the above is not clear to me, afair redhat initrd still uses
raidautorun, which iirc does not works with recent superblocks,
so you used uuids on kernel command line?
or you use something else for initrd?
why would remaking the initrd break it?

>the tests you can throw at it.  Quite simply, there is no way to tell
>the difference between those two situations with 100% certainty.  Mdadm
>tries to be smart and start the newest devices, but Luca's original
>suggestion of skip the partition scanning in the kernel and figure it
>out from user space would not have shown mdadm the new devices and would
>have gotten it wrong every time.
yes, in this particular case it would have, congratulation you found a new
creative way of shooting yourself in the feet.

maybe mdadm should do checks when creating a device to prevent this kind
of mistakes.
i.e.
if creating an array on a partition, check the whole device for a
superblock and refuse in case it finds one

if creating an array on a whole device that has a partition table,
either require --force, or check for superblocks in every possible
partition.

L.
-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
