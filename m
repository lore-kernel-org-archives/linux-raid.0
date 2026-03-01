Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E8F14A8B
	for <linux-raid@vger.kernel.org>; Sun,  1 Mar 2026 11:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772365183; cv=pass; b=AGMmWM4DU4KLaWnYgmLlruHaBoW0owsHPnnspn07Y3a5aVFWxRww+ifsjpetXSRgE5RrBguH+HLFVparShbhpUgr8Ciry6+v+bLcjuODqlG9DvJ9LpINAcQ3P+qkvU1ixzCp47dLVQTmIpF6FM2Qt6/PLnzzhhUw9lBXRJUW8eQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772365183; c=relaxed/simple;
	bh=DPOb6+vrxdjbpbbKY8ZYQKS/9pW2qeWPfFa8+00rKc4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Ksxi+o4Ut+HE5jx6FPDTUrYXqbb3Na8tlndXHP8UZ9XZ+v9CRHPXn2wUAA+sIK0NGg2mGLAM7qhIjqfMmXNJ5WU1NTN7Stb08atk5VnSfpFuH6jY/2BP/y1fzB9fdA7hmQmaK99VlBTPtmR/eKUOGU1WMMCihtEsXDjur+bvvMU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com; spf=pass smtp.mailfrom=lucidpixels.com; dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b=ofIFX300; arc=pass smtp.client-ip=209.85.160.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="ofIFX300"
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-505a1789a27so21490541cf.3
        for <linux-raid@vger.kernel.org>; Sun, 01 Mar 2026 03:39:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772365181; cv=none;
        d=google.com; s=arc-20240605;
        b=ibGgsYEG0XLkoDInEVImzmgiPPSzdaM36fdFYmPC21bZtvhpZACPON3ydPkYzMZE5v
         B+JNs29a/DcoYWxBjF07YRt0vbotUQ7YMugnXMj7082RaU2XkvMHoGgwT4VhP/5g2bhz
         lzWX+b/ONxfCA+CdY/csR1fELHiGoxoytcoiJGc6F1nOqHJxnBz3QiR0yqUgLLXRW/s7
         fzOdVqr7+KEncDcaUqFNp9eYT0a8pz6ag2rxevpJwtGymSwL2YeV7LSpunlAx78BaCKd
         p8rOEaZ688V7Noun7KMCuOpGqG1MepA0vquLOkD+xEburYfUwSiMj+VVRrm7cCWXBz7h
         6oGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=EoNhvs8U/ojW8ZJkNQTxI87TlxDPccTlNu+mF+xaKNE=;
        fh=AWHiw9JeSxCRxpHXU+YAb0OrCDYy5O7wfZdWFkSRAK8=;
        b=cgNH8vkcRvXDnXRpctxqJ8dVF7kBYPFMqL1gFf2/cLLcF4R5AZwwv/JntJ5qX3VLYb
         fWuMbQNU+PPqbC6OJ0IcRLAOHJnxesmkiKc4On29NIuBdppDRlECUeeZOAmYaEyCWejT
         zuRRXFcCcl2Gf9xPD2Av13xUsHYGEqXRlwjH2pYOeNcrcomR5C99bcrJNbS795riTagH
         czNH9UwL8XLJnoAEUQcD87iB4mRemzK1fOqhgy/KM7iv6LD0Kpq7UNGQTxDTBdB7qJ7X
         um3r5TS61xJtwKgWDp3IcNO4P6nkE3qnp2+v4KaABHXmlKqr56tAUTy4Wln/aQwjVXO6
         Kp7g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google; t=1772365181; x=1772969981; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=EoNhvs8U/ojW8ZJkNQTxI87TlxDPccTlNu+mF+xaKNE=;
        b=ofIFX300C2i+ej+N8p8eDJ7VA1oyAYiVketqx9ePavyMCaQ4aP7dO94hfmuQCQ00PZ
         dX+kBiPeSezHpjE1UTuhIZ7x7+Udr/EoSHXCuGMLWP73jx7hdtHc2Gy54gN9V3nskEB4
         kNXti5P1QG9VXAyDR6/+Pip/1vXPfypUgh9gY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772365181; x=1772969981;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EoNhvs8U/ojW8ZJkNQTxI87TlxDPccTlNu+mF+xaKNE=;
        b=rURLDFm7mW5woxgrHo5sboYjfQMw+sRLv8+n+CUXNq7ebdVkC40Uj0/OW6ertsiVOe
         LelhFz5qLntMnWXUakueGJ9EzALaccVLwIzEXLXEYeVkmTpKPGVrLLLuZrLIGeMyok1z
         Weae6Av8W9S8DnXhuyXvl5cm0R56vgoJ/gOtsuHxyaj9XeqouV3x05CZRJNxdLJMlo2a
         YBhC+Mga70zK8kivY4JbzV++OIfoURxc0W75MVzEkllI/iavMEVoHvYQv+1GXrhrc4kd
         16KPkh7TySTrbhrbvizncy0gKdwSB03a032AA1AneElxAdqSgFlx3l8CNT3EypUCyD+x
         E6iA==
