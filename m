From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: mdadm 3.1.1: level change won't start
Date: Mon, 21 Dec 2009 13:34:45 +0000
Message-ID: <73e903670912210534q13681fabve50b58addde592fc@mail.gmail.com>
References: <73e903670912201941q44dae7b0t455d1a94f13f5c31@mail.gmail.com>
	<20091221093528.GA24168@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091221093528.GA24168@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Mon Dec 21, 2009 at 03:41:33AM +0000, Kristleifur Da=F0ason wrote:
>
>> Hi all,
>>
>> I wish to convert my 3-drive RAID-5 array to a 6-drive RAID-6. I'm o=
n
>> Linux 2.6.32.2 and have mdadm version 3.1.1 with the 32-bit-array-si=
ze
>> patch from here: http://osdir.com/ml/linux-raid/2009-11/msg00534.htm=
l
>>
>> I have three live drives and three spares added to the array. When I
>> initialize the command, mdadm does the initial checks and aborts wit=
h
>> a "cannot set device shape" without doing anything to the array.
>>
>> $ mdadm --grow /dev/md_d1 --level=3D6 --raid-devices=3D6
>> --backup-file=3D/root/backup.md1_to_r6
>> mdadm: metadata format 1.10 unknown, ignored.
>> mdadm: metadata format 1.10 unknown, ignored.
>> mdadm level of /dev/md_d1 changed to raid6
>> mdadm: Need to backup 1024K of critical section..
>> mdadm: Cannot set device shape for /dev/md_d1
>> mdadm: aborting level change
>>

On Mon, Dec 21, 2009 at 7:25 AM, Michael Evans <mjevans1983@gmail.com> =
wrote:
> This is odd; cat /proc/mdstat shows 1.0 and 1.1 for my metadata
> formats; however using --detail --scan  I _DO_ see 1.00 and 1.01 on m=
y
> system.
>

On Mon, Dec 21, 2009 at 9:35 AM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> I don't think you can grow and reshape simultaneously. =A0I think you=
'll
> need to do this as two operations - either grow to a 5 disk RAID5 the=
n
> reshape to a 6 disk RAID6, or reshape to a 4 disk RAID6 then grow.
>

Thanks for the replies, Michael and Robin.

Re. metadata version number discrepancy, I'm going to assume for now
that it doesn't affect my reshape, and take it up later in its own
list thread.

Robin, it makes sense that I can't actually grow and reshape
simultaneously - it fits to the mdadm halt I'm seeing - but I did note
Neil Brown saying here >> http://neil.brown.name/blog/20090817000931
<< that

--- "One way to avoid the extra cost of doing the backup [reshape] is
to increase the number of devices at the same time. e.g. if you had a
4-drive RAID5 you could convert it to a 6-drive RAID6 with a command
like mdadm --grow /dev/md0 --level=3D6 --raid-disk=3D6 then it will
combine the increase in the number of devices with the change to the
layout and will copy every block only once. " ---

I'm OK with doing the grow and reshape in two separate steps, but the
indication that it should be possible in one step makes me a bit
anxious about the health of my array as it is now. Can anyone confirm
/ deny that a simultaneous reshape+grow is possible or not? Anyone
done one? :)

Thanks!

-- Kristleifur
-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
