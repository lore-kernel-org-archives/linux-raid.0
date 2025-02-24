Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02E51A0BCD
	for <linux-raid@vger.kernel.org>; Mon, 24 Feb 2025 12:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740399860; cv=none; b=UVU4jIztOY0Qb0VNHU0H4bopo7bwLMDZJRnQLtKztbZNkLdMX0mL7xL2RB6G74RqzYnslcanoAaOjhnewm9DD81TRsIj/6xwm+9Vz5dPh+MDC9x6BNWXEGc0NkWkp3lYtD9fzY3ThRLTN9Z+qvnp1IrmMe3851kk/o5m5HC3jJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740399860; c=relaxed/simple;
	bh=NnUPmiU/kVBfTupDuskGHBYrtrrgy6h7TWj3Oshfvi4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=jbrEVvmJtKjcKGPJieTrVxQI1QbIHEbBDQ6ciNDXp9UNdHX2Pdgfza+2N5H+hAGwHLUSqizhez83esFJF16EgBxLsCUrWpYRrVVmY02IAhM03prCVTA0HlD7iVmFM0FJR0A/bpoG4+hInJgWzVOkKJ4Mj9RWXcqzzCBk+HfnvxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hmIoUqfd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hmIoUqfd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740399857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=MWpVwguJGEOO1FAG1GOf7oMDKjGE+1CekVQNJhvfxQs=;
	b=hmIoUqfdvoLeDsaOLTDBZUMYToeXpoRhHk6hLz7BOQoRBGlqIFbYTiwAQyIaIP7adaRh50
	uxfACvZWvoPDZ5ZG6k8nlmdaibIXlZDl8eKRsJqD/Gyo3nndTOdzwkNzgXZeVknpncPCDg
	dkLip13Al1MWOi9HZnTXL+VA0lLgS38=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-587-xJBi6I9POCyO7sqgEXIJ5w-1; Mon, 24 Feb 2025 07:24:16 -0500
X-MC-Unique: xJBi6I9POCyO7sqgEXIJ5w-1
X-Mimecast-MFC-AGG-ID: xJBi6I9POCyO7sqgEXIJ5w_1740399855
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30a44bb4b84so19572861fa.1
        for <linux-raid@vger.kernel.org>; Mon, 24 Feb 2025 04:24:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740399854; x=1741004654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MWpVwguJGEOO1FAG1GOf7oMDKjGE+1CekVQNJhvfxQs=;
        b=S8VOXlYUwA63iatHzhw/ZMaBvNSqklJdc2p9zi7P8gGPetuyPEUqvmwrB/pszF8kUp
         XSdS6W9LaivVifDhDhtJru5vjzzxInpS4r4h4/KI9gGb+Yke7qi5a5j1ebxJnsUCfJ6A
         l8tSIIumrnwbi6U4u6/SO+wDBW6iVvhCrZ4mkT8K9rXWVTdkSBOQES8/ca8GnFtPYWi0
         KVilZ9knz8V2qrooY4DMoZy8oUV0Y4F6vRkvhKuxwuJeuTZPaZPxN89bblbh3GRg0uxb
         e9vvpF78EX16cqrBdAruv59fipXnYUIiuoBxuoHVhWub36qzcuWcsn3OJwl8qKecs0nI
         nBiA==
X-Gm-Message-State: AOJu0Yxyt7Z8U1ljJ6dMvqDeXQHNPLoaSNoxNCoZXeNDCnFCBCcwpLmO
	MeeRg9tk8szv7U2RK70jWbldDEBg9EPWQXgybMbylsqL6y4j/ZcYnU0aQOtgkbHgu0HlhBH1aVm
	kxiuWE8bLbc9fsT+8WIyXQM7rmkBmLUFrOOt26iDSiKuvcJJ016CNPRf/IX6huM8HuS/7kwDJtb
	t54WaKfagmEJNB2Fr26j+LpDqv4XXFbz24Ytxye0itElCS
X-Gm-Gg: ASbGncu3pB7VnFaDi5QkDdNfKaoh4ie9D6+tNfbUUkLAU4LMcprbrLgBOuruZJ+l37B
	0myo6w8gCs9//A6uSx9LWfZot7KK3UTYhOuxRp0xEMJRRCl1pcJlSMOoGJJIv6yLrAJhp+Cdapw
	==
X-Received: by 2002:a2e:8ed6:0:b0:309:2012:cc59 with SMTP id 38308e7fff4ca-30a599a6943mr45907221fa.26.1740399854238;
        Mon, 24 Feb 2025 04:24:14 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGbhDA5COZfuO1ZK9BoE6JpQOW5ApeR/vJUuS4JVRi4wkGygdK0GwA36Fx/wlyALTrDg8gQmNwGXU+zdQ4cEBo=
X-Received: by 2002:a2e:8ed6:0:b0:309:2012:cc59 with SMTP id
 38308e7fff4ca-30a599a6943mr45907121fa.26.1740399853829; Mon, 24 Feb 2025
 04:24:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xiao Ni <xni@redhat.com>
Date: Mon, 24 Feb 2025 20:24:01 +0800
X-Gm-Features: AWEUYZl43Zen0Jt4YMW1w2Tn8Q12Oa8BhylKfsJde2jkmfcVRV8bpWO7pCb_C5Q
Message-ID: <CALTww2_0LcdYFdPftJAi3MA_qqeMOWPYpBx0j4Nuw_woazMvrw@mail.gmail.com>
Subject: Failed to connect to control socket
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>, Blazej Kucman <blazej.kucman@intel.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

I'm trying to fix ddf test errors which we see recently. But I see
this error: "Failed to connect to control socket". I tried with an
imsm array with loop devices and the imsm array also has this problem.
(Note, this problem doesn't appear with real devices which system
supports imsm)

mdadm -CR /dev/md/imsm -e imsm -n 4 /dev/loop8 /dev/loop9 /dev/loop10
/dev/loop11
mdadm -CR /dev/md/vol1 -n 4 -l 10 /dev/loop8 /dev/loop9 /dev/loop10
/dev/loop11 -z 10000
mdadm: Creating array inside imsm container /dev/md127
mdadm: array /dev/md/vol1 started.
mdadm: Failed to connect to control socket.

[root@ ~]# systemctl status mdmon@md127.service
=C3=97 mdmon@md127.service - MD Metadata Monitor on md127
     Loaded: loaded (/usr/lib/systemd/system/mdmon@.service; static)
     Active: failed (Result: exit-code) since Mon 2025-02-24 05:43:07
EST; 14s ago
Feb 24 05:43:07 storageqe-59.rhts.eng.pek2.redhat.com systemd[1]:
Started MD Metadata Monitor on md127.
Feb 24 05:43:07 storageqe-59.rhts.eng.pek2.redhat.com mdmon[47066]:
mdmon: Cannot load metadata for md127

I used latest mdadm and 6.14.0-rc3+

Best Regards
Xiao

