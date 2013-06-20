From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Thu, 20 Jun 2013 18:16:39 +0200
Message-ID: <20130620161639.GA3033@lazy.lzy>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
 <20130619100803.03fde6d5@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130619100803.03fde6d5@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>, piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 19, 2013 at 10:08:03AM +1000, NeilBrown wrote:
> On Tue, 18 Jun 2013 11:09:10 +0200 Bernd Schubert
> <bernd.schubert@itwm.fraunhofer.de> wrote:
>=20
> > Here are a few raid6check fixes. This series also includes a patch =
for
> > Makefile to allow to build with optimizations. I only fixed raid6ch=
eck
> > to build with -O3, but I don't have time left today to fix mdadm=20
> > (e.g. Grow.c:2237:41: error: =E2=80=98info2.data_offset=E2=80=99 ma=
y be used uninitialized in this function [-Werror=3Duninitialized])
> >=20
>=20
> Thanks for mentioning that.  I've fix that problem.
>=20
> NeilBrown
>=20
>=20
> > I wanted to send the memleak-fixes much earlier, but then
> > I had been too busy. This patch is lightly tested, patches
> > from today are only build-tested.
>=20

Hi Neil,

BTW, what's your plan of including "raid6check"
into a main release of "mdadm" package?

Do you have "deadline" in mind?

Thanks,

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
