From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: ERC for raid [forked from "mdadm reshaping stuck problem"]
Date: Sun, 3 Dec 2017 18:59:35 +0000
Message-ID: <5A244997.8000205@youngman.org.uk>
References: <73f07f38fb71986fe71be67f00c77698@posteo.de>
 <fed720e2-fd55-6458-2d68-9b87c96254fc@turmel.org>
 <83ee590a545d4de7938b535b952729b7@posteo.de>
 <b795ed1f-cfcb-4b8f-c25c-a46297bf2614@turmel.org>
 <ff1c0581-c901-e4d5-df14-943845ef7dd9@walther.xyz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ff1c0581-c901-e4d5-df14-943845ef7dd9@walther.xyz>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Walther <matthias@walther.xyz>, rene.feistle@posteo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/12/17 18:14, Matthias Walther wrote:
> Hello,
> 
> Am 03.12.2017 um 18:20 schrieb Phil Turmel:
>> Very good.  At some point you need to replace the desktop drive -- it's
>> unsafe to use in a raid array -- but it doesn't look like it's blowing
>> up at the moment.  Use the following workaround on every boot until you
>> replace it:
>>
>> echo 180 > /sys/block/sde/device/timeout
>>
>> Search the archives for "timeout mismatch" to see many discussions on
>> why that drive is a time bomb.
> 
> this is an interesting point. As far as I understand it, there's no
> difference between a) the device tells the kernel, that an error
> occurred (ERC) or b) the kernel just waits three minutes.
> 
> From my point of understanding, I see no reason to avoid those disks.
> Just raise this timeout to 180 on all disks. Even those with ERC can be
> set to 180 seconds, because on some mainboards the order of sdX changes
> every boot. On your home nas it doesn't really matter if there's an
> access delay. This is of course not acceptable on enterprise systems.

"Just raise the timeout". THAT is the problem. BY DEFAULT these drives
will mess up an array. If you know what you're doing, it isn't a
problem, but how many people don't know what they're doing? Most of them?

Oh - and a three-minute access delay? When you're watching a film? Who
are you kidding! A three minute delay will cause pretty much any normal
user to throw their toys out the pram, home or enterprise.
> 
> By the way, the kernel doesn't just easily throw the device out. From my
> experiences it hard resets the link and completely reinitializes the
> device. Only if that fails, the raid will be degraded and if this fails,
> the device probably has a problem and should be replaced.

And if the user doesn't know what they're doing, this is exactly what
will happen. The hard reset will work, the "reinitialise the device"
will fail (because the drive is hung trying to carry out the read
request), and the drive will get kicked.
> 
> I run a raid-6 on six really cheap old second hand 4 TB drives and never
> had an issue with that in the past two years. I had no real failures and
> no accidentally or prematurely dropped devices. Mdadm just runs. And
> this raid writes about 50 GB each and every single day and never goes to
> sleep. This is what differs mdadm from hardware raid controllers, which
> really shouldn't used with non ERC drives due to exactly that timing
> problem.
> 
> Though I run a check every month, where all data is read, just to make
> sure it doesn't rot on the discs. In my opinion a (monitored) raid-6 on
> old, cheap non ERC drives is safer, than a raid-5 on „premium
> overpriced“ drives. Never forget, it's call raid - random array of
> inexpensive disks.

Raid 6 is safer than raid 5. PROPERLY CONFIGURED non-ERC drives are
fine. You know what you're doing, that's fine. Joe Random Luser is going
to have his array blow up in his face.
> 
> In cynical words, I see it this way: The hdd and nas manufactures came
> together and found a way to push the prices up.
> 
:-) Couldn't agree more.

Cheers,
Wol

