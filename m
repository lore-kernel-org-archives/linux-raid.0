Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFB31373
	for <linux-raid@vger.kernel.org>; Wed,  5 Jun 2024 11:03:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717585399; cv=none; b=YSzgcMk4KLcXQtQrjQWuDPh+1VTxVsmbEXGZM3BlURbW1ghXb826e/J9tC6Xw/D+GbjT+pjiGaGLUfWjIVhe1Mddjc2QME4u0+MgxWf3TqAKFWDT2ux/60yxMFKhIM+uAugJwQHwdzkTxaEJsb4NCW8Gkv5FJq7Rb4YLdp4VRA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717585399; c=relaxed/simple;
	bh=AkjTzOV98popNg+NQJtYvgRIeHS/T57Ixd8hjCD/QWE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=gckn6ROw0Rfo9GEo2MwijOtOFSjNObMRT36S/2iQwO6HaIDhJ8OBZDHv10pc1gmL8Ee9ESJOtblodysfwVNbtasBchwaNzN7b3GbLQxL2r4MkxyzLK8Xn83AARyngOK+wjpkM5dzg+7L+AdlWnEmOk+etarouwh6dzGZZuOD+hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=NfYxlZ6a; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="NfYxlZ6a"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2bfdae7997aso5339677a91.2
        for <linux-raid@vger.kernel.org>; Wed, 05 Jun 2024 04:03:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1717585396; x=1718190196; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AkjTzOV98popNg+NQJtYvgRIeHS/T57Ixd8hjCD/QWE=;
        b=NfYxlZ6ahzhNx7xc32yvxhLTFgSu+nWSKoAhvOmq2b1wLc8ySW6qTaY2P2Qh4coiN1
         uPidtjhEMMOJ45b7SSGvD6IxNqZuAqhJdGIyxQRE7h9ci34vDdITcunqQdQn8rBfGce1
         DFWiAj+pVYMRh3Qfhh8RncKGzDQGXTdnmH+cl8t3tk2UdSUAZBoc7KxK4T/zZGSJX9Bn
         uP75PIDLRu1hrMq4NxG04MJdF4lON9Z63ksTKcNnKYhjNZ3xci1CSt8MZJvvVApxa8I2
         BkkNiReuDdpmchHNQkvm5GCY8m+4/kmUh0XQn+SXGfAWMZo5ly1wSsjqA4jjBTh3ZVP2
         lHWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717585396; x=1718190196;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AkjTzOV98popNg+NQJtYvgRIeHS/T57Ixd8hjCD/QWE=;
        b=WwMAbMdH/vywxmh8yEo1HD/iq1YiwJB3vGZWVpLfwMn+/HLBtQqTCqSSz/OJhj9Rjk
         jmchnfHx38QPMgmofSBWBiNsdlnsUt1OuDHv3iI3AdLwHdB8gLS2CrwlABqSwrqa7ZQW
         faOCSu1bJnK2+QZmul5qtobO0tf+kMtoURn7vMbbgH5PDD6o9vLgxMtNeo14V+M/p1gb
         podMDgKDXJV9LYEAYc2DtfGVzJs8EqlCUhrf4sTYT4LouAM9AWclyV4ZBNaLcGbwpQv0
         GQJOnRAvLHAPFeWSOv4WHGxns0lnP7+n9D7yQUvlka4PTmXRle7iUF16PW+DHG2tjtsf
         F+Zg==
X-Gm-Message-State: AOJu0YyHjfG7i6SjhStubTO2TfRs5vr55TXTEy+KNeSyCTD+7UYxvM3m
	H7XY7Qpft8n9Bz+Txuydiu81deBcjKVxMnJ87nTy4QDHAp3E+dCIZ/L6GoCfHMxLsBEv6wB0XmC
	Vv36fB3yr3E/MFOo3MRGO4V7U1uXqXpFzolYGBoAL/MOApYzT12gy6g==
X-Google-Smtp-Source: AGHT+IHd+uUq3SVZ8LhI39CpqtI/ClHRmSMuOoSpFjVbcCAkmQzcbjkt6v/0+sJCYb9IlWB9uy4tpqc4N5hEzO6g7YU=
X-Received: by 2002:a17:90a:fe04:b0:2c1:ea2e:20b2 with SMTP id
 98e67ed59e1d1-2c27db57d16mr2054293a91.30.1717585396034; Wed, 05 Jun 2024
 04:03:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Lakshmi Narasimhan Sundararajan <lsundararajan@purestorage.com>
Date: Wed, 5 Jun 2024 16:33:03 +0530
Message-ID: <CAFe+wq0JfKxmomPNPhKbvXaNjEQXb_==xNRhjvGEJBEjeKU_Sg@mail.gmail.com>
Subject: Recovering mdraid after node reboot
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Team,
A very good day to you all.

I have a below scenario wherein mdraid array (raid0 originally) is
failing to assemble after a node reboot, while array was expanding
capacity (hence raid4).
Can you please confirm that the forced recovery in this below scenario
is correct and reliable always.

1/ create md array (raid0)
example cmd:
mdadm -C /dev/md/vol0 -n 2 --metadata 1.2 -c 1024 -l 0 /dev/sda /dev/sdb

2/ array goes full, so need to expand capacity
Since this is a virtual environment, I am able to resize /dev/sda and
/dev/sdb disks outside that are attached to my server node.

After increasing the disk capacity backing disks /dev/sda and
/dev/sdb, I am attempting to grow the array to the max capacity.

3/ Convert md array to raid 4
mdadm -G /dev/md/vol0 -l 4

4/ grow array to max capacity
mdadm -G /de/vmd/vol0 --size max

5/ put it back to raid 0
mdadm -G /de/vmd/vol0 -l 0

In the above sequence, I only expand capacity by resizing the array
elements and not by adding new disk to the array. While in the above
sequence, I hit a power fail and node got rebooted.

After node reboot, since array was in raid4 it failed to come online.
```
Jun 03 23:08:35 kernel: md/raid:md126: not clean -- starting
background reconstruction
Jun 03 23:08:35 kernel: md/raid:md126: device sda operational as raid disk 0
Jun 03 23:08:35 kernel: md/raid:md126: device sdb operational as raid disk 1
Jun 03 23:08:35 kernel: md/raid:md126: cannot start dirty degraded array.
Jun 03 23:08:35 md/raid:md126: failed to run raid set.
Jun 03 23:08:35 kernel: md: pers->run() failed ...
```

I recovered the array using the below sequence, given the array
expansion was only through disk capacity resize.

mdadm -S /dev/md126 /// which mapped to /dev/md/vol0 above
mdadm -C /dev/md/vol0 -n 2 --metadata 1.2 -c 1024 -l 0 --assume-clean
--force /dev/sda /dev/sdb

This brought up the array back online and contents were okay too.

So in the above sequence of actions, I want to understand the following:
-- is the above method a reliable way to recover array incase there
was a node reboot while in raid4 state?

-- Please let me know your thoughts on recovery and data reliability
on the array while recovering through the above sequence.

Many thanks and kind regards for your help and insights.
LN
