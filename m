Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBD1125AB
	for <linux-raid@vger.kernel.org>; Fri, 26 Jan 2024 10:46:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706265992; cv=none; b=Fjd2ZvBHnSqjCCwq1/mjS8Pf+Wi6W1/lsXFmL+tlrJUmEJkOnhwvfFKfG7z694FhsG6SND0P67oUyghHRum+K2fw0ZzbJj/z3CgN3+QD7LKG/h/fobtBxpPKzj6JB85gfPuNSj9T20yGYBxTHjIBSNZZ1k14pTsyXOIolnb+0WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706265992; c=relaxed/simple;
	bh=bYr6zz3JCs6V8j1TOSkJQRHg/kmoF+tqDNun6+QZnQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Content-Type; b=M+PvRxyQk1fM9I/FQPkcL5qNv4qi4m3VWr6hqAXTG8ivr3cQte93VBB7vzSR+pyZuhxWx5sW3yOizUd/+1MD460mtvTMXqPSCl4XPVGrX6jU2+gutzXofBknwkO8vQnubWM9fs5ot45IvPM5H6FlqV9dVqkFgQauioCuvN/x6RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RF0yhoZt; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RF0yhoZt"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-59927972125so132698eaf.3
        for <linux-raid@vger.kernel.org>; Fri, 26 Jan 2024 02:46:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706265989; x=1706870789; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bYr6zz3JCs6V8j1TOSkJQRHg/kmoF+tqDNun6+QZnQc=;
        b=RF0yhoZtzgAKfOtv/uMUaMq8LJukkQJS4bxcvo0RTWq2lldQTXX4LJTG5VxkDMutkk
         uZNHBCWHO34/2orXAWwyYe+3RXYX28KrhpQuEcwngJUNK8zAEwZ8AGloLRQhDJf7DylS
         10izdGN6kiBlf3GCoPqdTFnX2pChlGVU2lc28lMbdBM32cZTTkvO3YhCKocm3m2jkt7W
         TUgSK8tzi6PfNg1Mxh8jDHvshFAhPsD0FyMiy77aDfUToPsgiOAh6yAVnWmFGAV7NGB+
         29s3lYQRjdFcdYNfUS5VBOwq+r6jw4463sCiG2aOp60ltrHb6zPj1ae1AGMx0/FxPJJV
         5Abw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706265989; x=1706870789;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bYr6zz3JCs6V8j1TOSkJQRHg/kmoF+tqDNun6+QZnQc=;
        b=p/w9bUqwy3cpCG6cGlKYuPnxUQbQxP4tj5VKgykjpCg8rfh5MATIFL3/C//Rebgg0F
         fQmzcUHWyUTfyWH/nzFdb8592va9IEQssqMc9dFJ4unoROsiqAuCw1yDvsha38XS4hfM
         pfb4enBr5vvYZHAiJyQPGvrl967VI0Lwxu2Wau5hpWRUkHZxhobs1kVF3gHckDSK7tHF
         Exn6OE1hWRxwMVblfyqfIWPIiDUfJ2OIvE6Mc78ifJ9W0t3iKZ82tJIfH++O3UxNCFIH
         ShwjPm0sBS1fxyJMaKV0w+RAnUmzkZR1sTs+BCtwbBaBSKpTH2dsMxfjPG038ahK16MY
         wZIg==
X-Gm-Message-State: AOJu0Yya9FjnZej6CXP7ZVwfFVt/d1Fdpc3bwzViVXP/GiByVZ/8NOux
	0vsfjgI/0TV6vhwDxVevZwTg1P1pTXu7f6sg9xZhJ0Fm3vHyBwdXKxDoNcwhoD5iSyKBpGY7N2y
	/BdDva4E6AMt2L2xE2GcQSNF2JTGXuQfL
X-Google-Smtp-Source: AGHT+IGngCXp90ahq9mqLuz0LT33pgebCiWv3xO9d85E8xw8peG0MQT/PqmudGRRu6HVODNVhbP/jzuHERAimyR7rHY=
X-Received: by 2002:a4a:a809:0:b0:599:c8cd:f26e with SMTP id
 o9-20020a4aa809000000b00599c8cdf26emr809432oom.4.1706265989490; Fri, 26 Jan
 2024 02:46:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
In-Reply-To: <CAJH6TXjrmVRBpP-vr1io0unxqKZ_QE464G9R6G4Ekct3ShVx6g@mail.gmail.com>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Fri, 26 Jan 2024 11:46:18 +0100
Message-ID: <CAJH6TXgCOBRVc4rkrXjgxLxih6h1Avkn6x4JaJ3YZ20rAq5kig@mail.gmail.com>
Subject: Re: New device added but i did a mess
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Any help ?

Il giorno gio 25 gen 2024 alle ore 15:49 Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> ha scritto:
>
> Ok, i think i did a mess.
> I have a 3 way mirror with 3 drives on it
> All drives are working, not failed.
> I would like to replace one of these drive (because it's very old)
> with a new drive.
> I would like to to the add and replace in the same phase, without
> reducing the redundancy level
> I did this multiple times before, during the sync, the array is a 4 way mirror
>
> BUT this time i think i did an issue, i've just run this:
>
> $ mdadm /dev/md0 --add /dev/sdd1 --replace /dev/sda1 --with /dev/sdd1
>
> sda was marked failed immediately, and sdd1 is marked as active sync.
> Less than 1 second.
>
> Is this ok or i've just added a blank drive and forced the removal of
> a working one ?
>
> Honestly, and this is something that comes to mind right now, the
> partition is very very small, like 64MB so 1 second sync (on a SSD)
> could be ok.
>
> but:
> 1. which is the right command to run to add-sync-remove a not-failed disk ?
> 2. how can I ensure that sdd is working as expected and data were
> synced properly?
