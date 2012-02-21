From: Benjamin ESTRABAUD <be@mpstor.com>
Subject: Re: SES Enclosure Management.
Date: Tue, 21 Feb 2012 18:55:32 +0000
Message-ID: <4F43E8A4.8070108@mpstor.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com> <20120215073130.792d4fae@notabene.brown> <4F3AC741.6050204@gmail.com> <4F3AC9CB.3070707@gmail.com> <4F3D5236.7020101@mpstor.com> <4F3D5539.9030505@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3D5539.9030505@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Woodworth <robertjwoodworth@gmail.com>
Cc: Joe Landman <joe.landman@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/02/12 19:12, Robert Woodworth wrote:
> On 02/16/2012 12:00 PM, Benjamin ESTRABAUD wrote:
>> On 14/02/12 20:53, Robert Woodworth wrote:
>>> On 02/14/2012 01:42 PM, Joe Landman wrote:
>>>> On 02/14/2012 03:31 PM, NeilBrown wrote:
>>>>> On Tue, 14 Feb 2012 10:30:37 -0700 Robert Woodworth
>>>>> <robertjwoodworth@gmail.com>  wrote:
>>>>>
>>>>>> Has anyone ever thought of integrating SES managed enclosures 
>>>>>> into the
>>>>>> kernel RAID system?  I briefly looked through the archives and have
>>>>>> not found anything on the topic.
>>>>>>
>>>>>> Some HW based RAID controllers do this flawlessly now, there is no
>>>>>> reason why the kernel RAID cannot also.  (LSI MegaRAID)
>>>>>>
>>>>>> 1) When a drive is part if a managed enclosure, the RAID system 
>>>>>> should
>>>>>> address it by location instead of by enumerated device node.  The 
>>>>>> SES
>>>>>> device in the enclosure can map the physical slot to a physical 
>>>>>> drive.
>>>>>>   The RAID admin (mdamd) should be able to add/fail/identify devices
>>>>>> based on slot.
>>>>>
>>>>> Does this just mean that the admin should using names in 
>>>>> /dev/disk/by-path/
>>>>> rather than /dev/sdXX to address devices?  What can md or mdadm do 
>>>>> to help?
>>>>>
>>>>
>>>> Not sure on the SES (or SGPIO side), but one of the things we've 
>>>> been doing has been to create a file with disk placement 
>>>> "coordinates", so as to map serial number and device to physical 
>>>> location.
>>>>
>>>
>>> With real SES managed enclosures, you issue a SCSI command to read 
>>> SES Page1 and Page2 to get the details about the drives in any given 
>>> slot.  This currently works fine in Linux with the sg_utils3 
>>> package.  From the command line, 'sg_ses -p 2 /dev/sgXX`  where the 
>>> device is the SES device.
>>>
>>> Take a look at your systems, if you see a device at 
>>> /sys/class/enclosure/XXXX/ then you have a managed enclosure attached.
>>>
>>
>> Hi,
>>
>> True, but your definition of SES "slot 0" might be different from 
>> someone else's. The end user will still need to map "slot 0" to a 
>> physical slot on his system, instead of mapping a drive's serial 
>> number to a physical slot. There is no standard for slot numbering 
>> and most vendors use different schemes.
> On the boxes I write SES firmware for, we have a sticker label on the 
> slot 'slot1' and its my job to make sure the SES firmware always maps 
> the physical label 'slot1' with the drive in that slot to the data in 
> the SCSI SES page 10 (0x0A).
>
> That is the whole point of the SES device.
>
Very few vendor actually do this, although it makes sense I completely 
agree.
>>>
>>>>>>
>>>>>> 2) If the RAID system fails a drive, it should notify the SES
>>>>>> management and turn on the fail bit and the fail LED.
>>>>>
>>>>> "mdadm --monitor" will run a script on drive failure.  This could 
>>>>> easily
>>>>> notify the SES management.
>>>>
>>>> Yes, we are using this now for notifications and logging.
>>>>
>>>>>
>>>>> So maybe all we need here is a script to plug in to mdadm... Would 
>>>>> you like
>>>>> to write one?
>>>>>
>>>>
>>>> Just need a "standard" SES (or SGPIO) mechanism to hook into, and 
>>>> we should be able to support this.  Right now we have to work 
>>>> through HBA scripts.
>>> A true managed enclosure has nothing to do with the HBA.  A managed 
>>> enclosure provides a device on the SCSI bus and you exclusively 
>>> communicate with that device regardless of the HBA.  Most HW RAIDs 
>>> (LSI MegaRAID) will hide the SES device exactly like they hide the 
>>> physical disks.
>>>
>>>>
>>>>>>
>>>>>> 3) The RAID system should be able to turn on the 'identify' bit and
>>>>>> LEDs for an array or a single drive.
>>>>>
>> This is fine too, as you pointed out SES gives you information on 
>> disks, but in order to map a block device sda to a device in SES, 
>> won't you need to rely on its SAS address? or even the SAS address 
>> arbitrarily given by the expander to a SATA device?
> Look at SCSI SES Page 10 (0x0A), that is the correct mapping of disk 
> to slot on the host side.
>
>>
>> Your expander's SES device might display this address for both SAS 
>> and SATA drives in SES page 0xa, but most SES devices won't, at least 
>> for SATA drives, as the SES spec specifically requires SATA drive's 
>> address to be set to 0x0.
>>
>> So if drive "sd"a fails, you'll be able to tell which expander it is 
>> attached using kernel infos, tell its SAS address as you see it, but 
>> you won't be able to map it to a particular slot number in SES, and 
>> will not be able to set its failed LED reliably.
> As stated above.  If the firmware on the SES enclosure is written 
> correctly  the SES page1 and page2 will correctly map the physical 
> devices *and LEDs* to the devices in the SCSI SES pages.  This does 
> work on proper enclosures, yes you can rely on it (on my boxes anyway).
>
> Maybe people have bad experiences with bad firmware, but if you get a 
> box that my expanders and SES firmware is in, they will work correctly.
>
Well, the problem here is not that the SES page1 and page2 do not map to 
a physical device in the right slot, but how to identify them.
The only info in common between the SES device and the kernel about a 
disk is its SAS address. You can get a map of SAS address <> Slot in SES 
page 0xa as you correctly mentioned, but when using STP (SATA drives), 
that address will often be blank (0x0). This is not out of bad design 
and merely following the SES specs (which, for this particular issue do 
not make sense to me).

