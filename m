From: Larkin Lowrey <llowrey@gmail.com>
Subject: Re: raid5-cache: Cannot get enough stripes due to memory pressure.
 Recovery failed.
Date: Sun, 5 Nov 2017 10:20:05 -0500
Message-ID: <7545b7cd-8b8d-6264-d6d7-eeed6b852ee9@gmail.com>
References: <e4b20202-95e8-c31c-c37b-3da3109537d2@gmail.com>
 <59FDFEBE.3000904@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <59FDFEBE.3000904@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

The rescue shell had the full kernel loaded and all 16GB was available 
so that's not the issue.

I booted off a USB drive and was able to get both arrays to assemble. 
The kernel was much older, 4.11.8-300.fc26.x86_64.

After a clean shutdown and reboot to a 4.13.X kernel I no longer get 
dumped into the recovery shell but the boot process hangs. The 8 drive 
array gets assembled but the hang happens immediately after all of the 
drives for the 12 drive array are detected so I suspect the hang happens 
during the assembly of the 12 drive array.

When I go back to boot off the USB drive (4.11.8 kernel) both assemble 
just fine. Could there be regression between 4.11.8 and 4.13.X?

I no longer have full boot images with older kernels than 4.13 so I 
can't easily test to identify the point of regression.

--Larkin

On 11/4/2017 1:54 PM, Wols Lists wrote:
> On 04/11/17 16:13, Larkin Lowrey wrote:
>> The prior shutdown could have been unclean for the array. The shutdown
>> process got stuck and I eventually had to use the reset button.
>>
>> I have a second (8 drive) raid6 array on this host that has a 2GB
>> journal and it won't assemble either.
>>
>> Kernel: 4.13.10-100.fc25.x86_64
>>
>> What can I do? Do I need more RAM?
> You're in the recovery shell ... does/can that use all available ram?
> (Like DOS needed special drivers to use ram above 1MB). So I doubt you
> need more ram.
>
> Get a rescue disk of some sort, boot into that, so you've got a full
> working linux off DVD/CD, and see if you can assemble the arrays from there.
>
> Cheers,
> Wol
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

