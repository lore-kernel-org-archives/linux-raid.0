Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B3z9bjiu"
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04221B5
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 00:11:51 -0800 (PST)
Received: by mail-lf1-x12b.google.com with SMTP id 2adb3069b0e04-50abb83866bso5258782e87.3
        for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 00:11:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701072708; x=1701677508; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9N17GPQdTDc/+elv7ftN7CvD/tXDrPDW6Gu+3dhnFsw=;
        b=B3z9bjiuLX7x35fB2fd2T98XRx3JRH+tIXf/7NV3aLNgEHG1a0OanaPhcC5iDziH/M
         CyWVtLbNYPmwhY2mfRkmmIg2BC52stOlxrfNYV4O08oWUEqbnixV5acAfd9LuvYoaBxw
         nYPJ/wvGvkMxYia1MtvHl1fOQwNsDj7/DR6RILRbKo7ZhuxOMRvBUQdltoT11J/6Lz2R
         YLeNn4TPqu5XVCUztQY0q5iaCtA4dTflITzRSMNKsQwrfQCBlzNyoK19JyzJg73AFM7b
         bzhltnbPIquwnOkAmhIMvbRiARWgsTaXEFq4hRUyZnASBm0rnaKRWBAHcPIP41R5SKsy
         LEsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701072708; x=1701677508;
        h=to:subject:message-id:date:from:in-reply-to:references:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9N17GPQdTDc/+elv7ftN7CvD/tXDrPDW6Gu+3dhnFsw=;
        b=IND3FN2HjPLFopROb6K/ksYPwflXBqLcdCUyUL42fVS5VRZhAC6QZDQRCKKlLHwPcG
         YByuF0Fqx8MmdhBDk/irCZEihNir5Lca599NtHIK+j00gLJgeUAI9GfMzoVjchITHUiH
         VEwPVUkuAHwGGtbdspC9BIxStF/UpA75w/hDMEko04oMZMEj3knptbm7yTsEn1FBDW8Y
         9Ytcn+bdxg06Ep/JK50S8ridht04jv5i3drqfnA2kRAVZecm0ZuzuSOo/GNAUOYWfQwf
         lGOW8T5ZnJaRie5Fr2kBqTKxoYVZ5vlYztStK28xfEtAC+Phmit7iPwQK+wVSJPv8YG2
         bT/A==
X-Gm-Message-State: AOJu0Yykau2BSZKi2usKgD5+vXbs07jdoxkQpIkTvuEXwdRlXB0qT94V
	OgjDYkpV1Sfa3VgRp1o5BIQVO9kNU2TwAD19JNCHCQcUKcvQC6p+
X-Google-Smtp-Source: AGHT+IEETKyK2f2dx8YH11OZ2oeNMoPIXeUkDM1KzcXxCWER5PJvE/8+HXNLy3RABfGZYtc/KZOGhs8lLk5Mr8M8srQ=
X-Received: by 2002:a19:8c11:0:b0:50b:a818:f13f with SMTP id
 o17-20020a198c11000000b0050ba818f13fmr4204951lfd.64.1701072708420; Mon, 27
 Nov 2023 00:11:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
 <ZWMf+lg/CgRlxKtb@mail.bitfolk.com> <20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
 <d1ab59c2-e172-400d-8d6c-68f4bfce3a65@youngman.org.uk> <CAJH6TXiKLitvausMWgwZ_kNQbvp7sDA4AfaLvO2M54E7qLq8cg@mail.gmail.com>
 <20231127035237.3e7d78da@nvm> <CAJH6TXi2xc9o95qp_UfyyqSW=H2ssK-ZBvnfP3vpw89umoqD5A@mail.gmail.com>
In-Reply-To: <CAJH6TXi2xc9o95qp_UfyyqSW=H2ssK-ZBvnfP3vpw89umoqD5A@mail.gmail.com>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Mon, 27 Nov 2023 09:11:36 +0100
Message-ID: <CAJH6TXihycKVWNFYn9VLUG5_7rG6P-3ZQoJsVORPTCER1OQttQ@mail.gmail.com>
Subject: Re: SMR or SSD disks?
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

yes i know, but the most common SSD size is 1.92 , at least here in my country.

and the raid i have to upgrade is made with 2tb spinning disks.

(i don't have support for nvme on these old servers)

Il giorno lun 27 nov 2023 alle ore 00:08 Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> ha scritto:
>
> yes i know, but the most common SSD size is 1.92 , at least here in my country.
>
> and the raid i have to upgrade is made with 2tb spinning disks.
>
> (i don't have support for nvme on these old servers)
>
> Il dom 26 nov 2023, 23:52 Roman Mamedov <rm@romanrm.net> ha scritto:
>>
>> On Sun, 26 Nov 2023 23:22:51 +0100
>> Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com> wrote:
>>
>> > Il giorno dom 26 nov 2023 alle ore 13:22 Wols Lists
>> > <antlists@youngman.org.uk> ha scritto:
>> > > If you look at what SMR is, it's only relevant to spinning rust. It
>> > > relies on the fact that a read head can be much smaller than a write
>> > > head, so provided you shingle your writes (hence the name), you can
>> > > over-write half the previous track (so saving space) without rendering
>> > > the data unreadable.
>> >
>> > Thank you all.
>> > That's what i've thought but better stay safe than sorry so i've asked.
>> >
>> > In other words WD Red SSD are safe for a RAID, there is no need to change them
>> > (as mostly new) in both array (the grow was finished 1 hour ago: 2 WD
>> > Gold SATA 3.5 plus 1 WD RED SSD)
>> >
>> > Slowly, i'll replace all spinning disks with WD Red SSD
>> > I'm not a fan of WD, but 2TB disks able to replace a 2TB HDD are very
>> > very rare (the 1.92TB, much more common, can't replace a 2TB disk)
>>
>> There are three grades of capacity that you can get:
>> 1) ~1920 000 000 000 bytes
>> 2) ~2000 000 000 000 bytes
>> 3) ~2048 000 000 000 bytes
>>
>> Nobody is marketing the 1st variant as "2TB", you will find "1920G" on the
>> packaging and datasheets instead.
>>
>> 2nd one should be able to replace an HDD, unless there's some smaller
>> discrepancy in the sizes near the 2 billion byte mark between HDDs and SSDs. A
>> reason to use smaller-than-whole-disk partitions for your RAID.
>>
>> 3rd is not a common sight in SATA SSDs (but still happens), and is nearly
>> universal in NVMe. Of about ten "2 TB" NVMe models I've tested, only one had
>> 2000, *all* others were 2048. The 2000 one was Netac NV7000.
>>
>> --
>> With respect,
>> Roman
