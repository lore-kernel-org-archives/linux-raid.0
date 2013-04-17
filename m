From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 11:35:11 +1000
Message-ID: <516DFC4F.5000908@websitemanagers.com.au>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DEAD4.7080305@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: Robert L Mathews <lists@tigertech.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/04/13 10:20, Ben Bucksch wrote:
> Robert L Mathews wrote, On 17.04.2013 00:44:
>> the endless reports of complete array failures that appear on the
>> list with RAID 5 and even RAID 6 (a recent topic, I note, was
>> "multiple disk failures in an md raid6 array"). I almost never see
>> anyone reporting complete loss of a RAID 1 array.
> Correct
>
Obviously, if they suffered a two disk failure then they won't be here
asking for help will they :)

Although, you are right, there are less failure scenarios where they are
left with one or more working disks and no possibility to recover the data.
>> The fundamental difference between RAID 1 and other levels seems to
>> be that the usefulness of an individual array member doesn't rely on
>> the state of any other member. This vastly reduces the impact of
>> failures on the overall system. After using mdadm with various RAID
>> levels since 2002 (thanks, Neil), I'm convinced that RAID 1 is by its
>> very nature far less fragile than any other scheme. This belief is
>> sadly reinforced almost every week by a new tale of woe on the
>> mailing list. 
>
> Exactly.
>
> However, I think the RAID5 problems are caused by bad design decisions
> in the md implementation, not in the inherent concept of RAID5,
> though. Many people seem to have problems getting to the data of their
> RAID5 array, although they have enough disks that are readable, but
> they can't convince md to read it. RAID1 doesn't have that problem,
> because you can ignore md when reading them. This is a home-made
> problem of Linux md.
Well, you can ignore Linux md when reading from RAID5 member disks, you
just need to do some work to make the contents actually useful.
However, I totally disagree with your comment anyway. Linux md is simple
a part of the kernel, not the whole kernel. It takes a "block device"
and generates read/write commands to that block device. It can get back
one of a few possible results:
1) read error
2) write error
3) block device is no longer valid

1) A read error can be generated for a number of causes, but (AFAIK)
Linux md will simply read from another member, and try to write the data
back to the device that generated the read error. This would fix a URE
for example.

2) A write error is more of a problem, if the block device generates a
write error, then there are limited options. We can retry the write, or
we can discard the entire device. I think Linux md will discard the
entire device, possibly after retrying the write one or more times I
don't know enough about Linux md, but in any case, I think this is a
rare case where we get a write error from an otherwise good block device.

3) This is the issue that seems to bite everyone. Using block devices
that are not configured correctly. Sooner or later, the drive has a URE,
the drive goes off to la-la land and Linux patiently waits, tries a
drive reset, SATA bus reset, etc, still no response, eventually deciding
the drive has gone. The Linux kernel advises Linux md that the block
device is gone, so Linux md discards the block device and stops trying
to use it. Personally, I don't see that Linux md has a lot of choice in
the matter, without trying to re-implement every SATA/SCSI/SAS
controller driver into md itself so that we can keep retrying longer. We
are told the device is gone, so it is gone, end of story.

Now, if you truly have this issue, and do NOT make any silly assumption,
and follow the correct advice, you will have no problem resolving the
issue (as long as the actual device is working properly). Generally,
this is just a matter of assembling the MD without the oldest/first
affected device, and/or using --force or similar. The SECOND problem is
caused by the user attempting some other recovery methods which cause
additional writes to the array.

Certainly, a hardware raid controller doesn't have this issue, it
controls the disk, disk controller, and RAID, it knows everything about
all layers. However, if some strange issue happens such as two disks
dropping out of the array, one after the other, then I'm not sure what
your recovery options are, but I expect they are a lot more limited
compared to having the power of Linux md and tools like dd, GNU
ddrescue, etc to manipulate the data in well documented and understood
ways (as opposed to being stuck in a limited "BIOS" type tool with
limited GUI type options...)

Perhaps it is possible for Linux md to check whether the RAID members
support ecterc and/or what their timeout is, along with the associated
interface timeout. Possibly using user space mdadm rather than the
in-kernel md. At least this might catch more broken configurations
before they break rather than waiting for it to break first.

> FWIW, my own 10 years of experience with Linux md RAID led to the same
> conclusion as you had.
>
> See thread "md dropping disks too early"

Personally, I'd like to see RAID10 get a lot more attention. We need to
be able to grow RAID10 arrays (and shrink), etc, not because this would
provide RAID1 type reliability. Of course, you can still get multiple
disk failures, and you can still mess up a RAID10 array by trying to
"fix" it, yet still have just enough idea that all your data might be
there, you just need to know the right magic spell to make it re-appear.

The best part of Linux md RAID is that the large majority of the time,
the people that come to the list with broken arrays are able to recover
all of their data *IF* they are patient enough, *AND* follow the advice
of the very knowledgeable people on this list, even in cases where that
user has broken their RAID array further in their attempts to "fix" it.

In summary, I'll say it again, most Linux md RAID issues seem to be
caused by:
1) mis-configured systems that are just waiting for a critical moment to
break (Murphy's Law)
2) people who don't know enough about Linux md RAID who try to fix the
broken array


PS, I really have no idea what I'm talking about, except lurking and
reading this list and the problems (and resolutions) here, if I've made
any errors in the above, feel free to fix it. I really think the above
(plus whatever corrections/more complete information) should be saved in
a FAQ somewhere so we can just point people at the same page all the
time instead of discussing it again each time (it invariably seems to be
discussed every month or so).

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au

