From: =?UTF-8?Q?Tor_Arne_Vestb=C3=B8?= <torarnv@gmail.com>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of
 recovery when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 07:59:07 +0200
Message-ID: <AANLkTin0GfA7Q-Nc1y0C7xkniUKTk7UWvRz9xPXAShX-@mail.gmail.com>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>
	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>
	<AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>
	<4C68CCC9.2050604@jungers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C68CCC9.2050604@jungers.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hey Nicolas!

On Mon, Aug 16, 2010 at 7:29 AM, Nicolas Jungers <nicolas@jungers.net> =
wrote:
> I'd try to recreate the array with a copy of the disks
>
> do a ddrescue of the 3 good disks and then try a mdadm -C with the ex=
act
> parameters of the array creation with the same mdadm version (use mis=
sing
> for slot 2). =C2=A0It saved my raid10 array.

You mean you sdc and sde plus either sdb or sdd, depending on which
one I think is more sane a this point?

mdadm -E before http://pastebin.com/f46EWXEA vs after
http://pastebin.com/Kp145Mkx indicates sdb1 is missing a few events,
dunno if that's too much to be usable at this point?

Can the create-process be done "read-only", so that I don't have to
use extra disks? If I've understood things correctly --create will
only overwrite the superblocks, not touch the data?

So I could do:

mdadm -C /dev/md0 /dev/sdb1 /dev/sdc1 misssing /dev/sde1

I suppose the 33% restored spare sdf1 won't help any in this situation?

Tor Arne
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
