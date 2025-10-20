Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2611920ADD6
	for <linux-raid@vger.kernel.org>; Mon, 20 Oct 2025 14:40:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760971257; cv=none; b=ibbA6C9V4dbdKLRVMQPloL2KdUDoIaceeqdG94A7ERA/5Wv8xz5FJUY9uG7SHdPkSDFSKJ7vNFESq1QVYZ1luC0Hf8cMPBPXZv31T7BT0g8Yt0nkgPh54yW97LGlVZyhtLeYHWKd3AXeIP4ZBIDTD+b/HzTS/yIhMjfStRpJTcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760971257; c=relaxed/simple;
	bh=qqo/SGBHV9BG52PiRUAwSq3ZcZtk5NK/orbUl35qNSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DaWviCGMtR1dJLFYbgpqewdH7WUyt/qcGHPRecaKZrZGcp0hRvpPFVjfaDW69kUyeid8W6KXFC1o1jlQeFW+3KRlBIBIxEtyWWtS4j1WBDNvUwzwVLyMLPDuuMf0xabE/XHgdcO6aYrd+/aIEEORV0ZzeFj2MYPGXeBeu0hdtpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OheNwiZ4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OheNwiZ4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760971254;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4cD/GLAeMLUZar9iQW7Pk+UI5C9ajh4D3Bj+DADICMA=;
	b=OheNwiZ4jv30tJOaX/FGfL4pGYFu0ejnQcI79paZDmo+qM4IizSdiBKby/Z9kRHc/afUPB
	QbqN9SSf8JzZT5e5SMatPlI5UUj1w+aoe2Hv9hsY9tp9kcfh2YAKgOPJojyFRy0KokEPA+
	oULEkCONt5d6Q4D6/idvFvgESV0BGLQ=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-530-ObSsmfH9MDatEd7B5b_b0g-1; Mon, 20 Oct 2025 10:40:53 -0400
X-MC-Unique: ObSsmfH9MDatEd7B5b_b0g-1
X-Mimecast-MFC-AGG-ID: ObSsmfH9MDatEd7B5b_b0g_1760971252
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-375da0ef7f8so41208301fa.2
        for <linux-raid@vger.kernel.org>; Mon, 20 Oct 2025 07:40:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760971250; x=1761576050;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4cD/GLAeMLUZar9iQW7Pk+UI5C9ajh4D3Bj+DADICMA=;
        b=oCx5I8vUoURfv6FiuV1GQ3RcWS/P4pJMh3Z/6fysAfa4Fm17N9aAkVF45jqTJblBzy
         +D+hi2KsrMPQtIvcPz7T8+IZssnTEVwWc+WO5CBbsPD0ALTxaDyMDafDGllATsxQlO2z
         4crn7Lb6W754NBzoC5u0nx04WpYGcQfKbtjr4gk8ReEoZlpDRNyZkZ29FPbbc+34xqpf
         5xDaeFRUzZ0yXeuECrHvrHLSUu2oMEVb7PcHuWAMK9D9ujwt3M1kEQMEGyMlhNi394PV
         w6qQRc+rtHJAXwXtx12KmGs3q4kwV2m3513pM1/Qjb1iUs+9rsOPmEcwCnXSzDK6IPYw
         hqQw==
X-Gm-Message-State: AOJu0YzUMZopevWnlWa3anexHAdWoYXSdNZF1zTQ5A4/d15qiRo0vg++
	fiqbHc5I9EWkr1Al/CLpjZbAdvYwO8qRS8MEuPEIFwckQgMKEhf+KjofHFawZv+Y6lz2YIerAch
	fAU6Ag+Z8qXtRwmJcS3zEEOSaBgoRMv3SUrSnTwzJbnZ8p4Cg8P1H6xV++EmKWp/QyOWt4OEQqd
	qZGa+Vii1grIIH55cr1LjtZ/og9hIiGMt//XbuAjfeAM9dMUmtQbU=
X-Gm-Gg: ASbGncvWQ51crZMRh8B/mtDGucJ7CVImIHcmvcmR5dpz4fh9wy16+E6XnsHgc2ydmuo
	MfI/SmupwvMzXks3/4zdV7mnupZBi9LQHe+mFRBb9b3TpMXKrfVuS6Gn5Wjah1R6QOrGEPS7N/+
	GLjTJzKe9gRm9xp/7hzM2IbSZ3BsCDrY3uU6oL6ZYBSVKxKtpMOCWtrImy
