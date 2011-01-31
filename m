From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 21:37:25 +0100
Message-ID: <20110131203725.GB2283@www2.open-std.org>
References: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com> <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com> <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com> <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com> <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com> <AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com> <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4D4718E1.9040607@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@keldix.com>, Roberto Spadim <roberto@spadim.com.br>, Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 02:17:37PM -0600, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 1/31/2011 1:28 PM:
> > Top-posting...
> >=20
> > How is the raid0+1 problem of only 33 % survival for 2 disk with RA=
ID10?
> >=20
> > I know for RAID10,F2 the implementation in Linux MD is bad.
> > It is only 33 % survival, while it with a probably minor fix could =
be 66%.
> >=20
> > But how with RAID10,n2 and RAID10,o2?
>=20
> I don't care what Neil or anyone says, these "layouts" are _NOT_ RAID=
 10.  If
> you want to discuss RAID 10, please leave these non-standard Frankens=
tein
> "layouts" out of the discussion.  Including them only muddies things =
unnecessarily.

Please keep terminology clean, and non-ambigeous.
Please refer to the old term RAID10 as RAID1+0, which is also the
original and more precise term for that concept of multilevel RAID.

RAID10 on this list refers to the RAID10 modules of the Linux kernel.

I can concurr that this may be a somewhat misleading term, as it is
easily confused with the popular understanding of RAID10, meaning
RAID1+0. And I see Linux RAID10 as a family of RAID1 layouts.
Indeed RAID10,n2 is almost the same as normal RAID1, and RAID10,o2
is an implementation of a specific layout of the RAID1 standard.
RAID10,f2 could easily also be seen as a specific RAID1 layout.

But that is the naming of terms that we have to deal with on this Linux
kernel list for the RAID modules.

best regards
Keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
