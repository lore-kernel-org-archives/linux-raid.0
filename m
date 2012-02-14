From: Robert Woodworth <robertjwoodworth@gmail.com>
Subject: Re: SES Enclosure Management.
Date: Tue, 14 Feb 2012 14:10:47 -0700
Message-ID: <4F3ACDD7.5040506@gmail.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com> <20120215073130.792d4fae@notabene.brown> <4F3AC741.6050204@gmail.com> <4F3AC9CB.3070707@gmail.com> <4F3ACAF6.4030004@gmail.com> <4F3ACCC4.6070901@aeoncomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3ACCC4.6070901@aeoncomputing.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/14/2012 02:06 PM, Jeff Johnson wrote:
> On 2/14/12 12:58 PM, Joe Landman wrote:
>> On 02/14/2012 03:53 PM, Robert Woodworth wrote:
>>> On 02/14/2012 01:42 PM, Joe Landman wrote:
>>>> On 02/14/2012 03:31 PM, NeilBrown wrote:
>>>>> On Tue, 14 Feb 2012 10:30:37 -0700 Robert Woodworth
>>>>> <robertjwoodworth@gmail.com> wrote:
>>>>>
>>>>>> Has anyone ever thought of integrating SES managed enclosures 
>>>>>> into the
>>>>>> kernel RAID system? I briefly looked through the archives and have
>>>>>> not found anything on the topic.
>>>>>>
>>>>>> Some HW based RAID controllers do this flawlessly now, there is no
>>>>>> reason why the kernel RAID cannot also. (LSI MegaRAID)
>>>>>>
>>>>>> 1) When a drive is part if a managed enclosure, the RAID system 
>>>>>> should
>>>>>> address it by location instead of by enumerated device node. The SES
>>>>>> device in the enclosure can map the physical slot to a physical 
>>>>>> drive.
>>>>>> The RAID admin (mdamd) should be able to add/fail/identify devices
>>>>>> based on slot.
>>>>>
>>>>> Does this just mean that the admin should using names in
>>>>> /dev/disk/by-path/
>>>>> rather than /dev/sdXX to address devices? What can md or mdadm do to
>>>>> help?
>>>>>
>>>>
>>>> Not sure on the SES (or SGPIO side), but one of the things we've been
>>>> doing has been to create a file with disk placement "coordinates", so
>>>> as to map serial number and device to physical location.
>>>>
>>>
>>> With real SES managed enclosures, you issue a SCSI command to read SES
>>> Page1 and Page2 to get the details about the drives in any given slot.
>>> This currently works fine in Linux with the sg_utils3 package. From the
>>> command line, 'sg_ses -p 2 /dev/sgXX` where the device is the SES 
>>> device.
>>>
>>> Take a look at your systems, if you see a device at
>>> /sys/class/enclosure/XXXX/ then you have a managed enclosure attached.
>>>
>>
>> Got it.  Thanks.  Will look and see.  Should be pretty straight 
>> forward to do this.
>>
>>>
>>>>>>
>>>>>> 2) If the RAID system fails a drive, it should notify the SES
>>>>>> management and turn on the fail bit and the fail LED.
>>>>>
>>>>> "mdadm --monitor" will run a script on drive failure. This could 
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
>>>> Just need a "standard" SES (or SGPIO) mechanism to hook into, and we
>>>> should be able to support this. Right now we have to work through HBA
>>>> scripts.
>>> A true managed enclosure has nothing to do with the HBA. A managed
>>> enclosure provides a device on the SCSI bus and you exclusively
>>> communicate with that device regardless of the HBA. Most HW RAIDs (LSI
>>> MegaRAID) will hide the SES device exactly like they hide the physical
>>> disks.
>>>
>>
>> Ok.  Let me look to see if we can do this.  If so, we should be able 
>> to help contribute some scripts.
> I've been doing this for a while. In SES the various elements (slot, 
> power supplies, fans, etc) are named.  At least if your JBOD vendor 
> has their **** together. There is no need to decipher arrays of hex 
> values and modify bits to assert control. Once you know the names of 
> your elements you can address them by name for status and control 
> (fault LED, power on/off, temps, etc).
>
> --Jeff

Correct!  Now I just want to connect the RAID system to the SES system 
so that when a disk fails, the kernel module that failed the disk can 
light up the LED.

I work for one of those vendors, it's my job to have our **** together.

