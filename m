Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52532226CFE
	for <linux-raid@vger.kernel.org>; Fri, 14 Nov 2025 02:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763087186; cv=none; b=HOC32LoNDPCcMTDL2dqpcbD/ydNp2+/Vx1uDkiTqOqaN6rUoIa+QbTNNuyaj5BO+c0UVpeq1u/xO5tBiI0VrQyb9QXQV8x1Ejsy0h1hm+h5raslbzlfmYVuOfrzWnE8dT5rqVOkDUpYkzUggTAMlDeX/fahsoc5stV5DrrfBOdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763087186; c=relaxed/simple;
	bh=fLTtIkrqNnfba+tl2UZGhlSPsXeifMdt0D7LRvTucXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lz8bljI0mnnAzACxJNOwNmup21N9Kbv4rqU044iysYXf9PcIZroUgUf1R+wpkkkDCAPsaxlFjB14nL7zL7MTr33RBG5rWolhL1X8F6bRPrfgL7It1WZrgHwLY/yVAFttwWqOj1aZZSmD0taEf4ZirTBKl2FI9yOUiNYX++IYkWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CmiNqiyR; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=pjYnGWNL; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CmiNqiyR";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="pjYnGWNL"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1763087183;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GD9W63QN4cItEgsrQQ2eVvaqhF2qUTqA1EWvvr37lmE=;
	b=CmiNqiyRkL1b5vHyeXRB7t+EMKYBB0AjHHWtMMFeeMavAqj9sSuJPEU1bmIxSRkCWCAKfS
	K4i49YJZqNkP06WnvyoLteoax7v30N7cozfoTFdSl1qxf/ZJWSFqs3P87qZk1yb/iC7wNu
	KwC/kZCw5PrTQsP5BLz/AzLLiPF8xyI=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-434-lgLTW5cHMr-1ZaN2CdLYjA-1; Thu, 13 Nov 2025 21:26:21 -0500
X-MC-Unique: lgLTW5cHMr-1ZaN2CdLYjA-1
X-Mimecast-MFC-AGG-ID: lgLTW5cHMr-1ZaN2CdLYjA_1763087180
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-3436d81a532so3333418a91.3
        for <linux-raid@vger.kernel.org>; Thu, 13 Nov 2025 18:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1763087180; x=1763691980; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GD9W63QN4cItEgsrQQ2eVvaqhF2qUTqA1EWvvr37lmE=;
        b=pjYnGWNLiM4LeQ4G1GU8brTuyizPP5oxOYLpvZ4wd65I7cpWYPCbzZaQ4Tl2dwoueI
         pThHbwX/9rit9bh66SymONMnf82cIAQXQg28CfPiF8aYQuDbjG87hgmSh+Sxhp4fqM3l
         2upEeuJ0WUwaq8onTvXa+FF3q/ALl3zBYKF2VplRouNG0lOQbU36rfT7J8Scsjx8EXLC
         GKSeUBBimumivu5EG5CDbpC5IpNB0ZxQcyxLUkm1HE++5t+PYbl3s+pINjSj2JC26EEq
         4hLYT/mzmq+FAOSSq11YH5D4wvGkjE3W8B7aPS4PmvhvKy8QT8MffQp4Zb9EGxrMyDkX
         Bhdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763087180; x=1763691980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GD9W63QN4cItEgsrQQ2eVvaqhF2qUTqA1EWvvr37lmE=;
        b=eKf5hfHjnGn7Hub0B0X+HX1EJKJ3ZysTHSWBNSdSSHDPGGTleIO++/gn1e9kQQE2IY
         4MSeHqVc72DWeV4mFYDMwwxjKzvDGR3LF+y6wycKVrcSj4oflGNDKINqodzCl+iYkqUb
         lwdfN8Mvj1RUL4Qu6ruhhZAWBOuYxI+5Pcf7M1J7ZJAaLb7U88HTKNz2sU0Cl2EIAbQu
         4hx4Z/jYQ8Eko6JiMAQF/eU2jp1nwPwe8ntP5ahDNimxAn0N/wk/XNI/JkFoefpHqeYf
         sEM9DieleZ6mFSVzgtPsTkdMaKEGDz3Aws/kEus0rUOgj1BSsqDHbaM0RWagDUs9REmm
         xHDQ==
