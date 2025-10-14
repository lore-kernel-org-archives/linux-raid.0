Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 811A23009CE
	for <linux-raid@vger.kernel.org>; Tue, 14 Oct 2025 19:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760471598; cv=none; b=Wmb8rre9yHgrp7QmfbA3Vm5kFuEinUzAysxXZunfhEjmsGkHJUy6gGFPGudGm1oGkQcJxbYBTJJextrjDZ3/1RnUb3GPlp2n/e68G2ljW+z3w1NgyupY2BSGKPCRppgJeqyf6nJWFtM0+jGf/7DaddkjuSYbqtBVDoIbIT6L7nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760471598; c=relaxed/simple;
	bh=/kILl9BcrYDptnunV8fH0oumhGpgJxsAXmHn+OqLAXw=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=dwTbl1svrciMbSHea5OaYJ5J8KuIGOhm/xo7gaWG+DJ0MN2bOqL2VzTjuXWYygdiConIPqMfT/u+5ouR4f2s30m6uHxUVicsELkCDD4HdZZtp6qRJfYUvYyQ38ela1XhuwYiHTcfYM3BazsvlN1oaWW97gs6XdHisnUbeMX6q4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XaaXI6wF; arc=none smtp.client-ip=209.85.208.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaaXI6wF"
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63beb2653dbso267892a12.2
        for <linux-raid@vger.kernel.org>; Tue, 14 Oct 2025 12:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760471595; x=1761076395; darn=vger.kernel.org;
        h=content-transfer-encoding:autocrypt:subject:from:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SJdakYlWJTzr8za/Tj9/V4j0eRgIWiXlyWfyg3RC3ww=;
        b=XaaXI6wFKvty+I3U1S99OSU8pmA0bP6YuA0s5IEiYtbNvP0WfN28zM2u7Bxp319MK/
         E97y87R6WlMFu6k0feIAMmwQ2JPz6CN/2BIa1h1rrjaaBimjor5wuMB3+YOs88ZefouC
         AvvQv6rWfHKUPSov6xwK39J50yUe2MO4wjHr7/ys3pzXt3b2+gkfnDG0t4wg7FkCsHpA
         TMpzyoPFblElaCMORztphMugRYflA5UwAbOp6DDq2DsHk1ZU56y/NlDC8IiDhz0piAVT
         knKPENQfmf0UctdO3y361qV7GSlADJtxekdWpjii1wTzY+vU2ZPwsSkkY0ltd0liKWz3
         +ICw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760471595; x=1761076395;
        h=content-transfer-encoding:autocrypt:subject:from:to
         :content-language:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SJdakYlWJTzr8za/Tj9/V4j0eRgIWiXlyWfyg3RC3ww=;
        b=YjsMl2qwt0ZBqZmOOXENFakyt1F27Zh8cdAmb1+jA8ZvsFEtuRkhe3R/BpnEK8RmhC
         dM/JbDGObzFNRihyDuVEDpOe+6VGKZDuPQQvkPYc1LmbBX4WmVKGl7LhrZMUeotO1XmZ
         ZIDnlnt8okyvOpZ2lGy3jUTrDgp0AWGOtRwcM8d3p2xGqXtVAZ2TknDoUds7dZa/hcJm
         RQRIzt/Wf/BxTYT9/vYxix6ZrohyuYUVARlsQpxLgS2museDOE94UJW5cOPP6lnlneis
         3nt/s6LjYhqQ7uWZQCi972aE1ySDB26tJ8Kol3yA97Ox81I56ujLQ5ceT6znPTFbTwKD
         TalA==
X-Gm-Message-State: AOJu0Yy7xiwGyFCxU/ATO/oTXBxgYJf/pIG7ZhY04Gdxs0Y1LQF728mN
	UOj4n0MHtui3EyrnOjruSE1UoZlQqGQlochiQbqlVIo4BRVHfW7VhJbdfiDNeg==
