Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6296118DB35
	for <linux-raid@vger.kernel.org>; Mon, 10 Nov 2025 02:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762741625; cv=none; b=eRmqlHki0gpP55XG0NLhnEp2BEP5TIakc633EUghCfaRI+znVm/lIUjfbhD1lQg4kO5ZQ/U/BRc2BEDwwveyI4BYQiYUDRyRsFjOyR4jEkfjbs3Y9YkY4BSLOYg33jTWQhnEVeoU8G4VLYKEHf90gAC3wlL1B+9v4r3iDik4//M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762741625; c=relaxed/simple;
	bh=7nmmqVl1N5N20DGFXlx5/q7VZBrB7/oaoEQ3991NUd4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nafv8A0esF8NMGzcUIVu99WX02vF5zTjnWzhMA8tGPz+QyXBNdJ3dSe/KE3v6oBA3DuzaSZ4Ksk764729zF11F/Aw7cCzRsOY2jYRqNWOpgDlU5a+qoYH+yzJl4Ou8ltA4nJxPOiwjHEoXVNOgp5BTZx4j82LzPsV5F1wu0hKN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aCkv6pDB; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=MwLcOsEh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aCkv6pDB";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="MwLcOsEh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1762741622;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7nmmqVl1N5N20DGFXlx5/q7VZBrB7/oaoEQ3991NUd4=;
	b=aCkv6pDB7FqAVc4bE1ldyapTcyn3pnc9X9bP+TN8dJN/GkXM8aP5/xOrNvunN6xQqY9Lzf
	QuPNcc+BJxNjKC37kCtrov+owlEFRPwFUy2EU9v4KpFRsQQtLUWgTxT3MV0VuoE+DBImwU
	U6O+BIEe8k2AorMRmBqAzf4SCCyjEPk=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-203-fCnwoNXWMkuaftLe02cHyQ-1; Sun, 09 Nov 2025 21:27:01 -0500
X-MC-Unique: fCnwoNXWMkuaftLe02cHyQ-1
X-Mimecast-MFC-AGG-ID: fCnwoNXWMkuaftLe02cHyQ_1762741620
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-37a3f2cf8a2so21362891fa.1
        for <linux-raid@vger.kernel.org>; Sun, 09 Nov 2025 18:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1762741618; x=1763346418; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7nmmqVl1N5N20DGFXlx5/q7VZBrB7/oaoEQ3991NUd4=;
        b=MwLcOsEhG19VnlzGej48Ca9hqdS3gIQk/zFVLTrUdDnhaiJWOqGu12PCiDpiEfwj+Q
         L6agQMPp6JQJQbuJeZElsl4+D+IsK05Aeyx8YHlkCjZZM0djJ1OWfk5uydwBuf2Hndkw
         5LYGHaBTfvuG5LoWefElsLKq404MJvHmSSWN2eZ5DSUJEQZye6WHdDrPgYfhYl4b8Xk8
         JZtfVOf1G3yp0JKF1d2Z0C1gOHOTEaMxqh+hFadXqRa406UpRX7wtSjJ8gMU6Neac9gn
         0Y28o7J4usw3TcELniyP2ODs8gVwdf1CQmAYzs8fdD/TXe/GbfaIBEe1F50c66QgiCMi
         dPnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762741618; x=1763346418;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7nmmqVl1N5N20DGFXlx5/q7VZBrB7/oaoEQ3991NUd4=;
        b=YNu5/n9I2/oyVm8QAHJJt7tNeAdhvm0fCLuWGNCeE1di0W0Pq4YdtzSH8PLW7AZ9V+
         Z+MXO8ze3K2AuChNzTL927Fc0D5oBsuQJ6Ro2kWr85AWvZKygvuvC6Ujwn8ijv36CXmR
         DwJuMMcCR/TUOtwKhtjuooiXq9K2S2SBmmBkyqEebrSb2+enIlfPNVEYzplOrsQ4Reut
         tNDIpfhQj6MxZSts6Xba63CwR348vENrhpoS1IPIUk2A2X/vBIqVOzEiPLpLAqemfkMf
         XULblckKQ2JABMA/4hKvZVGMTh72mCyJAfL4obNX457tGjlOtfwQjkv4Lyis04+WmCHH
         QYww==
X-Forwarded-Encrypted: i=1; AJvYcCXlkQ2CI6UDsCvkVRCJiGHO/+eCCTOO9HTojMIilB4TZvKPMxGpcQ5GYtxl4w5OIyAPiDPslEzoHwKk@vger.kernel.org
X-Gm-Message-State: AOJu0Ywy0BySy28bGBTDyBdjGby+T4CGOFMHENiK7IrmmlPz3HwWUz9c
	ddrloftRxK8vcYPnk3W2m55YpXSTEe9suD9RIMYg5uDV36AGYuubQbIv/L/s2pj5LgNOcu6zf+w
	BzIz1RvXNWRMOiYMcO5TksElY2bEoVlyTpld3LRmm+UyBF/r/xaNDzxE3l30wlIsHg8MFt9+8k5
	tV48tF5Esr4AF15I/d7R0JAQM/g5/OTHsPFMfeRCqDdSfXvP/l
