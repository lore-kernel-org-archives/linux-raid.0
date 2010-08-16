From: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of recovery
 when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 14:13:19 +0200
Message-ID: <4C692B5F.9080909@gmail.com>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>	<AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>	<4C68CCC9.2050604@jungers.net> <AANLkTim9gUa95AR1KZcyBp7qM8_PeO1O7Bh99R2P8ON9@mail.gmail.com> <4C68D6D3.6070906@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C68D6D3.6070906@jungers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas Jungers <nicolas@jungers.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16.08.10 08.12, Nicolas Jungers wrote:
>> mdadm -E before http://pastebin.com/f46EWXEA vs after
>> http://pastebin.com/Kp145Mkx indicates sdb1 is missing a few events,
>> dunno if that's too much to be usable at this point?
>
> Did write happen during the reconstruction? You'll lose not only what
> was on the write but also everything on the same strip, including
> directories. That's a reason to try with a copy of sdd.

I've got a LVM volume group on the array, but never mounted any of the 
logical volumes during the reconstruction. Not sure if LVM will write 
something in the background that would have messed up things?

Tor Arne
