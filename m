Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972D8212B30
	for <linux-raid@vger.kernel.org>; Wed, 22 Jan 2025 13:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737552421; cv=none; b=kP5/Bg8hq8Z4Xo0sWpOLi7JSkZgvDN8gqnkgX7MqbDPBcrUP/pZ6W484zfUrAKTx2rfM3aR/VLosKKbrt/wiU9YTStRvgOtmr6y6kfYja1sb6lA/JndL/3okbT4BoUKfpX9NFjBvC9D0wy7e5HggYarxHztoc/X62dqPU2/A38M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737552421; c=relaxed/simple;
	bh=gSW4I409GZ2YEXCavzJCSL18FLEBeJCk5LqzFyPL7YY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sZC4Ewoub1CLdwVnnyqi8yUWtEV6W/pB/eOZDifH4SPdzEyh0BQ9qrif/oBGJ8Es3nDJjGKphxvDBO7rc0Pnm/hspe4Z2Rf+x9QbvUh5SsqgF948bonDjJ8ESc8zqczFsfs6C0J75zu4ZPc/ML0n/33L5vHqpN+H98W25Xy+qps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 74A91C4CED6;
	Wed, 22 Jan 2025 13:26:59 +0000 (UTC)
Date: Wed, 22 Jan 2025 14:26:55 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Coly Li <colyli@suse.de>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v2]  mdopen: add sbin path to env PATH when call
 system("modprobe md_mod")
Message-ID: <20250122142655.031435cc@mtkaczyk-private-dev>
In-Reply-To: <9F1A4711-351B-4E58-BC5F-D281AC936A4A@suse.de>
References: <20250122035359.251194-1-colyli@suse.de>
	<20250122130136.04011312@mtkaczyk-private-dev>
	<9F1A4711-351B-4E58-BC5F-D281AC936A4A@suse.de>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Jan 2025 20:43:19 +0800
Coly Li <colyli@suse.de> wrote:

> > 2025=E5=B9=B41=E6=9C=8822=E6=97=A5 20:01=EF=BC=8CMariusz Tkaczyk <mtkac=
zyk@kernel.org> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > Hi Coly,
> > I read that once again and I have more comments. Even if it
> > looks simple, we are calling many env commands in mdadm, that is
> > why I'm trying to be careful.
> >=20
> > On Wed, 22 Jan 2025 11:53:59 +0800
> > Coly Li <colyli@suse.de> wrote:
> >  =20
> >> During the boot process if mdadm is called in udev context, sbin
> >> paths like /sbin, /usr/sbin, /usr/local/sbin normally not defined
> >> in PATH =20
> >=20
> > normally defined? Please remove "not". =20
>=20
> This is correct, normally NOT defined. In boot time udev tasks just
> normally called binaries in their private directory, they don=E2=80=99t c=
all
> system binaries.
>=20

Oh, got you. Thanks!

