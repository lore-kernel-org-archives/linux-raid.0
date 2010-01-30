From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Why does one get mismatches?
Date: Sat, 30 Jan 2010 02:39:10 -0800 (PST)
Message-ID: <446144.76775.qm@web51305.mail.re2.yahoo.com>
References: <87fx5owjsz.fsf@frosties.localdomain>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fx5owjsz.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--- On Fri, 29/1/10, Goswin von Brederlow <goswin-v-b@web.de> wrote:

> From: Goswin von Brederlow <goswin-v-b@web.de>
> Subject: Re: Why does one get mismatches?
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Friday, 29 January, 2010, 23:52
> Jon Hardcastle <jd_hardcastle@yahoo.com>
> writes:
>=20
> > --- On Thu, 28/1/10, Goswin von Brederlow <goswin-v-b@web.de>
> wrote:
> >
> >> From: Goswin von Brederlow <goswin-v-b@web.de>
> >> Subject: Re: Why does one get mismatches?
> >> To: linux-raid@vger.kernel.org
> >> Date: Thursday, 28 January, 2010, 20:24
> >> "Tirumala Reddy Marri" <tmarri@amcc.com>
> >> writes:
> >>=20
> >> > I just tried and miss-match count is zero.
> >> Interesting, is XOR engine
> >> > doing something wrong ? . Then I ran a test
> where I
> >> raw-write the file
> >> > to /dev/md0. Then did the raw-read for the
> same size.
> >> In this case XOR
> >> > matched as expected. Then I failed a drive
> using
> >> "mdadm -f /dev/md0
> >> > /dev/sda". Then I read the same size data
> again from
> >> /dev/md0. And
> >> > checksum matches too.=20
> >> > What is this mean XOR engine is doing right
> thing. But
> >> "chec/repair"
> >> > test is not functioning properly with
> XOR-engine ?
> >> >
> >> > Or is this something to do with=A0 how the
> buffers
> >> are handled ? may they
> >> > are cached ?
> >> >
> >> >
> >> > -Marri
> >>=20
> >> No idea. But if everything works without the XOR
> engine and
> >> gives
> >> mismatches with then I would think there is a
> software or
> >> hardware error
> >> there and not in the cable or disks.
> >>=20
> >> MfG
> >> =A0 =A0 =A0 =A0 Goswin
> >> --
> >> To unsubscribe from this list: send the line
> "unsubscribe
> >> linux-raid" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.ht=
ml
> >>=20
> >
> > i think my RAM is fecked - does that sound like a
> possible cause? memtest86 gives PAGES of red errors when run
> but the POST gives nothing and the machine boots.... it has
> 512MB
> >
> > i have some more on order as a speculative..=20
>=20
> If memtest gives errors you certainly have errors. The
> reverse isn't
> allways true.
>=20
> MfG
> =A0 =A0 =A0 =A0 Goswin
>=20

Might have been a false alarm.. both the new chip and old one in an ass=
ortment of slots give the errors - upgrade from memtest86 3.3 to 3.5 an=
d the errors go away.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
