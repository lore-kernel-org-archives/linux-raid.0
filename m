Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D884D25632
	for <linux-raid@vger.kernel.org>; Fri,  1 Mar 2024 18:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709316454; cv=none; b=ZPRpv4TL9VWoOE0G2PPv1QhJH+IO5yV7PQxjjBwvCS5cglIg+vuc8JL33D9Y22xFyDaVy5TwMrkIiSyQVC2DsNi9L5NGUYEJqM76vkKr7/4tsVVxtrfAzVgy6Rx6D8u8abX6/tZWPmmZt+beYMwdl9LSSvbl3e4ntEtl2FVZx9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709316454; c=relaxed/simple;
	bh=PtHK5GmvU7jdgi+Ec5aG9npVqlGYdkMnWIinA3VgbmE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GQTa7N5OvAEX5/NtkPdo4tVqjfS5p/FjIYcGfGKSA8oR2zDG71i/+pnJarYMw5D3ZeuDTghB/tVyNiY7dxdkk1CMWhl8qy6kJN6/Y5jJpnGXpFUmHEYUCESOetF7BfHCpinOtCsV2l/6iV3L7eDTHdo7E4XGGjcaQpg08fdbEZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NSCRadkq; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NSCRadkq"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7c7b8fb8ba6so140753739f.2
        for <linux-raid@vger.kernel.org>; Fri, 01 Mar 2024 10:07:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709316452; x=1709921252; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kVUODV2zRWYOkThf+q0D9uM6P3PU6m6CEDDrHqOrWu4=;
        b=NSCRadkqguzIhHxlrPyeJMr0id1EBF/JzlqNorfFcnbVHMpjHLPnHuWn7tWI02huD5
         iEUC4+99ZLAvkVh3h/55ZZmscNA8ke+MJ2Ocb/LteJBzLfp2T0KXvMrdsjG4ZgBmcXqc
         pg4iM7GlOZn2IOF8pOGrbKUgxUWlqgm6jZ8FA/z1rPx2Nfpo72OjlUvT2xhAJ4cACHz5
         GH2Wkd9QWHjrn5f4Tgf/Rgl/j7Q2Cj0NyDvup1wtfRk/yJdY5RSpJg/I+PKPSlIo+CQm
         9xkexlPzymNyrrivIBIrPbcUDsJxNnnSX6Yau9Pjc0k30sEKNIHpk8wISMKfLAd2PrYB
         CBOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709316452; x=1709921252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kVUODV2zRWYOkThf+q0D9uM6P3PU6m6CEDDrHqOrWu4=;
        b=LqFmB9c0r00LiuwEToe691a3Mu1gTUgiG9FShZZaWauYxNJqVqvzbzbPd/FpsT1Hy5
         KsBeq1NAJlnSQXMr+iHq/8hkEBGb97aLEriTnjx6iatCIdo+j3v8R7yVnjfNuo/8ARoG
         AlF0Nx53ej6ik2WneagC7uEmkB0fD6XdeZNOhemzWr8E/L72hXBUCOIZ0vo6q5Najy14
         xeEV6MwuMwo+Bo6D3cTi0n/sOKyrq7Bd9FFVPs55GGU4950EpA+SwQCFmihZYremZIK/
         ysIPPLpFF8rgaOplg1sNaQe0Z+U22fdw0BsyREViQs9O3yKlkRKlj6gvypS0NaetAUZC
         JGSQ==
X-Gm-Message-State: AOJu0YyMKaxwuae224pq10CCD9fwtoJv17dz0cd+CXyROONNourIbJwL
	jfBaWemuU3e0yiQlX6y+a84O3omy2t1fVnJCyY1cykc0ULEVT7PGE+AgRwXUP1EYogoBuf+Q0Zk
	0m5yeD7QqgsQgg5/FvsQZf1lpnp/qw1ky
X-Google-Smtp-Source: AGHT+IGwX1NQMeuX/CiAsGJEDPiG8npKjiSHOmrD0YZ6p53eY8Add9sYrRAdlTnwfIOoqw8v1EQrgHrOV2SD7zpA5KE=
X-Received: by 2002:a6b:6113:0:b0:7c7:97ad:91fc with SMTP id
 v19-20020a6b6113000000b007c797ad91fcmr2686831iob.1.1709316452079; Fri, 01 Mar
 2024 10:07:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CADC_b1dj8AodZxYF0tLPnfv0S3xHGnCBVOmvWgyCZt4LqHze=w@mail.gmail.com>
 <CAAMCDecAJ4QP29v_Qgv4xi8vNL-RWEB+v_HMkAtY2Z3rk9zKZw@mail.gmail.com> <CADC_b1d-w5Hu0jfrLXz80OD+gK9b7JEps-UHE8TputL2QGHBqg@mail.gmail.com>
In-Reply-To: <CADC_b1d-w5Hu0jfrLXz80OD+gK9b7JEps-UHE8TputL2QGHBqg@mail.gmail.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 1 Mar 2024 12:07:21 -0600
Message-ID: <CAAMCDedGf5bacpyWe8bte8f+2-dkEeNZ5LD-96W279jD_7hywQ@mail.gmail.com>
Subject: Re: Requesting help with raid6 that stays inactive
To: Topi Viljanen <tovi@iki.fi>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

> I have now created overlays with this guide:
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>
> Did I understand correctly that now I can try to create the raid with
> that --create --assume-clean and using those /dev/mapper/sd* files?
> So testing different disk orders until I get them right and data back?
> After fail #1,#2,#3... I just revert the files back to beginning and
> try the next combination?


Yes, try, fail and revert and try another one until the fs makes sense.

Given these are GPT the gpt overwrites enough in the front of the disk
that assemble is not going to work.

You should likely also read the last 2-4 weeks of this group's
archive.  Another guy with a very similar partition table accident
recovered his array and posted some about the recovery steps he
needed..
