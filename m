From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: [PATCH] mdadm: do not read the 'clean' flag from potentially
 non-up-to-date drive
Date: Mon, 9 Apr 2012 12:07:30 +0300
Message-ID: <CAGRgLy6Pzrc9=BbdffToiNsgiO8=dzNiGPOaHn1VGg=yg9+Zrw@mail.gmail.com>
References: <CAGRgLy5=xP3ZJz71j2qYiCFLFFD6uCH0O92p3Ev2s2GnonRc8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5=xP3ZJz71j2qYiCFLFFD6uCH0O92p3Ev2s2GnonRc8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,
any comment on this?

Alex.

On Fri, Apr 6, 2012 at 3:24 PM, Alexander Lyakas <alex.bolshoy@gmail.co=
m> wrote:
> Hi Neil,
>
> I noticed that mdadm may decide that array is dirty, based on the
> non-freshest drive. This happens, e.g., when there is a drive failure
> during initial resync, and then array is stopped and re-assembled. Th=
e
> failed drive still has a valid sb->resync_offset, so if this drive is
> visible during assembly, array will be considered dirty, even though
> the rest of the drives have sb->resync_offset=3D=3DMaxSector.
>
> Do you think array should be considered as dirty in this case? Becaus=
e
> if the failed drive was not visible during assembly, array would have
> been considered clean.
>
> The below patch is only to demonstrate the possible fix. The idea is
> that we decide that array is dirty only according to up-to-date
> drives. Currently the "clean" flag is initialized from the first
> superblock, which might not be the freshest one.
>
> I haven't tested it at all. If you think the direction is reasonable,
> I will test.
>
> Thanks,
> =A0Alex.
>
>
> diff --git a/Assemble.c b/Assemble.c
> index 23695e7..42cbbd5 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -929,7 +929,6 @@ int Assemble(struct supertype *st, char *mddev,
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0st->minor_version =3D 90;
>
> =A0 =A0 =A0 =A0st->ss->getinfo_super(st, content, NULL);
> - =A0 =A0 =A0 clean =3D content->array.state & 1;
>
> =A0 =A0 =A0 =A0/* now we have some devices that might be suitable.
> =A0 =A0 =A0 =A0 * I wonder how many
> @@ -1122,6 +1121,7 @@ int Assemble(struct supertype *st, char *mddev,
> =A0#ifndef MDASSEMBLE
> =A0 =A0 =A0 =A0sysfs_init(content, mdfd, 0);
> =A0#endif
> + =A0 =A0 =A0 clean =3D 1; /* Assume that array is clean, until we se=
e otherwise */
> =A0 =A0 =A0 =A0for (i=3D0; i<bestcnt; i++) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0int j =3D best[i];
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0unsigned int desired_state;
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
