From: Duane <duane@evenson.tk>
Subject: Re: RAID5 devices assemble into RAID0 array
Date: Mon, 27 Nov 2017 19:52:01 -0700
Message-ID: <449af583-e7d6-236e-3ac2-d5da1bd7caf6@evenson.tk>
References: <c1ae7110-8f62-9afd-2e4c-092256212153@evenson.tk>
 <5A1AADCF.8090405@youngman.org.uk>
 <3d9c7310-ffe9-d79e-ff75-0a95b5c5170a@evenson.tk>
 <5A1B2DFC.6090702@youngman.org.uk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------FE0BE6D132630FFF92016991"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5A1B2DFC.6090702@youngman.org.uk>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------FE0BE6D132630FFF92016991
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

OK trying to re-add got me this problem.

# mdadm  -A /dev/md0 /dev/sdc2
mdadm: /dev/md0 assembled from 1 drive - not enough to start the array.

# mdadm  /dev/md0 --re-add /dev/sdd
mdadm: Cannot get array info for /dev/md0

Looking at the array,

# mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
      Raid Level : raid0
   Total Devices : 1
     Persistence : Superblock is persistent

           State : inactive

            Name : dave:0  (local to host dave)
            UUID : f8c0d29d:9b5986a4:050ca914:3a2fb8c8
          Events : 51526

     Number   Major   Minor   RaidDevice

        -       8       34        -        /dev/sdc2

I cannot re-add the missing devices.

Doing "mdadm -A /dev/md0 -s" gets me the same array configuration as I 
showed in my original post.

Does anyone know why it insists on going to RAID0?
Does anyone know how I can re-add the devices?
Thank you,
Duane



On 2017-11-26 02:11 PM, Wols Lists wrote:
> On 26/11/17 17:29, Duane wrote:
>> You're right I failed and removed device 3, then failed and removed
>> device 2, which broke my array.
>>
>> Let's assume I haven't messed things up any more than I already have.
>>
>> Is there a method to reverse the above operations for device 2 and
>> device 3?
>>
>> Thanks, Duane
>>
> My raid-fu is mostly theoretical, but what I would try is as follows.
>
> It's assembled the broken array as md0, so
>
> mdadm /dev/md0 --re-add /dev/device2
>
> followed by
>
> mdadm /dev/md0 --re-add /dev/device3
>
> That won't cause any further damage, and may work fine.
>
> Beyond that, I wouldn't like to suggest anything - if it doesn't work
> you'll probably need to use things like --force, which could easily
> break stuff. But re-add will probably work. And my syntax might not work
> - you might need to specify the mode like --grow or --manage, I don't know.
>
> Suck it and see, at least this won't do any damage, and if it doesn't
> work we'll have to wait for further advice.
>
> Cheers,
> Wol
>>
>> On 2017-11-26 05:04 AM, Wols Lists wrote:
>>> On 26/11/17 01:50, Duane wrote:
>>>> I have 3 RAID5 devices. When I assemble them, I end up with a RAID0
>>>> device.
>>>>
>>>> What is the cause? What is the solution?
>>>>
>>>> All I can think of is the fact that there is only 1 active device. I had
>>>> 2 but then manually failed it. I want to reassemble a RAID5 array and
>>>> then re-add the second device.
>>>>
>>> OUCH!
>>>
>>> Sorry. You have a 3-device raid-5. You only have 1 working device. Your
>>> array is well broken.
>>>
>>> You can't "reassemble raid5 then readd the second device". You need to
>>> readd the second device in order to get your raid5 back. I'll let
>>> someone else tell you how, but you need a MINIMUM of two devices to get
>>> your raid working again. Then you need to get your third device added
>>> back otherwise your raid 5 is broken.
>>>
>>> DON'T DO ANYTHING WITHOUT ADVICE. I'm sorry, but your message says you
>>> don't understand how raid works, and you are on the verge of destroying
>>> your array irrevocably. It should be a simple recovery, *provided* you
>>> don't make any mistakes.
>>>
>>> Cheers,
>>> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--------------FE0BE6D132630FFF92016991
Content-Type: text/x-vcard;
 name="duane.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="duane.vcf"

bnVsbA==
--------------FE0BE6D132630FFF92016991--
