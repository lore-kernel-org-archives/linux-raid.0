Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B48A2E7F32
	for <linux-raid@vger.kernel.org>; Sun,  7 Dec 2025 22:00:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765144839; cv=none; b=Rd1nh1jzCsLj4zZOjq9DN8lxTbWh6U9VkSbPdcuG7hWYn2cTlOY4rD3L/3a9Y5ty/AgvevLpPLodB7fazyzq1LQCVLdFFBr2fYApmsENv1d5DIxJPF/1RKmwPS4lwk1TS9rh3RUwET6YjFp0fFXjpqzx1F6xB7eFjNIMbBk/dL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765144839; c=relaxed/simple;
	bh=+uoZ2ZEZ3Vo9vLkkliX6R5Kz+qK7cKhZhTV+x8B57uA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCY7Lb9Po+3Cg0HQtHi2L6BM3KNh06l6eXya0RlHGg66MLaHiya8lyC1ayxt0rNwhf/DFUuiMu8ULj8hW6xHJB7Es9AIo8GvqEg66WfKq+oppRdao/xkLlT8o/aIcegiDKBFMyJXJSyKuN4RamjNrvvxHmqITzJawNbx4GK59cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AkNSoOUf; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AkNSoOUf"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7c6dbdaced8so3343283a34.1
        for <linux-raid@vger.kernel.org>; Sun, 07 Dec 2025 14:00:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765144836; x=1765749636; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D1ENxN7tJt9SIoIuLC5XRmcHpP6AJ/ZcbjCjfYWK4KA=;
        b=AkNSoOUfAtVj16Q9LtG593ip+GzXtcyp5PAGk80zm/QJoOFnVmxfFEl++meCi2MppO
         kDJ3vupH3kthThlFYXX2AFU0173ItnjGO7UZp6lS5TKWTIUXzQU1GgNv25LSexYhpyF0
         yZQMiUmOHhTOMPd2s5J/43PaYQTU+vVLZI8ofXpkxBM+3OFXr18b4zHZa1IH9CdZp4LU
         Gpgh1GQQF+YJCB7Fp6tS9ZC9lwPctvLFuNDTPaywT4KHTwk84TMR9b9b5yt+TYSqKm2i
         ICYGUu02sZVJVXErMM1zj9uah5GxfP7CHHA2NtcFabT1/Nfqi0QsE0DLIoIBGwwQHLoo
         D9Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765144836; x=1765749636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D1ENxN7tJt9SIoIuLC5XRmcHpP6AJ/ZcbjCjfYWK4KA=;
        b=byuwE7pXQgCKjT5n8KoDKRyLKv4Pez+l5Kwhja1NmdoORHcf3nuTzcQl4ggX8/KbJP
         fp/fnHdi4Iv3uocShs3T/8BrG4t8GsTRpvlMgPFfGRr6GbeSGH22zP6pFs28ruCCzQ5I
         qTSrheottqLpjJUDiwG4JW6ESORn7b5n7bdIZ5/S5OoQQmjhTWpnJKblrMdwIMDJMouT
         UHawL7u7juYhgglxBPBjKX/NGJ3/ygavNJ8Wb/5kdAukxns7hDt1LhlyjKUloVKgZwwf
         htQeHkBlUOxo+40NZ8gIVMxX5HF7GzN51zJa+KQgHkMneRLQaHbeGDjyOtct559d9V9+
         vXPw==
X-Gm-Message-State: AOJu0YyhLmo9zyJcOfTJgdKDSZDxFPnEW1eOOWNjol4RJ774kqanRxsH
	TTSRI89hbkZxj99nWq4ttK6E4zXJlq2ijk/tB8BnSnO9xjCb8OA+m1ditr4swtl2omg1AsCOR2T
	UYyGAai395CSXd4GQdS+DW2DXBwLxKac=
