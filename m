From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: LVM and Raid5
Date: Wed, 16 Sep 2009 03:33:15 -0700 (PDT)
Message-ID: <894436.58276.qm@web51307.mail.re2.yahoo.com>
References: <70ed7c3e0909160320j68c792d2g8ba01ac3c34eaae5@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909160320j68c792d2g8ba01ac3c34eaae5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>, "Majed B." <majedb@gmail.com>
Cc: Linux Raid Study <linuxraid.study@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids




--- On Wed, 16/9/09, Majed B. <majedb@gmail.com> wrote:

> From: Majed B. <majedb@gmail.com>
> Subject: Re: LVM and Raid5
> To: "Goswin von Brederlow" <goswin-v-b@web.de>
> Cc: "Linux Raid Study" <linuxraid.study@gmail.com>, linux-raid@vger.k=
ernel.org
> Date: Wednesday, 16 September, 2009, 11:20 AM
> Hello,
>=20
> I'm the one who ran those tests with LVM vs. RAID5 and I
> think I have
> faced speed difference because I have disks of varying
> speeds
> (different models and vendors), and I believe that LVM gets
> crippled
> down to the speed of the slowest disk.
>=20
> On Wed, Sep 16, 2009 at 1:09 PM, Goswin von Brederlow
> <goswin-v-b@web.de>
> wrote:
> > Linux Raid Study <linuxraid.study@gmail.com>
> writes:
> >
> >> Hello:
> >>
> >> Has someone experimented with LVM and Raid5
> together (on say, 2.6.27)?
> >> Is there any performance drop if LVM/Raid5 are
> combined vs Raid5 alone?
> >>
> >> Thanks for your inputs!
> >
> > Has always worked perfectly for me and i can't say I
> noticed any
> > performance change.
> >
> > MfG
> > =A0 =A0 =A0 =A0Goswin
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
>=20
>=20
>=20
> --=20
> =A0 =A0 =A0=A0=A0Majed B.
> --

Is that the case even if a dd read from say md4 is much, much faster th=
at he lvm's that are based on md4? Surely if the read from the underlyi=
ng md is faster so should the LV's?

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
