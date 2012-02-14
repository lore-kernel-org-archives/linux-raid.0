From: Robert Woodworth <robertjwoodworth@gmail.com>
Subject: Re: SES Enclosure Management.
Date: Tue, 14 Feb 2012 13:46:32 -0700
Message-ID: <4F3AC828.5000202@gmail.com>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com> <20120215073130.792d4fae@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120215073130.792d4fae@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/14/2012 01:31 PM, NeilBrown wrote:
> On Tue, 14 Feb 2012 10:30:37 -0700 Robert Woodworth
> <robertjwoodworth@gmail.com>  wrote:
>
>> Has anyone ever thought of integrating SES managed enclosures into the
>> kernel RAID system?  I briefly looked through the archives and have
>> not found anything on the topic.
>>
>> Some HW based RAID controllers do this flawlessly now, there is no
>> reason why the kernel RAID cannot also.  (LSI MegaRAID)
>>
>> 1) When a drive is part if a managed enclosure, the RAID system should
>> address it by location instead of by enumerated device node.  The SES
>> device in the enclosure can map the physical slot to a physical drive.
>>   The RAID admin (mdamd) should be able to add/fail/identify devices
>> based on slot.
> Does this just mean that the admin should using names in /dev/disk/by-path/
> rather than /dev/sdXX to address devices?  What can md or mdadm do to help?
I don't like the /by-path/ too well, it is not human readable.  I would 
propose that the SES module that is already in the base kernel be 
expanded to provide a /dev/disk/by-location/<enclosureID>/<slot> -> 
/dev/sdXY

If you have ever worked with AIX, all devices have physical locations in 
the configurations held by the kernel.


>> 2) If the RAID system fails a drive, it should notify the SES
>> management and turn on the fail bit and the fail LED.
> "mdadm --monitor" will run a script on drive failure.  This could easily
> notify the SES management.
>
> So maybe all we need here is a script to plug in to mdadm... Would you like
> to write one?
>
Yes, I thought of that too.


>> 3) The RAID system should be able to turn on the 'identify' bit and
>> LEDs for an array or a single drive.
> Again, it sounds like you just need a script to ask mdadm which devices are
> included in a given array, and then do whatever magic is needed to turn on
> the light.
> It is fairly easy to extra the device list from the output of
>    mdadm --detail --brief --verbose /dev/md/whatever
>
> but it might be good to make it easier to extra from
>    mdadm --detail --export /dev/md/whatever
>
> Would you like to write such a script?
Yes, I could take that on.


>> I'm currently doing firmware on a managed enclosure.  Although my
>> vendor only supports LSI MegaRAID, there is no reason why my
>> enclosures cannot work in the same manner on a kernel RAID system.
>>
>>
>>
>> Request for comments...
> It sounds to me like you just need a few scripts to provide some
> enclosure-specific functionality.  I would be happy to include them in the
> mdadm distribution.
>
> Or maybe there is something that I didn't understand??
>
> Thanks,
> NeilBrown
>
>
The one piece that could be included in the kernel level is the display 
of /proc/mdstat to show the enclosureID and slot number


>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

