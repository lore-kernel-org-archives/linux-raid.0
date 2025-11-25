Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAF332695B
	for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 14:42:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764081748; cv=none; b=W8SGQDitrvp3hPCVpb84Ifw9AKxzv5y+EBlN5gdSYIzzRWPWmJOPpncjcTUNE796J2oAjvt5lt5ucOX0gLfB1+1pnfHhmP+7D3Kr0Qy8DdRrdr2964iMfjHgm2+H61QLxK7yzYhewCkqGH01PJPxbWK8XWMocjSb9G9+g1uRpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764081748; c=relaxed/simple;
	bh=47pokBKKEFg7fqMU6ZymUGp2WYqWOxlE3HZsS2pZ6FM=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=I80TfvyFooKTV94/c4koNPI4y/j+RbwR6NN44TWi8TPrlN5cPQkBdda2DsuIkqN/b550ZKIrwq3lUK6SIsr4CzTmahsew3J8GsZvdhbS0Zbw6GxScl8UqFGgW0ijbOOQUaIQeH7AHqs1Q7Mprhn7InBhHUmpmfsXENY+F3LqeMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com; spf=pass smtp.mailfrom=lucidpixels.com; dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b=Ttj060nU; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lucidpixels.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=lucidpixels.com header.i=@lucidpixels.com header.b="Ttj060nU"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7c77ed036c3so3017303a34.0
        for <linux-raid@vger.kernel.org>; Tue, 25 Nov 2025 06:42:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lucidpixels.com; s=google; t=1764081745; x=1764686545; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=KaxA4URZMnkQPOL5VrfQqCvsZMWSgJ6OMNVogesAF0M=;
        b=Ttj060nUzPe5Flz67AQ9OHJrHYzCRtTN78tE8HsuVcNv5zA2VeSYhocquv+Vz3Exn5
         U8Wy8UJ2c8WzHStZq9heAppTq+SwvY1XsA55hcwWvehqFa1agmlxwCklvMa3DDkTm7vQ
         72sweFQkJfnwlWuWojFJ2EhuNjyYtsWvb0QDU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764081745; x=1764686545;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KaxA4URZMnkQPOL5VrfQqCvsZMWSgJ6OMNVogesAF0M=;
        b=bBNzc+OVn9WODgOSemkeCWS3q0beA63WfSHIfyJD6re1nydf8/0zosnaU+hVco7vTP
         e9g7+FOkiiTUPiCJMxZmtwlYwNXOMim/trQvaor4cy0IsOqx7GYnuNCY+Wz+tNylkygZ
         nJp5igXxJop00Y3zP+lJsmw0k3VA+4ItQjy4Q2VJJGk3TOw3CRjBeZcKxIIgHf4XjFkq
         SWvRbndBxWBVo2dZd8VvUI+soKQFjo55z7UbFjyJzw9ToSkUe9yxoyKMAXqmoOcRWX3x
         cfSh1K0eRexlJTolb/kL6WgMMN9Ba5bxYCvWJQSKiZuyFUJll3nzl0t33TDJWYg1n4y7
         dCqA==
X-Forwarded-Encrypted: i=1; AJvYcCV/CFQM7kAhwpAln5oZ0YN0I/VkcmoJeJ8I2/i0e5ilrSLPY22lI9B0CsLKnFB1yUvEjExvtPQ67ZJj@vger.kernel.org
X-Gm-Message-State: AOJu0YymBQWMyG17x2zg7LWbuPjoOQ7Sb/Kv1QVPBpWoSQJwTE8BRPJk
	PIoMdlBJYhpNPbFF/9+te9pZNgzamd801Zdg37ZWMENYsxvVf0APTvLXEUbuOVtSMFKaxHoLRIq
	Uq15T5cZ3ql7nQUnGHHIQUHP+i/qkif9dWtQiM1yXcg==
X-Gm-Gg: ASbGncushV66tzRhWuMANd4V/7rGrp9xGZdBwZFRlkMcOvyeJnHAadx3PU6PQYLbla9
	8p3XZsajtDsUKO7n+Cixt2Aj1y4S2PXlAMdlEUksL5ZXkgTBi6RquoVqZX1TNDXZxot6W4xTTiv
	Qn1zIolTm/050j4DV4I8zs74cuSrjrp7HWssz6jJ0LpX7e9kllqlV3gf06+LkuMwR5Z8bpN1BW7
	zNxFkM/S5j/GfaiaC4iAj46/iJIqSHJ5kpXNxMMi13fGTFhSJUDRynHEvBpxReiTMwWaG2S42Mh
	MeCpg9Re6IeYNsLtYOB4wS9ZcaV7aP6xWShzgmdFQvGfnFwp6dJtZyHy72XbdsY=
X-Google-Smtp-Source: AGHT+IF6nb0XFEY4hvcPmD684X1LLVnE8WIkq4uAC1EOIPxVrPDPf3pSobV7ttGqY8U/2wHv22LJA0oZ+NuEWodb+x4=
X-Received: by 2002:a05:6830:252:b0:7c7:1a6:6a09 with SMTP id
 46e09a7af769-7c798bf2716mr5653494a34.17.1764081745530; Tue, 25 Nov 2025
 06:42:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Justin Piszcz <jpiszcz@lucidpixels.com>
