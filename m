Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD2721B960
	for <linux-raid@vger.kernel.org>; Sat, 10 Aug 2024 00:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723250244; cv=none; b=d3sp8lPSZ93URlAZ/lqDCJd5dbu+FpAoxE5ipnSsRhT9aUbcB6Az0JxiQegzox2Qc2izJTw1Zn8GwMkMOdqdjGJ/9DyzsIvRBElcITq6FyEP0XQMgYUNUCSul1aZyDaDWqliX1sAB0xnHGSk8/A0jEE3Sc1E1QDNuNRZkHBMfko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723250244; c=relaxed/simple;
	bh=Xh8cF8qExRBUyiI3lZJM4kktTLfIrc8kR54WY1ciCOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MK7Vx98KALXZExS+ONi5lWCSJYPVvQXaKpfoZ9LMuqti2Kc5V9a3IwF9Yh/0Jrg83m1RbBNVB9XD2IscIfqKb9W54cZvHtyb14ctlksNAZUfmzCbM9LwL0Lm3usIPte76ZzIvDcCWdy/tzxrDQcFVVtyikxsl+yh43s5lAFiS6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MTSa/KoF; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTSa/KoF"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-39b51ba15dbso9670305ab.2
        for <linux-raid@vger.kernel.org>; Fri, 09 Aug 2024 17:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723250241; x=1723855041; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7kea2BQLeoix2YY9uliaiBKw4kLMe3Dq9xxgf4S60K8=;
        b=MTSa/KoFxhJqNbf7BIL0yF3l8utPTH3nHelC1Y0xntrtnA9VgofSgQ78PCPKBTnAiu
         qpNMaho+KLcy46rEPn9REVW1Cgh/SymDKwk1ymsclr+1irKAsXbYkG4ESKRm5wGKii48
         ocA1GIJZ7Gu44ZhPuaHCyhsNSfdxj2xPN/IsRzwl1Vz7jns8UZglWhZRM8BJ0bSiNSyH
         xA6v2U9DeHDYX57Af49RJKl9YL2HOx7sJiZlOP0apF5dTAhQQbagcT1ApD205ZTEkGpr
         dKD8VqqEzxeg8ReUvL1xo4064GRuOk2lSxAXOJSzBVkNEHSX9T11IRMXop+739fmd9YA
         GCyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723250241; x=1723855041;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7kea2BQLeoix2YY9uliaiBKw4kLMe3Dq9xxgf4S60K8=;
        b=cxkWJKndAk1hFtM7LKFj77Nc+HqhmOcSENnsAEt3PLx5ofFArHBuaYgMdjYXn0ZH64
         oRXinMSb43W0gsw8lMYUUvKSHo5UYsYeDAqvQFwTJbVW7YOrM6WCenfZO2AayqNO6yWs
         bN/oSTxf9wqGPF9r0e43xzdYHgJCUZQDEiztRLr+W55Fwc+lsvq63aQTGe3TeS5M1yzA
         tZJ0f19Yo/yteqSEAN9PMA1lpjnMpJtYHOclLyCmAY6TjzEfIJ5B9Dg+M9j+DGhYgOFA
         RR8B1saLF4sBF3uvI9Pieq50YBkynh1YS0mojm6c5MgTEOlv0C1ek8PFwKCcI3bSBBdG
         xUCg==
X-Forwarded-Encrypted: i=1; AJvYcCUy1MhoEkulMazbOEBzI5d45LVxZLkeOxhfYy6qR2Jsvpd1y7g/YJgN6dBeapYJCRXuM8RX0OZGUyYWszp4iO81ETQOWggDXjLDCw==
X-Gm-Message-State: AOJu0YzNEPnepzYBwn9FjiqACZ2G42VhVRBFQOh0NTZBpD84Siv8qPog
	FRZKbbJuThS9Gga0PP3hEQg0L7Gf5eLIMy6FHxgsBvEWz65SjSChe2RbsJPBCWFb+lNeVzPNGGx
	OsYrC9ujnZFxZl+UtZgHN4FILWsw=
