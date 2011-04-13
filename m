From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/2] imsm: FIX: Be more patient during loading matadata
Date: Tue, 12 Apr 2011 17:44:31 -0700
Message-ID: <BANLkTinryn7FTdXMHx9HsMSQqpgykWW+Gg@mail.gmail.com>
References: <20110412125116.7062.36275.stgit@gklab-128-013.igk.intel.com>
	<20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110412125128.7062.38008.stgit@gklab-128-013.igk.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Kwolek <adam.kwolek@intel.com>
Cc: neilb@suse.de, linux-raid@vger.kernel.org, ed.ciechanowski@intel.com, wojciech.neubauer@intel.com
List-Id: linux-raid.ids

On Tue, Apr 12, 2011 at 5:51 AM, Adam Kwolek <adam.kwolek@intel.com> wr=
ote:
> Sometimes occurs that metadata cannot be loaded e.g. wrong check sum
> It can happen due to metadata update racing with mdmon condition.
> If mpb loading is tried again, it is loaded successfully.
> Try to load metadata again before really giving up.
>
> Signed-off-by: Adam Kwolek <adam.kwolek@intel.com>
> ---
>
> =A0super-intel.c | =A0 10 ++++++++--
> =A01 files changed, 8 insertions(+), 2 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index dc5e34e..d23267a 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -2773,8 +2773,14 @@ load_and_parse_mpb(int fd, struct intel_super =
*super, char *devname, int keep_fd
> =A0 =A0 =A0 =A0int err;
>
> =A0 =A0 =A0 =A0err =3D load_imsm_mpb(fd, super, devname);
> - =A0 =A0 =A0 if (err)
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* try to load mpb again,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* in case of mdmon race we could hav=
e more luck...
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D load_imsm_mpb(fd, super, devnam=
e);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return err;
> + =A0 =A0 =A0 }
> =A0 =A0 =A0 =A0err =3D load_imsm_disk(fd, super, devname, keep_fd);
> =A0 =A0 =A0 =A0if (err)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return err;

This is semi-duplicates the check we already do after returning from
load_and_parse_mpb in load_super_imsm_all.  I'm curious, are you
hitting this path from load_super_imsm?  If the container is assembled
we should be loading from the container, if the container is not
available then mdmon can't be running and checksum errors are real.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