X-Forwarded-Encrypted: i=1; AJvYcCXGeJmxtKTkzfwIJOSBpizNzLKmozIJS/0RJXDhLyGDZjHt0+0Ww/T12o60lGK9JzD8JzREFNruxOYH@vger.kernel.org
X-Gm-Message-State: AOJu0YxXaff1ZTwjvFxrn/FCo12PtDgoH9K3fx4oKfxzeg2RpukTH3ic
	cKMaRaXA4X+mQdG+DtMV/xbOmp+lB7hxRsDqpr+A4jS9NO3RlObIZOx3leR9D8+9UM/F8FbiKsr
	yJQ3sEwS2OCWpo6yGhYIYtiH0CQu10yYFUHzDfAFNbtjQBrszqSaP2BsEipbYH6qnpDGRlzHFQf
	a6wABr+2441QqHtQNPX4DKyeMwfP5M3TuCldNCZg==
X-Gm-Gg: ASbGncsHmKTmaCGx0xXCcNT4FBPS3fwVzXfd/jb5JoFzU0zgf2zkBdDVO6Mng0BPOAH
	AjBLKhcxue5TVw8iAXdknlz/PNsQrTz8FmC09Pg4LA/XR5lpg0AwUibYbKP8Fjs+oisLnAWnS9L
	JHwowrl3NqGywvUqUFR1S4R5AIH/5x2chBZ9mBA/eCYTbP2Bbr2tQS6i2Lwk+jqs6dgI1FjqU1Z
	M3QKMMzFM9WGLTUJtJCvv/gh6xMfdkYHua2b+xR6XMq9L+QrpTs/ulARWs=
X-Received: by 2002:a05:7301:f85:b0:2a4:3593:969e with SMTP id 5a478bee46e88-2a4abd4a65cmr490303eec.27.1763087180222;
        Thu, 13 Nov 2025 18:26:20 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEnShmLr7WOkNWBl/yooqGH/mhdN+MOiTaJEkYWxSFexA1ZLheJsM8C2JIVIDYZD9MzLRTeiRY7GAsZdRzKksA=
X-Received: by 2002:a05:7301:f85:b0:2a4:3593:969e with SMTP id
 5a478bee46e88-2a4abd4a65cmr490299eec.27.1763087179692; Thu, 13 Nov 2025
 18:26:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+VqVnvGeneUoTbYvBv2cw6GwQRrR3B-iQ-_9rVfyumoKA@mail.gmail.com>
 <CAGVVp+Wo9nReFJYyERZxa8a9Jp7nogce=A8GS3GENHUi42mC_Q@mail.gmail.com> <15937d38-7b5f-4951-9c59-6531c236ed2d@fnnas.com>
In-Reply-To: <15937d38-7b5f-4951-9c59-6531c236ed2d@fnnas.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Fri, 14 Nov 2025 10:26:07 +0800
X-Gm-Features: AWmQ_bkm2tWITM2gWVyhCdjrcG9JFROX3JnJVX3S_bIFL9C1XCIICvZVSVy-TyM
Message-ID: <CAGVVp+VU3-2p-SvBT+ObFw-UBD+mUsjec5-pcjHPhTa3=5kPpw@mail.gmail.com>
Subject: Re: [bug report] BUG: kernel NULL pointer dereference, address: 0000000000000050
To: yukuai@fnnas.com
Cc: Linux Block Devices <linux-block@vger.kernel.org>, linux-raid@vger.kernel.org, 
	Ming Lei <ming.lei@redhat.com>, Li Nan <linan122@huawei.com>, Xiao Ni <xni@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 13, 2025 at 2:52=E2=80=AFPM Yu Kuai <yukuai@fnnas.com> wrote:
