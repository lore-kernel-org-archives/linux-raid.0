From: Neil Brown <neilb@suse.de>
Subject: Re: about raid5 recovery when created
Date: Wed, 30 Dec 2009 13:55:02 +1100
Message-ID: <20091230135502.6a21441f@notabene.brown>
References: <20091210145931.46ccbfe4@notabene.brown>
	<g3143w7eigolu0x2ziUYAxe124vaj_firegpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <g3143w7eigolu0x2ziUYAxe124vaj_firegpg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mjevans1983@gmail.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Thanks.  I have applied this patch.

NeilBrown



On Wed, 9 Dec 2009 21:52:18 -0800 (PST)
mjevans1983@gmail.com wrote:

> On Wed, Dec 9, 2009 at 7:59 PM, Neil Brown <neilb@suse.de> wrote:
> > On Wed, 9 Dec 2009 19:34:04 -0800
> > Michael Evans <mjevans1983@gmail.com> wrote:
> >
> >> On Wed, Dec 9, 2009 at 5:43 PM, Neil Brown <neilb@suse.de> wrote:
> >> > On Wed, 9 Dec 2009 19:29:04 +0800
> >> > hank peng <pengxihan@gmail.com> wrote:
> >> >
> >> >> I think it is better to implement this function in kernel's md =
layer.
> >> >> I wonder what Neil Brown think of this?
> >> >
> >> > I don't think it is worth the effort.
> >> > You probably would save some CPU time as you don't need to XOR, =
but as has
> >> > been said, we are usually IO bound, not CPU bound.
> >> >
> >> > With the current arrangement, you can start using the array imme=
diately - you
> >> > don't have to wait for the initial recovery to complete.
> >> > If you zeroed all devices at create time, you would have to wait=
 for that to
> >> > complete before using the array.
> >> >
> >> > So I see very little gain, and significant cost.
> >> >
> >> > NeilBrown
> >> >
> >> >
> >>
> >> When I assemble an array I tend to have checked the devices before
> >> hand; it would not be difficult to make the final pass a zeroing p=
ass
> >> if I knew I could vastly speed up post-assembly performance. =C2=A0=
As I
> >> stated, it's merely a lack of clarity in the documentation.
> >
> > If you would like to create a patch against the man page, I would b=
e happy to
> > accept it.
> >
> > NeilBrown
> >
>=20
> diff --git a/mdadm.8 b/mdadm.8
> index f8f240a..29e098b 100644
> --- a/mdadm.8
> +++ b/mdadm.8
> @@ -648,6 +648,12 @@ data will be affected unless you actually write =
to the array.  It can
>  also be used when creating a RAID1 or RAID10 if you want to avoid th=
e
>  initial resync, however this practice \(em while normally safe \(em =
is not
>  recommended.  Use this only if you really know what you are doing.
> +.IP
> +When the devices that will be part of a new array were filled
> +with zeros before creation the operator knows the array is
> +actually clean. If that is the case, such as after running
> +badblocks, this argument can be used to tell mdadm the
> +facts the operator knows.
>=20
>  .TP
>  .BR \-\-backup\-file=3D

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
