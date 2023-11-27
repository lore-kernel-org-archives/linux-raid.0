Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Qs4w5kGU"
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90CFB182
	for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 04:35:23 -0800 (PST)
Received: by mail-ed1-x534.google.com with SMTP id 4fb4d7f45d1cf-54afd43c83cso3746543a12.0
        for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 04:35:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701088522; x=1701693322; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C6kx3N8/oH7gfZKwX/S1pdO7plDz5iUi9AfBmB8HIFs=;
        b=Qs4w5kGUxh3jr1k0qHvyOHm8Yh/v4AMkTRi37FDllult2FK4jJvoA37Dk1RwL0B3Ho
         w2D4Xxc0AfMUWw7i/RXNJSPZgK5Gb9Mec2BLK1HkRBUlSfdk9CxFweIIKSgSQyHt0nwN
         ZXrSYUPnNxHP4HF17HzfAgRk9Ip47FwLR5L0BUyYQYTnymJqnFt7xZ9UxwPv2UzSsB9C
         Kn4+Zht16tLqDydO6YeBK5q8aHdndqrvTFof2NJWrs/5W6UQp+FJ09e8eBpmHETG5Fly
         eNKeBaoPa9m4x2S0tFvW/u8lMCP5odl+B2owTIJQCAJ60bsnSy1nCLIaP5UdM9QqgQ9u
         7PtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701088522; x=1701693322;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C6kx3N8/oH7gfZKwX/S1pdO7plDz5iUi9AfBmB8HIFs=;
        b=hMuimgR9xrBXxrZh5fRsvrIQdmaZDtA0lsEgxXqv/91TLlQCKo3kMf84RUkwt4HsoE
         UmMAdK2laTj4uVR2+egZ3yW5sgd0iZcW5d97QAsXSa2CBwsHd0+EeEx585wfkag0M2Ox
         gYrWJo6wmsL7LHgvigl5kLwJCwFq3++GPyXHS4Wwz7+R3VNZCq0YgV5eyecDYy3cn1Uw
         kjYwSMNSd+kT6To4juegGGSd2eVu+gmuw0otJjMI+8ZLEN8Op9K0XwG22nkV8gniWpUS
         8F0RnnZ6HydajwHRMCrYTeonYY3S3Z3arFXorLKw6ooPh9IsbZOWa6LsJP57HBQUSOlP
         SAag==
X-Gm-Message-State: AOJu0YwB9P5uWy/DbFZjTkKWiec1V26vstQHXffRPXzL69u0ks7aIkjw
	GnKGCEluDC542pwZTGtk0hI8MiwBBg2T0XzimpMkVU09cPlqaw==
X-Google-Smtp-Source: AGHT+IGHLa7H+oPF+Y2TGsuDLTumnNLiuwIzvpZXCrHIUBt4f6+oyjx6WRMzl3rnJFKZRwzZ1J/2znDBmWxCmafbeMY=
X-Received: by 2002:aa7:c608:0:b0:54a:f1db:c2b4 with SMTP id
 h8-20020aa7c608000000b0054af1dbc2b4mr8553502edq.12.1701088521880; Mon, 27 Nov
 2023 04:35:21 -0800 (PST)
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
 <CAJH6TXihycKVWNFYn9VLUG5_7rG6P-3ZQoJsVORPTCER1OQttQ@mail.gmail.com> <4a29e1d1-8ef1-4505-a197-46518fd3025f@thelounge.net>
In-Reply-To: <4a29e1d1-8ef1-4505-a197-46518fd3025f@thelounge.net>
From: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>
Date: Mon, 27 Nov 2023 13:35:09 +0100
Message-ID: <CAJH6TXjFqq1tV9kTYicLVRKv3+cfXtjDEyKRpGe6H5NWqjBmgw@mail.gmail.com>
Subject: Re: SMR or SSD disks?
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Il giorno lun 27 nov 2023 alle ore 10:15 Reindl Harald
<h.reindl@thelounge.net> ha scritto:
> i started to replace HDDs with "Samsung Evo 850 2 TB" 7 years ago
> in which country you coudn't buy them (now 870) from Amazon 2023?

Samsung are my first choise for desktop drives, (second choice, after
intel, for the DC drives)
but i've read somewhere that the latest SSDs had some issues,
particularly under linux, with a
lot of write errors, that's why i've purchased a different brand (and,
honestly, I hate WD)

Did you had any issue with the Evo drives under RAID ?
