From: Andrew Klaassen <clawsoon@yahoo.com>
Subject: Re: RAID10 - Ensure mirrors aren't on same JBOD
Date: Mon, 26 Apr 2010 11:57:09 -0700 (PDT)
Message-ID: <406003.10607.qm@web65416.mail.ac4.yahoo.com>
References: <m2h4877c76c1004261144h1019e9afkf05396996ea77a99@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <m2h4877c76c1004261144h1019e9afkf05396996ea77a99@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com> wrote:

> > --- On Mon, 4/26/10, Michael Evans <mjevans1983@gmail.com>
> wrote:
> > However, it doesn't say what happens with a larger
> > number of drives. =A0I'm looking for the kind of control I
> > can get with RAID 1+0, where I can specify which drives are
> > mirrors of each other. =A0Is that possible with RAID10?
>=20
> No, not predictably; the only provided guarantee is that
> the data will
> /not/ be duplicated on the same block-device (usually
> drive).=A0 In
> practice you will quickly be able to determine where a
> particular
> version with a given range of input causes data to be
> stored, but
> there is no requirement that future versions produce the
> precise same
> alignment and offsets.

Ah.  So if I want this level of control, I have to sacrifice the advant=
ages of RAID 10 and go with RAID 1+0.

Good to know.  Thanks.

Andrew





--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
