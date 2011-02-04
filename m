From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 21:42:52 +0100
Message-ID: <20110204204251.GB6603@www2.open-std.org>
References: <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com> <20110204090602.GA4017@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110204090602.GA4017@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Jon Nelson <jnelson-linux-raid@jamponi.net>, Mathias =?iso-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Feb 04, 2011 at 10:06:03AM +0100, Keld J=F8rn Simonsen wrote:
> On Fri, Feb 04, 2011 at 02:27:38AM -0600, Stan Hoeppner wrote:
> > Keld J=F8rn Simonsen put forth on 2/4/2011 1:06 AM:
> >=20
> > > It looks like they do define all major basic RAID disk layouts. (=
except
> > > raid10,f2 of cause) . RAID1+0 is a derived format, maybe that is =
out of
> > > scope of the DDF standard.
> >=20
> > "A secondary virtual disk is a VD configured using hybrid RAID leve=
ls like
> > RAID10 or RAID50. Its elements are BVDs."
> >=20
> > So apparently their Disk Data Format specification doesn't include =
hybrid RAID
> > levels.  This makes sense, as the _on disk_ layout of RAID 10 is id=
entical to
> > RAID 1.

I was puzzled here. I think you mean:

"the _on disk_ layout of RAID 10 is identical to RAID 1 and RAID 0"

If that is what you meant, I think we agree on most things here.

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
