From: =?UTF-8?Q?Tor_Arne_Vestb=C3=B8?= <torarnv@gmail.com>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of
 recovery when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 00:33:53 +0200
Message-ID: <AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>
	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Aug 15, 2010 at 10:06 PM, Tor Arne Vestb=C3=B8 <torarnv@gmail.c=
om> wrote:
> On Sun, Aug 15, 2010 at 8:52 PM, Tor Arne Vestb=C3=B8 <torarnv@gmail.=
com> wrote:
>> Hey,
>>
>> Hoping for some crisis help here :)
>
> Here's a few logs if it helps...

After reading various tips on recovering I tried the following:

# mdadm -Afv /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sde1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 4.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: added /dev/sde1 to /dev/md0 as 3
mdadm: added /dev/sdb1 to /dev/md0 as 4
mdadm: added /dev/sdc1 to /dev/md0 as 1
mdadm: /dev/md0 assembled from 2 drives and 1 spare - not enough to
start the array.

Thinking that since sdb1 was more or less intact it would be able to
jump in and work together with sdc1 and sde1 to form a degraded array
I could pull data off of.

But it seems that when I added sdb1 to the array earlier after it
initially was kicked for being "non-fresh", it got added as a spare,
in slot 4.

The message about no uptodoate device for slot 2 is correct, that's
the sdd1 device that failed. But for slot 0 it should be sdb1.

Is ther any way I can tell mdadm to assume sdb1 is up to date, and use
that at slot 0?

Thanks!

Tor Arne

PS: Pastebin.com seems to be down, so here's a repaste of mdadm -E:
http://pastebin.org/518816
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
