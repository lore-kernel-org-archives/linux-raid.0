Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227D71C695
	for <linux-raid@vger.kernel.org>; Sat, 10 Aug 2024 00:29:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723249780; cv=none; b=j9xYPPrtmWvWH9hCekcFcE0utk/GxqtONmfm65s6mugHp5JVwPN1OkC5OrokHAIGGQNnW1zkwd9IoQoyvJPtxvwVjrOGtAbqFJTEfzWnA9G9Ln8TN+gPzpd3n3PioLdvbOTvHpWQ7jWDcTY2+eT3P59/ddrq0Dn7oc6p8F1y5qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723249780; c=relaxed/simple;
	bh=/9gC/ikOX407DuNnRaH+NPd/ibquKutfM4YJQX7kXb8=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=brlnafO6hyzTGDu7PBU2zyb1KrNXnumouYeGaI0FQEYUFBdhigtcYPkyUpowWNgWAXlzj7cQtcbVokp2NLh5i9YyAb5RLe3Xk9ZBP1iVcjp+5yFeDoGFDECa0iUBQOeQ85sixQWSj18v3GR6m1V8aeUDb2zRi51IEQ5PIuERgLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lambdal.com; spf=pass smtp.mailfrom=lambdal.com; dkim=pass (1024-bit key) header.d=lambdal.com header.i=@lambdal.com header.b=Y8vruCQI; arc=none smtp.client-ip=209.85.219.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lambdal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lambdal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lambdal.com header.i=@lambdal.com header.b="Y8vruCQI"
Received: by mail-yb1-f179.google.com with SMTP id 3f1490d57ef6-e0bf9602db6so2665391276.1
        for <linux-raid@vger.kernel.org>; Fri, 09 Aug 2024 17:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lambdal.com; s=google; t=1723249777; x=1723854577; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=/9gC/ikOX407DuNnRaH+NPd/ibquKutfM4YJQX7kXb8=;
        b=Y8vruCQIXROvCTfKjBSsqNLWPXEfwCbf5T5AHuOyMrjfKuggSHto2glOvO360XxXRQ
         2kq+Hc1zgHcP9+cQBd578TRUS1aDHb0Bj0ITuhGW+sPyqUk4CJhqFvFMiXKGqeU+Bp+n
         NlopqAzZhVxnIOrAbA31ejEN49k8BGU90Id4s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723249777; x=1723854577;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/9gC/ikOX407DuNnRaH+NPd/ibquKutfM4YJQX7kXb8=;
        b=bAfgitmPBLwKCmhq++VRZF6wnYhNp3+Vfk20ao+22BOKxGXOSDxcFevnFOenOc/vQC
         vRCzmFzOiYaVSTNOVIsiIXLxfeJrVrEmsGYisdb4VhisA4PH7ktt8vw/anJMW1+JrSDf
         uCB2EjQU46s6QLNKI40TpYzCnqyPh9y+i1YjKZKl+VrpVYEWjDTOnbycQ06k79HuYbuv
         wQkUzEVbB/0nHoOsGp3JWwMFfQi4+PNvkyXTMNmeqSnPF094vbzLURoLHI4uEPtd7KJo
         JUKZyIvOXwsrvVrGYA4LzAqVUGbY9a9ZH6LsnZsQeJV8Wi12hukjvqmLULdofQgNvvVv
         ZdiA==
X-Gm-Message-State: AOJu0YxclREzPZC9vrHfNtEQCXuKwDkZFT+6qUaifx79s/13y0HR1N6R
	DD2Y5WW4mchOy22AE0NsiH3nNCdvJMn0dLevxJf/qXAOPpZBiLmF/ZGeQ8a00Uc=
X-Google-Smtp-Source: AGHT+IHAmgnCreMyt3R4ur4p6YxAxvJ4mMWlg3D5JJLcq9kmSLviykmxLOVLSLtkKWzJ/RnPfsEIiQ==
X-Received: by 2002:a05:6902:a05:b0:e02:c6fe:aea2 with SMTP id 3f1490d57ef6-e0eb9904126mr4295800276.7.1723249777060;
        Fri, 09 Aug 2024 17:29:37 -0700 (PDT)
Received: from [127.0.0.1] (syn-173-092-044-022.res.spectrum.com. [173.92.44.22])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7a4c7e04175sm24392685a.112.2024.08.09.17.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 17:29:36 -0700 (PDT)
Date: Fri, 09 Aug 2024 20:29:34 -0400
From: Ryan England <ryan.england@lambdal.com>
To: Pascal Hambourg <pascal@plouf.fr.eu.org>,
 Roger Heflin <rogerheflin@gmail.com>
CC: linux-raid@vger.kernel.org
Subject: Re: RAID missing post reboot
User-Agent: K-9 Mail for Android
In-Reply-To: <4c4b4ddb-b607-4c89-9b4d-2c400a0ac25a@plouf.fr.eu.org>
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com> <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com> <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com> <CAAMCDec8F0CjT9Sz77uE7uVjN87YTbUPte5fY67_244gOfKTwA@mail.gmail.com> <CAEWy8Swxj-RFZ=kya=ECYJLqX3a1-HysRRDXNvw70Go8v0Ou4A@mail.gmail.com> <CAAMCDefBkSsF4ZPOtWmsT2UieM-Obvovxud1U7-DbAk2CMx-SA@mail.gmail.com> <CAEWy8Syh+eMq_5-gTsLoXkT5LqVE4AUJWMGzVpRjS3pzF+YYyQ@mail.gmail.com> <CAEWy8SwZ6jgVpUr5_BgA5q9J6GK9brRkPqAat+WPK7PcRYs55w@mail.gmail.com> <4c4b4ddb-b607-4c89-9b4d-2c400a0ac25a@plouf.fr.eu.org>
Message-ID: <936B277A-F68A-4385-9686-E3EBFA828375@lambdal.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello Pascal,

Thank you for the update=2E I appreciate you contributing to the conversat=
ion=2E

Why wouldn't you use the entire disk? What are the risks? I've seen mixed =
info on this=2E Some use the entire disk and others use partitions=2E

You also mentioned using wipefs to wipe the metadata=2E Would you run the =
following:
- wipefs -a /dev/nvme0n1*
- etc

Regards,
Ryan E=2E

On August 9, 2024 6:28:10 PM EDT, Pascal Hambourg <pascal@plouf=2Efr=2Eeu=
=2Eorg> wrote:
>On 09/08/2024 at 23:36, Ryan England wrote:
>>=20
>> I was able to set some time aside to work on the system today=2E I used
>> parted to remove the partitions=2E
>>=20
>> Once the partitions were removed, I created the array as RAID5 using
>> /dev/nvme0n1, /dev/nvme1n1, and /dev/nvme2n1=2E Including my commands
>> below:
>> - parted /dev/nvme0n1 - print, rm 1, quit
>> - parted /dev/nvme1n1 - print, rm 1, quit
>> - parted /dev/nvme2n1 - print, rm 1, quit
>
>If you are going to use whole (unpartitioned) drives as RAID members (whi=
ch I do not recommend), then you must not only remove the partitions but al=
l partition table metadata=2E wipefs comes in handy=2E Else some parts of y=
our system may be confused by the remaining partition table metadata and ev=
en "restore" the primary GPT partition table from the backup partition tabl=
e, overwriting RAID metadata=2E
