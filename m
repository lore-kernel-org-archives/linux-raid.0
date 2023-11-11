Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF65FC4332F
	for <linux-raid@archiver.kernel.org>; Sat, 11 Nov 2023 06:25:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbjKKGZ5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 11 Nov 2023 01:25:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229666AbjKKGZz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 11 Nov 2023 01:25:55 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E87D94204
        for <linux-raid@vger.kernel.org>; Fri, 10 Nov 2023 22:25:51 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1cc5916d578so24299125ad.2
        for <linux-raid@vger.kernel.org>; Fri, 10 Nov 2023 22:25:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699683951; x=1700288751; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JvortSlF8Zkk0exah0umkgUGAWp9AYwxr7KNnwY8mtw=;
        b=eK+Q4qQWHOjidcIOOYit9jX8IVqbiISP4sPNOvi9Yp0K1MOGj9qV0CN2GgVpBFK7ae
         NzEN83d31KrcW48+SeAWC/V8TDJf06Es25VMoFjTkKrw9NdKyFywRDoRWcDWfOny20on
         7gKjIsD7KCrzlIXe7YPbxtxrzboc1QJVOSnsfq/PwEplw2UMilbAMtkcecjCbUV0WJ05
         RkNPs1eIblqTnRpD0yZb4LQke5SjS2HzjGzB0Zz4N89JUsvbC41Tc7J1SH7unEBo6El7
         GYfc23ysLq2aX0X06DsPBKcXxAog2JJyegehJXvRumPkLXrwbRMRmaEJvMRoT/kxwlS3
         5peQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699683951; x=1700288751;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JvortSlF8Zkk0exah0umkgUGAWp9AYwxr7KNnwY8mtw=;
        b=JzClI/EOvCP5ASkJ/HsTohtwpleMfN025ACF4wH6DXvFNw4LmZXURpWryxc/JPb2Cg
         w7VSS/GbWx1FxHpKIokOp/LqKq9u0CUA7fjXXv8zydUDGHgywBOtQVtdZvV0LuWe+xYk
         7a3JxqRNUX0WS1BXmAHycChi/wlKtRaMzeafs97RYvG5U9hBoOoRtfMszY5FS1tZAEXD
         95NMRjXORKlljtWyv8fO4W2+dKsdw/BHCHknRb4c/Y+QLUHMYRvAgQr91D/POJOhaCC4
         +ZWbcteX3l2XZLGy/My14gLCQ5179gw37PYVfsG21Dgc9iavDoAgR2ARWoz0lPL9jSoC
         zHGw==
X-Gm-Message-State: AOJu0YyHuP0rRduXBzRL+o+yULYLoN11wle3Wbgh9WwlX6lzCz54b3wL
        k0nfJkEbnBrEwD38fOms5qk=
X-Google-Smtp-Source: AGHT+IETlWxLvbCfSeLxBzphiN3a6/HuVyQ9vymJD5TmFDHd72vUYJnb06TlLdKHP+3iwatqbbKiMw==
X-Received: by 2002:a17:902:a402:b0:1c2:1068:1f4f with SMTP id p2-20020a170902a40200b001c210681f4fmr1301441plq.17.1699683951241;
        Fri, 10 Nov 2023 22:25:51 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id t7-20020a170902bc4700b001c9d968563csm652898plz.79.2023.11.10.22.25.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Nov 2023 22:25:50 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
        id 0731B10205C0D; Sat, 11 Nov 2023 13:25:48 +0700 (WIB)
Date:   Sat, 11 Nov 2023 13:25:48 +0700
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Bhanu Victor DiCara <00bvd0+linux@gmail.com>,
        linux-raid@vger.kernel.org
Cc:     regressions@lists.linux.dev, song@kernel.org,
        jiangguoqing@kylinos.cn, jgq516@gmail.com
Subject: Re: [REGRESSION] Data read from a degraded RAID 4/5/6 array could be
 silently corrupted.
Message-ID: <ZU8ebDX5Tl1L4vMF@archie.me>
References: <5727380.DvuYhMxLoT@bvd0>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="c3Tlr2Wgc3+Qko2f"
Content-Disposition: inline
In-Reply-To: <5727380.DvuYhMxLoT@bvd0>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--c3Tlr2Wgc3+Qko2f
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 11, 2023 at 09:00:00AM +0900, Bhanu Victor DiCara wrote:
> A degraded RAID 4/5/6 array can sometimes read 0s instead of the actual d=
ata.
>=20
>=20
> #regzbot introduced: 10764815ff4728d2c57da677cd5d3dd6f446cf5f
> (The problem does not occur in the previous commit.)
>=20

regzbot dashboard shows that commit cc22b5407e9ca7 ("md: raid0: account
for split bio in iostat accounting") should have fixed your regression.
Can you try that commit?

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--c3Tlr2Wgc3+Qko2f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZU8eYQAKCRD2uYlJVVFO
owiqAP9N9NEPFeiDaW+Tgz5S1BbV+6e1NN9DIBr0+HWugS54PwEAjJ76zqzv2XDq
aNKfgPhe4JnGj7ynuektF645/0saOAs=
=tSVZ
-----END PGP SIGNATURE-----

--c3Tlr2Wgc3+Qko2f--
