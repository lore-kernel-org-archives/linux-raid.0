Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6111F1DA58
	for <linux-raid@vger.kernel.org>; Sat, 10 Aug 2024 01:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723251830; cv=none; b=c+fXB7pJY/4pCC4fXa41q5pND8BqPTsKjlwgDHvgEZYEDoWjfKdjoCi5gg+zNbR+A2CiLGMKywsO2Qrfg+kHsOKcM3lbOD3EuRAMEOK9x9aAJAnAPA3grhxvxh1E/oR0HpZJ+GPJknF6OEyKZEMDzGLCGGmNWxkXYjgLd/4Bb5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723251830; c=relaxed/simple;
	bh=H3tVVypeeAnw4MoPh5ZAlANejBgs53IZmmQeg+tNIJI=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=KltXIpZY9QKJUx9wh11f2Kwq3xnA2HYfu5WlvCTh7RUfZEE9C1GgkPGYtHmMcAOgW18/XAz6zGEIxWUlBJnsuDSUohYFVICT6BrtnRJKPXJcA8hx8kRKtwKaeuAUzqySpxz1cA6r+Bm4fbHbFQGycIoyJe4FcOWSulhq548Ntcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lambdal.com; spf=pass smtp.mailfrom=lambdal.com; dkim=pass (1024-bit key) header.d=lambdal.com header.i=@lambdal.com header.b=HGtBUfZX; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lambdal.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lambdal.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lambdal.com header.i=@lambdal.com header.b="HGtBUfZX"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-6bb987d3a98so14747236d6.1
        for <linux-raid@vger.kernel.org>; Fri, 09 Aug 2024 18:03:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lambdal.com; s=google; t=1723251827; x=1723856627; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hszSBLGumRd/r3IGOzJGxrVFn24q/QnqgKnZJccBDAM=;
        b=HGtBUfZXmAj56EAt1+jgcD2Gbak24nz/riugKjVjo3n/WiTZN2QaykIks4aRR6mu70
         RvP/dUsUUABMb8hu3Ep482RdKWWegcKGHSjPb3SO5NRipfG8i8E6hs9KVhx9hONOnt6u
         Wc59T7uiDFtH2OBqfQKy5deXhc6okKzw54hQY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723251827; x=1723856627;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hszSBLGumRd/r3IGOzJGxrVFn24q/QnqgKnZJccBDAM=;
        b=wiUa1C0jInM0lAp9qSQvCR+lr0eACUlLCZpJZBdF8RJ4eYGutUWhygXwTbxXTjaVdA
         DcDw9sI8wZ38c8LZsCMFYPZt1qq2uBTyJgkeGWjrNE0n/zkZ8iBCMBzKE0vGH4HGu/wX
         nXEreZ1wrLDjJ+pfSsWefuRpTHhc3ZhqbYx4pzxutyYW0gEqbDnDuu2uoLrSloWpffV3
         mrVI1w615/QbyKYwhZ7FOrgCkoytnYet0a/3iJ2kooTNV6VUOeXPoARHXYFZLknbn4nu
         OY8jYq0yjzDrn3cAnA1D1sRMgmucxgDHnoIeoXu3/H0DUNVMJVak7nwk5UpaheGqoMxQ
         cW7g==
X-Forwarded-Encrypted: i=1; AJvYcCU/LEcAaengxcRw53EdwglAPU+ucujWPb8gUZD9ei+j28nM8bUPntWN/nkMvF9P+H4QQjdOGd+jXaWt@vger.kernel.org
X-Gm-Message-State: AOJu0Yzer3vaJl+UcF9CV9JkY4oQKG6oF9nKHlbkvabKKRh0l7wXYYKg
	HlfGzrA2RmFDLhdUyUlbzGdbRKPmpAmwmJ+pukIEZoHsTg4nYmc2OKHvfdUkCJg=
X-Google-Smtp-Source: AGHT+IFB9L6xNf8PyLwWD3T7947/s1EknH6GtkWr73EZgi12v4AUOqUEp+p5Ue/AKHbf6xAnwvA5XQ==
X-Received: by 2002:a05:6214:3381:b0:6bb:9b66:f262 with SMTP id 6a1803df08f44-6bd78ec7d10mr41861636d6.41.1723251827049;
        Fri, 09 Aug 2024 18:03:47 -0700 (PDT)
