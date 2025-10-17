Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB1282F6911
	for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 14:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760710057; cv=none; b=mnsq9AawMWDdyKSiaCBm/CWe2m4Ba1fD8uX3Qk235gVkEUPO/10s6hIBLZZcGJU4FvtQDq1lNYdY7xprV0HVcpdVWQ4sXgw7/+GB3Yp55DRQamgP5GAZ5vTTqckPCqliJ0qsJglQiUJOauht/B/97V0gOTIKcEidigP2WJOKtBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760710057; c=relaxed/simple;
	bh=AUpR5lII1xMXhkdO7Vx1nzQF8qdArM+7YkPZJTNzgJs=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=MgiAkHQk6qwkXbpZznMcqTSFofPa5uhranLmvVMFkpXhzgJ9dnyn6+jclzhdA+5z+7ZYtLyG2Mh7GF4motVXVDSZR6FNbip6lZxFOabr4FNBc9iWAwL5UpIZ2akrlBRYSbj2/pQp3QHeXG11YY1M3PabWlP8lRSIdVNI7TwDy8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWaCE8IY; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWaCE8IY"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63bf76fc9faso3532480a12.2
        for <linux-raid@vger.kernel.org>; Fri, 17 Oct 2025 07:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760710054; x=1761314854; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:autocrypt:content-language:to:subject
         :from:user-agent:mime-version:date:message-id:from:to:cc:subject
         :date:message-id:reply-to;
        bh=kQYJVyngugpPpMtD0BP9xYK9WdrOA9vfEzivjyz6WLA=;
        b=mWaCE8IY8FUXCO1uCUN2Y2+2lZjmrqwxfMBSuQazYzT44YKQLNKDdX+JiIKlg+lrDx
         6CVaV0SqQi0/NeL4dix7/TktJx4SbJcD9TXWFR6/w5OyYjbdo7/Awb/ZUOhOyxoxwvVS
         IcWqRcIA7MIeUpMlPE6D7CD+e5Az2dW1KEK6qMlZ+uiB+PBFWOvaISORJ2pSYdC7Xfpx
         zWq1idr5Q2WE3jhH/BkfDKVUpOe8v1muHIl7eXIgV3GTE4ZP2mFORYH/kI7dCqRh07VU
         mArnHJoHhY5SfYkOGsWXcM2EJM74K0Lzzfsv7ovRpoZsraytHvWIkcX9bgTnZWCBIZlA
         7QfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760710054; x=1761314854;
        h=content-transfer-encoding:cc:autocrypt:content-language:to:subject
         :from:user-agent:mime-version:date:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kQYJVyngugpPpMtD0BP9xYK9WdrOA9vfEzivjyz6WLA=;
        b=Kxw2rT2VTt0oMlCw/2ULNrQAtiJ0m3t0FSeorioUK580Is7N2fziMdPTod7L2QLSCP
         m+VqFA7vzOURRSlxsEffpP+01MdcZSmWR5Xep1+Sae7nUIVnvfLzFA7s10l2LNTC2es6
         Cjs7OjmEXf/ImrwsreUwulkOE08A1VI3hMqd3GsadcViHhHKy69LPkykz0T4Sezh7C6E
         JA/JWTk3Woa1fNCfNf4PXMI/PiVy2ZHufKwQTNMjs8ncVME3Taon6yxmZtivDGyVUGel
         6QQ7QXg2Tc+9gCX21qdBkwf3gR5doNSuChg1ezZ1DS5AvSR3VTwoT85Hfmq7byDbR7VI
         9wWQ==
X-Gm-Message-State: AOJu0YzfUJxYy0zXr23mwgc2GpKdddMF9NA1VuLITCRFcvoA0ozqSleD
	3M5JKL6D5ag9WMNGQexAsCEf0KNQFL6reuqJHtg0yG9I8Rf8wsFKHPpYx8YUKIOt
X-Gm-Gg: ASbGnctRsXC45BXTqZ7MWqbOImd5tEsYE9BXjNIQHsXi1X+hsEQUee9ZLEqEP2p3/Qn
	hvwIdwn2KKNgatFl3b5Kcxk2TizcIlMw7Xp5cZWkXRIUNGBzBx4k21N//loyblrBdTwSV/XUr9I
	PMXkXza2z1Fc7CSxFgyJwswl2S70xGn4mqNkAy3MaElO1cmZUkAYBheieSVtdQc3JRX3mGgM/Rg
	8sk1+uYS9oq5y1Pvt3LfDLYk5N54YKwmrTXw7jNKEYrUF82Q8qxTSFx4jSs4b9w/ahwMLwi66ZQ
	A9E60dS2DuxUvsQsrY2cxqnkNPdXhS4XrH/jK3QOwMLCqMhJCmsww0BAeOm43tdCpEibiMfZvBF
	9FbeFa3GQRM0qyGneMZjBg1ifyYPXbtgiEaX1qCgDnfo99igZdUINuRegFlSi+Z7eaFjf453bed
	ys9xFb4HfBqJnTYx/T6SAMr0z0puT8y62TL5lSddW+VucT
