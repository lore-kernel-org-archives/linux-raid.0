Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024C4139CE8
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 19:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713556174; cv=none; b=mo6b3k7FkpEXyrwEpN3E1SlO+rVUbBhE1w34te4R/t1STWWrvWANoVvydJaj3mCrh/ueJhoJVnNkC9kW5IZS7MEkM/pYWph7m4REsfsueKpes7DK5suMvGS85ZaICT++YEIOzHb6HsxxDxmpaQI9G3ZAoCoqJJVIz7piLKJw/b0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713556174; c=relaxed/simple;
	bh=0t7cKbHNyWYShZ1IUGM0RXzaw7CnwctOL8RpndHLsII=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Content-Type; b=r3QpJ+pZooaZbJRGuvhJDig+dzXf3/GIAsTnaQhkxzWDIUo73oxSD50zKN33IB5UezpqpZZE0u195uj6yrcbh7k1fqstGAWUI/quJFB1tAn2zV1ehCl32669X8H0kbM3EXbpSI6iUFsPuVetwLv8PRPxHxguILSg67E7ASQ7mr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YHBV1BBE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YHBV1BBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713556171;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=qutXDxjlH08P27L4yT/YrOOs9KtnCtU60dymyHlpZak=;
	b=YHBV1BBEWoYAHRWSEF0eexEv825Qc6sGOvhLtycIDhZi0RZmY0cmDEFer4kE4ElUTW+hfW
	FrHHGG1HFm+pdrlsJziQCU/YsZo2nTjjKmG50OENj0fWzYyX2yxIIioTLEc9y/9eB+bBzZ
	cxSq8T0KbKtKHKzsbArnpkwUv6q5avY=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-VbNNELZuNueK8jmPiLCiuQ-1; Fri, 19 Apr 2024 15:49:30 -0400
X-MC-Unique: VbNNELZuNueK8jmPiLCiuQ-1
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-78f08178393so539855385a.1
        for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 12:49:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713556168; x=1714160968;
        h=content-transfer-encoding:content-language:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=qutXDxjlH08P27L4yT/YrOOs9KtnCtU60dymyHlpZak=;
        b=VVIjfCDDuHab8iLi5nK8GLMq5+u6wdOSMyAWNfD2yFnhov/Bw/fwL5pWCE1KTkk0lZ
         /9nNE8njI+ZBwmjvqnxNh4NiDK8oIcC0A+yvUUb73aAa1LYbFz7rG9lK6MmQoHSOb5fQ
         oiyMMmEBeNlfB85amXW6B2YaMDTNg0YLXUvmevytasm6QLZSF4/f2H6Jx/R6OgUepil7
         amAj9QVJibyWx99l/Bfd2bWFo/Fx0K7TAZ9c4OeadReLUcwu3eOsDqwKXhk/A69qjoKR
         0OAD8cKCIQNAm9Q5/wocjMaOrGtNh7N5o68XsRbx4+vSP9Qb3WsiCql8jU+KBo/iETET
         cxuw==
X-Gm-Message-State: AOJu0YxcgY5kRX8tPyfwxztL1cuWJwPtl/r6dRSdrzwguSWIgZCa5xp/
	XaijWeUAHfGzsRhKY8RpmbDqpyDa3Y+zaaadwoV2drAHSVZM4ryXCQv133sa4QlfcbLiOjsCyqI
	pgptEVoq0en/Vzq/B0+II2o35vmvENvxlQB11fY2EKzsUN+UrKwps3Ozdsa15YR3xrpXuUB8/Pk
	eyQihh3WxFYaASWahGrPaJY65OitGtJD22E9nHgyCIjg==
X-Received: by 2002:a05:620a:688b:b0:78f:19d3:9b7c with SMTP id rv11-20020a05620a688b00b0078f19d39b7cmr5487675qkn.19.1713556168251;
        Fri, 19 Apr 2024 12:49:28 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IE5u5TOKpD5x5N5rmSfwlUYuNw4j5eCoLNifXW8L1zYfqI9AqajZTomoQ+0TVPK4PrNAUMHGw==
