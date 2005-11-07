From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Checking the sanity of SATA disks
Date: Mon, 07 Nov 2005 14:22:07 -0500
Message-ID: <436FA95F.4030007@tmr.com>
References: <20051004142913.GK6594@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20051004142913.GK6594@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andy Smith wrote:

>Hello,
>
>I have a home fileserver with 4 SATA disks in a RAID 5.  As I am
>sure you are aware, SATA devices in Linux currently cannot be
>queried for SMART info, so I can't do SMART health checks of these
>devices.
>
>Also there is still the tendency for Linux Software RAID to kick
>devices out of the array as soon as there is any error on them.
>
>I really don't want to be in the situation where a drive dies, I fit
>a new one, and during the resync another device is kicked out
>because of spontaneously finding a bad sector.
>
>I tried simply doing a
>
>        dd if=/dev/sd[abcd] of=/dev/null
>
>To check each disk in a very unsubtle fashion, but it drives the
>load average on the machine way way up (like to 20+) and makes it
>very unresponsive (wait several minutes for a keypress to be
>acknowledged), even if I run it under nice -n 19.
>

You (a) want to use larger buffers, and (b) a program which uses 
O_DIRECT for i/o. I had a news server which was running 28 aps until I 
started using dd, then it dropped to 3 aps. Usinf O_DIRECT there is no 
measurable slowdown (and no buffer contention).

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