> >  =20
> >> env variable, calling system("modprobe md_mod") in
> >> create_named_array() may fail with 'sh: modprobe: command not
> >> found' error message.
> >>=20
> >> We don't want to move modprobe binary into udev private directory,
> >> so setting the PATH env is a more proper method to avoid the above
> >> issue. =20
> >=20
> > Curios, did you verified what is happening to our "systemctl" calls?
> >=20
> > mdmon and grow-continue are started this way, they are later
> > followed by "WANTS=3D" in udev rule so the issue there is probably
> > hidden, maybe we should fix these calls too? =20
>=20
> For this specific case, md kernel module was not loaded yet, it was
> in quite early stage from observation of me and bug reporter.
>=20
>=20
> >  =20
> >>=20
> >> This patch sets PATH env variable with
> >> "/sbin:/usr/sbin:/usr/local/sbin" before calling system("modprobe
> >> md_mod"). The change only takes effect within the udev worker
> >> context, not seen by global udev environment. =20
> >=20
> > If we are running app from terminal (i.e mdadm -I, or ./mdadm -I)
> > this change should not affect the terminal environment. I verified
> > it to be sure. Could you please mention that in description?
> >  =20
>=20
> OK, let me do it in next version.
>=20
> >>=20
> >> Signed-off-by: Coly Li <colyli@suse.de>
> >> ---
> >> Changelog,
> >> v2: set buf[PATH_MAX] to 0 in stack variable announcement.
> >> v1: the original version.
> >>=20
> >>=20
> >> mdopen.c | 11 +++++++++++
> >> 1 file changed, 11 insertions(+)
> >>=20
> >> diff --git a/mdopen.c b/mdopen.c
> >> index 26f0c716..65bd8a1b 100644
> >> --- a/mdopen.c
> >> +++ b/mdopen.c
> >> @@ -39,6 +39,17 @@ int create_named_array(char *devnm)
> >>=20
> >> fd =3D open(new_array_file, O_WRONLY);
> >> if (fd < 0 && errno =3D=3D ENOENT) {
> >> + char buf[PATH_MAX] =3D {0};
> >> +
> >> + /*
> >> + * When called by udev worker context, path of
> >> modprobe
> >> + * might not be in env PATH. Set sbin paths into PATH
> >> + * env to avoid potential failure when run modprobe
> >> here.
> >> + */
> >> + snprintf(buf, PATH_MAX - 1, "%s:%s", getenv("PATH"),
> >> + "/sbin:/usr/sbin:/usr/local/sbin"); =20
> >=20
> > We can get NULL returned by getenv("PATH"), should we handle it? We
> > probably rely on compiler behavior here.
> >=20
> > I did simple test. I tried: printf("%s\n", getenv("NOT_EXISTING"));=20
> > I got segmentation fault. =20
>=20
> Yes, this was my fault, I took it for granted that PATH should always
> be set in udev context.
>=20
> You are right, I will add a NULL check in next version.
>=20
> >  =20
> >> + setenv("PATH", buf, 1); =20
> >=20
> > I see here portability issues. We, assume that these binaries must
> > be in locations we added here. We may even double them, if they are
> > already defined.
> > Even if I know that probably no one is enough brave to
> > not have base binaries there, we should not force our PATH. I think
> > it is not our task and responsibility to deal with binaries location
> > issues. We should take what system provided.
> >=20
> > I still think that we should pass locations during compilation. Here
> > example with EXTRAVERSION, of course it may require some adjustments
> > but it is generally the way it can be achieved:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D03ab9=
763f51ddf2030f60f83e76cf9c1b50b726c
> >=20
> > I'm not strong convinced to the option I proposed, I just need
> > argument because more or less code is not an argument. What we will
> > choose today will stay here for years, we need to choose the best
> > possible way we see. =20
>=20
> The installation path might vary, depends on the way how mdadm is
> installed. If from rpm or other installation pack, the dest location
> can be predicted. If mdadm is installed from source code compiling,
> the destination varies depends on the pre-defined installation
> location, similar situation happens in containers.

This is what I wanted to propose:

in makefile:
# If provided respect that, otherwise, search for it
MODPROBE_PATH ?=3D $(which modprobe)

DMODPROBE_PATH =3D $(if $(MODPROBE_PATH),-DMODPROBE_PATH=3D"\" -
$(MODPROBE_PATH)\"",)

+CFLAGS +=3D $(DVERS) $(DDATE) $(DEXTRAVERSION) $(DMODPROBE_PATH)

and finally in code:
if (system(MODPROBE_PATH " md_mod")

with that we would detect location of modprobe during compilation or
rpm building, or allow user to customize it. It assumes that location
of modprobe won't change.

I checked whether it is provided by pkg-config with no success.

>=20
> So the patch is just a best-effort-try, if the binary is not
> installed in /sbin, /usr/sbin or /usr/local/sbin, my patch just gives
> up.
>=20

Maybe we can print error then? It would be useful for programmers
to understand the problem. Sometimes, to debug early stages I simply
redirected all error messages from mdadm to /dev/kmsg.


> >  =20
> >> +
> >> if (system("modprobe md_mod") =3D=3D 0)
> >> fd =3D open(new_array_file, O_WRONLY); =20
> >  =20
> >> } =20
> >=20
> > The change will affect code executed later, probably we don't want
> > that. Shouldn't we restore old PATH here to minimize risk? =20
>=20
> For my understanding if the code was called after boot up, these path
> should be set already by shell initialization scripts. And for udev
> context, it is called and exited, and NOT shared with other udev
> tasks, almost no influence.

I see, it is more theoretical problem, almost to possible to met.
All fine then, we can continue with no clean up here as I cannot find
normal scenario it can occur.

Your change (after getenv fixes) LGTM. You can take a look into concept
I proposed but I have no strong preference.

Thanks,
Mariusz
