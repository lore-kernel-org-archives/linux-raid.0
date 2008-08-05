From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: [PATCH md] Speed up raid10 resync, especially for 'far' layout
Date: Tue, 5 Aug 2008 15:22:45 +0200
Message-ID: <20080805132245.GA17635@rap.rap.dk>
References: <20080805101429.GA16040@rap.rap.dk> <cccedfc60808050453g69074057y8d858fc7c4d6317b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60808050453g69074057y8d858fc7c4d6317b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 05, 2008 at 06:53:12AM -0500, Jon Nelson wrote:
> On Tue, Aug 5, 2008 at 5:14 AM, Keld J=F8rn Simonsen <keld@dkuug.dk> =
wrote:
> > Speed up raid10 resync, especially for 'far' layout
> >
> > This patch speeds up resync for raid10, especially for the 'far'
> > layout, where reading is done in 32 MiB increments and the moving o=
f
> > heads is therefore much reduced compared to the previous 2 MiB size=
,
> > nd the 'far' property of striping read can be employed.
> >
> > A speed up of more than 50 % has been reported.
>=20
> Actually, the time taken to 'check' the array was reduced by more tha=
n 50%.

Which corresponds to a speed up of more than 100 %.

Did you  have any indications on whether there would still be room for
improvements? What was the speed on the individual disks compared to
their nominal speed?

best regards
keld
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
