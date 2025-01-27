Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F348A1531C1
	for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 21:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738012733; cv=none; b=hnOc1/eHD/wnxKzRXd8r03u4885wk0f1Th6pX10aBzJBPRwtKJ1DpiCgAQDZb1rQZ7jes6NSFzkuDYC0J4IHlMbVyiiZtBepLqJ2hZRF2zz6iQXY+sYtC49wvRhVC3dYdFoVfqPeTNq4WI/hy8FPwpQsQY6NR91CFuX76MCRmTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738012733; c=relaxed/simple;
	bh=He++yNpERwvrS3FRBptE97rIytYD0A/fUjTmo6Sbe4g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hi1xDekTK18QrdeY37Kv2Lmg4dp4oPCoTt0NFi8xL7b9gVeETV+RUaewelh7N8p4dfnpVmJk9DHsd9LceAndFD7vrG4AIVzUXp/hlVH9WAmFl51b4M4v7ZdfV0tMKLViULwDrcY6jHScxfcf/ervVYP8RKSPgcOWkQiCGRFsDZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=aNihY0jd; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="aNihY0jd"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-21bb2c2a74dso11512255ad.0
        for <linux-raid@vger.kernel.org>; Mon, 27 Jan 2025 13:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1738012731; x=1738617531; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=He++yNpERwvrS3FRBptE97rIytYD0A/fUjTmo6Sbe4g=;
        b=aNihY0jddHqfhok9GEigGZFdcPF9bSOU4PJzI1S+Oo4qVBAKOwJu1HRGVR7ZeoAYBX
         WOCjpxIi+2//Y/cUYbcpL6Y7/bdFJXgpIxBp9KU4VujcDag/Vi2JOhND+kZ0hGPwXfaJ
         Vime1KvzlyqI7XAs/svXCd7m0ziXi7qaoHNx06UCAiHViZoiO65IjpFL9T9PiCeLW5wv
         vieO7CTShg7/+UYobm0TzBAzd7zyaJCO1SSqXd61lr9Z9ovMBqMRJ9urcIwy68gv5xIa
         lpQ/wgDm+ub3ZnPdThPDf3/8OrRUlkMgrNz7UDFynDuTtxBr4MLtdk9numOhhwnI1ocY
         t4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738012731; x=1738617531;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=He++yNpERwvrS3FRBptE97rIytYD0A/fUjTmo6Sbe4g=;
        b=tX1XNyRMrRg4e539mv0XgAuD7u7yPOD0yJA3UyOeaqrGNG16reTVh+ecsmP5M+1DGx
         pzgJh18tsPWb8m+0Q6FRFUsWZnD9juPiyEAP4+cBaGwskK/rtFaLt1mqMyfSHBS4sHJc
         6+OYODEEoaa6M3A4S1Pz36bcAEuJxqxySHm/Y7cYlUv1Ejmi4d/iTvQynkh9rj/OG/GQ
         WIuapQqIGslAJEQXXpr/+8tung+UBYL1eGHrrWChwo806sLvdv5KO6qW/cYaEVNZHJmd
         HBabPUuc31gpN1DOeUxYrzfyYf49KCSee88Lj5ZB7A/Pj8LtoOY+UgGWfrNBXQc25cB5
         WYEA==
X-Gm-Message-State: AOJu0YwDcAQ7BO/tkyDw+8rMcLeY0PuPEBkU2FoL8oMMi3A4ze1joXY3
	qFCJ9xqa615MIY9si+jwU15QkEiCeBCK96bzEtn8Qu2H3YOpDQt9V6N8nMYgw1LzwXMqb113UYm
	hB3dDnyDoy6OtRHgBUkw2yEB8bBQ=
X-Gm-Gg: ASbGncst8CzrxEa8PDL+U9qy9TAmWkD4JJy56T9iZPa6Ts+xjLzQtF1IHNZDTY43EQI
	CB7kcsL14K3KMmPIPBJTjVaZgNv6S2gdApDuS2uXnrIraFIoOEcnwk3Fb1B48wUQM
X-Google-Smtp-Source: AGHT+IEKoBP/hwxCS2r5Cme2jTJ9w3hpEmbfMkwgYaZEXE6gGaKr4V+jRZB45dn4HcO2hZWVk7t+TwY0/7e4XgK6tRE=
X-Received: by 2002:a17:903:11ce:b0:216:4339:70f with SMTP id
 d9443c01a7336-21d79afb1bdmr133321435ad.8.1738012731099; Mon, 27 Jan 2025
 13:18:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAAiJnjojkqPOE9B1NH3F05znW8bGGMK+OMChXXaexHXJP63Few@mail.gmail.com>
In-Reply-To: <CAAiJnjojkqPOE9B1NH3F05znW8bGGMK+OMChXXaexHXJP63Few@mail.gmail.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Mon, 27 Jan 2025 22:18:39 +0100
X-Gm-Features: AWEUYZm8b-pXdVT2iIfcPcBrS88rFOjRd0gL_fGJ8c0N0Aqz6UUe0WgF2X8sKcI
Message-ID: <CALtW_ahaops_C1XikG1iGOTF47ZC3aVo973vTW1-15DSijvvYg@mail.gmail.com>
Subject: Re: Add spare disk to raid50
To: Anton Gavriliuk <antosha20xx@gmail.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Read the man page (spare-group parameter), mdadm allows for one spare
drive to be used
for multiple arrays.

On Mon, 27 Jan 2025 at 15:15, Anton Gavriliuk <antosha20xx@gmail.com> wrote:
>
> How to add a spare disk to raid50 which consists of several raid5
> (7+1) ? It would be more economical and flexible than adding spare
> disks to each raid5 in raid50.
>
> Anton
>
