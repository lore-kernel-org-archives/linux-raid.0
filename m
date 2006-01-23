From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: Expanding RAID array?
Date: Mon, 23 Jan 2006 15:28:34 +0100
Message-ID: <87slrfuigd.fsf@pumba.bayour.com>
References: <1137424449.3953.38.camel@kenny>
	<17356.8228.325002.652805@cse.unsw.edu.au>
	<Pine.LNX.4.56.0601162244220.1836@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0601162244220.1836@lion.drogon.net> (Gordon
 Henderson's message of "Mon, 16 Jan 2006 22:48:04 +0000 (GMT)")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Gordon Henderson <gordon@drogon.net>:

> On Tue, 17 Jan 2006, Neil Brown wrote:
>
>> - status of RAID6
>>     I believe it is as stable/reliable as raid5.
>
> FWIW: I've been using RAID-6 since early last year in production
> environments and so-far so good.

Ditto. On a VERY loaded system (so loaded that it crash every now and
then because of the load). Haven't had ANY trouble what so ever with
RAID6. I'm very (!) happy with it!

This on 4x9Gb + 2 spares. Use it on the system/root filesystem only
though... Which isn't THAT loaded now when I think about it...

If I could, i'd convert all my RAID5 sets to RAID6. But I don't have
time for the downtime. I'll monitor this subject closely though... :)

> Kernels 2.6.11 to 2.6.15 (on a Dell 2850 server I'm building tonight with 6 drives).

Mine is a 2.6.12.4 on a Sun Blade 1000 (2x750MHz UltraSPARC III) CPU's
(now) with 2Gb mem...

> I've not had a disk failure for real yet, but it's "just worked" every time I've done
> tests on it.

Same here. I've been fortunate to not have a disk crash so I can't
say how stable/good RAID6 is if disks start krashing :)
-- 
PLO SEAL Team 6 domestic disruption jihad nuclear terrorist Clinton
colonel Qaddafi congress Marxist Peking bomb explosion South Africa
[See http://www.aclu.org/echelonwatch/index.html for more about this]
[Or http://www.europarl.eu.int/tempcom/echelon/pdf/rapport_echelon_en.pdf]
If neither of these works, try http://www.aclu.org and search for echelon.
