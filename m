From: Nicolas Jungers <nicolas@jungers.net>
Subject: Re: RAID5 disk failure during rebuild of spare, any chance of recovery
 when one of the failed devices is suspected to be intact?
Date: Mon, 16 Aug 2010 08:12:35 +0200
Message-ID: <4C68D6D3.6070906@jungers.net>
References: <AANLkTimiGhkzSBgt73fLZmoOcGf5Yyui-1WjkPLVVR6v@mail.gmail.com>	<AANLkTi=ryOfsBO0cVJbTT++P-Rh_jnEx+h5gSm_wXP5d@mail.gmail.com>	<AANLkTimEOFMh=TvQ2VqbPME+S2hNuiR3RNEbOGepBoH4@mail.gmail.com>	<4C68CCC9.2050604@jungers.net> <AANLkTim9gUa95AR1KZcyBp7qM8_PeO1O7Bh99R2P8ON9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim9gUa95AR1KZcyBp7qM8_PeO1O7Bh99R2P8ON9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
Cc: =?UTF-8?B?VG9yIEFybmUgVmVzdGLDuA==?= <torarnv@gmail.com>
List-Id: linux-raid.ids

On 08/16/2010 07:54 AM, Tor Arne Vestb=C3=B8 wrote:
> Hey Nicolas!
>
> On Mon, Aug 16, 2010 at 7:29 AM, Nicolas Jungers<nicolas@jungers.net>=
  wrote:
>> I'd try to recreate the array with a copy of the disks
>>
>> do a ddrescue of the 3 good disks and then try a mdadm -C with the e=
xact
>> parameters of the array creation with the same mdadm version (use mi=
ssing
>> for slot 2).  It saved my raid10 array.
>
> You mean you sdc and sde plus either sdb or sdd, depending on which
> one I think is more sane a this point?

I'd try both.  Do a ddrescue of the failing one and try that (with copy=
=20
of the others) and check what's coming out.

>
> mdadm -E before http://pastebin.com/f46EWXEA vs after
> http://pastebin.com/Kp145Mkx indicates sdb1 is missing a few events,
> dunno if that's too much to be usable at this point?

Did write happen during the reconstruction?  You'll lose not only what=20
was on the write but also everything on the same strip, including=20
directories.  That's a reason to try with a copy of sdd.

> Can the create-process be done "read-only", so that I don't have to
> use extra disks? If I've understood things correctly --create will
> only overwrite the superblocks, not touch the data?

yes, but I'd not do it.  And beside, you should not trust the failing=20
one (sdd).

>
> So I could do:
>
> mdadm -C /dev/md0 /dev/sdb1 /dev/sdc1 misssing /dev/sde1

or even
mdadm -C /dev/md0 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sde1

with copies.

>
> I suppose the 33% restored spare sdf1 won't help any in this situatio=
n?

I suppose not.

N.
>
> Tor Arne

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