X-Gm-Gg: ASbGncvG6M5cVN7clEws/1eGaSj9dfcqGUOocmdK1ajmbxavQhXW3rd0tVRryjpzYjz
	zVSax/fbK0le+wOFoNTGGisGjrhMjjRh3mrdFxMBalJxxvoyTRxDKTrxhFkTaoBTaZ/Rud784gW
	htP3nLUydB2gX6jp590ylUDJNEYEyPuQ8o0suq2qxfsXjhYMO/0CAN30Iy
X-Received: by 2002:a05:6512:3e22:b0:594:36b3:d1f9 with SMTP id 2adb3069b0e04-5945f1af20bmr1658107e87.25.1762741618369;
        Sun, 09 Nov 2025 18:26:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IG0OQ6POp2DvyduBqF18x2+BBZK5JQ/naempoem6bDJMgcg6osM3jUe/Zm740VX/IypFp1wgr5Bj9sbYSUkkJU=
X-Received: by 2002:a05:6512:3e22:b0:594:36b3:d1f9 with SMTP id
 2adb3069b0e04-5945f1af20bmr1658101e87.25.1762741617924; Sun, 09 Nov 2025
 18:26:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
 <20251103125757.1405796-5-linan666@huaweicloud.com> <CALTww29-7U=o=RzS=pfo-zqLYY_O2o+PXw-8PLXqFRf=wdthvQ@mail.gmail.com>
 <a660478f-b146-05ec-a3f4-f86457b096d0@huaweicloud.com> <CALTww29v7kKgDyWqUZnteNqHDEH9_KBRY+HtSMJoquMv0sTwkg@mail.gmail.com>
 <2c1ab8fc-99ac-44fd-892c-2eeedb9581f4@fnnas.com> <CALTww289ZzZP5TmD5qezaYZV0Mnb90abqMqR=OnAzRz3NkmhQQ@mail.gmail.com>
 <5396ce6f-ba67-4f5e-86dc-3c9aebb6dc20@fnnas.com> <CALTww2_MHcXCOjeOPha0+LHNiu8O_9P4jVYP=K5-ea951omfMw@mail.gmail.com>
 <c3124729-4b78-4c45-9b13-b74d59881dba@fnnas.com> <CALTww29X5KizukDHpNcdeHS8oQ-vejwqTYrV5RFnOesZbFhYBQ@mail.gmail.com>
 <8e240c3c-3cf7-4d48-8e13-2146a5d36c2b@fnnas.com>
In-Reply-To: <8e240c3c-3cf7-4d48-8e13-2146a5d36c2b@fnnas.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 10 Nov 2025 10:26:45 +0800
X-Gm-Features: AWmQ_bkEWK74DgGkBNl4ou8Ya5SG1OvgsF_zE3BWVU95djqIT-yojEdHF1L42eM
Message-ID: <CALTww2_hu3uocnYvJTViL88A30WgVPHs3-ZHgQYK2qgB0S9b7w@mail.gmail.com>
Subject: Re: [PATCH v9 4/5] md: add check_new_feature module parameter
To: yukuai@fnnas.com
Cc: Li Nan <linan666@huaweicloud.com>, corbet@lwn.net, song@kernel.org, hare@suse.de, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 7, 2025 at 1:06=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/11/6 22:56, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Nov 6, 2025 at 9:31=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote=
:
> >> Hi,
> >>
> >> =E5=9C=A8 2025/11/6 21:15, Xiao Ni =E5=86=99=E9=81=93:
> >>> In patch05, the commit says this:
> >>>
> >>> Future mdadm should support setting LBS via metadata field during RAI=
D
> >>> creation and the new sysfs. Though the kernel allows runtime LBS chan=
ges,
> >>> users should avoid modifying it after creating partitions or filesyst=
ems
> >>> to prevent compatibility issues.
> >>>
> >>> So it only can specify logical block size when creating an array. In
> >>> the case you mentioned above, in step3, the array will be assembled i=
n
> >>> new kernel and the sb->pad3 will not be set, right?
> >> No, lbs will be set to the value array actually use in metadata, other=
wise
> >> data loss problem will not be fixed for the array with different lbs f=
rom
> >> underlying disks, this is what we want to fix in the first place.
> > But the case you mentioned is to assemble an existing array in a new
> > kernel. The existing array in the old kernel doesn't set lbs. So the
> > sb->pad3 will be zero when assembling it in the new kernel.
>
> Looks like you misunderstood the patch, lbs in sb->pad3 will be updated t=
o the
> real lbs when array is assembled in the new kernel. Set lbs in metadata i=
s
> necessary to avoid data loss.
>
> And please noted this patch is required to be backported to old kernel to
> make it possible that array with default lbs can be assembled again in ol=
d
> kernel.

Thanks for the explanation. The patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

Regards
Xiao
>
> >
> > And as planned, we will not support --lbs (for example) for the `mdadm
> > --assemble` command.
> >
> > The original problem should be fixed by specifying lbs when creating
> > an array (https://www.spinics.net/lists/raid/msg80870.html). Maybe we
> > should avoid updating lbs when adding a new disk=EF=BC=9F
>
> I don't understand, lbs modification should be forbidden once array is
> created, it's only allowed to be updated before the array is running the
> first time.
>
> >
> > Regards
> > Xiao
> >> Thanks,
> >> Kuai
> >>
>

