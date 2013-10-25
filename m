From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: RE: Help raid10 recovery from 2 disks removed
Date: Fri, 25 Oct 2013 14:07:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310251405300.1838@uplift.swm.pp.se>
References: <1F36A02C60ACD1478457DCD917DA0FA8034656@ZEX001-0M9030.jp.ykgw.net> <alpine.DEB.2.02.1310241050290.1838@uplift.swm.pp.se> <1F36A02C60ACD1478457DCD917DA0FA8034983@ZEX001-0M9030.jp.ykgw.net> <52690FB2.6000005@turmel.org>
 <1F36A02C60ACD1478457DCD917DA0FA8034D07@ZEX001-0M9030.jp.ykgw.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1F36A02C60ACD1478457DCD917DA0FA8034D07@ZEX001-0M9030.jp.ykgw.net>
Sender: linux-raid-owner@vger.kernel.org
To: yuji_touya@yokogawa-digital.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 25 Oct 2013, yuji_touya@yokogawa-digital.com wrote:

> I had been believing that nowadays all hdd drive can reallocate bad 
> sectors. It is wrong, right?

No, the functionality referred to is how long the drive tries to read an 
errored sector before returning a read error. A RAID class device will 
typically wait 7 seconds, whereas a consumer grade device will wait 120 
(or so) seconds. The linux kernel by default timeouts the drive if it's 
unresponsive for this duration of time.

That's why you need to adjust the linux kernel timeouts, personally I set 
180 seconds before kicking the drive from the array.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
