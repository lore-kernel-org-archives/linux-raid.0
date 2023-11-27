Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WxviVUMn"
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A47D7D59
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 10:57:09 -0800 (PST)
Received: by mail-ed1-x52e.google.com with SMTP id 4fb4d7f45d1cf-54af2498e85so4652559a12.0
        for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 10:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701111428; x=1701716228; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fimaHFHuHW+kCIWh+lfEX8FoLhMkh3RiJNABbN2Djg0=;
        b=WxviVUMnyYROMetGVd5pmKm7tLx7gsPD/9181s/w4IYGiPHVYlTyCdBLBwrQP8a9fq
         kMUkUjIbo/F7v+i+6ks6gdNSNpUCEMnSkQU6CoJrygUTfX9sQfJ4BZercsd+7xy307hE
         /clpjaDiDLAPgdd+DlBUkvztlCKWeEDnH1DIeQHHmFLfO+URJYttNfXo4MStWQnXq3yQ
         LVqfQ57d7zDq+Ahzm1UcVJNtcFElklcAvIZ3vSDsFv5CHtcskXriI8EfOwNRkAED1D2u
         DM7UyLOOxgVrCPXHHdCE6m5NSWMRos5xanjXkyYrFCU2nlrS9GW/P9FX+bRDhuP2xJyF
         dMbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701111428; x=1701716228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fimaHFHuHW+kCIWh+lfEX8FoLhMkh3RiJNABbN2Djg0=;
        b=ElyVdB661CrU7C1hZJ96nPMM9cDgiz/9KtXTznbH4gVR3I49+e3tyuFGMHuYd9JPyy
         YCjP/3PiihQfMD4lhTMHlCAAGRx49CzEZKT6xvasFGyeZk6eyB8Lg1zGvGQ6LUBAayZ2
         2j4gZ8l4h/Oso0jUuXbt+XU9k5XH5gKejSS4ryCKLc7oMqGBTA3qa4Q4P0b27Qv9qZZz
         VN/lO9IqYtGNyINcbg4LreTaluRTz0n7iWZ+eh86NY7TpRnczEa4jKlEwnYttAoIUKkg
         QTuG2S2eVSnI/aoxfTtk7qVajIua/WcKAP0r7+LmGItBXAJrbefNWRB1X5fL3FJ/eL2x
         jGzA==
X-Gm-Message-State: AOJu0YzvrHl4RnK5YVWvtmtisW9gjBnfNmK3e1N5VIUi6BuvBedmDxv4
	MqKDdIO62AdcEdbT3EEzFOgjC4ME7T6e+UHcSOk/TEVAOIVt5A==
X-Google-Smtp-Source: AGHT+IH+dJiJG60iOWfx7brZjfrDMmM5wSudKH4u1/X1bsQXmFtCixwZss82wX9JHFwqpt8ZtvEkKjY72viopQB7tio=
X-Received: by 2002:a50:8acd:0:b0:54a:f72d:38b2 with SMTP id
 k13-20020a508acd000000b0054af72d38b2mr7422152edk.8.1701111427897; Mon, 27 Nov
 2023 10:57:07 -0800 (PST)
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
 <CAJH6TXihycKVWNFYn9VLUG5_7rG6P-3ZQoJsVORPTCER1OQttQ@mail.gmail.com>
 <4a29e1d1-8ef1-4505-a197-46518fd3025f@thelounge.net> <CAJH6TXjFqq1tV9kTYicLVRKv3+cfXtjDEyKRpGe6H5NWqjBmgw@mail.gmail.com>
 <CAJH6TXgR346bkR2sLQL-=UEWG5KWCMNFbXtA_FuiYtG3V25nwA@mail.gmail.com> <2cc1dc2d-8599-4076-a6d6-aeb0932b61e5@thelounge.net>
In-Reply-To: <2cc1dc2d-8599-4076-a6d6-aeb0932b61e5@thelounge.net>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Mon, 27 Nov 2023 19:56:53 +0100
Message-ID: <CAJH6TXhvvyf12impHCk+j+vQh4uL7S_8=CMdz+yK4thimSdTAQ@mail.gmail.com>
Subject: Re: SMR or SSD disks?
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il giorno lun 27 nov 2023 alle ore 18:23 Reindl Harald
<h.reindl@thelounge.net> ha scritto:
> my 870 are from 2022 and most likely not affacted at all
> these seem to be early produced ones
>
> when you make decisions on such threads you can't buy anything at all no
> matter SSD or HDD - Samsgung SSD at least have some reputation over the
> past 10 years
>

thank you so much
i'll order a couple of them...