X-Received: by 2002:a05:651c:3615:b0:372:9468:8f99 with SMTP id 38308e7fff4ca-37797a5cb4amr36472371fa.35.1760971250413;
        Mon, 20 Oct 2025 07:40:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF7mMcEXvZ3/X2zYKrMhuovvFV7zALhVzutOtUUcirG57vKZHFCPQxthN7WB/pYz6HJOQnkEQBI4Rw78WifSTM=
X-Received: by 2002:a05:651c:3615:b0:372:9468:8f99 with SMTP id
 38308e7fff4ca-37797a5cb4amr36472291fa.35.1760971249989; Mon, 20 Oct 2025
 07:40:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <608328b7-9dfe-4edd-afd5-68366fb845bc@gmail.com>
In-Reply-To: <608328b7-9dfe-4edd-afd5-68366fb845bc@gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 20 Oct 2025 22:40:37 +0800
X-Gm-Features: AS18NWC0NyJUEvCIDxliVRo9e33fmt-i6JCctKwgBCvt_I-LiXq5C5S8rFK4FaQ
Message-ID: <CALTww2_0rAvqc=C0zAP7pdGT-V7-ypMV5Rc=dk4iKS4VkAVE7Q@mail.gmail.com>
Subject: Re: Unable to set group_thread_cnt using mdadm.conf
To: Franco Martelli <martellif67@gmail.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, mtkaczyk@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 17, 2025 at 10:07=E2=80=AFPM Franco Martelli <martellif67@gmail=
.com> wrote:
>
> Hello,
>
> I've a RAID5 array on Debian 13:
>
> ~$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [linear] [raid0] [raid1] [raid10]
> md0 : active raid5 sda1[0] sdc1[2] sdd1[3](S) sdb1[1]
>        1953258496 blocks super 1.2 level 5, 512k chunk, algorithm 2
> [3/3] [UUU]
>
> unused devices: <none>
>
> ~# mdadm --version
> mdadm - v4.4 - 2024-11-07 - Debian 4.4-11
>
> the issue is that I can't set group_thread_cnt if I use the syntax
> described in mdadm.conf(5) man-page:
>
> =E2=80=A6
> SYSFS name=3D/dev/md/raid5 group_thread_cnt=3D4 sync_speed_max=3D1000000
> SYSFS uuid=3Dbead5eb6:31c17a27:da120ba2:7dfda40d group_thread_cnt=3D4
> sync_speed_max=3D1000000
>
> my "mdadm.conf" is:
>
> ~$ grep -v '^#' /etc/mdadm/mdadm.conf
>
>
> HOMEHOST <system>
>
> MAILADDR root
>
> ARRAY /dev/md/0  metadata=3D1.2 UUID=3D8bdf78b9:4cad434c:3a30392d:8463c7e=
0
>     spares=3D1
>
>
> SYSFS name=3D/dev/md/0 group_thread_cnt=3D8
> SYSFS uuid=3D8bdf78b9:4cad434c:3a30392d:8463c7e0 sync_speed_max=3D1000000
>
>
> after I makes changes to the file "mdadm.conf" I rebuild the initramfs
> image file and reboot. The thing that seems strange to me is that the
> other item I set (sync_speed_max) is changed accordingly, only
> "group_thread_cnt" fails to set (it's always =3D=3D0):
>
> ~$ cat /sys/block/md0/md/group_thread_cnt
> 0
> ~$ cat /sys/block/md0/md/sync_speed_max
> 1000000 (system)
>
> Why "sync_speed_max" is set while "group_thread_cnt" it is not? Any clue?

Hi Franco

The sync_speed_max should not be set too. Because it still shows
"system" rather than "local". I tried in my environment. It indeed has
a problem if you specify uuid in conf file to set sysfs value. This is
my conf:

cat /etc/mdadm.conf
ARRAY /dev/md/0  metadata=3D1.2 UUID=3D689642b7:fa1e5cf2:82c6c527:ca37716f
SYSFS name=3D/dev/md/0 sync_speed_max=3D5000 group_thread_cnt=3D8

After assembling by command `mdadm -As`:
[root@ mdadm]# cat /sys/block/md0/md/group_thread_cnt
8
[root@ mdadm]# cat /sys/block/md0/md/sync_speed_max
5000 (local)

If I specify uuid in the second line of the conf file, it can't work.
Because the uuid read from the device doesn't match with the conf
file. It should be the problem of big-endian and little-endian. I'm
looking at this problem.

But in your conf, the group thread cnt should be set successfully.
What's your command to assemble the array? Can you stop the array and
assemble it after boot.

Regards
Xiao
>
> Thanks in advance, kind regards.
> --
> Franco Martelli
>

