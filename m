From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write
 back mode
Date: Wed, 16 Nov 2016 05:18:51 +0000
Message-ID: <0F99C371-BD11-4032-945A-4E19A80AD771@fb.com>
References: <20161110204623.3484694-1-songliubraving@fb.com>
 <20161110204623.3484694-4-songliubraving@fb.com>
 <87bmxgi8hi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmxgi8hi.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <BD293DE12EEB314F98300AB676910E84@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

> This bothers me.  Why would a stripe *ever* be in "caching mode" (or
> "caching phase") when the array is in write-through?  It doesn't seem to
> make sense.

I was thinking about replacing STRIPE_R5C_WRITE_OUT with something
like STRIPE_R5C_CACHING. So that:

caching-phase is STRIPE_R5C_CACHING =3D=3D 1
write-out phase is STRIPE_R5C_CACHING =3D=3D 0=20

In this case, stripes in write-through mode will always have=20
STRIPE_R5C_CACHING =3D=3D 0.=20

This requires some changes to current state machine, but it might work out.=
=20

How do you like this?=20


> There are two actions that can be taken when where are ->towrite blocks
> on a stripe.  We can enter WRITE_OUT, or they can be cached in the
> journal.  Also we can enter WRITE_OUT when a stripe needs to be removed
> From memory or from the journal.
> This makes "writeout" and "cache" seem more like "actions" than states,
> modes, or phases.  Naming is hard.

Yes, it is more like action. We used to name it as "modes" as different *mo=
de*
handles writes with different *action*. So at end of the day, it doesn't re=
ally=20
matter?

Thanks,
Song



