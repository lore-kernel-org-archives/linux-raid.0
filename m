Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jpG56rQj"
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E39EED
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 14:23:05 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a640c23a62f3a-a002562bd8bso695272766b.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 14:23:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701037384; x=1701642184; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=YKGODCjDulMw7Gv1hSQ3exWgfERP++4kMDBNJ7L4MQk=;
        b=jpG56rQjY9JoWPbV/fBnVrov1L5Q96I21ePACiqqP88YE1FBEQfA0dOFV1u5hmd5Le
         lZVRR4cDBzI7U8k5MxnJ1xXnIH4/4Zk3EFXwDwf40Lz3M8OBnyaVw75aet+FySRkc6XL
         nvcmbuMJV1LmkmmcG64u1auNmihknaIMZe/QKREx+GUQgtO6Jra9XUOareQwjIIddwuW
         1h2F2YTYur/joRhha72g1Rg0MvZAkS/Z98jGTCCBas1XNQ3shg/eqnuxU4xaGjn/gENy
         /bHOI9hOaxxQ+/laGPwrcCLelTd4XUHq0wGvVF9llM1qDnqnQhQS733iKWJVjoQFb983
         ziNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701037384; x=1701642184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YKGODCjDulMw7Gv1hSQ3exWgfERP++4kMDBNJ7L4MQk=;
        b=CyOuZ/vzsf0nJ8p59DyAT2Bnq1pbKV6NSa9zxLemDDXd2J5kOS2iqzlw13XdrDgHGd
         cAvDXxFS6UXNJqcxAW31DnAFi1ukBZXhTLQybna+Cwj0cjlxa3H2ZeQDJei6OSp+fYCF
         psJRDnsJ+QkWDzQh0az8Gc/xmsNyXe494I7L0zNFWgiDu9clV0Z9OlZL9qo5m0SUIE97
         44eawCWJHPtNH4AuYOUa6zMk3Ue+6cCx97wlEYSVYrP39MJ1PvvQ2Q7EyIdPMl0RA1th
         iZyNDT/o+X0MsCEdGQ0YuZkUximG7yxolISXDHnu2e8mREj65Rpc0jPTAoJ4AUHzDmN2
         ZVsw==
X-Gm-Message-State: AOJu0Yymn3xWUxDRw/xPfgomvTRxW0DjrTKm9xGwi0TpkfE6SbHLVFTh
	phSQ9Wbc66U3dQ1/u8+kSjeaPvfAeFHpcI5d7gcTNRD4iAMAgg==
X-Google-Smtp-Source: AGHT+IHUO45KsOXXpt/yM8ZDuWr1wemq3pEutMi4v7vbfVMRc8Sxtywbt+ARTBqtxmwyhcGC9OJRrS2ac2oAgqDHTG8=
X-Received: by 2002:a17:906:748a:b0:9ee:295:5696 with SMTP id
 e10-20020a170906748a00b009ee02955696mr10968575ejl.2.1701037383866; Sun, 26
 Nov 2023 14:23:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJH6TXh-FB0HaCJGFKHHgzaSqh+cQefPsK45Y_UBTsrcxaa6ww@mail.gmail.com>
 <ZWMf+lg/CgRlxKtb@mail.bitfolk.com> <20938de4-65f2-4bab-90c0-018fe485c0e7@suse.de>
 <d1ab59c2-e172-400d-8d6c-68f4bfce3a65@youngman.org.uk>
In-Reply-To: <d1ab59c2-e172-400d-8d6c-68f4bfce3a65@youngman.org.uk>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Sun, 26 Nov 2023 23:22:51 +0100
Message-ID: <CAJH6TXiKLitvausMWgwZ_kNQbvp7sDA4AfaLvO2M54E7qLq8cg@mail.gmail.com>
Subject: Re: SMR or SSD disks?
To: Wols Lists <antlists@youngman.org.uk>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il giorno dom 26 nov 2023 alle ore 13:22 Wols Lists
<antlists@youngman.org.uk> ha scritto:
> If you look at what SMR is, it's only relevant to spinning rust. It
> relies on the fact that a read head can be much smaller than a write
> head, so provided you shingle your writes (hence the name), you can
> over-write half the previous track (so saving space) without rendering
> the data unreadable.

Thank you all.
That's what i've thought but better stay safe than sorry so i've asked.

In other words WD Red SSD are safe for a RAID, there is no need to change them
(as mostly new) in both array (the grow was finished 1 hour ago: 2 WD
Gold SATA 3.5 plus 1 WD RED SSD)

Slowly, i'll replace all spinning disks with WD Red SSD
I'm not a fan of WD, but 2TB disks able to replace a 2TB HDD are very
very rare (the 1.92TB, much more common, can't replace a 2TB disk)
