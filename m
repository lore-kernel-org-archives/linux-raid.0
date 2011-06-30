From: Phil Turmel <philip@turmel.org>
Subject: Re: Antw: Re: nested block devices (partitioned RAID with LVM): where
 Linux sucks ;-)
Date: Thu, 30 Jun 2011 09:01:56 -0400
Message-ID: <4E0C73C4.3090307@turmel.org>
References: <4E0AED02020000A100006458@gwsmtp1.uni-regensburg.de> <4E0B3A2A.3050906@turmel.org> <4E0C5DAF020000A1000064C9@gwsmtp1.uni-regensburg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0C5DAF020000A1000064C9@gwsmtp1.uni-regensburg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: neilb@suse.de, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Ulrich,

[added linux-raid back to the CC]

On 06/30/2011 05:27 AM, Ulrich Windl wrote:
>>>> Phil Turmel <philip@turmel.org> schrieb am 29.06.2011 um 16:43 in Nachricht
> <4E0B3A2A.3050906@turmel.org>:
>> [Added linux-raid.  Where this should have gone in the first place.]
>>
>> Note:  I'm somewhat less polite than usual, considering the subject line and 
>> tone.
> 
> Never mind, I also have no humour ;-) Hi anyway!

Thick skin helps in technical environments.

>> On 06/29/2011 03:14 AM, Ulrich Windl wrote:
>>> Hi!
>>>
>>> I decided to write this to the general kernel list instead of sending to 
>> the more specific lists, as this seems to be a colaboration issue:
>>
>> There's nothing in your report about general kernel development, sorry.  
>> Doesn't seem to be a collaboration issue, either.  A distribution issue, 
>> perhaps.
> 
> Well, this issue may be between LVM, MD-RAID, partition tables, and the order in which things are activated. I don't know the interfaces lsof of fuser use, but possibly these may also be affected. It's not a problem of MD-RAIS alone.

The order in which things are activated effectively random.  The kernel does not guarantee probe order, although it tends to be quite consistent from one boot to another.  The kernel just notifies udev as each device is found, and udev requests help from LVM and mdadm to decide what to do with them.  You have control over this process: you can customize udev rules, and you can restrict which devices LVM and mdadm look at.  So it is either the distributions fault that your complex setup didn't "just work", or your own, for lack of configuration.

>>> For SLES11 SP1 (x86_64) I had configured a MD-RAID1 (0.9 superblock) on 
>> multipathed SAN devices (the latter should not be important). Then I 
>> partitioned the RAID, and one partition was used as PV for LVM. A VG had been 
>> created and LVs in it. Filesystems created, populated, etc.
>>
>>> The RAID device was being used as boot disk for XEN VMs. Everything worked 
>> fine until the host machine was rebooted.
>>
>> I hope you didn't put it in production without testing.
> 
> False hope, it is productive, because I have neither time nor hardware for testing.

The layered block device subsystem doesn't start up the way you expected, and it bit you.  I don't understand how a professional environment can *not* have time for testing.  That's definitely neither the kernel's problem, nor Novell's problem.

>>> (Note: The mdadm command (mdadm - v3.0.3 - 22nd October 2009) has several 
>> mis-features regarding proper error reporting standards)
>>
>> Indeed, 2-1/2 years in the open source world closes many bugs.  Please 
>> retest with current kernel, udev, mdadm, and LVM.
> 
> Well, mdadm is the latest, and the distro is the latest Novell provides (all updates installed). CCing: Neil Brown for that reason.

No, 3.0.3 is not the latest.  It may be the latest Novell provides, but kernel devs can't fix that.

>> FWIW, the default metadata was changed to v1.1 in November of 2009, and 
>> later to v1.2.  Either would have avoided your problems.
> 
> According to the docs, only v1.1 pits the metadata at the beginning of the device. According to them man, v1.2 put the metadata 4K from the beginning. I suspect, partitions would have been found with v1.2 also, right?

In both v1.1 and v1.2, the nested data starts after the metadata (with additional space reserved for a bitmap, and then alignment).  In both v0.90 and v1.0, the data starts at block zero, with the metadata after.  So, no, v1.2 metadata does not have the problem you encountered.