In this particular case, there will be no way to map the "sdX" block 
device to a SES slot id. Therefore you will not know which slot to send 
the command to when you send your SES control.

This is an inevitable issue, unfortunately, which is a great barrier to 
integrate SES to the Linux kernel's block drivers in my opinion.

If SES had a common information to point out a disk with the kernel, it 
could easily be done. Without it it's kind of hard, if purely using a 
SES device and nothing more.

Regards,
Ben.
>
>
>>>>> Again, it sounds like you just need a script to ask mdadm which 
>>>>> devices are
>>>>> included in a given array, and then do whatever magic is needed to 
>>>>> turn on
>>>>> the light.
>>>>> It is fairly easy to extra the device list from the output of
>>>>>    mdadm --detail --brief --verbose /dev/md/whatever
>>>>>
>>>>> but it might be good to make it easier to extra from
>>>>>    mdadm --detail --export /dev/md/whatever
>>>>>
>>>>> Would you like to write such a script?
>>>>>
>>>>>>
>>>>>> I'm currently doing firmware on a managed enclosure.  Although my
>>>>>> vendor only supports LSI MegaRAID, there is no reason why my
>>>>>> enclosures cannot work in the same manner on a kernel RAID system.
>>>>>>
>>>>>>
>>>>>>
>>>>>> Request for comments...
>>>>>
>>>>> It sounds to me like you just need a few scripts to provide some
>>>>> enclosure-specific functionality.  I would be happy to include 
>>>>> them in the
>>>>> mdadm distribution.
>>>>>
>>>>> Or maybe there is something that I didn't understand??
>>>>>
>>>>> Thanks,
>>>>> NeilBrown
>>>>>
>>>>>
>> Regards,
>> Ben.
>>>>>
>>>>>> -- 
>>>>>> To unsubscribe from this list: send the line "unsubscribe 
>>>>>> linux-raid" in
>>>>>> the body of a message to majordomo@vger.kernel.org
>>>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>
>