>
> Hi,
>
> =E5=9C=A8 2025/11/12 17:33, Changhui Zhong =E5=86=99=E9=81=93:
> > On Wed, Nov 12, 2025 at 5:02=E2=80=AFPM Changhui Zhong <czhong@redhat.c=
om> wrote:
> >> the following kernel panic was triggered,
> >> please help check and let me know if you need any info/test, thanks.
> >>
> >> repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/
> >> branch: for-next
> >> INFO: HEAD of cloned kernel
> >> commit 9d5d227cc571e4dde525aa4fa00bb049c436a9b9
> >> Merge: 6e2eeb8123bc 6d7e3870af11
> >> Author: Jens Axboe <axboe@kernel.dk>
> >> Date:   Tue Nov 11 08:39:32 2025 -0700
> >>
> >>      Merge branch 'for-6.19/block' into for-next
> >>
> >>      * for-6.19/block:
> >>        blk-mq-dma: fix kernel-doc function name for integrity DMA iter=
ator
> >>
> >> reproducer:
> >> # cat repro.sh
> >> #!/bin/bash
> >>
> >> for i in {0..3};do
> >>          dd if=3D/dev/zero bs=3D1M count=3D2000 of=3Dfile$i.img
> >>          sleep 1
> >>          device=3D$(losetup -fP --show file$i.img)
> >>          devices+=3D" $device"
> >>          eval "dev$i=3D$device"
> >>          sleep 1
> >>          mkfs -t xfs -f $device
> >> done
> >>
> >> echo "dev list: $dev0 ,$dev1 ,$dev2 ,$dev3"
> >> pvcreate -y $devices
> >> vgcreate  black_bird $devices
> >>
> >> lvcreate --type raid0 --stripesize 64k -i 3 \
> >>          -n non_synced_primary_raid_3legs_1 -L 1G \
> >>          black_bird $dev0:0-300 $dev1:0-300 \
> >>          $dev2:0-300 $dev3:0-300
> >>
> >>
> >> dmesg log:
> >> [  375.341923] BUG: kernel NULL pointer dereference, address: 00000000=
00000050
> >> [  375.349711] #PF: supervisor read access in kernel mode
> >> [  375.355450] #PF: error_code(0x0000) - not-present page
> >> [  375.361178] PGD 1366f3067 P4D 0
> >> [  375.364783] Oops: Oops: 0000 [#1] SMP NOPTI
> >> [  375.369454] CPU: 15 UID: 0 PID: 9991 Comm: lvcreate Kdump: loaded
> >> Tainted: G S                  6.18.0-rc5+ #1 PREEMPT(voluntary)
> >> [  375.382561] Tainted: [S]=3DCPU_OUT_OF_SPEC
> >> [  375.386938] Hardware name: Lenovo ThinkSystem SR650 V2/7Z73CTO1WW,
> >> BIOS AFE118M-1.32 06/29/2022
> >> [  375.396647] RIP: 0010:create_strip_zones+0x3c/0x7d0 [raid0]
> >> [  375.402872] Code: 49 89 fc 55 53 48 89 f3 48 83 ec 48 48 8b 3d 63
> >> 86 2a f3 48 89 74 24 38 be c0 0d 00 00 e8 9c c5 f9 f1 49 89 c6 49 8b
> >> 44 24 78 <48> 8b 40 50 8b a8 b0 00 00 00 48 c7 03 f4 ff ff ff 4d 85 f6
> >> 0f 84
> >> [  375.423830] RSP: 0018:ff6856f988a0fa10 EFLAGS: 00010246
> >> [  375.429655] RAX: 0000000000000000 RBX: ff6856f988a0fa90 RCX: 000000=
0000000000
> >> [  375.437620] RDX: 0000000000000000 RSI: ffffffffc14cc7f4 RDI: ff2081=
5ae89bdc60
> >> [  375.445586] RBP: ffffffffc16407c5 R08: 0000000000000020 R09: 000000=
0000000000
> >> [  375.453552] R10: ff6856f988a0fa10 R11: fefefefefefefeff R12: ff2081=
5af4df6058
> >> [  375.461516] R13: ffffffffc160b0c0 R14: ff20815ae89bdc40 R15: 000000=
0000000000
> >> [  375.469480] FS:  00007f4bf7188940(0000) GS:ff20815e3a471000(0000)
> >> knlGS:0000000000000000
> >> [  375.478514] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >> [  375.484926] CR2: 0000000000000050 CR3: 0000000128c76004 CR4: 000000=
0000773ef0
> >> [  375.492892] PKRU: 55555554
> >> [  375.495912] Call Trace:
> >> [  375.498641]  <TASK>
> >> [  375.500986]  raid0_run+0x10d/0x150 [raid0]
> >> [  375.505559]  md_run+0x2bb/0x790
> >> [  375.509068]  ? __pfx_autoremove_wake_function+0x10/0x10
> >> [  375.514906]  raid_ctr+0x492/0xcdb [dm_raid]
> >> [  375.519579]  dm_table_add_target+0x193/0x3c0 [dm_mod]
> >> [  375.525240]  populate_table+0x9a/0xd0 [dm_mod]
> >> [  375.530214]  ? __pfx_table_load+0x10/0x10 [dm_mod]
> >> [  375.535571]  table_load+0xc9/0x230 [dm_mod]
> >> [  375.540250]  ctl_ioctl+0x1a0/0x300 [dm_mod]
> >> [  375.544933]  dm_ctl_ioctl+0xe/0x20 [dm_mod]
> >> [  375.549612]  __x64_sys_ioctl+0x96/0xe0
> >> [  375.553800]  ? syscall_trace_enter+0xfe/0x1a0
> >> [  375.558664]  do_syscall_64+0x7f/0x810
> >> [  375.562757]  ? __rseq_handle_notify_resume+0x35/0x60
> >> [  375.568301]  ? arch_exit_to_user_mode_prepare.isra.0+0xa2/0xd0
> >> [  375.574816]  ? do_syscall_64+0xb1/0x810
> >> [  375.579100]  ? clear_bhb_loop+0x30/0x80
> >> [  375.583382]  ? clear_bhb_loop+0x30/0x80
> >> [  375.587665]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> >> [  375.593303] RIP: 0033:0x7f4bf74464bf
> >> [  375.597294] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24
> >> 10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00
> >> 00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28
> >> 00 00
> >> [  375.618244] RSP: 002b:00007ffef26ed6d0 EFLAGS: 00000246 ORIG_RAX:
> >> 0000000000000010
> >> [  375.626695] RAX: ffffffffffffffda RBX: 00005583edb4f810 RCX: 00007f=
4bf74464bf
> >> [  375.634660] RDX: 00005583edb4f8f0 RSI: 00000000c138fd09 RDI: 000000=
0000000003
> >> [  375.642625] RBP: 00007ffef26ed8b0 R08: 00005583eadfbbb8 R09: 00007f=
fef26ed580
> >> [  375.650588] R10: 0000000000000007 R11: 0000000000000246 R12: 000055=
83ead95d8c
> >> [  375.658553] R13: 00005583edb4f9a0 R14: 00005583ead95d8c R15: 000000=
0000000020
> >> [  375.666517]  </TASK>
> >> [  375.668955] Modules linked in: raid0 dm_raid raid456
> >> async_raid6_recov async_memcpy async_pq async_xor xor async_tx
> >> raid6_pq tls rpcsec_gss_krb5 auth_rpcgss nfsv4 dns_resolver nfs lockd
> >> grace nfs_localio netfs rfkill intel_rapl_msr intel_rapl_common
> >> intel_uncore_frequency intel_uncore_frequency_common i10nm_edac
> >> skx_edac_common nfit libnvdimm x86_pkg_temp_thermal intel_powerclamp
> >> coretemp kvm_intel kvm ipmi_ssif irqbypass rapl intel_cstate cdc_ether
> >> iTCO_wdt usbnet mgag200 dax_hmem iTCO_vendor_support cxl_acpi cxl_port
> >> cxl_core mii isst_if_mmio intel_uncore i2c_i801 isst_if_mbox_pci
> >> i2c_algo_bit mei_me intel_th_gth ioatdma einj pcspkr i2c_smbus
> >> isst_if_common intel_th_pci intel_pch_thermal mei intel_vsec intel_th
> >> dca ipmi_si acpi_power_meter acpi_ipmi ipmi_devintf ipmi_msghandler
> >> acpi_pad sg fuse loop xfs sd_mod ahci libahci libata
> >> ghash_clmulni_intel tg3 wmi sunrpc dm_mirror dm_region_hash dm_log
> >> dm_multipath dm_mod nfnetlink
> >>
> >>
> >> Best Regards,
> >> Changhui
> >
> Thanks for the test, the problem is due to mddev->gendisk is NULL for dm-=
raid.
> Following patch should fix this problem.
>
> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
> index 47aee1b1d4d1..985c377356eb 100644
> --- a/drivers/md/raid0.c
> +++ b/drivers/md/raid0.c
> @@ -68,7 +68,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>          struct strip_zone *zone;
>          int cnt;
>          struct r0conf *conf =3D kzalloc(sizeof(*conf), GFP_KERNEL);
> -       unsigned int blksize =3D queue_logical_block_size(mddev->gendisk-=
>queue);
> +       unsigned int blksize =3D 512;
> +
> +       if (!mddev_is_dm(mddev))
> +               blksize =3D queue_logical_block_size(mddev->gendisk->queu=
e);
>
>          *private_conf =3D ERR_PTR(-ENOMEM);
>          if (!conf)
> @@ -84,6 +87,10 @@ static int create_strip_zones(struct mddev *mddev, str=
uct r0conf **private_conf)
>                  sector_div(sectors, mddev->chunk_sectors);
>                  rdev1->sectors =3D sectors * mddev->chunk_sectors;
>
> +               if (mddev_is_dm(mddev))
> +                       blksize =3D max(blksize, queue_logical_block_size=
(
> +                                     rdev1->bdev->bd_disk->queue));
> +
>                  rdev_for_each(rdev2, mddev) {
>                          pr_debug("md/raid0:%s:   comparing %pg(%llu)"
>                                   " with %pg(%llu)\n",
>

Hi=EF=BC=8CYu Kuai

thank you for your patch, your patch fixed this issue.
I re-ran my test with your patch and confirmed that the reproducer no
longer triggered the issue after applying your patch.

Tested-by: Changhui Zhong <czhong@redhat.com>

