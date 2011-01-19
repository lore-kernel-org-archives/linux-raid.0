From: Igor Podlesny <for.poige+linux@gmail.com>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Wed, 19 Jan 2011 14:41:10 +0700
Message-ID: <AANLkTi=C6Pn9qHXPXX0NCEtEwihb1rVPDM48RUDXD_Eh@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com> <20110119064457.5ab8bdd0@notabene.brown>
Reply-To: for.poige+linux@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110119064457.5ab8bdd0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 January 2011 02:44, NeilBrown <neilb@suse.de> wrote:
> On Tue, 18 Jan 2011 22:59:07 +0700 Igor Podlesny <for.poige+linux@gma=
il.com>
> wrote:

   Hi Neil! Thanks for your reply.

> 1/ The rationale given by Greg for non-power-of-two chunk sizes is no=
t so
> =C2=A0relevant for Linux I think. =C2=A0The more common filesystems =C2=
=A0can be told that
> =C2=A0the device is a RAID and can deliberately offset the extra supe=
r blocks so
> =C2=A0they don't all end up on the one device.

   Yeah, that's right. But "non-2^n"-stripe is simpler in general and
wouldn't require any additional "tuning" and hopes, that FS'
developers took into consideration such things as possible RAID below
=46S- or even FS/LVM-2-layer. Shorter speaking, it would give benefits
in a much more simpler way. Also, there's another problem with "2^n":
stripe size are "gaped" more and more: 512, 1024, 2048, 4096. I'd
rather try using something like 768, 1355, 1719. Unable at present
though...
>
> 2/ Power-off-two is required simply because it was easier to code. =C2=
=A0The

   I guessed that. :-)

> =C2=A0restriction was dropped for RAID0 a year or more ago. =C2=A0The=
 restriction
> =C2=A0could be dropped for RAID4/5/6 and RAID10 relatively easily. =C2=
=A0It would just
> =C2=A0require a thorough code review and changing a few 'mask' and 's=
hift'
> =C2=A0operations to divisions.
[...]

   Would be really great. Really!

--=20
End of message. Next message?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
