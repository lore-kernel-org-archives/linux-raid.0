Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76F66DD1D
	for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 14:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706194187; cv=none; b=mdaw5+mN9v2BoI5LV2rEM2XSwLP+lym+LUrS35ths7LKY699ogQUbMH0J/FHHO7KAwCOyvfcIg30+MAZkFlfdvNSbdzjp6bf+jK7JW5BV1OKhvtkG+JuFwTqTDB70w8U8MiG2SBLtPSOzxnXB/0L5tQ8p6VCbZJvYsiaJwg2eok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706194187; c=relaxed/simple;
	bh=lrYVG7J28E90dsFt2bWvtC0y3d9/sQCi8UStaRJHSqc=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Fs91zAu+AJ/Wyi2hkWVUjSq5h/Rk5OyIurdYjZCVT5Dp7QXg7CchulKO087QJoL0qgFWiginKlF5/fJF/aHktRQF1Kbpqa+F33aXKQw3L9h+M9sDSlUqwGf2QnU2FYijml2PHmMi+zHdpTOv4E0d3I7RGfFNoQ2mknpmBKqa1po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gh10aqId; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gh10aqId"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6dc83674972so3699330a34.1
        for <linux-raid@vger.kernel.org>; Thu, 25 Jan 2024 06:49:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706194184; x=1706798984; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lrYVG7J28E90dsFt2bWvtC0y3d9/sQCi8UStaRJHSqc=;
        b=Gh10aqIdWGXma2IBTGuqreG9wHZqA7EvG3UZRKPQ29nix9RyF+bWbwX7578+nbY36p
         AS+RvkvXt/v9ZXIpJUoaOl4stWpB5tjE3wFyMBuKXXru4hpiwA/fKiWEYRYP+ScCjOqJ
         82lhpYLjLdiuvDXTdrkkuNA4RuxaPkckjmR6Z5QgWUgJjoalm9AV/3fw1BfjCPzmB4Tk
         bnANwieVdjSj3LdxS2fMhDuWHahCzBopg4wsGgTaGKUdG0+T5km7MVztX50jkokwlWDC
         OtUYPAU5lQpRTgNup3Heb4nPvjYZC3NnSkkkiAMcilXqV8O1YCpMZssQ/Wu9aHGF07Y4
         IGbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706194184; x=1706798984;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lrYVG7J28E90dsFt2bWvtC0y3d9/sQCi8UStaRJHSqc=;
        b=FHB7wmVTQ0gT/3qYgvlt9bhwLGhWmUnfYEajzx65Vcd4SBUbU6mPcevM947w64pPSF
         rdQsvVIL8CrwSbaJ4iQzUeSkj8YWgE6AGXzXGd3UnlJHsTRTyUBeBfR9qJlsw9PFj+h2
         ut1eL44CfrzmqEGjPHCKanc4IopmH2NSlLGwfoSurYj7iEUknnGhOUM+Wvw7BQf8Do3s
         yzcYo6cP/qxWDm3uJhvMrCv0tpRcbOTW7Xt7fArOHCNh0pnk7v88s5vHWbYy1cGv5NEd
         QdiQcjHxKu01KNVoAYi5/KiFm4BzcpV6qTcTDkWg2AOBCoy5/UWyWVWm6K9ROGI+2BOa
         WgXw==
X-Gm-Message-State: AOJu0YzKAJjvy9i6doiVg/9uUKSHFE87Mt8g32JwBv7ty54PVGYsGV4R
	XAqnA3G8x/xRlI8V1FBIwOwr843ApbfymfJt8I4UUeS3lLBlBiM4wUofnFdnt+kv6/uu6caZkc0
	02+3BP+1zV8b2Ct8u776ElntKSz+7o83rn8M=
X-Google-Smtp-Source: AGHT+IFiQjfcKCG3jn1pFDvINasYzhtsKOAZ/MMN849Catw50LDnG8S+m/eIdFIhap5H7SGtsAmju1WZyDg82wqhfYY=
X-Received: by 2002:a05:6870:d299:b0:214:2851:7e6e with SMTP id
 d25-20020a056870d29900b0021428517e6emr947653oae.49.1706194184625; Thu, 25 Jan
 2024 06:49:44 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Thu, 25 Jan 2024 15:49:33 +0100
Message-ID: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
Subject: New device added but i did a mess
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Ok, i think i did a mess.
I have a 3 way mirror with 3 drives on it
All drives are working, not failed.
I would like to replace one of these drive (because it's very old)
with a new drive.
I would like to to the add and replace in the same phase, without
reducing the redundancy level
I did this multiple times before, during the sync, the array is a 4 way mirror

BUT this time i think i did an issue, i've just run this:

$ mdadm /dev/md0 --add /dev/sdd1 --replace /dev/sda1 --with /dev/sdd1

sda was marked failed immediately, and sdd1 is marked as active sync.
Less than 1 second.

Is this ok or i've just added a blank drive and forced the removal of
a working one ?

Honestly, and this is something that comes to mind right now, the
partition is very very small, like 64MB so 1 second sync (on a SSD)
could be ok.

but:
1. which is the right command to run to add-sync-remove a not-failed disk ?
2. how can I ensure that sdd is working as expected and data were
synced properly?