X-Received: by 2002:a05:620a:688b:b0:78f:19d3:9b7c with SMTP id rv11-20020a05620a688b00b0078f19d39b7cmr5487643qkn.19.1713556167849;
        Fri, 19 Apr 2024 12:49:27 -0700 (PDT)
Received: from [192.168.50.193] ([134.195.185.129])
        by smtp.gmail.com with ESMTPSA id n20-20020a05620a295400b0078ec6778be9sm1865511qkp.111.2024.04.19.12.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 19 Apr 2024 12:49:27 -0700 (PDT)
Message-ID: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
Date: Fri, 19 Apr 2024 15:49:26 -0400
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Nigel Croxon <ncroxon@redhat.com>
Subject: regression: CPU soft lockup with raid10: check slab-out-of-bounds in
 md_bitmap_get_counter
To: linux-raid@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Xiao Ni <xni@redhat.com>, song@kernel.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

There is a problem with this commit, it causes a CPU#x soft lockup

commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
Author: Li Nan <linan122@huawei.com>
Date:   Mon May 15 21:48:05 2023 +0800
md/raid10: check slab-out-of-bounds in md_bitmap_get_counter

Message from syslogd@rhel9 at Apr 19 14:14:55 ...
  kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s! [mdX_resync:6976]

dmesg:

[  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not 
tainted 6.9.0-rc4-next-20240419 #1
[  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.16.2-1.fc38 04/01/2014
[  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
[  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90 90 90 
90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb 65 ff 0d 95 9f 75 
76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc cc cc cc cc cc cc cc cc
[  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
[  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX: 
000000000000000c
[  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI: 
ffff926160ccd200
[  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09: 
0000000000000000
[  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12: 
0000000000000000
[  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15: 
ffff926151019000
[  104.245611] FS:  0000000000000000(0000) GS:ffff9273f9580000(0000) 
knlGS:0000000000000000
[  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4: 
0000000000370ef0
[  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[  104.245618] Call Trace:
[  104.245620]  <IRQ>
[  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
[  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
[  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
[  104.245638]  ? hrtimer_interrupt+0xff/0x240
[  104.245640]  ? sched_clock+0xc/0x30
[  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
[  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
[  104.245652]  </IRQ>
[  104.245653]  <TASK>
[  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
[  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
[  104.245661]  md_bitmap_start_sync+0x6b/0xf0
[  104.245668]  raid10_sync_request+0x25c/0x1b40 [raid10]
[  104.245676]  ? is_mddev_idle+0x132/0x150
[  104.245680]  md_do_sync+0x64b/0x1020
[  104.245683]  ? __pfx_autoremove_wake_function+0x10/0x10
[  104.245690]  md_thread+0xa7/0x170
[  104.245693]  ? __pfx_md_thread+0x10/0x10
[  104.245696]  kthread+0xcf/0x100
[  104.245700]  ? __pfx_kthread+0x10/0x10
[  104.245704]  ret_from_fork+0x30/0x50
[  104.245707]  ? __pfx_kthread+0x10/0x10
[  104.245710]  ret_from_fork_asm+0x1a/0x30
[  104.245714]  </TASK>

When you run the reproducer script below...

#!/bin/sh
vg=t
lv=t
devs="/dev/sd[c-j]"
sz=3G
isz=2G
path=/dev/$vg/$lv
mnt=/mnt/$lv

vgcreate -y $vg $devs
lvcreate --yes --nosync --type raid10 -i 2 -n $lv -L $sz $vg

mkfs.xfs $path
mkdir -p $mnt
mount $path $mnt
df -h

for i in {1..10}
do
     lvextend -y -L +$isz -r $path
     lvs
done

lvs -a -o +devices
lvchange --syncaction check $path
#lvs -ovgname,lvname,copypercent t/t         <-- this cmd to watch

