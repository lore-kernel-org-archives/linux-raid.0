From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Fw: Why does one get mismatches?
Date: Sun, 24 Jan 2010 09:40:42 -0800 (PST)
Message-ID: <65698.36235.qm@web51306.mail.re2.yahoo.com>
References: <877hra57pf.fsf@frosties.localdomain>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <877hra57pf.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com, Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Fri, 22/1/10, Goswin von Brederlow <goswin-v-b@web.de> wrote:

> From: Goswin von Brederlow <goswin-v-b@web.de>
> Subject: Re: Fw: Why does one get mismatches?
> To: Jon@eHardcastle.com
> Cc: linux-raid@vger.kernel.org
> Date: Friday, 22 January, 2010, 18:13
> Jon Hardcastle <jd_hardcastle@yahoo.com>
> writes:
>=20
> > --- On Tue, 19/1/10, Jon Hardcastle <jd_hardcastle@yahoo.com>
> wrote:
> >
> >> From: Jon Hardcastle <jd_hardcastle@yahoo.com>
> >> Subject: Why does one get mismatches?
> >> To: linux-raid@vger.kernel.org
> >> Date: Tuesday, 19 January, 2010, 10:04
> >> Hi,
> >>=20
> >> I kicked off a check/repair cycle on my machine
> after i
> >> moved the phyiscal ordering of my drives around
> and I am now
> >> on my second check/repair cycle and it has kept
> finding
> >> mismatches.
> >>=20
> >> Is it correct that the mismatch value after a
> repair was
> >> needed should equal the value present after a
> check? What if
> >> it doesn't? What does it mean if another check
> STILL reveals
> >> mismatches?
> >>=20
> >> I had something similar after i reshaped from raid
> 5 to 6 i
> >> had to run check/repair/check/repair several times
> before i
> >> got my 0.
> >>=20
> >>=20
> >
> > Guys,
> >
> > Anyone got any suggestions here? I am now on my ~5
> check/repair and after a reboot the first check is still
> returning 8.
> >
> > All i have done is move the drives around. It is the
> same controllers/cables/etc=20
> >
> > I really dont like the seeming random nature of what
> can/does/has caused the mismatches?
>=20
> There is some unknown corruption going on with raid1 that
> causes
> mismatches but it is believed that it will never occur on
> any used
> block. Swapping is a likely cause.
>=20
> Any swap device on the raid? Try turning that off.
> If that doesn't help try umounting filesystems or
> remounting RO.
>=20
> MfG
> =A0 =A0 =A0 =A0 Goswin

Hello, my usual savior Goswin!

The deal is it is a 7 drive raid 6 array. it has LVM on it and is not u=
sed for swapping. I have umounted all LV's and still got mismatches, i =
run smartctl --test=3Dlong on all drives - nothing. I have now dismantl=
ed the array and am 3/4 the way through 'badblocks -svn' on each of the=
 component drive. I have a hunch that it may be a dodgy SATA cable but =
have no evidence. No errors in log, nothing on dmesg.

Is there any way to get more information? I am starting to think this i=
s more happened since i changed from raid 5 to 6..... which i did < 1 m=
onth ago.

The only lead i have is that whilst doing the bad blocks 1 drive ran at=
 ~10~15MB/s whereas the rest are going at ~30 i have another identical =
model drive coming up so i will see if that one is slow too. But the la=
ck of logging info is not helpful and worrying! and the prospect of sil=
ent corruption a big worry!


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