X-Google-Smtp-Source: AGHT+IHKqLeixS3+Mag3Yk6PRGO6lg9p6yF0aFwjudAhYH8p8v4/yPrB8fXoamOz+1twJjlhX/jCX0JDMcFsNr+a8gA=
X-Received: by 2002:a05:6e02:1a65:b0:39a:ea6a:9a82 with SMTP id
 e9e14a558f8ab-39b7a41e62amr49358445ab.13.1723250240591; Fri, 09 Aug 2024
 17:37:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com>
 <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com>
 <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com>
 <CAAMCDec8F0CjT9Sz77uE7uVjN87YTbUPte5fY67_244gOfKTwA@mail.gmail.com>
 <CAEWy8Swxj-RFZ=kya=ECYJLqX3a1-HysRRDXNvw70Go8v0Ou4A@mail.gmail.com>
 <CAAMCDefBkSsF4ZPOtWmsT2UieM-Obvovxud1U7-DbAk2CMx-SA@mail.gmail.com>
 <CAEWy8Syh+eMq_5-gTsLoXkT5LqVE4AUJWMGzVpRjS3pzF+YYyQ@mail.gmail.com>
 <CAEWy8SwZ6jgVpUr5_BgA5q9J6GK9brRkPqAat+WPK7PcRYs55w@mail.gmail.com>
 <4c4b4ddb-b607-4c89-9b4d-2c400a0ac25a@plouf.fr.eu.org> <4E85ED2F-4B9E-4E82-A006-A4BFD66DBC87@lambdal.com>
In-Reply-To: <4E85ED2F-4B9E-4E82-A006-A4BFD66DBC87@lambdal.com>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 9 Aug 2024 19:37:09 -0500
Message-ID: <CAAMCDed-pHOvLQzHKKtwumT_LY5k2BSvC+0zTTiZ+eqjUejT4A@mail.gmail.com>
Subject: Re: RAID missing post reboot
To: Ryan England <ryan.england@lambdal.com>
Cc: Pascal Hambourg <pascal@plouf.fr.eu.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I may be mis-reading what a partition looks like on nvme.   if nvme0n1
is the whole device, then you probably want a partition.  I

You can run it without a partition but there have been some events as
Pascal notes that may be because there is an empty/broken GPT
partition on the device and the bios/EFI "fixes" it, overwriting some
data.

The original report showed that on nvme0n1p1 there as appeared to be a
gpt partition table.

From this:
mdadm --examine /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1

/dev/nvme0n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
1 (type ee)
/dev/nvme1n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
1 (type ee)
/dev/nvme2n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
1 (type ee)

The above output seems to indicate a gpt partition table on nvme2n1p1
if I am reading that right, and that is on what should be the md
devices.

On Fri, Aug 9, 2024 at 7:25=E2=80=AFPM Ryan England <ryan.england@lambdal.c=
om> wrote:
>
> Hello Pascal,
>
> Thank you for the update. I appreciate you contributing to the conversati=
on.
>
> Why wouldn't you use the entire disk? What are the risks? I've seen mixed=
 info on this. Some use the entire disk and others use partitions.
>
> You also mentioned using wipefs to wipe the metadata. Would you run the f=
ollowing:
> - wipefs -a /dev/nvme0n1*
> - etc
>
> Regards,
> Ryan E.
>
>
> On August 9, 2024 6:28:10 PM EDT, Pascal Hambourg <pascal@plouf.fr.eu.org=
> wrote:
>>
>> On 09/08/2024 at 23:36, Ryan England wrote:
>>>
>>>
>>> I was able to set some time aside to work on the system today. I used
>>> parted to remove the partitions.
>>>
>>> Once the partitions were removed, I created the array as RAID5 using
>>> /dev/nvme0n1, /dev/nvme1n1, and /dev/nvme2n1. Including my commands
>>> below:
>>> - parted /dev/nvme0n1 - print, rm 1, quit
>>> - parted /dev/nvme1n1 - print, rm 1, quit
>>> - parted /dev/nvme2n1 - print, rm 1, quit
>>
>>
>> If you are going to use whole (unpartitioned) drives as RAID members (wh=
ich I do not recommend), then you must not only remove the partitions but a=
ll partition table metadata. wipefs comes in handy. Else some parts of your=
 system may be confused by the remaining partition table metadata and even =
"restore" the primary GPT partition table from the backup partition table, =
overwriting RAID metadata.