>>> The RAIDs couldn't be assembled with errors like this:
>>> mdadm: /dev/disk/by-id/dm-name-whatever-E1 has wrong uuid.
>>> mdadm: /dev/disk/by-id/dm-name-whatever-E2 has wrong uuid.
>>>
>>> However:
>>> # mdadm --examine /dev/disk/by-id/dm-name-whatever-E1 |grep -i uuid
>>>            UUID : 2861aad0:228a48bc:f93e96a3:b6fdd813 (local to host host)
>>> # mdadm --examine /dev/disk/by-id/dm-name-whatever-E2 |grep -i uuid
>>>            UUID : 2861aad0:228a48bc:f93e96a3:b6fdd813 (local to host host)
>>>
>>> Only when calling "mdadm -v -A /dev/md1" there are more reasonable messages 
>> like:
>>> mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E1: Device or 
>> resource busy
>>>
>>> Now the question is: "Why is the device busy?" and "Who is holding the 
>> device busy?"
>>> Unfortunately (and here's a problem), neither "lsof" nor "fuser" could 
>> tell. That gave me a big headache.
>>
>> Stacked devices have been this way forever.  There's no process holding the 
>> device.  The kernel's got it internally.
> 
> Of course, it's funny that you can access the devices just fine. I'd only wish, mdadm would do so as well. Is there an interface to tell what devices are "opened" (I guess that's what "busy" means) by the kernel?

Device "open" is not necessarily exclusive.  You can use dd on a raw disk partition while its filesystem is mounted.  Not necessary wise, but the kernel will let you.

As for finding such usage, you have to search the sysfs hierarchy.  You might find "lsdrv" useful.  http://github.com/pturmel/lsdrv

>>> Further digging in the verbose output of "mdadm" I found lines like this:
>>> mdadm: no recogniseable superblock on 
>> /dev/disk/by-id/dm-name-whatever-E2_part5
>>> mdadm: /dev/disk/by-id/dm-name-whatever-E2_part5 has wrong uuid.
>>> mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E2_part2: Device 
>> or resource busy
>>> mdadm: /dev/disk/by-id/dm-name-whatever-E2_part2 has wrong uuid.
>>> mdadm: no recogniseable superblock on 
>> /dev/disk/by-id/dm-name-whatever-E2_part1
>>> mdadm: /dev/disk/by-id/dm-name-whatever-E2_part1 has wrong uuid.
>>> mdadm: cannot open device /dev/disk/by-id/dm-name-whatever-E2: Device or 
>> resource busy
>>> mdadm: /dev/disk/by-id/dm-name-whatever-E2 has wrong uuid.
>>>
>>> So mdadm is considering partitions as well. I guessed that activating the 
>> partitions might keept the "parent device" busy, so I tried a "kpart -vd 
>> /dev/disk/by-id/dm-name-whatever-E2", but that did do nothing (with no error 
>> message).
>>
>> Without instructions otherwise, both mdadm and LVM consider every block 
>> device.
>>
>> The man-page for mdadm.conf describes how to filter the devices to consider. 
>>  Did you read about this?
> 
> Yes, I even use it, but that wouldn't help with the problem; it would only reduce the number of devices probed, right?

The safest setup explicitly lists every member device of every array, using udev's */by-id/* device names.  mdadm accepts shell-style wildcards, though, so you can minimize the number of entries required.

>> The man-page for lvm.conf describes how to filter devices to consider, 
>> including a setting called "md_component_detection".  Did you read about 
>> this?
> 
> Yes, but that would require a VERY specific (and long) filter list.

md_component_detection should have been the only setting you needed.  LVM does accept regular expressions, though, so you can give patterns of acceptable devices instead of a long list.

[...]

> Hmmm: My manual page says:
>        -e, --metadata=
>               Declare the style of RAID metadata (superblock) to be used.  The
>               default is 0.90 for --create, and to guess for other operations.
>               The  default can be overridden by setting the metadata value for
>               the CREATE keyword in mdadm.conf.
> 
>               Options are:
> 
>               0, 0.90, default
>                      Use the original 0.90  format  superblock.   This  format
>                      limits  arrays  to 28 component devices and limits compo-
>                      nent devices of levels 1 and greater to 2 terabytes.
> 
>               1, 1.0, 1.1, 1.2
>                      Use the new version-1 format superblock.   This  has  few
>                      restrictions.    The  different  sub-versions  store  the
>                      superblock at different locations on the  device,  either
>                      at  the  end (for 1.0), at the start (for 1.1) or 4K from
>                      the start (for 1.2).

The superblock is part of the metadata, but not all of it.  There's also space for a write-intent bitmap, and mdadm then aligns to either the chunk size, or 1MB, or some combination depending on version.  The key is the data offset, not the precise placement of the superblock.  If data offset == 0, misidentification is possible.

Run 'mdadm --examine' against test devices with various metadata versions and it'll be more clear.

[...]

> Yes, I'd wish to have time for active software development. For legal support reasons I must use what Novell provides.

Then asking on these lists is pointless.  If you'd found a real bug that hadn't been addressed yet, you wouldn't be able to test a patch to fix it, even if Neil offered you a binary.  (I've never seen that happen.)  I don't understand how the upstream developers can help you if you can't use their software.

> On the support thing: We payed for a 24x7 support contract. Compared to HP support, where we only have a "next day" contract, Novell was very slow to provide anything.

This list is for volunteer development and support of the upstream MD raid subsystem.  It's nice to know who's paid support is useful, but that knowledge is useless on this mailing list.

Phil