X-Gm-Gg: ASbGncuJ77zQQgOCrFsnCqPOflzidKgitF2gheWNBPpAA6qOoxUq6auFsyz4OPo9GMA
	JDSfVXvkghF2hji6Y04m2Vqyu0b63kVZVKJ5Qcon9mXzeRwogQQ+KvD2cwC5YOMc+H8n8ZhLLkL
	2su9yMHk5yaT3Dr3wGhONwPbLQc7Xyuezn7jSI5BWbX6yDK17XstssKA/DjBEVAspjoZCt2ljpY
	OsZG5nUPtgHeHeA3sn2+JkN/LK5PGyydAD2ceT9SmGbstAmJVaTZ34qzYCqMxqCVWivNA==
X-Google-Smtp-Source: AGHT+IFikZYpMEUT4O0S+15R1d4GDcp3lStVQUxoJhoRpEnhL51YgnEAy3OR7E8XHLLHlP5wrw5hIl+uzvU9fgUmvdU=
X-Received: by 2002:a05:6820:618:b0:659:9a49:8f3a with SMTP id
 006d021491bc7-6599a9843e6mr2890511eaf.75.1765144836213; Sun, 07 Dec 2025
 14:00:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
In-Reply-To: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Sun, 7 Dec 2025 16:00:25 -0600
X-Gm-Features: AQt7F2r47AMlyGU_MbUqmP92MkRg8pevs3_4ruKTqRO4nI8QkkRZyOBcAg9cP1w
Message-ID: <CAAMCDefCdcPn8--UtyXyLzO+sqUomsEzStoqtc=8RewRJhyvXw@mail.gmail.com>
Subject: Re: Possible issue with software RAID 1 in case of disks with
 different speed
To: Christian Focke-Kiss <christian.focke-kiss@mail.fernfh.ac.at>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "yukuai3@huawei.com" <yukuai3@huawei.com>, 
	"song@kernel.org" <song@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 7, 2025 at 8:41=E2=80=AFAM Christian Focke-Kiss
<christian.focke-kiss@mail.fernfh.ac.at> wrote:
>
> Hello,
>

>
> Now, as long as the sixth disk was still connected via USB 3.x, the
> rsync job and a kworker job were 'blocked' after some hours of rsync-
> ing, and the console displayed some 'sync' errors, and I had to press
> Ctrl+Alt+Del to reboot the system because login didn't work anymore.
>
> I flagged the USB 3.x disk 'write-mostly' and 'nofailfast' but this
> didn't resolve the issue.
>
> Only after I added two NVMe SSDs as boot disks and migrated the sixth
> SSD into the sixth slot, everything runs fine.
>
> Conclusion:
> I suspect software RAID 1 has issues if one disk of a three disk RAID 1
> set is significantly slower than the other two disks.
>
> Everything works fine for me now, but in case ...
>
> Kind regards, Christian

I have seen enterprise grade array/controllers (SAN) that "defeated"
multipathd (older kernels, dm-mapper, same layer used by mdraid).
The way the "enterprise" array defeated multipath was that the array
controller was programmed to return  a TUR (test unit ready) when it
was alive and "believed" the "disk" it was managing was ok via its
paths, even when the "disk" it was managing was not really working.
The issue with that is some of the lower layers(the SCSI layer used
to/may still use a TUR as a health  check) when a timeout occurs sends
a TUR and if it gets the TUR response back than it retries the IO, and
it can get stuck in this loop under the right conditions and not fail
IO even though IO is not fuctioning because the TUR always works.   I
have seen multipath layers not process IO and not timeout/fail io from
this issue. for minutes to hours (often it never reports a timeout in
the logs because the TUR keeps works).  I had a discussion with the
enterprise raid people suggesting that during a failover the failing
controller should stop responding to TURs first and then stop
processing the IO instead of only stopping TURs when the controller
was rebooted.   It is quite possible that a USB controllers could be
doing the exact same thing(short circuiting and sending the TUR
itself, ie not a TUR from the actual disk)  and defeating the
timeout/failure code  in MDRAID even though the disk itself is not
responding.
