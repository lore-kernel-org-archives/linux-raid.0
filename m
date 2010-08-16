From: =?UTF-8?Q?Tor_Arne_Vestb=C3=B8?= <torarnv@gmail.com>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of
 recovery when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 07:49:17 +0200
Message-ID: <AANLkTinK0FQq_o=5mfJJL1h-zo+3pL8Vm-9K5SFiLF8M@mail.gmail.com>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>
	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>
	<AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 16, 2010 at 12:33 AM, Tor Arne Vestb=C3=B8 <torarnv@gmail.c=
om> wrote:
> Thinking that since sdb1 was more or less intact it would be able to
> jump in and work together with sdc1 and sde1 to form a degraded array
> I could pull data off of.

Here's a paste of the mdadm -E state of things before this happened:

http://pastebin.com/f46EWXEA

I notice the event count has gone up since then, does this indicate
that sdb1 will be too old (non-fresh) to be usable?

Perhaps I'll have more luck assembling the array with the known-faulty
sdd1 with a little bit of file corruption, or perhaps it was just
failing temporarily and got kicked just to be safe?

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
