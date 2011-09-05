From: CoolCold <coolthecold@gmail.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Mon, 5 Sep 2011 12:57:08 +0400
Message-ID: <CAGqmV7r3SnOKoRCy-f9XnPckNM0mp=uLjzfp2w6bL1mBvx+8Cg@mail.gmail.com>
References: <4E57FE4D.5080503@vorgon.com>
	<20110827084535.5e64bf5c@notabene.brown>
	<4E5FC63A.1040206@vorgon.com>
	<CAEUYfyN6nfEDwgE8_eZN48UFzaJNCN2NjBpJbeQR_G01CYCgvQ@mail.gmail.com>
	<4E60F95C.40203@vorgon.com>
	<CAEUYfyPWFwyadvYC8pUTssQMpGhqEoB0aTHtM_3yb7o33M1Edw@mail.gmail.com>
	<20110903121723.GA6123@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110903121723.GA6123@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Matthews <simon.d.matthews@gmail.com>, "Timothy D. Lenz" <tlenz@vorgon.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Sep 3, 2011 at 4:17 PM, Robin Hill <robin@robinhill.me.uk> wrot=
e:
> The way I do it is to run grub, then for each drive do:
> =A0 =A0device (hd0) /dev/sdX
> =A0 =A0root (hd0,0)
> =A0 =A0setup (hd0)
>
> That should set up each drive to boot up as the first drive.
$me does the same way, it works.

>
> Cheers,
> =A0 =A0Robin
> --
> =A0 =A0 ___
> =A0 =A0( ' } =A0 =A0 | =A0 =A0 =A0 Robin Hill =A0 =A0 =A0 =A0<robin@r=
obinhill.me.uk> |
> =A0 / / ) =A0 =A0 =A0| Little Jim says .... =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
> =A0// !! =A0 =A0 =A0 | =A0 =A0 =A0"He fallen in de water !!" =A0 =A0 =
=A0 =A0 =A0 =A0 =A0 =A0 |
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
