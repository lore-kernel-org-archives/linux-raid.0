From: Mark F <gnomeza@gmail.com>
Subject: Re: Manually specifying data_offset in component device superblock?
Date: Thu, 9 Jul 2009 23:11:31 +0100
Message-ID: <6ad05c580907091511v59f70a78o72901b54ac1ab7b9@mail.gmail.com>
References: <6ad05c580907070354o485818d7w255d75de9101fb39@mail.gmail.com>
	 <19029.18706.672808.169640@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <19029.18706.672808.169640@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil

Firstly, thanks!
I recovered all the data this evening.

2009/7/9 Neil Brown <neilb@suse.de>:
> On Tuesday July 7, gnomeza@gmail.com wrote:
>>
>> I'm attempting to recover a RAID5 (6 disks) with zeroed superblocks.
>>
>> But I'm unable to get the data offsets of some of the disks in the
>> array to match what I had before:
>> ...
>> Data offset for this disk was originally 136, but on recreation, mdadm
>> chooses 272...
>
> It must have been created with mdadm-2.5.6 or earlier
>
Ta, I downloaded and compiled mdadm-2.5.6.

>> After updating data_offset and the checksum of the first disk I
>> assembled the array and cryptsetup found its header. (Yay!)
>
> You would need to update the data_offset on each device.
>
Thanks again. This info was crucial.
The dump of mdadm --examine /dev/sd* I grabbed before I shut
everything down showed two out of six disks with data_offset of 272
sectors and the rest with 136.
(I didn't think that was weird at first.)

I'm guessing this happened because I dumped the info after trying to
add the two failed disks back to the array with the new version of
mdadm.
Following your hint, I recreated the array with data_offset of 136 on
all the disks.

A script to permute the order of the disks and run mdadm -C
--assume-clean && cryptsetup && mount did the rest.

So...yay!
  Mark
