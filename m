From: joystick <joystick@shiftmail.org>
Subject: Re: Corrupted FS after recovery. Coincidence?
Date: Thu, 28 Feb 2013 00:19:25 +0100
Message-ID: <512E947D.1030000@shiftmail.org>
References: <512E6098.6040703@jamie-thompson.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <512E6098.6040703@jamie-thompson.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jamie Thompson <jamierocks@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/27/13 20:38, Jamie Thompson wrote:
> Hi all.
>
> I just wanted to check with those more clued up that I'm not missing 
> something important. To save you wading through the logs, in summary 
> my filesystem got borked after I recovered an array when I realised 
> I'd used the device and not the partition and corrected the mistake.

Not coincidence.

For sure MD cannot possibly recover 500GB in 9 seconds so something must 
be wrong.

You do not show metadata type. My guess is that it is at the end of the 
disk (1.0 maybe) and so when you added sdf1 MD thought it was a re-add 
and re-synced only the parts that were dirty in the bitmap (changed 
since removal of sdf). However since you moved the start of the disk, 
all data coming from such disk are offsetted and hence bogus. That's why 
metadata default for mdadm is version 1.2: you don't risk this kind of 
crazy things with 1.2 .

With nondegraded raid-5 (which is the situation after adding sdf1), in 
raid5 the reads always come from the nonparity disk for every stripe. So 
when you read, approximately you get 1/3 of data from sdf1, all of it 
bogus. Clearly also ext3 is not happy with its metadata screwed up, 
hence the read errors you see.

If I am correct, the "fix" for your array is simple:
- fail sdf1
After that already you can read. Then do mdadm --zero-superblock 
/dev/sdf1 (and maybe even mdadm --zero-superblock /dev/sdf then 
repartition the drive, just to be sure) so mdadm treats it like a new 
drive. Then you can re-add. Ensure it performs a full resync, otherwise 
fail it again and report here.

Too bad you performed fsck already with bogus sdf1 in the raid... Who 
knows what mess it has done! I guess many files might be unreachable by 
now. That was unwise.

For the backup you performed to an external disk: if my reasoning is 
correct you can throw it away. This is unless you like to have 1/3 of 
the content of your files full of bogus bytes. You will have more luck 
backing up the array again after failing sdf1 (most parity data should 
still be correct, except where fsck wrote data).

However before proceeding with anything I suggest to wait for some other 
opinion on the ML, 'cuz I am not infallible (euphemism).
Disassemble the raid in the meantime. This will make sure at least that 
a cron'd "repair" does not start, that would be disastrous.

Also please tell us your kernel version and cat /proc/mdstat please so 
we can make better guesses.

Good luck
J.

