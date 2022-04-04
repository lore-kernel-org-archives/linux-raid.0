Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E761C433F5
	for <linux-raid@archiver.kernel.org>; Mon,  4 Apr 2022 12:38:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346648AbiDDMkM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Apr 2022 08:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345285AbiDDMkM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Apr 2022 08:40:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 6A84D27B2B
        for <linux-raid@vger.kernel.org>; Mon,  4 Apr 2022 05:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1649075895;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=juKLOUsIJZ+4brNGn4ICdVclC3eLwMAToH4uvlm5xqE=;
        b=Kx0S6RSbOZ1syhQONJjhH9P/go8kfMu+n6SDEyVRzWlG5255DyGOGosm0oPunC+9ebrn4d
        cx+J0F6PgrEVnPYW/BXtktELrfnRwtyisfwJ43LH+COWqErGBIVCpKkam2Kq+XvMQtAPUk
        rcpSM+MP2DTSqkJ4+hcWH0YwtmnJf1w=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-338-RRgV-R6EMHuEymdBQ_ZOJA-1; Mon, 04 Apr 2022 08:38:14 -0400
X-MC-Unique: RRgV-R6EMHuEymdBQ_ZOJA-1
Received: by mail-qt1-f199.google.com with SMTP id h11-20020ac87d4b000000b002e1c9a3ae51so6248006qtb.0
        for <linux-raid@vger.kernel.org>; Mon, 04 Apr 2022 05:38:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version;
        bh=juKLOUsIJZ+4brNGn4ICdVclC3eLwMAToH4uvlm5xqE=;
        b=W21P0lOp1RyeDD48jlWKlIanCIQC6QD4fGb3va2e5LpA/1xt5ndNVmrP/H+Mxqi2x5
         ffyIBra6Hdw0RqOWNZuuhnFqFl4Kv/zh6qhkKrTlIWwt73xc+mKZRDClI+YM+fKaGC9N
         /38pc/75cF0tEA80VjsYW6kjTarhJIoPXK+M36bdjDYwFOtAi75O86LGEQoBm+m2FvG6
         w83yjN9/VBB/Orzx2TTEZa5/0klpQDxisusedfJWr+lLqZLVUVSteNs6tc9Ays8UyYVZ
         v5fZXdHzCTYrUJxH7HpTTeyyBDiVoJflboAdv0oc511fLLqJnUD1iYCF0c6cdKrMr/D+
         UP+w==
X-Gm-Message-State: AOAM530a7Chhuw1LLzo62AihIO3izRlI3Awi8cs+3SQoyKUm7NMsDpGN
        /a38Q4692WBXIJtS0Xte4HucxdukUsN6w407scHgbhRT7s/BrjvQjddiiRU7DR/TTNWCFPxiMqz
        g0x2GXk54ZBYoW39o8Fq54Q==
X-Received: by 2002:a05:6214:c26:b0:441:6696:c806 with SMTP id a6-20020a0562140c2600b004416696c806mr17325767qvd.43.1649075893880;
        Mon, 04 Apr 2022 05:38:13 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwZAZ0UNf2epIpUz209RBdzGLS9pzacwDKMfZwCO/Uza4lC7QEdbe7pS5+ROjh/hyxJrceAAg==
X-Received: by 2002:a05:6214:c26:b0:441:6696:c806 with SMTP id a6-20020a0562140c2600b004416696c806mr17325749qvd.43.1649075893610;
        Mon, 04 Apr 2022 05:38:13 -0700 (PDT)
Received: from linux-ws.nc.xsintricity.com (104-15-26-233.lightspeed.rlghnc.sbcglobal.net. [104.15.26.233])
        by smtp.gmail.com with ESMTPSA id a14-20020a05620a066e00b0067d36cc5b12sm5978386qkh.87.2022.04.04.05.38.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 05:38:12 -0700 (PDT)
Message-ID: <53bc131b71b7f94210e507eed93390b1b3899246.camel@redhat.com>
Subject: Re: [PATCH] Add RAID 1 chunksize test
From:   Doug Ledford <dledford@redhat.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>,
        linux-raid@vger.kernel.org
