From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Why does one get mismatches?
Date: Wed, 20 Jan 2010 06:34:01 -0800 (PST)
Message-ID: <316224.99310.qm@web51305.mail.re2.yahoo.com>
References: <hj73e0$anm$1@ger.gmane.org>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hj73e0$anm$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Brett Russ <bruss@netezza.com>
List-Id: linux-raid.ids


--- On Wed, 20/1/10, Brett Russ <bruss@netezza.com> wrote:

> From: Brett Russ <bruss@netezza.com>
> Subject: Re: Why does one get mismatches?
> To: linux-raid@vger.kernel.org
> Date: Wednesday, 20 January, 2010, 14:19
> On 01/19/2010 05:04 AM, Jon
> Hardcastle wrote:
> > I kicked off a check/repair cycle on my machine after
> i moved the
> > phyiscal ordering of my drives around and I am now on
> my second
> > check/repair cycle and it has kept finding
> mismatches.
> >=20
> > Is it correct that the mismatch value after a repair
> was needed
> > should equal the value present after a check? What if
> it doesn't?
> > What does it mean if another check STILL reveals
> mismatches?
> >=20
> > I had something similar after i reshaped from raid 5
> to 6 i had to
> > run check/repair/check/repair several times before i
> got my 0.
>=20
> I think to diagnose this you'll need to show us the results
> of running 'mdadm -E /dev/[hs]dX#' (i.e. /dev/sda2) for each
> member device in the md device you're trying to assemble
> *before* attempting to start the md device.=A0 This will
> report on the state of that specific member device
> (partition) and will show why a resync/repair would/would
> not be needed.
>=20
> Note that if your md device is not in a read-only mode that
> the member states may be changing underneath you as you run
> the above command. Therefore, you should either stop the
> device then run the commands, or at least have the device in
> a read-only mode first.
>=20
> -BR
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20

I will gather the information you require, but so it is clear it is a a=
 echo 'check' that is kicking off the ultimate mismatch not from boot.

Also, I have never marked the array as read-only whilst i have done it =
historically - I can but never have and this is a data storage array an=
d isn't actually(shouldn't be) in use really whilst i am not there (can=
 that be tested?!) the main OS drive md3 runs and completes without a p=
roblem..

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'

***********
Please note, I am phasing out jd_hardcastle AT yahoo.com and replacing =
it with jon AT eHardcastle.com
***********

-----------------------


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
