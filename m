From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [[Patch mdadm] 1/5] Make the IMSM_DEVNAME_AS_SERIAL option work
	when creating containers. This allows a person to testing using loopback
	devices that don't support serial number queries.
Date: Mon, 18 Jan 2010 15:13:03 -0700
Message-ID: <e9c3a7c21001181413p60e0322byd97844d3f30a0715@mail.gmail.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>
	 <1263242294-5353-2-git-send-email-dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1263242294-5353-2-git-send-email-dledford@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Doug,

On Mon, Jan 11, 2010 at 1:38 PM, Doug Ledford <dledford@redhat.com> wro=
te:
> Signed-off-by: Doug Ledford <dledford@redhat.com>
> ---
> =A0super-intel.c | =A0 =A05 ++++-
> =A01 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/super-intel.c b/super-intel.c
> index d6951cc..fcf438c 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -3208,7 +3208,10 @@ static int add_to_super_imsm(struct supertype =
*st, mdu_disk_info_t *dk,
> =A0 =A0 =A0 =A0dd->fd =3D fd;
> =A0 =A0 =A0 =A0dd->e =3D NULL;
> =A0 =A0 =A0 =A0rv =3D imsm_read_serial(fd, devname, dd->serial);
> - =A0 =A0 =A0 if (rv) {
> + =A0 =A0 =A0 if (rv && check_env("IMSM_DEVNAME_AS_SERIAL")) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 memset(dd->serial, 0, MAX_RAID_SERIAL_L=
EN);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 fd2devname(fd, (char *) dd->serial);
> + =A0 =A0 =A0 } else if (rv) {

This just duplicates the check already inside imsm_read_serial().
Containers on loopback devices worked before this patch, so I'll send
a revert.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
