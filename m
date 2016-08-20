From: Sarah Newman <srn@prgmr.com>
Subject: Re: Assistance Reviewing Proposed Recovery Measures
Date: Fri, 19 Aug 2016 19:48:15 -0700
Message-ID: <ab06c6a7-f1ac-3775-d415-bbd08fd6e4ec@prgmr.com>
References: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.11.1608191717050.23388@bluenose.cs.dal.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Maxwell <cmaxwell@dal.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/19/2016 01:18 PM, Chris Maxwell wrote:
<snip>

> https://raid.wiki.kernel.org/index.php/RAID_Recovery suggest one can create rather than assemble a sw raid. (Not sure whether to call it md0 or md1)
> mdadm --create /dev/md0 --metadata=0.90 --raid-devices=2 --level=raid1 /dev/sdb1 missing
> 
> However, the it also says
> 
>> Recreating should be considered a *last* resort, only to be used when everything else fails. People getting this wrong is one of the primary reasons
>> people lose data. It is very commonly used way too early in the fault finding process. You have been warned! It's better to send an email to the
>> linux-raid mailing list with detailed information (mdadm --examine from all component drives plus log entries from when the failure happened,
>> including mdadm and kernel version) and ask for advice than to try to use --create --assume-clean and getting it wrong.
> 
> 
> 
> So before I messed things up even worse, I figured I would consult the experts to see what my next step should be.

I am not an expert but 0.9 metadata is at the end, and the md device is a simple mirror. I don't know why the underlying device couldn't be used directly.

I think this should work, depending on your hardware raid:

* verify exact size of md device by looking at size of /dev/md0 block device assembled from failing /dev/sdc1
* copy partition layout from /dev/sdc using sfdisk -d
* pull both sdb1 and sdc1 drives (mark which drive goes where)
* put in 2 new drives to replace failing sdc
* initialize new drives in hardware raid
* observe no existing partition table on new device
* create partition table on new device using sfdisk
* create a new md device /dev/md1 on the new /dev/sd?1, verifying size of /dev/md1 block device is same or bigger than original /dev/md0
* add good drives from original sdb back
* make an overlay of the first partition of the good device
https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
* zero the metadata on the overlay with mdadm --zero-superblock /path/to/overlay
* dd data from /path/to/overlay onto /dev/md1. This will run out of room if the new md device is exactly the same size as the old one, but should copy
all the actual data.

--Sarah