Cc:     jes@trained-monkey.org, colyli@suse.de
Date:   Mon, 04 Apr 2022 08:38:09 -0400
In-Reply-To: <20220404070830.7795-1-mateusz.kusiak@intel.com>
References: <20220404070830.7795-1-mateusz.kusiak@intel.com>
Organization: Red Hat, Inc.
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-eMeeyUCkEC910YScJX6p"
User-Agent: Evolution 3.40.4 (3.40.4-3.fc34) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


--=-eMeeyUCkEC910YScJX6p
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2022-04-04 at 09:08 +0200, Mateusz Kusiak wrote:
> Specifying chunksize for raid 1 is forbidden.
> Add test for blocking raid 1 creation with chunksize.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> =C2=A0tests/01r1create-chunk | 15 +++++++++++++++
> =C2=A01 file changed, 15 insertions(+)
> =C2=A0create mode 100644 tests/01r1create-chunk
>=20
> diff --git a/tests/01r1create-chunk b/tests/01r1create-chunk
> new file mode 100644
> index 00000000..717a5e5a
> --- /dev/null
> +++ b/tests/01r1create-chunk
> @@ -0,0 +1,15 @@
> +# RAID 1 volume, 2 disks, chunk 64
> +# NEGATIVE test - creating raid 1 with chunksize specified is
> forbidden
> +
> +num_disks=3D2
> +level=3D1
> +device_list=3D"$dev0 $dev1"
> +chunk=3D64
> +
> +# Create raid 1 with chunk 64k and fail
> +if ! mdadm --create --run $md0 --auto=3Dmd --level=3D$level --
> chunk=3D$chunk --raid-disks=3D$num_disks $device_list
> +then
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0exit 0
> +fi
> +
> +exit 1

This is a case of overkill IMO.  Chunk size with raid1 isn't really a
problem and shouldn't result in mdadm refusing to work.  Chunk size with
raid1 simply has no effect and should just be ignored with at most a
warning by mdadm.

--=20
Doug Ledford <dledford@redhat.com>
=C2=A0=C2=A0=C2=A0=C2=A0GPG KeyID: B826A3330E572FDD
=C2=A0=C2=A0=C2=A0=C2=A0Fingerprint =3D AE6B 1BDA 122B 23B4 265B=C2=A0=C2=
=A01274 B826 A333 0E57 2FDD

--=-eMeeyUCkEC910YScJX6p
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAmJK5rIACgkQuCajMw5X
L92KKw//XdPB8a6AJJ6ThLW/j/yVTUcWALsqzBA54JNUxVRrzMfysXZ2g6kuhKnp
J5sWFzZnKEuULu2Et1P/iko1+I5QdXhjkVwN2+9Ppct77t5Ko9obgjw0Pytq9gjN
GNKOg+v/uZQMDH282zrXN/Y+HhVi0VOr5ZkEj2lnfjJUHqlogiQ8n7jECMl+908x
aBGOYIn2T13iPMP9Pi/80E9sNydnARk+6FcQ7Mzgk5TWh+gQYTUFnOAxEr33ICZh
tHJtf1EJzrB14KDPz6oE+bkIAQi1lMtBtacCYOrzToyfMm+ur/ER/Jr0JwUza1z7
KWX0Hfh31Kqo/tZ+8ivzS3DSk5l1U+ewviGsfVnx865DgF5m/u4ufwwkczHo+lEF
d68ST/ba09iVZ6AvjtlioF7PvzZf2gyWG0SNnWjQXRCAsCfR0yjhg8fdbTNKKRnZ
dTGaKgDTZX/bb5XkgOJX2QJvspSNDwe2pclxFwG3Z6H0NxtAtBAowLg1/lI+LgFM
XcmvAwDfQQcZ3aIwA3tFCWOr8t7V8WOe6IGWyGbbv4A/4nrR+Rd38eYoztzheaBx
qLHSr2DSOU3VZX7gTX2WyJxNKpGnScdHjeEQstvhGyKfwcu/mmDKjEFxZ09v2DPX
D9GRV300L17o4ANb0t6G2kB1Lq8yh3oHOPrGmGzA96Fyx5ea1Jw=
=vWwP
-----END PGP SIGNATURE-----

--=-eMeeyUCkEC910YScJX6p--

