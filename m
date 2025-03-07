Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58F3C19DF66
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 20:42:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741380158; cv=none; b=nOdhkAru6o512n+kNMyaydiCifa78tWdUrI349g4irsM7mc2wdyWslDq93Nr4hhBJ6KF9LdFPxTETEsSzTvnJy5fT2+foHoj/HerxaWIkrb4hrHt5fqQxfN0rDKlWzxxnd1UKsZG1wHBVhngWeSrt0g9mdDAOyCK1BY8iyXfsTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741380158; c=relaxed/simple;
	bh=OknocWyw67SK2o0nJzf1N9qGF/QQVoxFJCLxna8lIY8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qYLzlwzB9YRvqv4GBaHpJhmy6+f1kdLCOEgGDy+9xuCGiUH7ombrXlnxkZcW+2u0/PXsFwvzboJwFdK1UbyCA3D0T8BJFh6ILgdyWeqZxWbPGp544jJwRcEdkK+JaqKRnnacv0ZY14fVIEWXZeG9K0bV8wYBEhWsLafbXpK/Dwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ma9nCmpk; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ma9nCmpk"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3d3e25323cfso20248065ab.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Mar 2025 12:42:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741380156; x=1741984956; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WaWTdfqfvhH1MadK+QIXEGECfGPGmxkX9+td32CG4KM=;
        b=Ma9nCmpk0J1csJ2A3QKzhLpwDJ9RRwvAcMrBUcwvt2JrWRrVQQnuPwExVhssFRYma+
         zXkqccT356j2o76/2PQkmPukEwmHUE91SXvQ7vA/hoc5/vHazEl+SxVhNuuP54hEO7Mk
         Z8vt4z8vAIymG/4vRtLFJidMlQsBch7FGO1BM7CCExIL8VhKsQDLR7oQTfPgMOWftOAS
         glTviao/BZwpAVxxa3MVuPKZhu6yhuLPkTYNPK4OlONwmsbkA2w1MPfBsBrJfApivxum
         9UjkzTh+EHAgwiWObYPku1HNqwo0g+jajMucdAXLwFcyAPCZ2PsFdOGhtJ+0mrJykgAE
         k5qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741380156; x=1741984956;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WaWTdfqfvhH1MadK+QIXEGECfGPGmxkX9+td32CG4KM=;
        b=ebLfG3J23Pst8ITxpOb/LIeSvrZlhXonin0aQKgRen47yPaGrEOD9IGPxNJRp6sMpN
         ndvWbnYJgLmpBVeXPeE98w4vyMdY2tbC7QrrYaqqEMRVoJpsvtNn9cHkYkDrmMMXpj+4
         +e5bnEFX/uR/Gi5/cjhgqYEUsyC1bys4KRuuV2a/6sqnfB6lECOms0p/OSgNpyzFv6RF
         /0jtmakBwtBG8ZQ9aln99uXgJptfVkZxqm7W22+yuFfNJbFmjHbMcZLFp/PmxLslY/wV
         1fMmGpNTjmPw1Zf27SxaEaEt/rODu5FcYpuS4FsYVRBK+l1b77fZOO3vu7gr1RlGOz+9
         vrtA==
X-Forwarded-Encrypted: i=1; AJvYcCXBJCZm7VjJmyWmMzcdKpbju/D3N5ER6piJjamixxceUa/KJymeBwOziCw56cL3cgdeuDgxGrp0ikVd@vger.kernel.org
X-Gm-Message-State: AOJu0Yx26jy6wiuTLdZeeYg9ZPbSCKp/7J1rC+2DP8su7XSXmz5m3pzU
	I0q5mGL4lGJIFcOL4B2CNMKOvOrbxEeoSEqEfOi2ktnSyV4IjrZ/SRWfkyEgd/cm6afj/Y9UEWJ
	o5zh9XggufG1wztfC7veWTDVtjLY=
X-Gm-Gg: ASbGnculPwuFNeLT3qi5wRkCG7vgC9ONHDgKYwPMGfdMYpsKQyqIwtuR9NDBQSupNhH
	/vtDV9+nF/cApAdK8iWa5zn1q5N1jju0wyYLAHfnjlF/9nVFLYQUIaG7quuviomHC83iec1eXAL
	wEsRbC7HjXfT18GWtxW0LBMedY
