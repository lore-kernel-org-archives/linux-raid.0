From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: [PATCH 0/6] raid6check fixes
Date: Tue, 18 Jun 2013 19:16:33 +0200
Message-ID: <20130618171633.GA2272@lazy.lzy>
References: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130618090910.1161109.69430.stgit@fsdevel7.hpc.devnet.itwm.fhg.de>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: neilb@suse.de, piergiorgio.sartor@nexgo.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jun 18, 2013 at 11:09:10AM +0200, Bernd Schubert wrote:
> Here are a few raid6check fixes. This series also includes a patch fo=
r
> Makefile to allow to build with optimizations. I only fixed raid6chec=
k
> to build with -O3, but I don't have time left today to fix mdadm=20
> (e.g. Grow.c:2237:41: error: =E2=80=98info2.data_offset=E2=80=99 may =
be used uninitialized in this function [-Werror=3Duninitialized])
>=20
> I wanted to send the memleak-fixes much earlier, but then
> I had been too busy. This patch is lightly tested, patches
> from today are only build-tested.

Hi Bernd,

cool!!!

Good you're keeping it up!

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
