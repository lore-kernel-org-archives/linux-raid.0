From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: raid5+hotspare: request for recommended procedure
Date: Wed, 29 Sep 2010 07:29:37 -0700 (PDT)
Message-ID: <285938.34612.qm@web51302.mail.re2.yahoo.com>
References: <4CA34C6E.7050804@xunil.at>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CA34C6E.7050804@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, lists@xunil.at
List-Id: linux-raid.ids

--- On Wed, 29/9/10, Stefan G. Weichinger <lists@xunil.at> wrote:

> From: Stefan G. Weichinger <lists@xunil.at>
> Subject: Re: raid5+hotspare: request for recommended procedure
> To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
> Date: Wednesday, 29 September, 2010, 15:25
> Am 2010-09-29 12:03, schrieb Tim
> Small:
>=20
> > Run smartctl -t long, and see what the LBA of the
> errors are (smartctl
> > -a when finished, and look at the error log) - it may
> be that it is
> > outside of the used space (e.g. right at the end of
> the drive - I've
> > seen this in the past) if this is the case, you can
> just dd over it.
> >=20
> > If the test completes without error then the
> unreadable sector is either
> > not user-addressable, or doesn't really exist, in
> which case I'd ignore
> > it (or perhaps a security-erase will get the drive
> back into a sensible
> > state).=A0 Some of the earlier firmwares for the
> ST3250310NS were a little
> > buggy in my experience, so you might want to look at
> upgrading it
> > (latest Seagate non-OEM firmware is SN06), which can
> be done with hdparm.
>=20
> Yep, it finished without error!
>=20
> Does that mean I could ignore that safely?
>=20
> Or should I rebuild the raids onto the spare-disk and then
> swap drive?
>=20
> S
> --

Personally I would trust nothing less than a dammed good thrashing from=
 badblocks -svw ideally or -svn if the drive has data on it. Then an sm=
art offline check to be sure the pending/reallocated sector counts have=
 no increased.

Before commissioning a new drive a do a badblocks -svw atleast 3 times =
without any counters increasing (something there are bad sectors I just=
 want to flush them out early) then I do some short, long and offline s=
mart tests.

Then I add to the array, then I run check a couple of times.


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
