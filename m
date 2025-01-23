Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com [209.85.219.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A4620F070
	for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737640594; cv=none; b=L2f4+iteRWv4ITlTQEubivuH+d/ErTPJbnXVCdJBx4eE+egBoQvr+Suww/Ri+10SkBvrSLsK2fsGgCVo6dLKfpldENr+rHwMB00D7w7x73r8S4g5PEZjBGb0e4L5PabxTtqqaWURDBAjT76MLPUIfQJ3f9HmYO9AqaAdBk4Ci5A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737640594; c=relaxed/simple;
	bh=SrPm3AcoPGTcWtTP67Mb8BH9xb4WdKlSLA/oYOBcU6A=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=ho7BFwHuhPrhicBiHZ3GgGNiznoD8RQh4F7LPV+p0MhzI7nqi55I4aR2aFd13xMKmvIcHCIlV3vOtKDWhQ35yArjjbc+1cDrhXYREKfXlID8NeMeE1K2F5BBCN1upfZ3oWOcMRPaa0a+zC2otuE0J3vDYGqzTFIdbs3yhA6/1Ro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TagJiuRX; arc=none smtp.client-ip=209.85.219.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TagJiuRX"
Received: by mail-yb1-f180.google.com with SMTP id 3f1490d57ef6-e39779a268bso1492632276.1
        for <linux-raid@vger.kernel.org>; Thu, 23 Jan 2025 05:56:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1737640592; x=1738245392; darn=vger.kernel.org;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zwrsHInt80R7fTcQmmn0JwtCR/10rrkxcNp6DjPF340=;
        b=TagJiuRXFRp1i0uVMUjZA54BpirlKQyK+LMQb+VqLUr2Q6tc4cdXBmMERhLhaNfnAD
         umc4UxwSH1EiQ1lhB3piPfAE8loecpJWwh1fnUNreLmfccGQ3SHs19J+zo40HiEXfKKl
         S6M3SLq5jvMn+AWcv6767WMtF9QvB3NjYfKVia5+XXBWrKMSsJgVHAl/CeOFqj3IAw2z
         kcsrv3j8tav8amExeTO14o31xoZU+Of0u2tz7p+EchKWH7ULkHYSFPvuBu98iHTIVYHS
         Rw929CHcS81mjsHg4pFkJEfj6I4TPoo40f4tfbGa4aYtiGaddbOPvDTakUDt/mt3AVI2
         1+Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737640592; x=1738245392;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zwrsHInt80R7fTcQmmn0JwtCR/10rrkxcNp6DjPF340=;
        b=o/R9feoUB2XHOkW/YUIyW8BVe26rENnZ/8tcZTUrCQfxeq1lrNDMC+/8SbBXcLUyWS
         h3No25Z2Jij8uteoqSA+EGsUdYVPBhoreAzeOaKI9+CZam8H8xC9Ss8e6dp9vKUMPSrg
         nW3hkqD7TuoIiBgq4zbM6K7wYORj+Tj2JMNIimpZS6vjeph3EQcICROFJW3K563dgsxM
         bIkC7ku96P+UhnkV4AO8m0tmpxGGyTP+RwtXEGGVH038t2Un0CdP4h4/MUv1hk1h/oSn
         fOftdYwMIJ2dL81JlnhmgCYQeSO5tvrGyvStZZrK9fpeAG49HpJsRqT/XSoF7Ybs1Ur9
         38NQ==
X-Forwarded-Encrypted: i=1; AJvYcCVh7u4qPinGXFfqeCcOk3S9icDH4pdqAX/zv2H/M+43yOoSh2Of9nbz8CqoaqUKPvoQzOUTBVhNDnF2@vger.kernel.org
X-Gm-Message-State: AOJu0YyGFL/eIkv8ojXNXTiltVfwASp/mxkWPR1GeotZ53xpuoLcW6YS
	4AkBndGUVMjbgKTPuhZwSGzd684W/mT9AkT21N69GhEnAW/W3AcXdNU+M0J62IVRjxSCDYghblf
	pndw1dPECNMv+E++MoF1ElRa/KBM=
X-Gm-Gg: ASbGncvR/1i+qJazOA4vnEolDeSeQ8tE1Yn7sFSgcIoFSU9wYSlnESOAt//tf6N5Vek
	ewZ1T3j9fLPLw6mf4g4E5q6lRg0kj23/fOSWZ4FPvfl0n/1GmomHx6MvYOdqrNus=
X-Google-Smtp-Source: AGHT+IHF2YI2Y8XiQNDVAG3/iCwa0jOX7KoWgjt0dqlWiObOwHaZxQYpV8CMRcbK3nwsC3SJRanBSyLpam8NxCJOISQ=
X-Received: by 2002:a05:6902:e07:b0:e58:7ce:3421 with SMTP id
 3f1490d57ef6-e58257a561fmr2829736276.4.1737640591878; Thu, 23 Jan 2025
 05:56:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Thu, 23 Jan 2025 15:56:20 +0200
X-Gm-Features: AWEUYZlV3tIy7lQIY4My1mkmAe5w3jNajPogD2So_SrIgufJyIeqZ40UYCDnBWI
Message-ID: <CAAiJnjqFwETu8ZwE44jdNWk=UYbdoNJr0W7pjkgjkTy0ff8grA@mail.gmail.com>
Subject: Huge lock contention during raid5 build time
To: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi

I'm building mdadm raid5 (3+1), based on Intel's NVMe SSD P4600.

Mdadm next version

[root@memverge2 ~]# /home/anton/mdadm/mdadm --version
mdadm - v4.4-13-ge0df6c4c - 2025-01-17

Maximum performance I saw ~1.4 GB/s.

[root@memverge2 md]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 nvme0n1[4] nvme2n1[2] nvme3n1[1] nvme4n1[0]
      4688044032 blocks super 1.2 level 5, 512k chunk, algorithm 2 [4/3] [U=
UU_]
      [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>......]  recovery =3D 71.=
8%
(1122726044/1562681344) finish=3D5.1min speed=3D1428101K/sec
      bitmap: 0/12 pages [0KB], 65536KB chunk

Perf top shows huge spinlock contention

Samples: 180K of event 'cycles:P', 4000 Hz, Event count (approx.):
175146370188 lost: 0/0 drop: 0/0
Overhead  Shared Object                             Symbol
  38.23%  [kernel]                                  [k]
native_queued_spin_lock_slowpath
   8.33%  [kernel]                                  [k] analyse_stripe
   6.85%  [kernel]                                  [k] ops_run_io
   3.95%  [kernel]                                  [k] intel_idle_irq
   3.41%  [kernel]                                  [k] xor_avx_4
   2.76%  [kernel]                                  [k] handle_stripe
   2.37%  [kernel]                                  [k] raid5_end_read_requ=
est
   1.97%  [kernel]                                  [k] find_get_stripe

Samples: 1M of event 'cycles:P', 4000 Hz, Event count (approx.): 7170387479=
38
native_queued_spin_lock_slowpath  /proc/kcore [Percent: local period]
Percent =E2=94=82       testl     %eax,%eax
        =E2=94=82     =E2=86=91 je        234
        =E2=94=82     =E2=86=91 jmp       23e
   0.00 =E2=94=82248:   shrl      $0x12, %ecx
        =E2=94=82       andl      $0x3,%eax
   0.00 =E2=94=82       subl      $0x1,%ecx
   0.00 =E2=94=82       shlq      $0x5, %rax
   0.00 =E2=94=82       movslq    %ecx,%rcx
        =E2=94=82       addq      $0x36ec0,%rax
   0.01 =E2=94=82       addq      -0x7b67b2a0(,%rcx,8),%rax
   0.02 =E2=94=82       movq      %rdx,(%rax)
   0.00 =E2=94=82       movl      0x8(%rdx),%eax
   0.00 =E2=94=82       testl     %eax,%eax
        =E2=94=82     =E2=86=93 jne       279
  62.27 =E2=94=82270:   pause
  17.49 =E2=94=82       movl      0x8(%rdx),%eax
   0.00 =E2=94=82       testl     %eax,%eax
   1.66 =E2=94=82     =E2=86=91 je        270
   0.02 =E2=94=82279:   movq      (%rdx),%rcx
   0.00 =E2=94=82       testq     %rcx,%rcx
        =E2=94=82     =E2=86=91 je        202
   0.02 =E2=94=82       prefetchw (%rcx)
        =E2=94=82     =E2=86=91 jmp       202
   0.00 =E2=94=82289:   movl      $0x1,%esi
   0.02 =E2=94=82       lock
        =E2=94=82       cmpxchgl  %esi,(%rbx)
        =E2=94=82     =E2=86=91 je        129
        =E2=94=82     =E2=86=91 jmp       20e

Are there any plans to optimize spinlock contention ?

Latest PCI 5.0 NVMe SSDs have tremendous performance characteristics,
but huge spinlock contention just kills that performance.

Anton
