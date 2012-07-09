From: Alexander Schleifer <alexander.schleifer@googlemail.com>
Subject: Re: RAID5 superblock and filesystem recovery after re-creation
Date: Mon, 9 Jul 2012 08:50:16 +0200
Message-ID: <CA+=meHUtC5PqczdhgQM3c2JYBNVGFuWJektgq_+Pvs80JgVHMw@mail.gmail.com>
References: <CA+=meHXO02k4hSJihNFiYXb+LOjik_LX3n8UZbqERC2tYy+L-g@mail.gmail.com>
	<20120709081358.199630c8@notabene.brown>
	<CA+=meHVhYu8Z5a+D5beWQ-4M7YXq1bCabsqqntMMKfFy5dqAPA@mail.gmail.com>
	<20120709100208.5b9c56cd@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120709100208.5b9c56cd@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2012/7/9 NeilBrown <neilb@suse.de>:
> On Mon, 9 Jul 2012 00:45:08 +0200 Alexander Schleifer
> <alexander.schleifer@googlemail.com> wrote:
>
>> 2012/7/9 NeilBrown <neilb@suse.de>:
>> > On Sun, 8 Jul 2012 23:47:16 +0200 Alexander Schleifer
>> > <alexander.schleifer@googlemail.com> wrote:
>> >
>> >> Hi,
>> >>
>> >> after a new installation of Ubuntu, my RAID5 device was set to
>> >> "inactive". All devices were set to spare device and the level was
>> >> unknown. So I tried to re-create the array by the following command.
>> >
>> > Sorry about that.  In case you haven't seen it,
>> >    http://neil.brown.name/blog/20120615073245
>> > explains the background
>> >
>> >>
>> >> mdadm --create /dev/md0 --assume-clean --level=5 --raid-disk=6
>> >> --chunk=512 --metadata=1.2 /dev/sde /dev/sdd /dev/sda /dev/sdc
>> >> /dev/sdg /dev/sdh
>> >>
>> >> I have a backup of the mdadm -Evvvvs output, so I could recover the
>> >> chunk size, metadata and offset (2048) from this information.
>> >>
>> >> The partially output of mdadm --create... shows this output:
>> >>
>> >> ...
>> >> mdadm: /dev/sde appears to be part of a raid array:
>> >>     level=raid5 devices=6 ctime=Sun Jul  8 23:02:51 2012
>> >> mdadm: partition table exists on /dev/sde but will be lost or
>> >>        meaningless after creating array
>> >> ...
>> >>
>> >> The array is recreated, but no valid filesystem is found on /dev/md0
>> >> (dumpe2fs: Filesystem revision too high while trying to open /dev/md0.
>> >> Couldn't find valid filesystem superblock.). Also fdisk /dev/sde shows
>> >> no partition.
>> >> My next step would be creating Linux RAID type partitions on the 6
>> >> devices with fdisk and call mdadm --create with /dev/sde1 /dev/sdd1
>> >> and so on.
>> >> Is this step a possible solution for recovering the filesystem?
>> >
>> > Depends.. Was the original array created on partitions, or on whole devices?
>> > The saved '-E' output should show that.
>> >
>> > Maybe you have the devices in the wrong order.  The order you have looks odd
>> > for a recently created array.
>> >
>> > NeilBrown
>>
>> The original array was created on whole devices, as the saved output
>> starts with e.g. "/dev/sde:".
>
> Right, so you definitely don't want to create partitions.  Maybe when mdadm
> reported "partition table exists' it was a false positive, or maybe old
> information - creating a 1.2 array doesn't destroy the partition table.
>
>> I used the order of the 'Device UUID' from the saved output to
>> recreate the order in the new system (the ports changed due to a new
>> mainboard).
>
> When you say "the order", do you mean the numerical order?
>
> If you looked at the old "mdadm -E" output matching the "Device Role" with
> "Device UUID" to determine the order of the UUIDs, then looked at the
> "mdadm -E" output after the metadata got corrupted and used the "Device UUID"
> to determine the correct "Device Role", then ordered the devices by that Role,
> then that should have worked.

Ok, I used the "Device UUID" only to get the order. Now I reordered my
"mdadm --create..." call according to old "Device Role" and it works
;)

>
> I assume you did have a filesystem directly on /dev/md0, and hadn't
> partitioned it or used LVM on it?

Yes, the devices all are the same type and so I used the whole device
and created a filesystem directly on /dev/md0.

Now, fsck is running pass 1 for a few minutes with no error. So, I
think that everything is fine and I say thank you for helping get my
raid back to life ;-)

-Alex

>
> NeilBrown
>
>
>>              After the installation I had a degraded array in
>> initramfs, but I was able to simply "exit" the debug shell and the
>> array was accessible. I will now skip the step of creating raid type
>> partitions and try every possible order of devices.
>>
>> Thanks,
>> -Alex
>
