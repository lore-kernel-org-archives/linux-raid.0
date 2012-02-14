From: Robert Woodworth <robertjwoodworth@gmail.com>
Subject: Re: SES Enclosure Management.
Date: Tue, 14 Feb 2012 13:53:31 -0700
Message-ID: <4F3AC9CB.3070707@gmail.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com> <20120215073130.792d4fae@notabene.brown> <4F3AC741.6050204@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3AC741.6050204@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/14/2012 01:42 PM, Joe Landman wrote:
> On 02/14/2012 03:31 PM, NeilBrown wrote:
>> On Tue, 14 Feb 2012 10:30:37 -0700 Robert Woodworth
>> <robertjwoodworth@gmail.com>  wrote:
>>
>>> Has anyone ever thought of integrating SES managed enclosures into the
>>> kernel RAID system?  I briefly looked through the archives and have
>>> not found anything on the topic.
>>>
>>> Some HW based RAID controllers do this flawlessly now, there is no
>>> reason why the kernel RAID cannot also.  (LSI MegaRAID)
>>>
>>> 1) When a drive is part if a managed enclosure, the RAID system should
>>> address it by location instead of by enumerated device node.  The SES
>>> device in the enclosure can map the physical slot to a physical drive.
>>>   The RAID admin (mdamd) should be able to add/fail/identify devices
>>> based on slot.
>>
>> Does this just mean that the admin should using names in 
>> /dev/disk/by-path/
>> rather than /dev/sdXX to address devices?  What can md or mdadm do to 
>> help?
>>
>
> Not sure on the SES (or SGPIO side), but one of the things we've been 
> doing has been to create a file with disk placement "coordinates", so 
> as to map serial number and device to physical location.
>

With real SES managed enclosures, you issue a SCSI command to read SES 
Page1 and Page2 to get the details about the drives in any given slot.  
This currently works fine in Linux with the sg_utils3 package.  From the 
command line, 'sg_ses -p 2 /dev/sgXX`  where the device is the SES device.

Take a look at your systems, if you see a device at 
/sys/class/enclosure/XXXX/ then you have a managed enclosure attached.


>>>
>>> 2) If the RAID system fails a drive, it should notify the SES
>>> management and turn on the fail bit and the fail LED.
>>
>> "mdadm --monitor" will run a script on drive failure.  This could easily
>> notify the SES management.
>
> Yes, we are using this now for notifications and logging.
>
>>
>> So maybe all we need here is a script to plug in to mdadm... Would 
>> you like
>> to write one?
>>
>
> Just need a "standard" SES (or SGPIO) mechanism to hook into, and we 
> should be able to support this.  Right now we have to work through HBA 
> scripts.
A true managed enclosure has nothing to do with the HBA.  A managed 
enclosure provides a device on the SCSI bus and you exclusively 
communicate with that device regardless of the HBA.  Most HW RAIDs (LSI 
MegaRAID) will hide the SES device exactly like they hide the physical 
disks.

>
>>>
>>> 3) The RAID system should be able to turn on the 'identify' bit and
>>> LEDs for an array or a single drive.
>>
>> Again, it sounds like you just need a script to ask mdadm which 
>> devices are
>> included in a given array, and then do whatever magic is needed to 
>> turn on
>> the light.
>> It is fairly easy to extra the device list from the output of
>>    mdadm --detail --brief --verbose /dev/md/whatever
>>
>> but it might be good to make it easier to extra from
>>    mdadm --detail --export /dev/md/whatever
>>
>> Would you like to write such a script?
>>
>>>
>>> I'm currently doing firmware on a managed enclosure.  Although my
>>> vendor only supports LSI MegaRAID, there is no reason why my
>>> enclosures cannot work in the same manner on a kernel RAID system.
>>>
>>>
>>>
>>> Request for comments...
>>
>> It sounds to me like you just need a few scripts to provide some
>> enclosure-specific functionality.  I would be happy to include them 
>> in the
>> mdadm distribution.
>>
>> Or maybe there is something that I didn't understand??
>>
>> Thanks,
>> NeilBrown
>>
>>
>>
>>> -- 
>>> To unsubscribe from this list: send the line "unsubscribe 
>>> linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