Received: from [127.0.0.1] (syn-173-092-044-022.res.spectrum.com. [173.92.44.22])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-6bd82e53e89sm2910666d6.111.2024.08.09.18.03.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 18:03:46 -0700 (PDT)
Date: Fri, 09 Aug 2024 21:03:41 -0400
From: Ryan England <ryan.england@lambdal.com>
To: Roger Heflin <rogerheflin@gmail.com>
CC: Pascal Hambourg <pascal@plouf.fr.eu.org>, linux-raid@vger.kernel.org
Subject: Re: RAID missing post reboot
User-Agent: K-9 Mail for Android
In-Reply-To: <CAAMCDed-pHOvLQzHKKtwumT_LY5k2BSvC+0zTTiZ+eqjUejT4A@mail.gmail.com>
References: <CAEWy8SyOXqk+CYu_8HV-R_bRa8WRVYUu_DhU8=RfZevZZGMRHA@mail.gmail.com> <CAAMCDeeTZrP-VGz2sqaCS5JtETK0DHydXT0qwE=cbQ5eQDg1Dg@mail.gmail.com> <CAEWy8SwvaTd3WvD3rKn9dGkLozAOnZEjpMF09nhESd4KpYCbvQ@mail.gmail.com> <CAAMCDec8F0CjT9Sz77uE7uVjN87YTbUPte5fY67_244gOfKTwA@mail.gmail.com> <CAEWy8Swxj-RFZ=kya=ECYJLqX3a1-HysRRDXNvw70Go8v0Ou4A@mail.gmail.com> <CAAMCDefBkSsF4ZPOtWmsT2UieM-Obvovxud1U7-DbAk2CMx-SA@mail.gmail.com> <CAEWy8Syh+eMq_5-gTsLoXkT5LqVE4AUJWMGzVpRjS3pzF+YYyQ@mail.gmail.com> <CAEWy8SwZ6jgVpUr5_BgA5q9J6GK9brRkPqAat+WPK7PcRYs55w@mail.gmail.com> <4c4b4ddb-b607-4c89-9b4d-2c400a0ac25a@plouf.fr.eu.org> <4E85ED2F-4B9E-4E82-A006-A4BFD66DBC87@lambdal.com> <CAAMCDed-pHOvLQzHKKtwumT_LY5k2BSvC+0zTTiZ+eqjUejT4A@mail.gmail.com>
Message-ID: <6C9556F9-2915-4680-AC81-FEE0460B8E71@lambdal.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Is there any good documentation available for md? I'd like to be confident =
we're setting this up correctly=2E=20

The rest of my comments are inline=2E=20

On August 9, 2024 8:37:09 PM EDT, Roger Heflin <rogerheflin@gmail=2Ecom> w=
rote:
>I may be mis-reading what a partition looks like on nvme=2E   if nvme0n1
>is the whole device, then you probably want a partition=2E  I

How would you use parted to create a partition you would use for software =
RAID?

>You can run it without a partition but there have been some events as
>Pascal notes that may be because there is an empty/broken GPT
>partition on the device and the bios/EFI "fixes" it, overwriting some
>data=2E
>
>The original report showed that on nvme0n1p1 there as appeared to be a
>gpt partition table=2E
>
>From this:
>mdadm --examine /dev/nvme0n1p1 /dev/nvme1n1p1 /dev/nvme2n1p1
>
>/dev/nvme0n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
>1 (type ee)
>/dev/nvme1n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
>1 (type ee)
>/dev/nvme2n1p1: MBR Magic : aa55 Partition[0] : 4294967295 sectors at
>1 (type ee)
>
>The above output seems to indicate a gpt partition table on nvme2n1p1
>if I am reading that right, and that is on what should be the md
>devices=2E

That's correct=2E It reads as a gpt partition on nvme2n1p1=2E That should =
be where the md is located=2E=20

>On Fri, Aug 9, 2024 at 7:25=E2=80=AFPM Ryan England <ryan=2Eengland@lambd=
al=2Ecom> wrote:
>>
>> Hello Pascal,
>>
>> Thank you for the update=2E I appreciate you contributing to the conver=
sation=2E
>>
>> Why wouldn't you use the entire disk? What are the risks? I've seen mix=
ed info on this=2E Some use the entire disk and others use partitions=2E
>>
>> You also mentioned using wipefs to wipe the metadata=2E Would you run t=
he following:
>> - wipefs -a /dev/nvme0n1*
>> - etc
>>
>> Regards,
>> Ryan E=2E
>>
>>
>> On August 9, 2024 6:28:10 PM EDT, Pascal Hambourg <pascal@plouf=2Efr=2E=
eu=2Eorg> wrote:
>>>
>>> On 09/08/2024 at 23:36, Ryan England wrote:
>>>>
>>>>
>>>> I was able to set some time aside to work on the system today=2E I us=
ed
>>>> parted to remove the partitions=2E
>>>>
>>>> Once the partitions were removed, I created the array as RAID5 using
>>>> /dev/nvme0n1, /dev/nvme1n1, and /dev/nvme2n1=2E Including my commands
>>>> below:
>>>> - parted /dev/nvme0n1 - print, rm 1, quit
>>>> - parted /dev/nvme1n1 - print, rm 1, quit
>>>> - parted /dev/nvme2n1 - print, rm 1, quit
>>>
>>>
>>> If you are going to use whole (unpartitioned) drives as RAID members (=
which I do not recommend), then you must not only remove the partitions but=
 all partition table metadata=2E wipefs comes in handy=2E Else some parts o=
f your system may be confused by the remaining partition table metadata and=
 even "restore" the primary GPT partition table from the backup partition t=
able, overwriting RAID metadata=2E
