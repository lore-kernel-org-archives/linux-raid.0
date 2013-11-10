From: Adam Goryachev <adam@websitemanagers.com.au>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Mon, 11 Nov 2013 10:01:08 +1100
Message-ID: <52801034.5020006@websitemanagers.com.au>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com> <5278E50E.90808@websitemanagers.com.au> <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com> <5279F64F.5000104@websitemanagers.com.au> <F53E1ABB-E13A-45EC-A27E-5917F54546A5@gmail.com> <985D2F3C-9E55-405E-AC95-FF7733599870@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <985D2F3C-9E55-405E-AC95-FF7733599870@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/11/13 17:32, Ivan Lezhnjov IV wrote:
> Hello,
>
> so I've successfully rebuilt the array, added internal bitmap, haven't run any extensive i/o tests but I continued with copying of my data off the old disks and I haven't really noticed a serious impact. This is a first impression only, but so far so good.
>
> Now that I have bitmap I deliberately repeated sleep/resume cycle exactly as it was done the last time that led to array degradation and sure enough the system started up with a degraded array. in fact, it is way more messy this time because both devices were dynamically assigned new /dev/sdx devices: before sleep they were /dev/sdc1 and /dev/sdd1, after resume they became /dev/sdd1 and /dev/sdb1.
I think this is a different issue, raid is not responsible for device 
discovery and mapping to device names. I think udev may provide a 
solution to this where it will ensure each device identified by some 
distinct hardware feature (eg, serial number), will be configured as a 
specific device name. I use this often for ethernet devices, but I 
assume something similar is applicable to disk drives.

> So, I unmounted filesystem on the array, and stopped the array. Then reassembled it, and it looks to be in a good shape. However, I am wondering if this is exactly due to the internal bitmap. Basically what surprised me was that the array was assembled and shown as in sync instantly. Worth noting, I should say that before the laptop went to sleep there were no processes writing to the array disks -- I made sure -- so the data should be consistent on both drives, but as we know from my very first message event count may be still different when upon resume from sleep.
Yes, given that there were no writes to the array, (or minimal writes, 
probably there is always something), then the re-sync would have been so 
quick you would not have noticed it. As mentioned, it can easily be 
completed in a second... for me, it is often a minute or two due to a 
lot of writes happening during the bootup process.
> My question is basically if I'm enjoying the benefits of having 
> internal bitmap or maybe I got lucky and this time event count was the 
> same for both drives? 
The only way to know for sure would be to examine the drives during the 
bootup process before the raid array is assembled....

You might see some information in the logs about the resync.

Regards,
Adam

-- 
Adam Goryachev
Website Managers
P: +61 2 8304 0000                    adam@websitemanagers.com.au
F: +61 2 8304 0001                     www.websitemanagers.com.au

