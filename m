Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 287D9C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  8 Feb 2022 06:43:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240248AbiBHGnj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 8 Feb 2022 01:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiBHGnh (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 8 Feb 2022 01:43:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17655C0401EF
        for <linux-raid@vger.kernel.org>; Mon,  7 Feb 2022 22:43:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86E3D61584
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 06:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1ADC340EE
        for <linux-raid@vger.kernel.org>; Tue,  8 Feb 2022 06:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644302615;
        bh=wZJ925KAUIP6JYq90oIjNq8pV7b7hYaseDnPHj0lpAU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TVHG9VAzWnIN432zk1/HBMwZNmrO5jZ9M+hd9DGW4209CUt/39MSvarEVI1TEsZ4w
         oO/0b+E24EOMFIc+YPDdUWm5dWEOWLWWNkM78VMeVceomSNdzz+TsN2xkaRasJMMMl
         9zvB1XVtFAfgMQLeeV95YClO1fjIUwXeqkzuhvIcYvhXPhbYOqyaWmnoromDP1qLY0
         7GJ/uU1CnenVlt+q2e0ijrUv+5FB2LC2nzmEUtiumRke5FbaO8G+xOqTPLuKhr1tsb
         gKKyvpG7KicaqahdKGeOE1iGgztBoyY3kL8mg4Rgt3ACVkW8lArRxtZYcdKUvMo+Df
         zb6bAz1HdtBlQ==
Received: by mail-yb1-f176.google.com with SMTP id v186so47218056ybg.1
        for <linux-raid@vger.kernel.org>; Mon, 07 Feb 2022 22:43:34 -0800 (PST)
X-Gm-Message-State: AOAM532Wq7IZRM+pv1/K/86wdt7/friR6BfYDDTL5gsehgRWPar+xIpN
        tHU85XgPBnrK29cZ2ezHddCKP/AV/WwapPl9DG4=
X-Google-Smtp-Source: ABdhPJxCyPmwCAK12TCeY5tZ8FBhb7TYvwG6IT9cMvC31GOY2Is6dJ+4DeQyS9y9u9ys8CjymjTxuFJ/gtRofjOtPsU=
X-Received: by 2002:a81:6502:: with SMTP id z2mr3634421ywb.148.1644302613958;
 Mon, 07 Feb 2022 22:43:33 -0800 (PST)
MIME-Version: 1.0
References: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
In-Reply-To: <20220126114144.370517-1-pmenzel@molgen.mpg.de>
From:   Song Liu <song@kernel.org>
Date:   Mon, 7 Feb 2022 22:43:22 -0800
X-Gmail-Original-Message-ID: <CAPhsuW7N+NYU=pbLCUR0vhY-RuKMO=8pkL-7tE=t4yncCqm7ZA@mail.gmail.com>
Message-ID: <CAPhsuW7N+NYU=pbLCUR0vhY-RuKMO=8pkL-7tE=t4yncCqm7ZA@mail.gmail.com>
Subject: Re: [PATCH 1/3] lib/raid6/test/Makefile: Use `$(pound)` instead of
 `\#` for Make 4.3
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org,
        linux-raid <linux-raid@vger.kernel.org>,
        Matt Brown <matthew.brown.dev@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Paul,

Sorry for the delayed reply.

On Wed, Jan 26, 2022 at 3:42 AM Paul Menzel <pmenzel@molgen.mpg.de> wrote:
>
> Buidling `raid6test` on Ubuntu 21.10 (ppc64le) with GNU Make 4.3 shows th=
e
> errors below:

Please do not use `xxx` in the commit log (and subject).

>
>     $ cd lib/raid6/test/
>     $ make
>     <stdin>:1:1: error: stray =E2=80=98\=E2=80=99 in program
>     <stdin>:1:2: error: stray =E2=80=98#=E2=80=99 in program
>     <stdin>:1:11: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=E2=80=
=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__attribute__=
=E2=80=99 before =E2=80=98<=E2=80=99 token
>     cp -f ../int.uc int.uc
>     awk -f ../unroll.awk -vN=3D1 < int.uc > int1.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int1.o=
 int1.c
>     awk -f ../unroll.awk -vN=3D2 < int.uc > int2.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int2.o=
 int2.c
>     awk -f ../unroll.awk -vN=3D4 < int.uc > int4.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int4.o=
 int4.c
>     awk -f ../unroll.awk -vN=3D8 < int.uc > int8.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int8.o=
 int8.c
>     awk -f ../unroll.awk -vN=3D16 < int.uc > int16.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int16.=
o int16.c
>     awk -f ../unroll.awk -vN=3D32 < int.uc > int32.c
>     gcc -I.. -I ../../../include -g -O2                      -c -o int32.=
o int32.c
>     rm -f raid6.a
>     ar cq raid6.a int1.o int2.o int4.o int8.o int16.o int32.o recov.o alg=
os.o tables.o
>     ranlib raid6.a
>     gcc -I.. -I ../../../include -g -O2                      -o raid6test=
 test.c raid6.a
>     /usr/bin/ld: raid6.a(algos.o):/dev/shm/linux/lib/raid6/test/algos.c:2=
8: multiple definition of `raid6_call'; /scratch/local/ccIJjN8s.o:/dev/shm/=
linux/lib/raid6/test/test.c:22: first defined here
>     collect2: error: ld returned 1 exit status
>     make: *** [Makefile:72: raid6test] Error 1
>
> The errors come from the `HAS_ALTIVEC` test, which fails, and the POWER
> optimized versions are not built. That=E2=80=99s also reason nobody notic=
ed on the
> other architectures.
>
> GNU Make 4.3 does not remove the backslash anymore. From the 4.3 release
> announcment:
>
> > * WARNING: Backward-incompatibility!
> >   Number signs (#) appearing inside a macro reference or function invoc=
ation
> >   no longer introduce comments and should not be escaped with backslash=
es:
> >   thus a call such as:
> >     foo :=3D $(shell echo '#')
> >   is legal.  Previously the number sign needed to be escaped, for examp=
le:
> >     foo :=3D $(shell echo '\#')
> >   Now this latter will resolve to "\#".  If you want to write makefiles
> >   portable to both versions, assign the number sign to a variable:
> >     H :=3D \#
> >     foo :=3D $(shell echo '$H')
> >   This was claimed to be fixed in 3.81, but wasn't, for some reason.
> >   To detect this change search for 'nocomment' in the .FEATURES variabl=
e.
>
> So, do the same as commit 9564a8cf422d (Kbuild: fix # escaping in .cmd
> files for future Make) and commit 929bef467771 (bpf: Use $(pound) instead
> of \# in Makefiles) and define and use a `$(pound)` variable.

Please run ./scripts/checkpatch.pl against the patch files, and fix
errors/warnings
as much as possible.

Thanks,
Song

>
> Reference for the change in make:
> https://git.savannah.gnu.org/cgit/make.git/commit/?id=3Dc6966b323811c37ac=
edff05b57
>
> Cc: Matt Brown <matthew.brown.dev@gmail.com>
> Signed-off-by: Paul Menzel <pmenzel@molgen.mpg.de>
> ---
>  lib/raid6/test/Makefile | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/lib/raid6/test/Makefile b/lib/raid6/test/Makefile
> index a4c7cd74cff5..4fb7700a741b 100644
> --- a/lib/raid6/test/Makefile
> +++ b/lib/raid6/test/Makefile
> @@ -4,6 +4,8 @@
>  # from userspace.
>  #
>
> +pound :=3D \#
> +
>  CC      =3D gcc
>  OPTFLAGS =3D -O2                 # Adjust as desired
>  CFLAGS  =3D -I.. -I ../../../include -g $(OPTFLAGS)
> @@ -42,7 +44,7 @@ else ifeq ($(HAS_NEON),yes)
>          OBJS   +=3D neon.o neon1.o neon2.o neon4.o neon8.o recov_neon.o =
recov_neon_inner.o
>          CFLAGS +=3D -DCONFIG_KERNEL_MODE_NEON=3D1
>  else
> -        HAS_ALTIVEC :=3D $(shell printf '\#include <altivec.h>\nvector i=
nt a;\n' |\
> +        HAS_ALTIVEC :=3D $(shell printf '$(pound)include <altivec.h>\nve=
ctor int a;\n' |\
>                           gcc -c -x c - >/dev/null && rm ./-.o && echo ye=
s)
>          ifeq ($(HAS_ALTIVEC),yes)
>                  CFLAGS +=3D -I../../../arch/powerpc/include
> --
> 2.34.1
>
