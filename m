From: CoolCold <coolthecold@gmail.com>
Subject: Re: [PATCH] Use MDMON_DIR for pid files created in Monitor.c
Date: Fri, 24 Feb 2012 00:39:37 +0400
Message-ID: <CAGqmV7o1G86SPn4vM-LuXtKr9-gi=boVMNJzBP93komSLsHEWA@mail.gmail.com>
References: <1328183102-9377-1-git-send-email-Jes.Sorensen@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1328183102-9377-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes.Sorensen@redhat.com
Cc: neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 2, 2012 at 3:45 PM, =A0<Jes.Sorensen@redhat.com> wrote:
> From: Jes Sorensen <Jes.Sorensen@redhat.com>
>
> Other parts of mdadm/mdmon place .pid/.sock files in MDMON_DIR. This
> makes Monitor.c consistent with the rest.
>
> Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
> ---
> =A0Monitor.c | =A0 =A08 +++++---
> =A01 files changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/Monitor.c b/Monitor.c
> index 77f22aa..7ed5282 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -294,8 +294,10 @@ static int check_one_sharer(int scan)
> =A0 =A0 =A0 =A0int pid, rv;
> =A0 =A0 =A0 =A0FILE *fp;
> =A0 =A0 =A0 =A0char dir[20];
> + =A0 =A0 =A0 char path[100];
Just wondering why not something like PATH_MAX or similar constant? I
guess there should be one, though 100 should be enough
> =A0 =A0 =A0 =A0struct stat buf;
> - =A0 =A0 =A0 fp =3D fopen("/var/run/mdadm/autorebuild.pid", "r");
> + =A0 =A0 =A0 sprintf(path, "%s/autorebuild.pid", MDMON_DIR);
> + =A0 =A0 =A0 fp =3D fopen(path, "r");
> =A0 =A0 =A0 =A0if (fp) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (fscanf(fp, "%d", &pid) !=3D 1)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0pid =3D -1;
> @@ -317,12 +319,12 @@ static int check_one_sharer(int scan)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fclose(fp);
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0if (scan) {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mkdir("/var/run/mdadm", S_IRWXU) < =
0 &&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (mkdir(MDMON_DIR, S_IRWXU) < 0 &&
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0errno !=3D EEXIST) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprintf(stderr, Name "=
: Can't create "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"autor=
ebuild.pid file\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0} else {
> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fp =3D fopen("/var/run/=
mdadm/autorebuild.pid", "w");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 fp =3D fopen(path, "w")=
;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (!fp)
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0fprint=
f(stderr, Name ": Cannot create"
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0" autorebuild.pid"
> --
> 1.7.4.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

This is 2nd copy, first was sent from phone and discarded as contained =
HTML.

--
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