X-Google-Smtp-Source: AGHT+IF97TGcRsmGejAbuPGjCaeWERyNyk+knShTFHZJWE5ukF6ml9a0W8N4FfCnzjdNSg7iDVP0yw==
X-Received: by 2002:a05:6402:3483:b0:639:e308:f0a2 with SMTP id 4fb4d7f45d1cf-63c1f6b4d55mr3474873a12.18.1760710053666;
        Fri, 17 Oct 2025 07:07:33 -0700 (PDT)
Received: from [192.168.0.3] (mob-5-90-139-32.net.vodafone.it. [5.90.139.32])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-63a5235dccfsm18499428a12.9.2025.10.17.07.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 07:07:33 -0700 (PDT)
Message-ID: <608328b7-9dfe-4edd-afd5-68366fb845bc@gmail.com>
Date: Fri, 17 Oct 2025 16:07:31 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Franco Martelli <martellif67@gmail.com>
Subject: Unable to set group_thread_cnt using mdadm.conf
To: linux-raid@vger.kernel.org
Content-Language: en-US
Autocrypt: addr=martellif67@gmail.com; keydata=
 xjMEXwx9ehYJKwYBBAHaRw8BAQdA8CkGKYFI/MK9U3RPhzE5H/ul7B6bHu/4BIhTf6LLO47N
 J0ZyYW5jbyBNYXJ0ZWxsaSA8bWFydGVsbGlmNjdAZ21haWwuY29tPsKWBBMWCAA+FiEET9sW
 9yyU4uM6QbloXEn0O0LcklAFAmhyroACGwMFCQ0ncuYFCwkIBwIGFQoJCAsCBBYCAwECHgEC
 F4AACgkQXEn0O0LcklAHVwD9H5JZ52g292FD8w0x6meDD8y/6KkNpzuaLHP6/Oo8kAIBAJsh
 aMB9LdCBJTMtnxU8JTHtAoGOZ/59UJWeZIkuWJUNzjgEXwx9ehIKKwYBBAGXVQEFAQEHQNP5
 V2q0H0oiJu89h1SSPgQDtkixXvUvRf1rNLLIcNpPAwEIB8J+BBgWCAAmFiEET9sW9yyU4uM6
 QbloXEn0O0LcklAFAmhyroACGwwFCQ0ncuYACgkQXEn0O0LcklASVwEAoEkHMEU7mHc0zmAu
 D2R1PYsDh9+3wQeied5PrF+HdakBAOeSGsf40GBew5umZuM59I04d1uXYAXGMP+jGN2RUtMA
Cc: xni@redhat.com, ncroxon@redhat.com, mtkaczyk@kernel.org
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello,

I've a RAID5 array on Debian 13:

~$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [linear] [raid0] [raid1] [raid10]
md0 : active raid5 sda1[0] sdc1[2] sdd1[3](S) sdb1[1]
       1953258496 blocks super 1.2 level 5, 512k chunk, algorithm 2 
[3/3] [UUU]

unused devices: <none>

~# mdadm --version
mdadm - v4.4 - 2024-11-07 - Debian 4.4-11

the issue is that I can't set group_thread_cnt if I use the syntax 
described in mdadm.conf(5) man-page:

…
SYSFS name=/dev/md/raid5 group_thread_cnt=4 sync_speed_max=1000000
SYSFS uuid=bead5eb6:31c17a27:da120ba2:7dfda40d group_thread_cnt=4 
sync_speed_max=1000000

my "mdadm.conf" is:

~$ grep -v '^#' /etc/mdadm/mdadm.conf


HOMEHOST <system>

MAILADDR root

ARRAY /dev/md/0  metadata=1.2 UUID=8bdf78b9:4cad434c:3a30392d:8463c7e0
    spares=1


SYSFS name=/dev/md/0 group_thread_cnt=8
SYSFS uuid=8bdf78b9:4cad434c:3a30392d:8463c7e0 sync_speed_max=1000000


after I makes changes to the file "mdadm.conf" I rebuild the initramfs 
image file and reboot. The thing that seems strange to me is that the 
other item I set (sync_speed_max) is changed accordingly, only 
"group_thread_cnt" fails to set (it's always ==0):

~$ cat /sys/block/md0/md/group_thread_cnt
0
~$ cat /sys/block/md0/md/sync_speed_max
1000000 (system)

Why "sync_speed_max" is set while "group_thread_cnt" it is not? Any clue?

Thanks in advance, kind regards.
--
Franco Martelli
