From: Phil Turmel <philip@turmel.org>
Subject: Re: All disk ar reported as spare disks
Date: Fri, 31 Jan 2020 08:57:29 -0500
Message-ID: <e6a3c4d6-bc2e-fe11-5ed5-310fa1b7526b@turmel.org>
References: <CAC4UdkZoo=B2c-XmRwPA19gEsUtHYVhq2=Sqgs54mf2ZHerDxw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC4UdkZoo=B2c-XmRwPA19gEsUtHYVhq2=Sqgs54mf2ZHerDxw@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Rickard Svensson <myhex2020@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rickard,

Good report.

On 1/30/20 6:48 PM, Rickard Svensson wrote:
> Hello
> 
> Excuse me for asking again.
> 
> But this is a simpler(?) follow-up question to:
> https://marc.info/?t=157895855400002&r=1&w=2
> 
> In short summary. I had a raid 1 0, there were too many write errors
> on one disk (I call it DiskError1), which I did not notice, and then
> two days later the same problem on another disk (I call it
> DiskError2).
> 
> I got good help here, and copy the disk portions of the 2 working
> disks as well as disk DiskError2 with ddrescue to new disks.
> Later I'll create a new raid 1, so I don't plan reuse the same raid 1 0 again.
> 
> 
> My questions:
> 1) I haven't copied the disk DiskError1, because it is older data, and
> it shouldn't be needed.   Or is it better to add that one as well?
> 
> 2) Everything looks pretty good :)
> But all disk ar reported as spare disks in /proc/mdstat
> A assume that is because "Events" count is not the same. It is same on
> the good disks(2864) but not DiskError2 (2719).

No, the array isn't running, so /proc/mdstat isn't complete.  Your three 
disks all have proper "Active device" roles per --examine.

> I have been looking how I can "force add" disk DiskError2, use
> "--force" or "--- zero-superblock"?

Neither --add nor --zero-superblock is appropriate.  They will break 
your otherwise very good condition.

> But would prefer to avoid making a mistake now,   what has the
> greatest chance of being right :)

First, ensure you do not have a timeout mismatch as evidenced in your 
original thread's smartctl output.  The wiki has some advice.  Hopefully 
your new drives are "NAS" rated and you need no special action.

Then you should simply use --assemble --force with those three devices.

That should get you running degraded.  Then immediately backup the most 
valuable data in the array before doing anything else.

Finally, --add a fourth device and let your raid rebuild its redundancy.

When all is safe, consider converting to a more durable redundancy 
setup, like raid6, or raid10,near=3.

Phil
