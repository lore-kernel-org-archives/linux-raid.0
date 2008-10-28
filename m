From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 02:54:31 +0100
Message-ID: <ac3eb2510810271854v6f3474f0g293f9321bcc004b1@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com>
	 <18694.19834.523955.697048@notabene.brown>
	 <ac3eb2510810271703k7d9c97caob0f1d2eee28b8b7@mail.gmail.com>
	 <18694.28269.475324.862514@notabene.brown>
	 <ac3eb2510810271852q574cca9al173348fbd06b7e74@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ac3eb2510810271852q574cca9al173348fbd06b7e74@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Doug Ledford <dledford@redhat.com>, "martin f. krafft" <madduck@debian.org>, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 02:52, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Tue, Oct 28, 2008 at 02:44, Neil Brown <neilb@suse.de> wrote:
>> On Tuesday October 28, kay.sievers@vrfy.org wrote:
>>> On Tue, Oct 28, 2008 at 00:23, Neil Brown <neilb@suse.de> wrote:
>>> > I notice that 'md'
>>> > devices don't seem to disappear.  Maybe that is because /sys/block/mdX
>>> > never disappears (last time I tried it was too racy).
>>>
>>> It stays because the md kernel device lifetime rules are kind of
>>> broken regarding hotplug setups. Similar issue why md needs all the
>>> static nodes in /dev too to create a device.
>>>
>>> > Would there be any way to get udev to delete devices when
>>> >  /sys/block/mdX/md/array_state
>>> > becomes 'clear' (presumably on a CHANGE event) ??
>>>
>>> What would be the reason to leave the kernel block device around?
>>> Can't you just remove it like any other subsytem in the kernel does.
>>> That would just remove the node, all links and update userspace to
>>> reflect the change.
>>>
>>> There is currently no "change" event that could tell to remove a
>>> device node in /dev while we still have a kernel device around. And
>>> you would need to convince me that this is really needed, and why md
>>> is so special here. :)
>>
>> I've just done a bit of experimentation...
>>
>> If create an array /dev/md0 and we get a symlink
>>  /dev/disk/by-id/md-uuid-XXXXX -> ../../md0
>> I stop the array and the symlink stays there
>> I create a new array as /dev/md0 (hence new uuid)
>> and I get an new symlink
>>  /dev/disk/by-id/md-uuid-YYYY -> ../../md0
>> but also, the first symlink goes away.
>>
>> So somehow that first symlink is being removed even though the device
>> isn't being stopped.
>
> I guess mdadm --export didn't give the old name again when the
> "change" event was sent. If udev get's an "add" or "change" event for
> an existing device, it will lookup the currently links belonging to
> that device in its database. It computes the new links, deletes all
> the no longer valid links, keeps the still valid ones, and creates the
> new ones. On "remove" it will remove all links and possibly restore
> stuff this device has overwritten.
>
>> I guess I need a
>>   kobject_uevent(...., KOBJ_CHANGE)
>> when the array is stopped.... [tries that].
>
> If mdadm will not export stuff anymore, the links will be removed that way, yes.
>
>> Better.  But it looks like I need to get rid of the partitions too...
>>
>> Yes.  Putting
>>
>>                bdev = bdget_disk(mddev->gendisk, 0);
>>                if (bdev) {
>>                        blkdev_ioctl(bdev, 0, BLKRRPART, 0);
>>                        bdput(bdev);
>>                }
>>                kobject_uevent(&disk_to_dev(mddev->gendisk)->kobj, KOBJ_CHANGE);
>>
>> at a suitable place in do_md_stop causes all the symlinks created by
>> udev to disappear when I stop the array, only the /dev/mdX remains.
>> That should do for 2.6.28.  Something better maybe for .29.
>
> Yes, BLKRRPART does already send change events for the disk and all partitions.

Just in case you don't already do that, you can run "udevadm monitor
--udev --env" and see the udev processed events with the properties.
DEVLINKS will tell you the currently valid links that will be created,
or have been removed.

Kay