X-Gm-Gg: ASbGncuvGVHn4QmZ0BuwoRWMnO/c3HWd+bPV6BxUR70gJHWbFKmyfcYdSP+EbUFbzX1
	H9r1wrjGRSHAAOBY9kaZmuVaZy9yNpztD6yEHfqmXgFkgSzysDVoGRKQUCZBE7/yw8LPzx+fSSw
	KxBiVk9mjJFC2Mk0l3yBlvIdN79V7eMK0cmpleC4/kmsbVXcbxGO8eCLEMqNL/tR0hgMdidRpKl
	FD7pxaJ9whNe04KOBhKxZxYTLxvKbaWP+NuizIXk84IggyKW/0pIUQrMelAwPytpQoI4xu1auT9
	vhqw+W6NpnC+PJ01VE5sN7w/MirroqdWjkAmZ7O4xtCzubppQELMGNZPgORIjmhoKFIT3VfCXdD
	ibYQtOtUKsNBFcuiQEKWLFMzAyd7qBweJMEzuXSocTqCdzE1M1hRNcMd1rquTTlugsZkwmZMFC7
	auI40qv3nkOw==
X-Google-Smtp-Source: AGHT+IGAXWm1HVr6oJ1OuVncmhrDDcfdCHHxy2+EYMpuJIl9P1s4vOcLPNIkv4vIbOIKYeMl9mmqNA==
X-Received: by 2002:a17:907:7f17:b0:b45:c0cc:2fe9 with SMTP id a640c23a62f3a-b50ac8e5577mr2715339566b.46.1760471594596;
        Tue, 14 Oct 2025 12:53:14 -0700 (PDT)
Received: from [192.168.0.3] (mob-5-90-139-32.net.vodafone.it. [5.90.139.32])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b5cb965cc74sm52803966b.17.2025.10.14.12.53.13
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Oct 2025 12:53:14 -0700 (PDT)
Message-ID: <6588535f-2721-4b48-8438-1fe1ac2ead16@gmail.com>
Date: Tue, 14 Oct 2025 21:53:12 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-raid@vger.kernel.org
From: Franco Martelli <martellif67@gmail.com>
Subject: Unable to set group_thread_cnt using mdadm.conf
Autocrypt: addr=martellif67@gmail.com; keydata=
 xjMEXwx9ehYJKwYBBAHaRw8BAQdA8CkGKYFI/MK9U3RPhzE5H/ul7B6bHu/4BIhTf6LLO47N
 J0ZyYW5jbyBNYXJ0ZWxsaSA8bWFydGVsbGlmNjdAZ21haWwuY29tPsKWBBMWCAA+FiEET9sW
 9yyU4uM6QbloXEn0O0LcklAFAmhyroACGwMFCQ0ncuYFCwkIBwIGFQoJCAsCBBYCAwECHgEC
 F4AACgkQXEn0O0LcklAHVwD9H5JZ52g292FD8w0x6meDD8y/6KkNpzuaLHP6/Oo8kAIBAJsh
 aMB9LdCBJTMtnxU8JTHtAoGOZ/59UJWeZIkuWJUNzjgEXwx9ehIKKwYBBAGXVQEFAQEHQNP5
 V2q0H0oiJu89h1SSPgQDtkixXvUvRf1rNLLIcNpPAwEIB8J+BBgWCAAmFiEET9sW9yyU4uM6
 QbloXEn0O0LcklAFAmhyroACGwwFCQ0ncuYACgkQXEn0O0LcklASVwEAoEkHMEU7mHc0zmAu
 D2R1PYsDh9+3wQeied5PrF+HdakBAOeSGsf40GBew5umZuM59I04d1uXYAXGMP+jGN2RUtMA
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

~$ cat /etc/mdadm/mdadm.conf | grep -v "#"


HOMEHOST <system>

MAILADDR root

ARRAY /dev/md/0  metadata=1.2 UUID=8bdf78b9:4cad434c:3a30392d:8463c7e0
    spares=1


SYSFS name=/dev/md/0 group_thread_cnt=8
SYSFS uuid=8bdf78b9:4cad434c:3a30392d:8463c7e0 sync_speed_max=1000000


after I makes changes to the file I rebuild the initramfs image file and 
reboot. The thing that seems strange to me is that the other item I set 
(sync_speed_max) is changed accordingly, only "group_thread_cnt" fails 
to set (it's always =0).
Why "sync_speed_max" is set while "group_thread_cnt" it is not? Any clue?

Thanks in advance, kind regards.
--
Franco Martelli

