From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: mismatch_cnt again
Date: Sat, 07 Nov 2009 19:42:02 +1100
Message-ID: <4AF532DA.4080608@eyal.emu.id.au>
References: <4AF4C247.6050303@eyal.emu.id.au> <4AF4D323.6020108@panix.com>	 <4AF5268D.60900@eyal.emu.id.au> <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c0911070008m789507f8h799d419287740ca5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael,

This is something new to me. I never saw any message in any of the logs.

I am not a new linux user and neither am I unfamiliar with looking after
my system, yet I have never seen any messages related to these mismatches.

The first time I find out about this is when I run a raid 'check', and
even this scan does not produce any messages about the mismatch which
is simply logged into /sys/devices/virtual/block/md0/md/mismatch_cnt

Nov  7 03:05:02 e7 kernel: md: data-check of RAID array md0
Nov  7 03:05:02 e7 kernel: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
Nov  7 03:05:02 e7 kernel: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
Nov  7 03:05:02 e7 kernel: md: using 128k window, over a total of 976759808 blocks.
Nov  7 07:06:22 e7 kernel: md: md0: data-check done.

All intervening messages are unrelated (named verbiage).

Eyal

Michael Evans wrote:
> Your dmesg and/or the syslog stream of the same kernel warnings/info
> should show you when and where these errors occurred.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org

-- 
Eyal Lebedinsky	(eyal@eyal.emu.id.au)
