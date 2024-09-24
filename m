Received: from mail-yw1-f170.google.com (mail-yw1-f170.google.com [209.85.128.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E1313D89D
	for <linux-raid@vger.kernel.org>; Tue, 24 Sep 2024 22:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727215792; cv=none; b=bQ8DMoOCS7ySbpDGgcuRbeX5BE7A5lBpibJwB7fxMy4JhzagZ5v/1qq6lqbTWrjv7w2ek0tc+bG/vrdIvmFaVkRTLsqH1Vriux7a/8SbLiVuKYU/wZOhczuSsXASSWjPU+NxzVRUSuTLUf3TqJbBDiarQz3lFDjLE2FogAImvuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727215792; c=relaxed/simple;
	bh=yUuubDs1X31K6/OuACUCFBdGE58Iwh8MNfMwQaAE/+A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Bzy5+l2rPnh69c4RNUHnFfWJQX6DmddZsG8z8gdN3UxuyNVqXQN0H7O80fDLny+kK71Cmh0XbpkPtWM8JhAvfZroszsIxwu927wAUR/r8iufHJnw3Q9hK4tn87sKbKy24uzw3Apuh2nHz0fSw7nmuOJMtnb/q6Wz6vExeeajnHw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LskUejFQ; arc=none smtp.client-ip=209.85.128.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LskUejFQ"
Received: by mail-yw1-f170.google.com with SMTP id 00721157ae682-6d6891012d5so48478957b3.2
        for <linux-raid@vger.kernel.org>; Tue, 24 Sep 2024 15:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727215789; x=1727820589; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=X9LASmECBi8iFji9RYjH2oRH/grngsfAhZQCcg33zAg=;
        b=LskUejFQaPZWEN0e+ela0m2ZPbpz6dNm/qEQq+7iMdxEQBOK+kwqvP1Pttqdh+MLQR
         ECDwEV505Mdb1xq13P8mGHB2bu9HbsbLq+HxIUht9hLK+C/vaRPkpZpdJDqw1tEVWoHO
         6vXHylMlXNKrhLrSTplT9/OFBsnHJS/T23xey29wRHlHyZZvGj+myquugbjJwB6xMAjd
         Ul7GXuxKbnSRdVMj8w3zmM/NFGO/QqV+p4khZ7LHqLFQdtBlxi5f9bPBsrndPTv+XH5I
         A1RJdJTAVp673jNJGgI8oqrwCtONIkglKXd1r/lwpIA2ogKRbyUuwBBxr/JQI/hyFRKy
         acGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727215789; x=1727820589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X9LASmECBi8iFji9RYjH2oRH/grngsfAhZQCcg33zAg=;
        b=M4bcuA29RxJyYYxP+NSTGO2kJORjPGf8E8knQrPTktgH+gDF0qTP+GSVqffPLje7xm
         QbffbwNMm81mbD2mQaAwNLdam9CjS3vot8dQe0juHXQopry50b7MtczoI/YOUEafLEfg
         rzfa3bhTT09/OMdX94jgbJdTlmyijODvshklXyRerJvQJ0siTm4B7jNwdmoH9MlvZLx4
         pMXhVQX+PCa3YLlQqpwwQ660XpmVUO2z/l7oTh7Ip6tu++XZOFz2EBoNDI7Lt7ocOhY9
         v5VCFC4d8tN5H6bLR3S0TWKAYS+XDbsgrh7eoqizh4gwteOoLd5ryOg3oSP5BUETrURN
         XrOA==
X-Forwarded-Encrypted: i=1; AJvYcCVwId4MImFmSIyU9d+Q2luZ+/2del8AZIRg0EAwJW8KEX+/yyIrswH81n1XS1sBZ7bE4qDLVtuVc/+I@vger.kernel.org
X-Gm-Message-State: AOJu0YzvDxQFMlo8YYiWSb5RslRX0cw0SKCd9qhOfPOi9JW0LGPFStpT
	tOFN5mHAKkqLhwyyZzcSArTfIgaPQRPcCGZcat0EfV5VSb78qahPQoI/nFjIOTBO8vzTfJSAT0Z
	Vi1rH4ZzmtDMQOlHjwcVz2BppZkQ=
X-Google-Smtp-Source: AGHT+IGTB7paOdrVr+FcWEW5Q5XCNKwa/KqqKDLx5D6zkYT9FM2NAcH21k2GGphJqrg30WGec0BRcRoeOF+FiGMSZj8=
X-Received: by 2002:a05:690c:3:b0:6b1:8834:1588 with SMTP id
 00721157ae682-6e21d9bb582mr11100177b3.35.1727215789446; Tue, 24 Sep 2024
 15:09:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALc6PW6XU07kE7fyWzCnLXdDWs0UDGF6peg=kxxicATGB73wJw@mail.gmail.com>
 <CALc6PW6XayCCkRHK=okVJs13Vy-XSFjBEixCvSVjYdYy6AK-gA@mail.gmail.com>
 <16a80dd3-6bdb-16bb-ec72-0994a3344a86@huaweicloud.com> <CALc6PW4GYKSZmMZwfT8_-rgukoDX3jKSoXZUQm3Mjom9oQTeEA@mail.gmail.com>
 <CALc6PW5OMaU=E72rbL3DEi6O0a_3Ag0z3mnQsVxJ2R7rZM2nPQ@mail.gmail.com>
 <CALc6PW7Rb5nhT8f19nfj3Z+23qJr1ynaiE1b3rwm6=HUBnCrqQ@mail.gmail.com>
 <b118cf34-2957-65ed-761b-f999c4ff03fc@nuitari.net> <CALc6PW71Bzzvv+M+SmXYCCHjCA6cni5HcAMiRvP-v+dwXhz24A@mail.gmail.com>
 <0baa2f9a-68e9-92f5-962f-3ca1246638d2@nuitari.net>
In-Reply-To: <0baa2f9a-68e9-92f5-962f-3ca1246638d2@nuitari.net>
From: William Morgan <therealbrewer@gmail.com>
Date: Tue, 24 Sep 2024 17:09:38 -0500
Message-ID: <CALc6PW7K7h=ccyzGnWF0vWZaMPf8UJ=GshHsa-vKPD-ywnNY7g@mail.gmail.com>
Subject: Re: RAID 10 reshape is stuck - please help
To: Stephane Bakhos <nuitari-vger@nuitari.net>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid <linux-raid@vger.kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 23, 2024 at 11:19=E2=80=AFPM Stephane Bakhos
<nuitari-vger@nuitari.net> wrote:
>
> Check the following attributes:
>
> - Reallocated_Sector_Ct
> - Seek_Error_Rate
> - Current_Pending_Sector
> - Offline_Uncorrectable
> - Raw_Read_Error_Rate
>
> If any of these are increasing, its a sign of a dead drive. If
> the drive is taking a long time to time out from a surface defect it coul=
d
> be the cause.
>
> - UDMA_CRC_Error_Count
>
> That one is usually a sign of a bad cable.
>

Smart attributes look fine for all 10 drives. All values are above threshol=
d:

bill@bill-desk:~$ for i in {e..n}; do echo -e "\nsd$i\n" ; sudo
smartctl -x /dev/sd$i | grep
'ID\#\|Reallocated_\|Seek_Error\|Current_Pending\|Offline_Un\|Raw_Read\|UDM=
A']
; done

sde

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   073   064   044    -    21117259
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   082   060   045    -    170317463
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdf

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   079   064   044    -    71711229
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   082   060   045    -    171651865
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdg

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   067   064   044    -    4728851
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   082   060   045    -    173788681
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdh

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   080   064   044    -    96543092
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   082   060   045    -    175410482
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdi

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   082   064   044    -    143574742
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   075   060   045    -    30335787
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdj

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   073   064   044    -    17809062
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   064   060   045    -    2577528
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdk

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   072   064   044    -    17754175
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   064   060   045    -    2765316
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdl

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   073   064   044    -    17827863
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   064   060   045    -    2761597
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdm

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   080   064   044    -    104938805
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   076   060   045    -    41478011
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0

sdn

ID# ATTRIBUTE_NAME          FLAGS    VALUE WORST THRESH FAIL RAW_VALUE
  1 Raw_Read_Error_Rate     POSR--   081   064   044    -    116043252
  5 Reallocated_Sector_Ct   PO--CK   100   100   010    -    0
  7 Seek_Error_Rate         POSR--   076   060   045    -    41655990
197 Current_Pending_Sector  -O--C-   100   100   000    -    0
198 Offline_Uncorrectable   ----C-   100   100   000    -    0





> >> Are the components of md1 (the unrelated array) on a different hardwar=
e
> >> controller / wires?
> >
> > Same controller, but I see the same results even if I unplug md1.
>
> Have you tried replacing the cabling and the backplane?
>
> I'm not sure what layout you have, but something I'd try is to remove the
> drives for md1 and put the md127 drives in the place where the md1 were.
> It would help rule out that either is the issue.

I haven't tried replacing the cabling, but when I swap the cables
around between the two arrays, everything behaves the same way.
