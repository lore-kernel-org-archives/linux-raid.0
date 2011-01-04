From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID for USB flash drives
Date: Tue, 04 Jan 2011 20:09:20 +0000
Message-ID: <4D237E70.6030104@anonymous.org.uk>
References: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=kcbanFit5x27ccS_1RChxC=Dn+Hs4Ak+FbKsX@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hank Barta <hbarta@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/01/2011 19:40, Hank Barta wrote:
> Hi folks,
> This is going to be one of those corner cases and I'm sure some of you
> won't even think it a good idea. But I won;t let that stop me from
> asking your opinion.
[...]

Go ahead :-)

> So... Anything you would do differently?

First up, booting. You'll have to boot off a bare device which may in 
fact be a mirror over 2 or more sticks. Make that your first partition. 
I think it's simpler to make it over all 4. Look up booting from RAID to 
find out how.

Then, as far as I know USB flash sticks have lousy or no wear-levelling 
algorithms and use cheap flash which may not have very many write 
cycles, so given that, I'd either:

1. Use RAID-1, 5 or 10 for the rest of the system with ext4 as you suggest,

or 2. Use btrfs for the rest of the system - btrfs is included in Ubuntu 
10.10 but you may be able to get it for 10.04.

And in either case, make sure there are regular backups of the whole lot 
to your main disc-based array, because those $7 USB sticks could still 
give you problems.

Or 3. I might just decide to use just one stick to boot the system from 
(as a /boot) and put the rest of the system in an LVM LV, or even a 
file, on the main array, and make sure I had a second stick to start the 
system from if the first one went bad.

In any case, it's an interesting project, so good luck!

Cheers,

John.

