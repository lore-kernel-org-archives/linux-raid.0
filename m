From: =?iso-8859-1?Q?Agust=EDn_Ciciliani?= <agustin@maderonet.net.ar>
Subject: Re: Raid 1 - md "Total Disks" question
Date: Mon, 20 Sep 2004 13:05:03 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <008a01c49f2b$9cb64ea0$6800a8c0@Agus>
References: <019801c499ab$405f20d0$6800a8c0@Agus><16710.16837.832998.503557@cse.unsw.edu.au><1095374065.4196.22.camel@compaq.xsintricity.com> <16718.6808.294471.886458@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: dledford@redhat.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ok, so I will apply the patch. Thank you!

----- Original Message -----=20
=46rom: "Neil Brown" <neilb@cse.unsw.edu.au>
To: "Doug Ledford" <dledford@redhat.com>
Cc: "Agust=EDn Ciciliani" <agustin@maderonet.net.ar>; <linux-raid@vger.=
kernel.org>; "Marcelo
Tosatti" <marcelo.tosatti@cyclades.com>
Sent: Sunday, September 19, 2004 8:47 PM
Subject: Re: Raid 1 - md "Total Disks" question


> On Thursday September 16, dledford@redhat.com wrote:
> > On Mon, 2004-09-13 at 20:56, Neil Brown wrote:
> > > On Monday September 13, agustin@maderonet.net.ar wrote:
> > > > Hi Everybody,
> > > >
> > > > I was wondering if you could take a look to the following and g=
ive some advice...
I just
> > > > have TWO SATA WD800 disks and "mdadm" says I have "three" and o=
ne of
> > > > them has "failed"!!!
> > >
> > > It's just some odd accounting in the kernel.  Don't worry about i=
t.
> >
> > It is just some odd accounting stuff, but it's hardly something I w=
ould
> > say "don't worry about it".  I had to chase a similar looking probl=
em
> > down in our RHEL3 product line.  In fact, it was raid1 where I was
> > seeing this problem.  I've attached the email I sent about the prob=
lem
> > to the internal kernel people, the patch I originally sent in for i=
t,
> > and the update patch that catches a couple spots I originally misse=
d in
> > my first patch (apologies if my mailer horks this up, haven't tried=
 to
> > send sent mail in exactly the way I'm trying it now).
>
> Well, the accounting and the locking are really to separate issues,
> but your patch looks good, thanks.
>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
