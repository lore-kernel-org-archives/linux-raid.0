From: Felipe Kich <fkich1977@gmail.com>
Subject: Re: Help in recovering a RAID5 volume
Date: Thu, 10 Nov 2016 15:47:25 -0200
Message-ID: <CA+GmhESqEQd6J3CSteR08qw907NnC7r1ewecs3NkWUmpei6BVw@mail.gmail.com>
References: <CA+GmhESH-2hDJrOjvNzVBsgCP65BnUE2AbfOZ1Bbrp02jyBNUQ@mail.gmail.com>
 <5824A918.3030300@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5824A918.3030300@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Anthony,

Thanks for the reply. Here's some answers to your questions and also
another question.

It really seems that 2 disks are bad, but 2 are still good, according
to SMART. I'll replace them ASAP.
For now, I don't need to increase the array size. It's more than
enough for what I need.

About the drive duplication, I don't have spare discs available now
for that, I only have one 4TB disk at hand, so I'd like to know if
it's possible to create device images that I can mount and try to
rebuild the array, to test if it would work, then I can go and buy new
disks to replace the defective ones.

And sure, I'll send you the logs you asked, no problem.

Regards.

-
Felipe Kich
51-9622-2067


2016-11-10 15:06 GMT-02:00 Wols Lists <antlists@youngman.org.uk>:
> On 10/11/16 15:41, Felipe Kich wrote:
>> So, with that info, I could verify some things that are frequently
>> mentioned on the posts:
>> - SCT Error Recovery Control is disabled for both Read and Write operations;
>> - Events counter in the devices are the same, except for one disk, but
>> the difference is small (<50);
>> - Magic Numbers and Checksums are all correct;
>>
>> Hope someone can give some advice as how to proceed next.
>>
> Okay. It says the drives are failing, so the first thing is to go out
> and get four new drives :-( Ouch!
>
> Preferably WD Reds or Seagate NAS (Toshibas seem to support ERC too, I'm
> not sure...)
>
> DON'T TOUCH A 3TB BARRACUDA. Barracudas aren't a good idea but the 3TB
> disk is apparently an especially bad choice.
>
> Do you want to upgrade your array size? Or do you want to go Raid-6?
> Four 2TB drives will give you a 4TB Raid-6 array. And look at getting 3-
> or 4TB drives, they're good value for money. You might decide it's not
> worth it.
>
> Copy and replace all the failing drives with ddrescue. Hopefully you'll
> get a perfect copy. Don't worry that the old drive is smaller than the
> new one if you get 2TB or larger drives.
>
> Assuming everything copies fine, find the three drives that are copies
> of sda, sdb, sdd (ie the ones with the highest event counts), and
> assemble with --force. You should now have a new array working fine. Do
> a fsck to make sure everything's okay - you'll probably lose a file or
> two :-(
>
> Add in the fourth disk - it'll trigger a rebuild, but that's normal.
>
> Now if your new disks are bigger than the old ones, you can expand the
> array to use the space. You can either create a new partition in the
> empty drive space for a third array, or you can use a utility to
> move/expand the partitions. If you take the latter step, you should be
> able to convert your raid-5 to a raid-6 (I'll let the experts chime in
> on that). You can then expand the array to use all the available space,
> and expand the filesystem on the array to use it.
>
> NB: If you don't get a perfect ddrescue copy, can you please email me
> the log files - especially where it logs the blocks it can't copy. One
> of the things I want to do is work out how to write that utility
> mentioned on the "programming" page of the wiki.
>
> Cheers,
> Wol
>
