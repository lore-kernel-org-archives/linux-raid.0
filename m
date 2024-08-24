Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3AF946444
	for <linux-raid@vger.kernel.org>; Sat, 24 Aug 2024 18:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724523164; cv=none; b=CE0NihSrMcH8fEfhh50cGKv+hceS7OJT+5S6QQ55AwfKn9v34xo+iSp8kWTUkyPmQ+pjb0pekcY5w3Dmlu1YlhNWUtrVpanrnAl9Q0XgIaO709mAr+YVkuvuBw5Ra4smjFv4Ik2HLYfp3xPOTYSTatybfvo8NuOWMMfq7ytieaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724523164; c=relaxed/simple;
	bh=YETSCOnsIeBZ5iZDbo+TpWNJY/YMahQmhW+4xSvK7Dg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NaWtBGhZAk37r8RbAjkR7CsgjlBBUR6PelI1JEjWwGjhWg0Lzd14cu2adXynLKD48QIoOFJJoLaZZxDohvLrv/gKZVKsWOln1lweUKBCyxvVVYzegcxunov7onWofHJgrKQLVOUu5Xr2rvnaL0qBGu51QhMwOmdlrGVfdbP+dLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=UvZYHBEw; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="UvZYHBEw"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2d3d4862712so359143a91.2
        for <linux-raid@vger.kernel.org>; Sat, 24 Aug 2024 11:12:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1724523162; x=1725127962; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ElACriSOYd8nAcwknSV71BfVzwApL6pof2DJpT2TA64=;
        b=UvZYHBEwfz2xVyqT8Tgrt1/FJBPXnZLAZeBI+Hb8rrwFADV0ZTFk25tqQRlh7jjhWd
         66llVXqYCnknsCVwfYWVmUkvNdrGxAWOd/FBQulOfrw2QFDw0hfLtzlTp8PXWzyfEA8P
         J3dnVY15vxZys51OdhYc30M/qAFIhzaGvyf1I3QAf+p70+Vps9EzArcBO5y9pCBkxLfV
         xd5OC+LfcrI3eMJ9VEAxJ6KlOfxhlv9Rjovcf9ZvkEbIVRHS5HsdWwh/JP6fI99klin1
         O4t/rxC4yrA+0t9pDhlV5HrHmFRn71QcCIG3eNRGUY1/0tjBIfHCvMtHPoSylryFz4Zs
         E6mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724523162; x=1725127962;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ElACriSOYd8nAcwknSV71BfVzwApL6pof2DJpT2TA64=;
        b=v+E2jQlgFKruolXUtY1krAj+tN8i2TiaeuwgPOvOpZn5fLoIwjmZG16PqOV4r41htt
         xaXwLJByQuhHCxSShifihyttCiRVLSzHqGIPZcwAWOOMKCYN1qaydUJdm6RM4XsUzk8x
         ssg5rKgoGbltsV8/t3LyKYrr1jPpYcn0Rk3rcLcdcR92YtnzCddOisZXQCsZh4aL/akW
         oP2kO90lmIZTb/pZqFxB0tbxZ9AIfog1kzGRmW0Sxcc6iBsKqLimeS10kvO+OHcRqJfS
         QD2IgXho+/JceRgE/dpajhuTeZUycw8zr+3ThF/H8BqmEzUpE9TuiBznSJr29AYQWhDJ
         v9jw==
X-Forwarded-Encrypted: i=1; AJvYcCWft1Vw9pjCx98zkJwMGcD779vapvluD0W787F1T4l7bPeIo2cAc+Y0OQV50c9LNAuh2WUA0MU2zGsp@vger.kernel.org
X-Gm-Message-State: AOJu0YyyCNeT62sB/icJ7FY10B8AeieonnYv3CHcWpP1vLYTobPIzKpo
	RIdQ1+XjotSkUU7QbS6Xq9dT090TAmq8pHj6sVEdNIRYiuOsjR+zRYBx+WM/4wTMH2KI1IRK+42
	hTCBKGDGVlgCEk9usb+YDZad8LJw=
X-Google-Smtp-Source: AGHT+IGyixcMUS2U07yKW+EnotEo6YYu3PSQ7EpZN9irpYOB9iCLFffhfwL9K4W4XpQ5UawHLxAI5RDAgZ7XOAt5UGU=
X-Received: by 2002:a17:90b:3709:b0:2c8:4623:66cd with SMTP id
 98e67ed59e1d1-2d646b9dc77mr4085809a91.1.1724523161975; Sat, 24 Aug 2024
 11:12:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
 <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com> <58450ED6-EBC3-4770-9C5C-01ABB29468D6@flyingcircus.io>
 <EACD5B78-93F6-443C-BB5A-19C9174A1C5C@flyingcircus.io> <22C5E55F-9C50-4DB7-B656-08BEC238C8A7@flyingcircus.io>
 <26291.57727.410499.243125@quad.stoffel.home> <2EE0A3CE-CFF2-460C-97CD-262D686BFA8C@flyingcircus.io>
 <26292.54499.173087.840312@quad.stoffel.home> <595DE483-7F2D-4B27-9645-AC51E8B90D0C@gmail.com>
 <26307.45971.357185.491868@quad.stoffel.home>
In-Reply-To: <26307.45971.357185.491868@quad.stoffel.home>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Sat, 24 Aug 2024 20:12:30 +0200
Message-ID: <CALtW_agdJ9RLEit8=3MrOK2R=kT69wQj0oD1O5nEmeEh_WyBHw@mail.gmail.com>
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: John Stoffel <john@stoffel.org>
Cc: tihmstar <tihmstar@gmail.com>, Christian Theune <ct@flyingcircus.io>, 
	Yu Kuai <yukuai1@huaweicloud.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

> Interesting.  Why this way?  It would seem you now have to enter N
> passwords on bootup, instead of just one.

On RedHat based distributions, by default, a single entry will unlock
multiple devices.