Date: Tue, 25 Nov 2025 09:42:11 -0500
X-Gm-Features: AWmQ_bk5BLfGjtbuPG45HuYMv-wNYW6cT8NjghdCxB7iHGsDTxTzucuMonB00cg
Message-ID: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
Subject: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting reset, CSTS=0x1)
To: LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hello,

Issue/Summary:
1. Usually once a month, a random WD Red SN700 4TB NVME drive will
drop out of a NAS array, after power cycling the device, it rebuilds
successfully.

Details:
0. I use an NVME NAS (FS6712X) with WD Red SN700 4TB drives (WDS400T1R0C):
1. Ever since I installed the drives, there will be a random drive
that drops offline every month or so, almost always when the system is
idle.
2. I have troubleshot this with Asustor and WD/SanDisk.
3. Asustor noted that they did have other users with the same
configuration running into this problem.
4. When troubleshooting with WD/SanDisk's it was noted my main option
is to replace the drive, even though the issue occurs across nearly
all of the drives.
5. The drives are up to date currently according to the WD Dashboard
(when removing them and checking them on another system).
6. As for the device/filesystem, the FS6712X's configuration is
MD-RAID6 device with BTRFS on-top of it.
7. The "workaround" is to power cycle the FS6712X and when it boots up
the MD-RAID6 re-syncs back to a healthy state.

I am using the latest Asus ADM/OS which uses the 6.6.x kernel:
1. Linux FS6712X-EB92 6.6.x #1 SMP PREEMPT_DYNAMIC Tue Nov  4 00:53:39
CST 2025 x86_64 GNU/Linux

Questions:
1. Have others experienced this failure scenario?
2. Are there identified workarounds for this issue outside of power
cycling the device when this happens?
3. Are there any debug options that can be enabled that could help to
pinpoint the root cause?
4. Within the BIOS settings, which starts 2:18 below there are some
advanced settings that are shown, could there be a power saving
feature or other setting that can be modified to address this issue?
4a. https://www.youtube.com/watch?v=YytWFtgqVy0

[1] The last failures have been at random times on the following days:
1. August 27, 2025
2. September 19th, 2025
3. September 29th, 2025
4. October 28th, 2025
5. November 24, 2025

Chipset being used:
1. ASMedia Technology Inc.:ASM2806 4-Port PCIe x2 Gen3 Packet Switch

Details:

1. August 27, 2025
[1156824.598513] nvme nvme2: I/O 5 QID 0 timeout, reset controller
[1156896.035355] nvme nvme2: Device not ready; aborting reset, CSTS=0x1
[1156906.057936] nvme nvme2: Device not ready; aborting reset, CSTS=0x1
[1158185.737571] md/raid:md1: Disk failure on nvme2n1p4, disabling device.
[1158185.744188] md/raid:md1: Operation continuing on 11 devices.

2. September 19th, 2025
[2001664.727044] nvme nvme9: I/O 26 QID 0 timeout, reset controller
[2001736.159123] nvme nvme9: Device not ready; aborting reset, CSTS=0x1
[2001746.180813] nvme nvme9: Device not ready; aborting reset, CSTS=0x1
[2002368.631788] md/raid:md1: Disk failure on nvme9n1p4, disabling device.
[2002368.638414] md/raid:md1: Operation continuing on 11 devices.
[2003213.517965] md/raid1:md0: Disk failure on nvme9n1p2, disabling device.
[2003213.517965] md/raid1:md0: Operation continuing on 11 devices.

3.  September 29th, 2025
[858305.408049] nvme nvme3: I/O 8 QID 0 timeout, reset controller
[858376.843140] nvme nvme3: Device not ready; aborting reset, CSTS=0x1
[858386.865240] nvme nvme3: Device not ready; aborting reset, CSTS=0x1
[858386.883053] md/raid:md1: Disk failure on nvme3n1p4, disabling device.
[858386.889586] md/raid:md1: Operation continuing on 11 devices.

4. October 28th, 2025
[502963.821407] nvme nvme4: I/O 0 QID 0 timeout, reset controller
[503035.257391] nvme nvme4: Device not ready; aborting reset, CSTS=0x1
[503045.282923] nvme nvme4: Device not ready; aborting reset, CSTS=0x1
[503142.226962] md/raid:md1: Disk failure on nvme4n1p4, disabling device.
[503142.233496] md/raid:md1: Operation continuing on 11 devices.

5. November 24th, 2025
[1658454.034633] nvme nvme2: I/O 24 QID 0 timeout, reset controller
[1658525.470287] nvme nvme2: Device not ready; aborting reset, CSTS=0x1
[1658535.491803] nvme nvme2: Device not ready; aborting reset, CSTS=0x1
[1658535.517638] md/raid1:md0: Disk failure on nvme2n1p2, disabling device.
[1658535.517638] md/raid1:md0: Operation continuing on 11 devices.
[1659258.368386] md/raid:md1: Disk failure on nvme2n1p4, disabling device.
[1659258.375012] md/raid:md1: Operation continuing on 11 devices.


Justin
