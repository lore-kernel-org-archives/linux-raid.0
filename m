From: jes.sorensen@gmail.com
Subject: Re: [PATCH v1] mdadm: add checking clustered bitmap in assemble mode
Date: Mon, 06 Mar 2017 16:32:17 -0500
Message-ID: <wrfjzigyks66.fsf@gmail.com>
References: <1488425157-24582-1-git-send-email-zlliu@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1488425157-24582-1-git-send-email-zlliu@suse.com> (Zhilong Liu's
        message of "Thu, 2 Mar 2017 11:25:57 +0800")
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Zhilong Liu <zlliu@suse.com> writes:
> Both clustered and internal array don't need to specify
> --bitmap when assembling array.
>
> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>
> diff --git a/mdadm.c b/mdadm.c
> index b5d89e4..4087f77 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1095,8 +1095,10 @@ int main(int argc, char *argv[])
>  				pr_err("bitmap file needed with -b in --assemble mode\n");
>  				exit(2);
>  			}
> -			if (strcmp(optarg, "internal") =3D=3D 0) {
> -				pr_err("there is no need to specify --bitmap when assembling arrays =
with internal bitmaps\n");
> +			if (strcmp(optarg, "internal") =3D=3D 0 ||
> +			    strcmp(optarg, "clustered") =3D=3D 0) {
> +				pr_err("no need to specify --bitmap when assembling
> +					arrays with internal or clustered bitmap\n");
>  				continue;
>  			}
>  			bitmap_fd =3D open(optarg, O_RDWR);

This doesn't build - could you please send me a working patch.

Thanks,
Jes

cc -Wall -Werror -Wstrict-prototypes -Wextra -Wno-unused-parameter -ggdb -D=
Sendmail=3D\""/usr/sbin/sendmail -t"\" -DCONFFILE=3D\"/etc/mdadm.conf\" -DC=
ONFFILE2=3D\"/etc/mdadm/mdadm.conf\" -DMAP_DIR=3D\"/run/mdadm\" -DMAP_FILE=
=3D\"map\" -DMDMON_DIR=3D\"/run/mdadm\" -DFAILED_SLOTS_DIR=3D\"/run/mdadm/f=
ailed-slots\" -DNO_COROSYNC -DNO_DLM -DVERSION=3D\"4.0-6-g8383db9\" -DVERS_=
DATE=3D"\"2017-03-06\"" -DUSE_PTHREADS -DBINDIR=3D\"/sbin\"  -c -o mdadm.o =
mdadm.c
mdadm.c: In function =E2=80=98main=E2=80=99:
mdadm.c:1100:12: error: missing terminating " character [-Werror]
     pr_err("no need to specify --bitmap when assembling
            ^
mdadm.c:1101:48: error: missing terminating " character [-Werror]
      arrays with internal or clustered bitmap\n");

