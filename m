Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cXe0WKw/"
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 627B6135
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 04:36:49 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-54b0e553979so3114316a12.2
        for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 04:36:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701088608; x=1701693408; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JQ0MbnM9wTms+Ev218QwzmTmOyuqvHHFU29VVrAuPVc=;
        b=cXe0WKw/T4dBaOt76CYnBljbdMcRdXHUEXByabAwOo/SGMXLO01O7vJma4hNsBtASB
         EYOZpF/tw9O0T5TNw8i1wvu8IVw0NEqsP7eca6K9go65u30DfxAh7Z9baHQd+Ux2EBbH
         NPKp71M6ELJvrcRK+crubPYj5ilgANQEEwt7es6QNRUW9v8IMaLdyWhErwaR0+pIO/O5
         WQakHsar7xv/ztHYfcEjwuTnaLihVHjllBV5uu9FuYQ73JLXfQj+W9GLcfFCtZKrXf40
         XZGhyzb0Y/Mnjgx/TpGM4KM5VelycseAZQEUg2jwtpi48MGieXJk1jxy3h/6VupUE1km
         6kHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701088608; x=1701693408;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JQ0MbnM9wTms+Ev218QwzmTmOyuqvHHFU29VVrAuPVc=;
        b=Fn5y2ufK4Rtxt/wOFZZBFYdr31/pO/IQwtjfkTqFsAZ4EKNs2i4dsPq8pyrCnPzPT2
         PifnMpwLpWH1erd9jYjG//rdG2dIMSQ3mSZvdHjqZg0Uqd0bjGx9WBNjZyE7FFYRlrcC
         Se0SxVsvw2pcXx4DLOBc53n0EKtVKoY3SeDxvGR7ZWkQJX7cREakfaGQGTinJLIeMRtv
         v9cX9/FXOgI97zgJ7dXEnwbyJQhVxbJoS9vvY906SwSLZwm1x4nIwOxM5GNjI5Byl8sM
         txRMfTdLrYQUQ9lIx2qk9IV0ggNH4J/gz6iayNPsHeLEru1GlhXZdiw3tBW0Y0zMuNcr
         zhkA==
X-Gm-Message-State: AOJu0Ywni2JteYqtcSi7Qks/B5XjwX/+3uV9MRC803POzEDqUqAABCEY
	Vz2S8yjTO4D3ziaJiY7BjAQ/oLSJaIKsgCjP4+k=
X-Google-Smtp-Source: AGHT+IEc41PVUstoToD5Vt5L5mC5E9bWmXKa2vGYbWBnrMd60fnEK0nm+VAa4kc0us6ptoJfEY9cnGLuMQvHNOe53VI=
X-Received: by 2002:a05:6402:491:b0:54b:5a2a:1cb5 with SMTP id
 k17-20020a056402049100b0054b5a2a1cb5mr2550960edv.9.1701088607774; Mon, 27 Nov
 2023 04:36:47 -0800 (PST)
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
In-Reply-To: <CAJH6TXjFqq1tV9kTYicLVRKv3+cfXtjDEyKRpGe6H5NWqjBmgw@mail.gmail.com>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Mon, 27 Nov 2023 13:36:35 +0100
Message-ID: <CAJH6TXgR346bkR2sLQL-=UEWG5KWCMNFbXtA_FuiYtG3V25nwA@mail.gmail.com>
Subject: Re: SMR or SSD disks?
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il giorno lun 27 nov 2023 alle ore 13:35 Gandalf Corvotempesta
<gandalf.corvotempesta@gmail.com> ha scritto:
> but i've read somewhere that the latest SSDs had some issues,
> particularly under linux, with a
> lot of write errors, that's why i've purchased a different brand (and,
> honestly, I hate WD)

In example
https://www.techpowerup.com/forums/threads/samsung-870-evo-beware-certain-batches-prone-to-failure.291504/
