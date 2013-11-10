From: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>
Subject: Re: mdadm: /dev/md0 has been started with 1 drive (out of 2).
Date: Mon, 11 Nov 2013 01:24:56 +0200
Message-ID: <182A8B2E-195E-44D6-B2DE-4C1FB823068A@gmail.com>
References: <C8EFEBC6-4B43-4B71-AA3F-7DC69480220D@gmail.com> <5278C2A6.7060005@websitemanagers.com.au> <E9509E1D-C8FB-4496-ADD5-C6ACBEFC4007@gmail.com> <5278D84C.4040600@websitemanagers.com.au> <5E756798-9940-4EA9-821A-2A49F92E0B03@gmail.com> <5278E50E.90808@websitemanagers.com.au> <6BD059D7-DF6F-4185-B1F9-A564ECB3EFBE@gmail.com> <5279F64F.5000104@websitemanagers.com.au> <F53E1ABB-E13A-45EC-A27E-5917F54546A5@gmail.com> <985D2F3C-9E55-405E-AC95-FF7733599870@gmail.com> <52801034.5020006@websitemanagers.com.au>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52801034.5020006@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <adam@websitemanagers.com.au>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Nov 11, 2013, at 1:01 AM, Adam Goryachev <adam@websitemanagers.com.au> wrote:

> On 08/11/13 17:32, Ivan Lezhnjov IV wrote:
>> Hello,
>> 
>> so I've successfully rebuilt the array, added internal bitmap, haven't run any extensive i/o tests but I continued with copying of my data off the old disks and I haven't really noticed a serious impact. This is a first impression only, but so far so good.
>> 
>> Now that I have bitmap I deliberately repeated sleep/resume cycle exactly as it was done the last time that led to array degradation and sure enough the system started up with a degraded array. in fact, it is way more messy this time because both devices were dynamically assigned new /dev/sdx devices: before sleep they were /dev/sdc1 and /dev/sdd1, after resume they became /dev/sdd1 and /dev/sdb1.
> I think this is a different issue, raid is not responsible for device discovery and mapping to device names. I think udev may provide a solution to this where it will ensure each device identified by some distinct hardware feature (eg, serial number), will be configured as a specific device name. I use this often for ethernet devices, but I assume something similar is applicable to disk drives.

That is correct, and my problem happens only when system fails to stop array before going to sleep. I've poked around a bit and learned that SAMBA server that uses this array as a share wouldn't allow the system to unmount it cleanly before going into the sleep state. On resume it would become a mess with drives having stale /dev/* devices, /dev/md0 still mounted sometimes but filesystem inaccessible (I/O errors is the only thing that I would see), etc. Long story short, I create pm-utils sleep hook that stops SAMBA, then umounts /dev/md0 and stop array cleanly, and then reassembles, mounts filesystem and starts SAMBA again and that resolves the above mentioned issue. I can now sleep/resume and have the array work as a kind of plug'n'play device ha :)

> 
>> So, I unmounted filesystem on the array, and stopped the array. Then reassembled it, and it looks to be in a good shape. However, I am wondering if this is exactly due to the internal bitmap. Basically what surprised me was that the array was assembled and shown as in sync instantly. Worth noting, I should say that before the laptop went to sleep there were no processes writing to the array disks -- I made sure -- so the data should be consistent on both drives, but as we know from my very first message event count may be still different when upon resume from sleep.
> Yes, given that there were no writes to the array, (or minimal writes, probably there is always something), then the re-sync would have been so quick you would not have noticed it. As mentioned, it can easily be completed in a second... for me, it is often a minute or two due to a lot of writes happening during the bootup process.

Indeed, it is lighting fast. And luckily for me, I don't really see performance decline with default internal bitmap type and its default chunk size.

>> My question is basically if I'm enjoying the benefits of having internal bitmap or maybe I got lucky and this time event count was the same for both drives? 
> The only way to know for sure would be to examine the drives during the bootup process before the raid array is assembled....
> 
> You might see some information in the logs about the resync.

Either I do not know how to read entries produced by mdadm but logs would typically contain little descriptive (yeah, depends on whether I can speak the mdam code language lol) information.

At any rate, I think I have a fairly good understanding of what's happening now. I've seen resync happen in under 5 seconds so it confirmed for me that internal bitmap is working as expected and even better than I expected.

Thanks for the answer, anyway!

Ivan

