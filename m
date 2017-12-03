From: Phil Turmel <philip@turmel.org>
Subject: Re: mdadm reshaping stuck problem
Date: Sun, 3 Dec 2017 12:20:43 -0500
Message-ID: <b795ed1f-cfcb-4b8f-c25c-a46297bf2614@turmel.org>
References: <73f07f38fb71986fe71be67f00c77698@posteo.de>
 <fed720e2-fd55-6458-2d68-9b87c96254fc@turmel.org>
 <83ee590a545d4de7938b535b952729b7@posteo.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83ee590a545d4de7938b535b952729b7@posteo.de>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: rene.feistle@posteo.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Rene,

{ Convention on kernel.org is to trim replies & either bottom post or
interleave.  Please do. }

On 12/03/2017 09:59 AM, rene.feistle@posteo.de wrote:
> Hello Phil,
> 
> Thanks for your fast reply.
> 
> I did run your commands and the results are attached to this email and
> on pastebin here:
> 
> https://pastebin.com/EVpLfmAe
> https://pastebin.com/ZMBYB5CW

Very good.  At some point you need to replace the desktop drive -- it's
unsafe to use in a raid array -- but it doesn't look like it's blowing
up at the moment.  Use the following workaround on every boot until you
replace it:

echo 180 > /sys/block/sde/device/timeout

Search the archives for "timeout mismatch" to see many discussions on
why that drive is a time bomb.

> The drive names have changed because I deinstalled one drive that was
> not in the raid. I had a copy of all data on this drive so I'm trying to
> recover my data with that drive now. The chances are good because I did
> overwrite the partition table only.

Ok.

Based on the mdadm -E reports, I recommend stopping the array, booting
with a rescue CD that has mdadm tools (I recommend SystemRescueCD, btw)
and a recent kernel.  Your situation sounds like a kernel bug and your
best bet to get out of this is to use a more recent kernel for the
duration of the reshape and rebuild.

So, in the rescue environment, use --assemble --force with these three
drives.  Then --add your fourth drive, and wait for both rebuild and
reshape to complete.

Be sure to explicitly --stop the array before leaving the rescue
environment.

Phil