X-Forwarded-Encrypted: i=1; AJvYcCUg8+s8hnFv3dUe5aP0ZifIxujVd81n32xko73/g+S5D4Bg07UxSdNqYclGjx8cluxdNOrVbszJlX4x@vger.kernel.org
X-Gm-Message-State: AOJu0YzkRUnNXO4Errrj9KD0+Y109SQcYHK+z5EnNYG9iJct00/4UQuI
	bFPxEWorlEZro49hh5bzAm/IfeB7a7GUtSgwhnY7rbCDtXNI8dimcdHh/1wz9Fm46MIEL5cYzrT
	SizGLJ6Rlul6BLusds+fgaADWncUjowtyo8oDiJiqAw==
X-Gm-Gg: ATEYQzzSg77f2HeH/hWIt/EMLrUg74aOcNlt9DwwTk7BFybCQW4WCA/qn/2KO7tkbzO
	WNyl1EcgBiS1QR3X9Huv2y3EhGQwoHq7SCMyTUUVqLrhYt+ZOjOSfJ9xuxr5siXB3dW76/lCcn2
	T6gFlSWgBROdWE2vTwamGajm37NiGhd8/r9XijjQX/jRYua/6Azt5azxKq0e11lv90S4jo0nz7m
	wOjlx55UDzXgeEce1KRVOHQ2k+eISnstGkycgvnFByE7F6oiyu17JFl+007tBhn87B+7jKBDYGM
	4ErkzxYJTESx7nBUhBLpQj/HEl6hD9gVdRil6/4O23kRBtwyzMC87UAm9NhEE/rLq1TaS3QUcSa
	vqzuc/Mw2qQ==
X-Received: by 2002:ac8:5806:0:b0:501:13ce:4e0a with SMTP id
 d75a77b69052e-50752840802mr114996361cf.10.1772365181076; Sun, 01 Mar 2026
 03:39:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Sun, 1 Mar 2026 01:39:29 -1000
X-Gm-Features: AaiRm51MwT5pQCYhssaqR0QnLqOv4NsckjM8W0_zZRRcQsA3A0fjKitkD8mG5ew
Message-ID: <CAO9zADxDnb5OVVVZWj64ac70SACH=-G5TC+2F+vfuDmLbZECQA@mail.gmail.com>
Subject: 4 TiB WD SN700 drives drop off of Sonnet Card
To: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

Kernel: 6.12.73
Distribution: Debian Stable Trixie

There are long outstanding issues with these WD Red SN700 4TiB drives
with an ASUS FlahsStor Gen1.

I have 16 drives on two x8 Sonnet boards and the same issue is
occurring across two different platforms.  Are these drives completely
defective when used in a software raid configuration?

Does anyone have a specific kernel parameter to make these drives work
without dropping off the bus=E2=80=94 or is it time to retire/replace these
drives?  On various forums the below parameters had been tested
previously and did not help.

[Sun Mar 1 00:30:58 2026] nvme nvme0: controller is down; will reset:
CSTS=3D0xffffffff, PCI_STATUS=3D0xffff
[Sun Mar 1 00:30:58 2026] nvme nvme0: Does your device have a faulty
power saving mode enabled?
[Sun Mar 1 00:30:58 2026] nvme nvme0: Try
"nvme_core.default_ps_max_latency_us=3D0 pcie_aspm=3Doff pcie_port_pm=3Doff=
"
and report a bug
[Sun Mar 1 00:31:03 2026] nvme 0000:03:00.0: Unable to change power
state from D3cold to D0, device inaccessible
[Sun Mar 1 00:31:03 2026] nvme nvme0: Disabling device after reset failure:=
 -19
[Sun Mar 1 00:31:03 2026] md/raid:md0: Disk failure on nvme0n1p1,
disabling device.

Justin
