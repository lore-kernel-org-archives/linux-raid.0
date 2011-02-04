From: hansbkk@gmail.com
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 21:21:48 +0700
Message-ID: <AANLkTikxybDGW3tOHvoy4tBTo1+OpLAUizno=VMp_exm@mail.gmail.com>
References: <20110131203725.GB2283@www2.open-std.org>
	<AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com>
	<AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com>
	<AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com>
	<4D475AB5.10600@hardwarefreak.com>
	<20110203110428.GA26762@www2.open-std.org>
	<4D4B3DAE.3070502@hardwarefreak.com>
	<20110204070613.GA3788@www2.open-std.org>
	<4D4BB87A.30800@hardwarefreak.com>
	<iigobc$n0n$2@dough.gmane.org>
	<20110204135343.GC4808@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110204135343.GC4808@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@keldix.com>
Cc: David Brown <david@westcontrol.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2011/2/4 Keld J=F8rn Simonsen <keld@keldix.com>:
>
> I wonder why this is so. (I cannot dispute what you are saying, as I =
have
> not got any experience with any small SAN/NAS devices).
>
> Anyway, Linux NAS/SAN devices should run a kernel that should be able=
 to
> run MD raid10 and RAID 1+0 - as this has been in the Linux kernel
> for more than 5 years.
>

95% of such devices sold have only one drive, a few models have 2
bays, with external connections (usually USB, some e-sata now) only
available for in-bound data copying. These are cheap enough that a
decent hacker community has sprung up creating replacement opensource
firmware, but the hardware limitations are severe enough that IMO the
main attraction is a very low power bill for 24/7 convenience.

There are some that offer 4 or 5 bays, but IMO anyone knowledgeable
enough to make use of higher-end options like md raid10 would take one
look at the price tag and bolt for a whitebox+free/opensource solution
instead.

Even whitebox+Windows Home Server (gasp!) would IMO be both cheaper
and better in most cases than getting locked into proprietary hardware
*and* software wrapped up together.

If you want to investigate further, here are the main brands, I
imagine most are running on Linux/mdadm-based firmware:

Thecus, Qnap, Synology, Dlink, Buffalo, NetGear (was Infrant)

IMO Drobo looks like a very interesting kit, not mdadm-based AFAICT
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
