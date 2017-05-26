From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: raid5 to raid6 reshape never appeared to start, how to cancel/revert
Date: Fri, 26 May 2017 14:27:54 -0500
Message-ID: <CAAMCDecn=2Kr-P5G5qQrcSRnVFeiFSJo6KJSwvJFBfbb0d8kJg@mail.gmail.com>
References: <CAAMCDefCqUCY4Pd5im1u-JPh_SLG6BG8Onb8JxuPwoAkgXOkrA@mail.gmail.com>
 <20170522193304.GA4379@metamorpher.de> <CAAMCDedqUJXZFMwtqPVDjwoau42goEMcOLTbLX1fGdT7teQQQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDedqUJXZFMwtqPVDjwoau42goEMcOLTbLX1fGdT7teQQQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, May 22, 2017 at 3:04 PM, Roger Heflin <rogerheflin@gmail.com> wrote:
> On Mon, May 22, 2017 at 2:33 PM, Andreas Klauer
> <Andreas.Klauer@metamorpher.de> wrote:
>> On Mon, May 22, 2017 at 01:57:44PM -0500, Roger Heflin wrote:
>>> I had a 3 disk raid5 with a hot spare.  I ran this:
>>> mdadm --grow /dev/md126 --level=6 --backup-file /root/r6rebuild
>>>
>>> I suspect I should have changed the number of devices in the above command to 4.
>>
>> It doesn't hurt to specify, but that much is implied.
>> Growing 3 device raid5 + spare to raid6 results in 4 device raid6.
>>
>
> Yes.
>
>>> The backup-file was created on a separate ssd.
>>
>> Is there anything meaningful in this file?
>>
>
> 16MB in size, but od -x indicates all zeros, so no, there is nothing
> meaningful in the file.
>
>>> trying assemble now gets this:
>>>  mdadm --assemble /dev/md126 /dev/sd[abe]1 /dev/sdd
>>> --backup-file=/root/r6rebuild
>>> mdadm: Failed to restore critical section for reshape, sorry.
>>>
>>> examine shows this (sdd was the spare when the --grow was issues)
>>>  mdadm --examine /dev/sdd
>>> /dev/sdd1:
>>
>> You wrote /dev/sdd above, is it sdd1 now?
>>
>>>         Version : 0.91.00
>>
>> Ancient metadata. You could probably update it to 1.0...
>>
>
> I know.
>
>>>   Reshape pos'n : 0
>>
>> So maybe nothing at all changed on disk?
>>
>> You could try your luck with overlay
>>
>> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>>
>> mdadm --create /dev/md42 --metadata=0.90 --level=5 --chunk=64 \
>>       --raid-devices=3 /dev/overlay/{a,b,c}
>>
>>> It does appear that I added sdd rather than sdd1 but I don't believe
>>> that is anything critical to the issue as it should still work fine
>>> with the entire disk.
>>
>> It is critical because if you use the wrong one the data will be shifted.
>>
>> If the partition goes to the very end of the drive, I think the 0.90
>> metadata could be interpreted both ways (as metadata for partition
>> as well as whole drive).
>>
>> If possible you should find some way to migrate to 1.2 metadata.
>> But worry about it once you have access to your data.
>>
>
> I deal with others messing up partition/no partition recoveries often
> enough to not be worried about how to debug and/or fix that mistake.
>
> I found a patch from Neil from 2016 that may be solution to this
> issue, I am not clear if it is an exact match to my issue, it looks
> pretty close.
>
> http://comments.gmane.org/gmane.linux.raid/51095
>
>> Regards
>> Andreas Klauer

Thanks for the ideas.   The patch I mentioned was already in the mdadm
that I had so that was no help.

I got it back by doing an -assume-clean and initially I could see the
pv but not the vg, I checked the device and it did look like a few kb
was missing between the pv label and the first vgdata I saw on the
disk.

I tried a vgcfgrestore and that failed with some weird errors I have
never seen before about failure to write and checksum failures (and I
have used vgcfgrestore a number of times successfully before).  I
finally saved out the first 1M for data to another disk and then
zeroed where the header should have been and did a pvrestore --uuid
and then a vgcfgrestore again and a vgchange -ay and it found the lv
and the filesystem appears to be fully intact.  I am guessing that
something did write to a few k to the disk during the attempt to raid6
it.  I am verifying and/or saving anything that I want (there may be
nothing important on it) and then will rebuild it as a new raid6 with
new metadata.
