From: Andy Smith <andy@strugglers.net>
Subject: Re: Can extremely high load cause disks to be kicked?
Date: Sun, 3 Jun 2012 22:05:36 +0000
Message-ID: <20120603220536.GN3867@bitfolk.com>
References: <20120531083158.GE3867@bitfolk.com>
 <4FC81B85.8090807@hardwarefreak.com>
 <20120601192524.GH3867@bitfolk.com>
 <4FC9A8D4.9060803@hardwarefreak.com>
 <20120603033042.GI3867@bitfolk.com>
 <CA+sTkh49kYa=sqzSNhnQtjMTs7OL=kmpsoP55k1zifFVByzENw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+sTkh49kYa=sqzSNhnQtjMTs7OL=kmpsoP55k1zifFVByzENw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Igor,

On Sun, Jun 03, 2012 at 12:05:31PM +0800, Igor M Podlesny wrote:
> On 3 June 2012 11:30, Andy Smith <andy@strugglers.net> wrote:
> > I probably didn't give enough details. On this particular host ther=
e
> > are four md arrays:
> >
> > md0 is mounted as /boot
> > md1 is used as swap
> > md2 is mounted as /
> > md3 is an LVM PV for "everything else"
> [=E2=80=A6]
>=20
>    Kinda off-topic question =E2=80=94 why having separate MDs for swa=
p and
> root? I mean LVM's lv would be just fine for them.

I know, but I'm kind of old-fashioned and have some (probably
unwarranted) distrust of having the really essential bits of the
system in LVM if they don't really need to be.

The system needs swap and I'm unlikely to want to change the size of
that swap, but if I do I can just add more swap from inside LVM. / is
also unlikely to need to be resized ever, so I keep that outside of
LVM too.

My position on this is probably going to have to change given the
current "get rid of /usr" plans that seem to be gaining traction in
the Linux community. A beefier / would probably justify being in
LVM to me.

But really it is all just personal taste isn't it..

Cheers,
Andy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