X-Google-Smtp-Source: AGHT+IGPONkZLLtuDmrd7CXycQ+K4B+ZevO4DkqK7tmfQPWRUPswXwl4awkvlT0Zd+8OAvWddx8/Q73EPBWBfUq8/OE=
X-Received: by 2002:a05:6e02:1d03:b0:3d4:3aba:e5ce with SMTP id
 e9e14a558f8ab-3d44193e0ccmr63790185ab.20.1741380156344; Fri, 07 Mar 2025
 12:42:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <lMRgP8wc-P3iUlmbrsOKyuXM834ndQZZUThbeEUIO0WoNKKMQLd-T5P6QrFMEYiYAoQUAWkFGaggDTMSzZFw9KzBagunLy1mRNDk2TljKUM=@pm.me>
 <20250307234753.473dc4b5@nvm> <wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me>
In-Reply-To: <wbKuA1vBv5kD_KeuudRU95HVHtIXiMs9hvH40_jlVcKTvwOR_4vszdQADWASxjhfBXFS2JkNpQnCnrdaoiombOE6Tof66ktqnXyRnwQXw7o=@pm.me>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 7 Mar 2025 14:42:24 -0600
X-Gm-Features: AQ5f1Joh4uXYR-C3RwwgKNbvE8S6F9sPIMesWjxa69rizqy3vwYK6pQ9vHR4oB0
Message-ID: <CAAMCDefMK6PD7+BpfQ9e2WGjdsk_hQaoGOAYmQ2_Rtn5o7nGrQ@mail.gmail.com>
Subject: Re: RAID 5, 10 modern post 2020 drives, slow speeds
To: David Hajes <d.hajes29a@pm.me>
Cc: "rm@romanrm.net" <rm@romanrm.net>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I put an external bitmap on a raid1 SSD and that seemed to speed up my
writes.  I am not sure if external bitmaps will continue to be
supported as I have seen notes that I don't exactly understand for
external bitmaps, and I have to reapply the external bitmap on each
reboot for my arrays which has some data loss risks in a crash case
with a dirty bitmap.

This is the command I used to set it up.
mdadm --grow --force --bitmap=3D/mdraid-bitmaps/md15-bitmap.img /dev/md15

On Fri, Mar 7, 2025 at 1:25=E2=80=AFPM David Hajes <d.hajes29a@pm.me> wrote=
:
>
> Hi Roman,
>
> Thanks for reply.
>
> All drives tourist SATA3 CMR
>
> Link speed for LSI SAS2308 8GTs/8x
>
> Intel C224 chipset SATA controller
>
> Write speed is always same, no matter RAI level, chipset C224 or SAS conn=
ection.
>
> Read test for RAID10 is 414MBs
>
> I was hoping for higher writing speeds. What is interesting RAID5 in defa=
ult setting does 220MBs while RAID10 struggles at 170MBs.
>
> There is something horribly wrong :o)
>
> So bitmap seems to be on. Mdstat says "bitmap: 0/204 pages 65M chunk
>
> --bitmap=3Dnone
>
> Write speed 170MBs on RAID10 with chunk 1MB
>
> Bitmap internal with chunk 128M write speed 170
>
>
> -------- Original Message --------
> On 07/03/2025 19:47, Roman Mamedov <rm@romanrm.net> wrote:
>
> >  Hello,
> >
> >  On Fri, 07 Mar 2025 18:36:13 +0000
> >  David Hajes <d.hajes29a@pm.me> wrote:
> >
> >  > I have issues with RAID5 running on post-2020 14TB drives.
> >  >
> >  > I am getting max writting speeds of 220MBs.
> >
> >  What about read speeds, do you get much more, or clamped in the same b=
allpark?
> >
> >  To not wait for a full resync just to check this (or various other set=
tings),
> >  you can create the array with --assume-clean.
> >
> >  In case reads are also limited to the same value, I'd suspect PCIe ban=
dwidth
> >  issues, such as the HBA getting choked by 2.5 GT/s x1 for whatever rea=
son.
> >  Check the bandwidth in "lspci -vvv".
> >
> >  > I have played with chunk size...default 512k-2MBs...no difference
> >  >
> >  > "Read-ahead" set for md0 virtual disk
> >  >
> >  > NCQ disabled - set 1 for all physical drives
> >  >
> >  > I have basically tried every suggestion on famous ArchWiki.
> >
> >  Do you use the Write-Intent bitmap, and what is its chunk size?
> >  Try without one briefly, to see if this was the issue.
> >  For production use, increase the bitmap chunk size and see if that hel=
ps.
> >
> >  > Initial resync drops to 130MBs
> >
> >  Are your drives SMR or CMR? For SMR drives it is common to briefly wri=
te
> >  quickly and then slow down as they need to do their housekeeping durin=
g the
> >  same time as new writes. SMR are not recommended for RAID.
> >
> >  > Is it possible this weird issue is linked to HDD timeout described t=
here >>> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/index.php/=
Timeout_Mismatch.html
> >
> >  No.
> >
> >  --
> >  With respect,
> >  Roman
> >
>
