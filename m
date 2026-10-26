Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793025956;
	b=lAi7RTgCfySHzkYEGsw+/uzq4WxFZHHtYHToJNwjs/S9GNDsEa2Abfe4SNiFXg/mF9jl
	 mLh0udB7d3oBeKpIHY7hXH6z+2Qzam0XJP1ccJYfjT4tTFbJ3WfDxba8O90ST56a/f1+J
	 UpWGLSrWuCJqul4wbgu8qYOnRqVcj0G95990NsmtTToQXRjbLzj1O2a+0sozL080zVNL+
	 XpVho7DYVORgENFzIOAqhwRuG7hkVoN3SJDFxG2FSoyqYxAhZviK5YZ2tdqA+Joft8v+I
	 PHUEMqAZS/4vDKazmOxaEdR/rvAOLSjCbte3/SjTVkDhyxlH+A5LyO8iaUmEu8OAtpw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793025956;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:MIME-Version:References:In-Reply-To:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type:
	 Content-Transfer-Encoding;
	bh=Xl5/intmUiXAE8+mmqtuYRR1ZbCkeJBNVCGX7MeNWxE=;
	b=MEAOBiXsCOEXEjxSvpQMFi4hBgFZiyKNoT0NXhkiAnrO+LJzR393WYNRScADQnnc3Pga
	 zGoveWpiLYxHtdMTFtIlgdh+vgdqMJovSu6D/dXHjT7Qq3BhKx8soueRVcv47CCL2TmJ2
	 02brf3gGk3ad+cuLtZ1ut4N0EATCbxGdTvtfFiYJn6Spjf8LwSSlEYSJ3jtlevsjH5MHs
	 j0079qYpeaYZfkOBF6mmJPlDheAydrTKzAp8ZJQXboHjIeK9QD+BK84TKU2Ebjh96OvAF
	 ukJr0AuN1g5/FiWKFU3/2gCEEyI4W4Pk6Lj+eMg7e/MH+p915XFBmkH/saCDVO7THnw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Jf69yF2C;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=KuY4zS5u;
	arc=pass header.oldest-pass=0 smtp.remote-ip=170.10.133.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77E21606A31A
	for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 14:45:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77E21606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=Jf69yF2C;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=KuY4zS5u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793025954;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xl5/intmUiXAE8+mmqtuYRR1ZbCkeJBNVCGX7MeNWxE=;
	b=Jf69yF2CuldRznxpH3B6o6xs6janSzAP0dyork7klELDLtsVlTj3gyCtaArhoETX9ZED/8
	xUSpSWo8FJa+nlUpUQkHSVPOBZ0pQpOUdy+Nr3/MeQvFu5O1fEJvVMz62n3+C9xjJZ2Rhw
	+B+9aFpdTtsv7O5aJneOBeW6MjgSOMc=
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com
 [74.125.82.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-198-fNZK4GwgNk2f22_vKCa-4w-1; Mon, 26 Oct 2026 10:45:53 -0400
X-MC-Unique: fNZK4GwgNk2f22_vKCa-4w-1
X-Mimecast-MFC-AGG-ID: fNZK4GwgNk2f22_vKCa-4w_1793025952
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-341eff9e381so9005091eec.1
        for <linux-raid@vger.kernel.org>; Mon, 26 Oct 2026 07:45:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793025952; cv=none;
        d=google.com; s=arc-20260327;
        b=bOqdw7A1ymXlrJZmuIeCWfgQsSz/6GZ/kWqmeg/XWcgdU07uLII6212EQdKYh/AQ/a
         Eu8OYhmTi+NZtcXiSWFRPBCb9DtnxGJWtYVdAhRfz8gp07oXnadxo8Bqg+JzJjxovAeu
         UeSxdQWO1zUUB8jcsOzNTZFfNNX0jR6pE9KR/gIoOZNFwpdZ05241qTtXQSebKvM4oxB
         Dk7ZDHaCdk+mnrUfUL2SxW1K6Qb/fdRI2ij86JkEZwKInhj+RL6OD25Q9NRyDy0vTs8W
         VrqCTArvfo62IbxvPsn+iQvIrJjx8Zci2sUWdVolHKg54LEEaoo18KTFpKgHZ34Kshql
         iBBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Xl5/intmUiXAE8+mmqtuYRR1ZbCkeJBNVCGX7MeNWxE=;
        fh=DR8Y1d9vQRlceI+RK2xtE5hQpHK3qLBZWFF/HLiko8k=;
        b=b67oq4X/qGyqtyHfzs4nwcVJyX4oPIPDWa33/iGGa5ZC80utpA2dYyGnCmzpTAc6Yo
         k0BoUXp44j5pYj1d1Nb5Xp7mbLMRUhZEmUVg1clddt5kra+XjtajnUVmroYH6hzsHbKp
         H19qZ5/AT+shVDfTiDcnODwKgmC0Z7ecNpr6vPN3byMpa3H/f+IwWH51h5ReYx1Kluk7
         cUu8F6g3m3A939Uifk8rWo9RyARNfyWTuVkNH/lxmf0e8MDWPeX71nAWx6g4z0VO/J2T
         f8+/1MyP3/WvEPyRZ1sHpqmc+JPwkq8W9v0MHFhszvs/dVzmKIZucTclXaR/p1Y4k1hd
         ZHNw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793025952; x=1793630752; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Xl5/intmUiXAE8+mmqtuYRR1ZbCkeJBNVCGX7MeNWxE=;
        b=KuY4zS5ux37JecH9R5jfr+a2fY4KwSAI3CplLD2R+R73gIXWIGLEhvMxmsCq3Y9wIO
         ZsUiyjIPSlgKOwaHEYlLNrWuSgYtSgQ80tuvc2g+2Ywyd9/HINGoFYA+zNQwpNNwML91
         qH86lzoXwPywp/AMaV+uas6DfIw39oDY0Ihycg9iKdcsM36ZFj929dr1QOg0z4pdnifh
         Ip5MOj4wNBGT860tthD6gXd8/ENmuNiBdp6VrCFPUUlyPnCC9NctuzKCziNWU69CqkN0
         Of94oLc92i+/N5mvhwdYT4F47y9aqw/fbEWZTOd/U5aGsUhHg/Qiy8321hQtSavMP5X8
         mEdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793025952; x=1793630752;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Xl5/intmUiXAE8+mmqtuYRR1ZbCkeJBNVCGX7MeNWxE=;
        b=Dk1rGx2F/FKMMuzi40h/7RlyXRXncvn7aPF6sbMZf8sRfFjBUshsPgbIKeGRJwcf8L
         vUHDRNAUa8Q3bWV7/avjNdNAI2xk4S/1oUWSfnujLIne5MPkTFxXY9GbBE3hauaiKWpD
         yeoIPXvC8DZZ6xGZtXPFuSBiv88W+a2wnt+rt6khv2MRHvbeBkl+fvWqBMnJ0FwA8MHA
         iH6B5yib40mRCQLoL9kFp9lo5Xilnl1Uu2MiCEUkWITsl8qiBWLT7EqLfRWF0t/LK0e/
         bCNaKvLjigP2+Z/bTBtMijzouHnd1XtIV37NQ2G87VSS3WcEjGiwKt4RkSr+pDZBS6/f
         Mg7w==
X-Forwarded-Encrypted: i=1; AKwUvBzSap95MHzd8pgUZi3bbhAKCKHAEEeo86AMZ54AxSQ6WwXdpfrbE84S4iwmdsjReQ3aK5CPMgl444FR@vger.kernel.org
X-Gm-Message-State: AFq9FYJIQAzZkXFmlHOxgesiNbbkoE/DKIb0v22/opCFmlHPcFFp2H6s
	+07H1Pq3ZRchugi9GBTKCCdbVSaJdsC5EEPl39VQlNlPsl9xDzT5U84EFl/IStseA5agFZaMK8n
	8CoeKllT/S4ND3I86Yu87jjkPYe3oneWXGqpTlX3O3wJQTfmtBY5+XdfhXjNAEXaQ/78wQTWWa9
	DYGFrCH0zvpkYlCjscG1SMjwZVoxeOa7cP9mK0BA==
X-Gm-Gg: AYBFou0N7OChJGT1VWBIKdq6JYcui8rqSbqVTsbsm3iMd3bDeIyIsX+mt3tlcTgh+cq
	8J213I/kaPm8W2lzSgRMJnvNSv2b9TzOEC/6gY3/ixgMWVI4iz4O2JowwdVezWE2GbP4Eb/34Un
	8IjPkmAs3LFg7Mjn0z/SI3DDDBatXh9jDeO+oav0aLdZ5B9hRI8jzmVLQ=
X-Received: by 2002:a05:7301:6194:10b0:35e:5f8f:9665 with SMTP id 5a478bee46e88-369e850755bmr10994313eec.29.1793025950890;
        Mon, 26 Oct 2026 07:45:50 -0700 (PDT)
X-Received: by 2002:a05:7301:6194:10b0:35e:5f8f:9665 with SMTP id
 5a478bee46e88-369e850755bmr10994256eec.29.1793025949831; Mon, 26 Oct 2026
 07:45:49 -0700 (PDT)
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
 <20261019010827.2922617-2-wozizhi@huaweicloud.com> <CAOjDE+C8KFcTsaWjMfmcWcQOwv8qetm-QKvYts+cUGFzgUB8uA@mail.gmail.com>
 <f4ff3d74-c6ca-49d2-aeb5-fdf6c6276e98@huaweicloud.com>
In-Reply-To: <f4ff3d74-c6ca-49d2-aeb5-fdf6c6276e98@huaweicloud.com>
From: Bruce Johnston <bjohnsto@redhat.com>
Date: Mon, 26 Oct 2026 10:45:38 -0400
X-Gm-Features: AclHuK8Vc9jcw6lsqbbSxyc8IkB-eoOZDWys1hpJKEFvQhgsBlFP6ro9Irzdft4
Message-ID: <CAOjDE+CNXzZ86tyq4u6Yw_oFxLK96A7U86pigtY2NWC7MHi9ew@mail.gmail.com>
Subject: Re: [PATCH V2 1/6] md/raid0: don't leave mddev in an inconsistent
 state when takeover fails
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com, 
	xiao@kernel.org, linux-raid@vger.kernel.org, yangerkun@huawei.com, 
	chengzhihao1@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I've been trying to devise a solid takeover fix for a while now
but I have been distracted lately. I'm glad others are
looking into this issue as well.

My hope is/was to create a new mddev and pass it around to
pers->takeover and pers->run, so that if things failed we could
just discard the new mddev and the old mddev would still be
there and untouched. I'm still trying to get the code right.

If I were doing this myself and only concerned with fixing the
pers->takeover function, I would likely put any new
backup/restore fields in the personality configuration struct.
r0conf, r10conf, etc. Some of them already store temporary
values from mddev, like dev_sectors in r10conf. Some of
them even have arrays of md_rdevs like r0conf. The conf
could be passed around to other functions as needed,
like create_stripe_zones.

1. Create copies in the conf structs for the things you plan to
change in mddev. This is raid level specific.
2. Allocate the conf as the very first thing you do in the
pers->takeover functions. fail if allocate fails.
3. Change the values in the conf. Do whatever code
validation code and value changes you do now, but on the
conf struct. On any failure, you just fail. mddev is not
affected.
4. At very end of pers->takeover when you know everything
is ok, you copy the appropriate conf fields over to the mddev.
counterparts.

Fixing the failure cases in pers->takeover is a great step but
even if we get this right, it doesn't solve the entire takeover
issue. The trouble is that later on in level_store we call
pers->run. This function can also fail. If it does, you need
to clean up all the things that got modified in run before
the failure AND also all the changes that happened above
the pers->run function call in level_store, including the
pers->takeover function call. So even if takeover succeeds
and we get to step 4 above, we now have to restore all
those changes if pers->run fails.

I realize all this "extra" stuff is outside the scope of what you
are trying to do but I wanted to give you some context on
what I see is the the overall issue with level_store and
takeover in general.

Bruce

On Sun, Oct 25, 2026 at 11:05=E2=80=AFPM Zizhi Wo <wozizhi@huaweicloud.com>=
 wrote:
>
>
>
> =E5=9C=A8 2026/10/23 21:29, Bruce Johnston =E5=86=99=E9=81=93:
> > On Sun, Oct 18, 2026 at 9:16=E2=80=AFPM Zizhi Wo <wozizhi@huaweicloud.c=
om> wrote:
> >>
> >> From: Zizhi Wo <wozizhi@huawei.com>
> >>
> >> raid0_takeover_raid45(), raid0_takeover_raid10() and raid0_takeover_ra=
id1()
> >> update mddev before create_strip_zones(), which can fail.
> >>
> >> On failure, level_store() only rolls back new_level, new_layout,
> >> new_chunk_sectors, raid_disks and delta_disks. The old personality is
> >> therefore left with a reset resync_offset, cleared feature flags, and,=
 for
> >> raid1, the wrong chunk size.
> >>
> >> Set only what create_strip_zones() needs before calling it, and move t=
he
> >> rest after it succeeds.
> >>
> >> create_strip_zones() also rounds rdev->sectors, but the old levels do =
not
> >> use it for I/O, so that is harmless. And mddev->degraded is already re=
set
> >> by level_store() on success, so drop the redundant assignment in
> >> raid0_takeover_raid10().
> >>
> >
> > The rounding of sectors is not too much of a concern of mine. I'm more =
concerned
> > about rdev->sectors getting set to mddev->dev_sectors in the
> > raid0_takeover_raid45.
> > While I think I understand why it is done and I agree rdev->sectors
> > isn't used by the 4/5 raid
> > level I/O, I'm pretty sure the field is still used in sysfs fields and
> > things like mdstat. On
> > a takeover failure, I feel like we are losing what the old
> > rdev->sectors value was when
> > we go back to raid 4/5 (rdev->sectors and mddev->dev_sectors can be
> > different values)
> >
> > Do you have any thoughts on this? I know it would be a pain to backup
> > / restore every
> > rdev.
>
> Thanks for the review.
>
> If I understand you correctly: since rdev->sectors is exposed to
> userspace via sysfs (and similar interfaces), it's better to keep it
> consistent across a failed takeover, i.e. restore the original value on
> the error path.
>
> Looking at the takeover flow, there are two places that modify
> rdev->sectors:
>
> 1. In create_strile_zones(), here the value is adjusted by at most
> *chunk_sectors - 1*, so the discrepancy is small?
>
> 2. In raid0_takeover_raid45(), where it gets overwritten by
> mddev->dev_sectors =E2=80=94 here the difference can be much larger.
>
> In principle both would leave a stale value behind on failure. My
> understanding is that you consider the first one "not too much of a
> concern" because the delta is tiny, while the second is the one that
> really matters. Is that correct?
>
> However, if the user has dynamically changed chunk_sectors to a large
> value at runtime, and the corresponding rdev->sectors was originally
> small, then the difference presented to the user could actually be quite
> significant. RAID0 doesn't allow modifying chunk_sectors at runtime, but
> RAID4/5/etc. do. Is this something we need to be concerned about?
>
> I currently see two possible approaches:
>
> 1. In raid0_takeover_raid45(), allocate a temporary array up front to
> save the old values, and restore them on failure =E2=80=94 a targeted fix=
 for
> just the raid45 case.
>
> 2. In create_strip_zones(), allocate a temporary array up front to save
> the old values; then remove the rdev->sectors assignment from
> raid0_takeover_raid45() and consolidate all the assignment logic into
> create_strip_zones() (which already assigns this field anyway), choosing
> between rdev->sectors and mddev->dev_sectors based on the level. The
> error path would then restore the saved values, fixing both places at
> once.
>
> Do you have a preference between these two, or is there a simpler
> approach you'd suggest?
>
> Thanks,
> Zizhi Wo
>
> >
> >> Fixes: 9af204cf720c ("md: Add support for Raid5->Raid0 and Raid10->Rai=
d0 takeover")
> >> Fixes: fc3a08b85b7a ("Add raid1->raid0 takeover support")
> >> Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
> >> ---
> >>   drivers/md/raid0.c | 36 +++++++++++++++++++++++-------------
> >>   1 file changed, 23 insertions(+), 13 deletions(-)
> >>
> >> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> >> index 35e103f0c2c3..8157e1058a24 100644
> >> --- a/drivers/md/raid0.c
> >> +++ b/drivers/md/raid0.c
> >> @@ -669,15 +669,16 @@ static void *raid0_takeover_raid45(struct mddev =
*mddev)
> >>          mddev->new_level =3D 0;
> >>          mddev->new_layout =3D 0;
> >>          mddev->new_chunk_sectors =3D mddev->chunk_sectors;
> >>          mddev->raid_disks--;
> >>          mddev->delta_disks =3D -1;
> >> -       /* make sure it will be not marked as dirty */
> >> -       mddev->resync_offset =3D MaxSector;
> >> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
> >>
> >> -       create_strip_zones(mddev, &priv_conf);
> >> +       if (!create_strip_zones(mddev, &priv_conf)) {
> >> +               /* make sure it will be not marked as dirty */
> >> +               mddev->resync_offset =3D MaxSector;
> >> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV=
_FLAGS);
> >> +       }
> >>
> >>          return priv_conf;
> >>   }
> >>
> >>   static void *raid0_takeover_raid10(struct mddev *mddev)
> >> @@ -711,23 +712,25 @@ static void *raid0_takeover_raid10(struct mddev =
*mddev)
> >>          mddev->new_level =3D 0;
> >>          mddev->new_layout =3D 0;
> >>          mddev->new_chunk_sectors =3D mddev->chunk_sectors;
> >>          mddev->delta_disks =3D - mddev->raid_disks / 2;
> >>          mddev->raid_disks +=3D mddev->delta_disks;
> >> -       mddev->degraded =3D 0;
> >> -       /* make sure it will be not marked as dirty */
> >> -       mddev->resync_offset =3D MaxSector;
> >> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
> >>
> >> -       create_strip_zones(mddev, &priv_conf);
> >> +       if (!create_strip_zones(mddev, &priv_conf)) {
> >> +               /* make sure it will be not marked as dirty */
> >> +               mddev->resync_offset =3D MaxSector;
> >> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV=
_FLAGS);
> >> +       }
> >> +
> >>          return priv_conf;
> >>   }
> >>
> >>   static void *raid0_takeover_raid1(struct mddev *mddev)
> >>   {
> >>          struct r0conf *priv_conf;
> >>          int chunksect;
> >> +       int old_chunk_sectors;
> >>
> >>          /* Check layout:
> >>           *  - (N - 1) mirror drives must be already faulty
> >>           */
> >>          if ((mddev->raid_disks - 1) !=3D mddev->degraded) {
> >> @@ -748,22 +751,29 @@ static void *raid0_takeover_raid1(struct mddev *=
mddev)
> >>
> >>          if ((chunksect << 9) < PAGE_SIZE)
> >>                  /* array size does not allow a suitable chunk size */
> >>                  return ERR_PTR(-EINVAL);
> >>
> >> +       /* Save for rollback if create_strip_zones() fails */
> >> +       old_chunk_sectors =3D mddev->chunk_sectors;
> >> +
> >>          /* Set new parameters */
> >>          mddev->new_level =3D 0;
> >>          mddev->new_layout =3D 0;
> >>          mddev->new_chunk_sectors =3D chunksect;
> >>          mddev->chunk_sectors =3D chunksect;
> >>          mddev->delta_disks =3D 1 - mddev->raid_disks;
> >>          mddev->raid_disks =3D 1;
> >> -       /* make sure it will be not marked as dirty */
> >> -       mddev->resync_offset =3D MaxSector;
> >> -       mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV_FLAGS);
> >>
> >> -       create_strip_zones(mddev, &priv_conf);
> >> +       if (!create_strip_zones(mddev, &priv_conf)) {
> >> +               /* make sure it will be not marked as dirty */
> >> +               mddev->resync_offset =3D MaxSector;
> >> +               mddev_clear_unsupported_flags(mddev, UNSUPPORTED_MDDEV=
_FLAGS);
> >> +       } else {
> >> +               mddev->chunk_sectors =3D old_chunk_sectors;
> >> +       }
> >> +
> >>          return priv_conf;
> >>   }
> >>
> >>   static void *raid0_takeover(struct mddev *mddev)
> >>   {
> >> --
> >> 2.52.0
> >>
> >>
> >
> >
>

