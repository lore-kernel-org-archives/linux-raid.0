From: Martin Wilck <mwilck@arcor.de>
Subject: Re: ddf: remove failed devices that are no longer in use ?!?
Date: Tue, 30 Jul 2013 21:24:24 +0200
Message-ID: <51F812E8.1080004@arcor.de>
References: <51F2E4B9.1020505@arcor.de> <20130730113435.3421a111@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130730113435.3421a111@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/30/2013 03:34 AM, NeilBrown wrote:
> On Fri, 26 Jul 2013 23:06:01 +0200 Martin Wilck <mwilck@arcor.de> wrote:
> 
>> Hi Neil,
>>
>> here is another question. 2 years ago you committed c7079c84 "ddf:
>> remove failed devices that are no longer in use", with the reasoning "it
>> isn't clear what (a phys disk record for every physically attached
>> device) means in the case of soft raid in a general purpose Linux computer".
>>
>> I am not sure if this was correct. A common use case for DDF is an
>> actual BIOS fake RAID, possibly dual-boot with a vendor soft-RAID driver
>> under Windows. Such other driver might be highly confused by mdadm
>> auto-removing devices. Not even "missing" devices need to be removed
>> from the meta data in DDF; they can be simply marked "missing".
>>
>> May I ask you to reconsider this, and possibly revert c7079c84?
>> Martin
> 
> You may certainly ask ....
> 
> I presumably had a motivation for that change.  Unfortunately I didn't record
> the motivation, only the excuse.
> 
> It probably comes down to a question of when *do* you remove phys disk
> records?
> I think that if I revert that patch we could get a situation where we keep
> adding new phys disk records and fill up some table.

How is this handled with native meta data? IMSM? Is there any reason to
treat DDF special? In a hw RAID scenario, the user would remove the
failed disk physically sooner or later, and it would switch to "missing"
state. So here, I'd expect the user to call mdadm --remove.

We already have find_unused_pde(). We could make this function try
harder - when no empty slot is found, look for slots with
"missing|failed" and then "missing" (or "failed"?) disks, and replace
those with the new disk.

> We should probably be recording some sort of WWN or path identifier in the
> metadata and then have md check in /dev/disk/by-XXX to decide if the device
> has really disappeared or is just failed.

Look for "Cannot be bothered" in super-ddf.c :-)
This is something that waits to be implemented, for SAS/SATA at least.

> Maybe the 'path' field in phys_disk_entry could/should be used here.  However
> we the BIOS might interpret that in a specific way that mdadm would need to
> agree with....
> 
> If we can come up with a reasonably reliable way to remove phys disk records
> at an appropriate time, I'm happy to revert this patch.  Until then I'm not
> sure it is a good idea.....
> 
> But I'm open to being convinced.

Well, me too, I may be wrong, after all. Perhaps auto-removal is ok. I
need to try it with fake RAID.

Martin


> 
> Thanks,
> NeilBrown

