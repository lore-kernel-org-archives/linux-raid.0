From: "NeilBrown" <neilb@suse.de>
Subject: Re: Help
Date: Sat, 22 Aug 2009 19:34:12 +1000 (EST)
Message-ID: <3d3031d0053a547684fa49ddc6532819.squirrel@neil.brown.name>
References: <200908210627.06241.Info@quantum-sci.net>
    <200908211102.58744.Info@quantum-sci.net>
    <200908211220.28701.Info@quantum-sci.net>
    <200908212314.31887.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908212314.31887.Info@quantum-sci.net>
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, August 22, 2009 4:14 pm, Info@quantum-sci.net wrote:
>
> Not able to boot to my RAID devices.  md0 is / and ext3 RAID1, but md1 and
> md2 are swap and JFS respectively, RAID10 created like this:
> mdadm --create /dev/md1 --level=raid10 --layout=o2 --metadata=1.2
> --chunk=256 --raid-disks=2 missing /dev/sdb2
>
> It gives the initial kernel boot message but then says
> invalid raid superblock magic on sdb2
> invalid raid superblock magic on sdb3
>
> ... and halts progress.  I have to hard-reset to continue.  Why isn't the
> error more specific?

You say md0 is raid1 but mdstat shows it to be raid10, so that won't boot.

'raid autodetect' only works for 0.90 metadata, and you are using 1.x.
You should not use 'raid autodetect' partitions.  Rather the initrd
should use mdadm to assemble the arrays.  Most distros seem to get this
right these days.  Maybe you just need to rebuild your
initrd...

NeilBrown


>
> I've tried setting the metadata to 1.1, and tried adjusting mdadm.conf
> from /dev/md/1 to /dev/md1, but neither helped.  The parts are set to raid
> autodetect and the kernel parameter is set to md_autodetect.  What could
> be wrong?
>
>
>
> On Friday 21 August 2009 12:20:28 Info@quantum-sci.net wrote:
>>
>> My God, the command is not working.  I need to remove sdb1 from md0 so I
>> can change it from a RAID10 to RAID1, and it simply ignores my command:
>> # mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
>> # cat /proc/mdstat
>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>> [raid4] [multipath]
>> md2 : active raid10 sdb3[1]
>>       1868560128 blocks super 1.2 64K chunks 2 offset-copies [2/1] [_U]
>>       bitmap: 94/446 pages [376KB], 2048KB chunk
>>
>> md1 : active raid10 sdb2[1]
>>       6297344 blocks super 1.2 64K chunks 2 offset-copies [2/1] [_U]
>>       bitmap: 0/25 pages [0KB], 128KB chunk
>>
>> md0 : active raid10 sdb1[1]
>>       78654080 blocks super 1.2 64K chunks 2 offset-copies [2/1] [_U]
>>       bitmap: 76/151 pages [304KB], 256KB chunk
>>
>> unused devices: <none>
>> #
>>
>>
>> My system is half-converted and is now unbootable.  What am I going to
>> do?
>>
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

