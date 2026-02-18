Received: from mail-10698.protonmail.ch (mail-10698.protonmail.ch [79.135.106.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6C625F984
	for <linux-raid@vger.kernel.org>; Wed, 18 Feb 2026 13:44:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771422265; cv=none; b=JPkcDBidJys++Wee4lPr/BcAYSMw2Dx01NyJIsg5t+PAW8CtiBdyl6zm/wRYQ0ahc9Crzk2f0nhqSIG6VzJIkLk7TiatGD6vgUDlmIj5QFRkbosbsVgixO+8lbBJEHAnyd9qds4Tpi9GdPjFjroEn+lbWTEy+RkH3qKIe3CbwJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771422265; c=relaxed/simple;
	bh=EX/UerZtSmPtHOhUEk2UGrGyjJ8ti8YxlpBEa3q63Rw=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eS3lo2bUk5MQG1IPCjslby4e+xqP7JZnWKWt71ML2DPM6/HLAKsqG5X+3Tzua/Es6Y0MSj7BnmNFHIj/nVN8HjkUdilJbILBFJ57XrVLH0HeS64JxkPR9eLag4YNMb1e2FtYND4HWePZD8s7hXY7c6lyGhluCGkdtrY/BKR2j8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me; spf=pass smtp.mailfrom=proton.me; dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b=KF9wxH0X; arc=none smtp.client-ip=79.135.106.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=proton.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=proton.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=proton.me header.i=@proton.me header.b="KF9wxH0X"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=proton.me;
	s=protonmail; t=1771422249; x=1771681449;
	bh=EX/UerZtSmPtHOhUEk2UGrGyjJ8ti8YxlpBEa3q63Rw=;
	h=Date:To:From:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=KF9wxH0XYJdQwK2dpAo2wlT6RG4TLuePUGByh4lknidjh6Q3yrt05viGdPCDr2g7h
	 BtD746Mljd/omieihAw8xO/FmUJRg/I75oMHPl23Y5tfLeKbOMkC1Ts21X98astQZJ
	 TyZFkkXYMBM7ZiIi6w9IKwwk6mkkXJT5ct2r3wnU7z17cpdsdvXeC84IQ6cKVtG1CV
	 3+Uovi+IWwAAjt4NYlAfjpBVRAYoAeIIZDlTuurB4nCVr5YqFKtGL+UAq5mKYagQlp
	 0+MGQ7WQjM1qd40xmbD5z3vMhjOkAjBYXNcvmGgW3kMAx7JxlyZmZ19hE65BF13raz
	 4phYAVKhZu6bw==
Date: Wed, 18 Feb 2026 13:44:05 +0000
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
From: jfiusdq <jfiusdq@proton.me>
Subject: Fw: Re: slab raid6-md125 start c000000d9371bf30 pointer offset 16 size 2544 ist_add corruption. prev->next should be next
Message-ID: <QUqmufhoGWCRrAJ0n4MKQnJacw0nOQ-EJYPjtnS4Wtk5m1yxYCHrkB4_iQnLI6Mn-FzYHDXG6YxYm6eCgn3tolwX3IDToy4RtR-WJimWJ88=@proton.me>
In-Reply-To: <hWTi4qnyyq1EBkwAD1UperpLdhLIpIPWhx2YNesZO9blCrGVIa24-c8eOQ0NK7my8KqyzN_NOiV7tRODZAR1fDSpDUyibmXubU74FdXZcKs=@proton.me>
References: <7U4DoryKHwk5nrwUmPBHdm6PVnv01nM51PnTb3VAYzTtv2vPp7-FjwXkccToIFSQN6it9_9qqf5OyYRJtotDRorEfM907p3PNKvr3XUYlBY=@proton.me> <xqGbbceZZfpScrUjLzi4aIaxDEn6eM-5uusdXyCYPe-CJ4prSGsCztpS6LdkRk1l3kGSBGIraVjdk3y8g5bPBrleLnXN3Bm8Tex0AYS9Nkw=@proton.me> <hWTi4qnyyq1EBkwAD1UperpLdhLIpIPWhx2YNesZO9blCrGVIa24-c8eOQ0NK7my8KqyzN_NOiV7tRODZAR1fDSpDUyibmXubU74FdXZcKs=@proton.me>
Feedback-ID: 167378330:user:proton
X-Pm-Message-ID: 3f1da52d02e1e547999ba770c7680ca60a60c3c9
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha512; boundary="------3ccc66f98350953d7ee2d3b7b147d15aa0f13c6791987991b9c8ae5abb81122e"; charset=utf-8

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------3ccc66f98350953d7ee2d3b7b147d15aa0f13c6791987991b9c8ae5abb81122e
Content-Type: multipart/mixed;boundary=---------------------df630996e73322e4e0947ceeea6a20cd

-----------------------df630996e73322e4e0947ceeea6a20cd
Content-Type: multipart/alternative;boundary=---------------------84a2ad6ef82036717be673bbeec47f00

-----------------------84a2ad6ef82036717be673bbeec47f00
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

Hello,

I have been facing a troubling issue with weird silent data loss on latest=
 linux stable on Fedora ;

I initially thought it could be arch specific but at the end it does not s=
eem like it. Hence why I initially sent my report to linux-ppc mailing lis=
t.

I also opened an issue at RHEL's Bugzilla :=C2=A0https://bugzilla.redhat.c=
om/show_bug.cgi?id=3D2438830

I am continuously monitoring the issue and trying to gather more diagnosti=
c data, I have been unable to find the cause as of now.

If you have any idea what's causing this, also don't hesitate to ask me fo=
r more info if you need it. I am surprised that it seems not many people a=
re affected by it, at least I could not find more reports online about thi=
s same issue, weirdly.

Thanks alot
------- Forwarded Message -------
From: jfiusdq <jfiusdq@proton.me>
Date: On Tuesday, February 10th, 2026 at 4:57 PM
Subject: Re: slab raid6-md125 start c000000d9371bf30 pointer offset 16 siz=
e 2544 ist_add corruption. prev->next should be next
To: linuxppc-dev@lists.ozlabs.org <linuxppc-dev@lists.ozlabs.org>


> I have removed my out of tree module out of precaution and it still happ=
ened again, this time un-tainted kernel:
> =


> [24962.760298] sd 1:0:0:0: Power-on or device reset occurred[122456.5818=
78] =C2=A0slab raid6-md125 start c0000006487c31b0 pointer offset 16 size 2=
544
> [122456.581972] list_add corruption. prev->next should be next (c0002000=
5a376ce0), but was c0000006487c31c0. (prev=3Dc0000006487c31c0).
> [122456.582068] ------------[ cut here ]------------
> [122456.582097] kernel BUG at lib/list_debug.c:32!
> [122456.582130] Oops: Exception in kernel mode, sig: 5 [#1]
> [122456.582185] LE PAGE_SIZE=3D64K MMU=3DRadix =C2=A0SMP NR_CPUS=3D2048 =
NUMA PowerNV
> [122456.582231] Modules linked in: vhost_net vhost vhost_iotlb tap tun n=
ft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_=
tftp bridge stp llc kvm_hv kvm rfkill xt_conntrack nft_compat nft_fib_inet=
 nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_rejec=
t_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 =
nf_defrag_ipv4 nf_tables dm_cache_smq dm_cache raid456 async_raid6_recov a=
sync_memcpy async_pq async_xor async_tx sunrpc raid10 snd_hda_intel snd_in=
tel_dspcfg snd_hda_codec snd_hda_core joydev snd_hwdep snd_seq snd_seq_dev=
ice at24 onboard_usb_dev snd_pcm snd_timer atlantic tg3 snd ofpart ipmi_po=
wernv macsec soundcore powernv_flash ipmi_devintf mtd ipmi_msghandler vmx_=
crypto opal_prd rtc_opal i2c_opal fuse dm_multipath loop nfnetlink zram lz=
4hc_compress lz4_compress xfs dm_thin_pool dm_persistent_data dm_bio_priso=
n dm_crypt raid1 nvme nvme_core uas usb_storage nvme_keyring mpt3sas nvme_=
auth hkdf ast raid_class scsi_transport_sas i2c_algo_bit scsi_dh_rdac
> [122456.582467] =C2=A0scsi_dh_emc scsi_dh_alua i2c_dev aes_gcm_p10_crypt=
o crypto_simd cryptd
> [122456.583119] CPU: 5 UID: 0 PID: 2697 Comm: dmcrypt_write/2 Not tainte=
d 6.18.8-200.fc43.ppc64le #1 PREEMPT(voluntary)
> [122456.583216] Hardware name: T2P9D01 REV 1.00 POWER9 (raw) 0x4e1202 op=
al:skiboot-ecb1dc7 PowerNV
> [122456.583292] NIP: =C2=A0c000000000e098fc LR: c000000000e098f8 CTR: 00=
00000000000000
> [122456.583370] REGS: c00000003c9877a0 TRAP: 0700 =C2=A0 Not tainted =C2=
=A0(6.18.8-200.fc43.ppc64le)
> [122456.583432] MSR: =C2=A0900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,D=
R,RI,LE> =C2=A0CR: 24004240 =C2=A0XER: 00000156
> [122456.583498] CFAR: c00000000034542c IRQMASK: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR00: c00000000=
0e098f8 c00000003c987a40 c0000000026ba900 0000000000000075
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR04: 00000000f=
fffbfff 0000000000000001 0000201ff71a0000 0000000000000001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR08: 000000000=
0000027 0000000000000000 0000000000000000 c00000003c987890
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR12: c000201ff=
f18ffa8 c000201fff7e8180 c000000000299c28 c000000005aba780
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR16: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR20: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR24: 000000000=
0000000 c00000003c987c70 c000200060539800 c000200618eddb30
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR28: 000000000=
0000000 c000201485cbe738 c00000003bd42800 c000201485cbe6f0
> [122456.583968] NIP [c000000000e098fc] __list_add_valid_or_report+0xdc/0=
x140
> [122456.584045] LR [c000000000e098f8] __list_add_valid_or_report+0xd8/0x=
140
> [122456.584093] Call Trace:
> [122456.584115] [c00000003c987a40] [c000000000e098f8] __list_add_valid_o=
r_report+0xd8/0x140 (unreliable)
> [122456.584189] [c00000003c987ab0] [c008000026e90ad4] release_stripe_plu=
g+0x9c/0x150 [raid456]
> [122456.584258] [c00000003c987b00] [c008000026e959f4] make_stripe_reques=
t+0x32c/0x560 [raid456]
> [122456.584333] [c00000003c987bd0] [c008000026e95df8] raid5_make_request=
+0x1d0/0x610 [raid456]
> [122456.584418] [c00000003c987d10] [c000000001369a04] md_handle_request+=
0x1c4/0x400
> [122456.584484] [c00000003c987da0] [c000000000d04010] __submit_bio+0x230=
/0x3d0
> [122456.584560] [c00000003c987e40] [c000000000d04244] __submit_bio_noacc=
t+0x94/0x250
> [122456.584635] [c00000003c987eb0] [c00000000138743c] dm_submit_bio_rema=
p+0x4c/0x120
> [122456.584698] [c00000003c987ef0] [c00800001dc226a8] dmcrypt_write+0x1a=
0/0x200 [dm_crypt]
> [122456.584765] [c00000003c987f90] [c000000000299da8] kthread+0x188/0x1a=
0
> [122456.584818] [c00000003c987fe0] [c00000000000ded8] start_kernel_threa=
d+0x14/0x18
> [122456.584879] Code: f8c10060 f8010080 4b883b35 60000000 3c62ff82 38639=
388 e8c10060 e9210068 e8a60000 7d244b78 4b53baf5 60000000 <0fe00000> 7c080=
2a6 7c852378 7c641b78
> [122456.585015] ---[ end trace 0000000000000000 ]---
> [122457.162074] pstore: backend (nvram) writing error (-1)
> =


> [122457.162141] note: dmcrypt_write/2[2697] exited with irqs disabled
> [122457.162214] ------------[ cut here ]------------
> [122457.162257] WARNING: CPU: 5 PID: 2697 at kernel/exit.c:903 do_exit+0=
x5c/0x5b0
> [122457.162314] Modules linked in: vhost_net vhost vhost_iotlb tap tun n=
ft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntrack_=
tftp bridge stp llc kvm_hv kvm rfkill xt_conntrack nft_compat nft_fib_inet=
 nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_rejec=
t_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_ipv6 =
nf_defrag_ipv4 nf_tables dm_cache_smq dm_cache raid456 async_raid6_recov a=
sync_memcpy async_pq async_xor async_tx sunrpc raid10 snd_hda_intel snd_in=
tel_dspcfg snd_hda_codec snd_hda_core joydev snd_hwdep snd_seq snd_seq_dev=
ice at24 onboard_usb_dev snd_pcm snd_timer atlantic tg3 snd ofpart ipmi_po=
wernv macsec soundcore powernv_flash ipmi_devintf mtd ipmi_msghandler vmx_=
crypto opal_prd rtc_opal i2c_opal fuse dm_multipath loop nfnetlink zram lz=
4hc_compress lz4_compress xfs dm_thin_pool dm_persistent_data dm_bio_priso=
n dm_crypt raid1 nvme nvme_core uas usb_storage nvme_keyring mpt3sas nvme_=
auth hkdf ast raid_class scsi_transport_sas i2c_algo_bit scsi_dh_rdac
> [122457.162459] =C2=A0scsi_dh_emc scsi_dh_alua i2c_dev aes_gcm_p10_crypt=
o crypto_simd cryptd
> [122457.163011] CPU: 5 UID: 0 PID: 2697 Comm: dmcrypt_write/2 Tainted: G=
 =C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 6.18.8-20=
0.fc43.ppc64le #1 PREEMPT(voluntary)
> [122457.163123] Tainted: [D]=3DDIE
> [122457.163171] Hardware name: T2P9D01 REV 1.00 POWER9 (raw) 0x4e1202 op=
al:skiboot-ecb1dc7 PowerNV
> [122457.163240] NIP: =C2=A0c00000000026035c LR: c000000000260950 CTR: 00=
00000000000000
> [122457.163322] REGS: c00000003c987330 TRAP: 0700 =C2=A0 Tainted: G =C2=A0=
 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(6.18.8-=
200.fc43.ppc64le)
> [122457.163406] MSR: =C2=A09000000002029033 <SF,HV,VEC,EE,ME,IR,DR,RI,LE=
> =C2=A0CR: 24004240 =C2=A0XER: 20040156
> [122457.163501] CFAR: c00000000026094c IRQMASK: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR00: c00000000=
0260950 c00000003c9875d0 c0000000026ba900 0000000000000005
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR04: 000000000=
0002710 0000000000000001 0000201ff71a0000 0000000000000001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR08: 000000000=
0000005 0000000000000001 c00000003c987f18 0000000000004000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR12: c000201ff=
f18ffa8 c000201fff7e8180 0000000000000000 0000000000000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR16: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR20: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR24: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR28: 000000000=
0000005 0000000000000003 c000000003e3a900 c00000001be2a000
> [122457.163984] NIP [c00000000026035c] do_exit+0x5c/0x5b0
> [122457.164037] LR [c000000000260950] make_task_dead+0xa0/0x1d0
> [122457.164079] Call Trace:
> [122457.164126] [c00000003c9875d0] [c00000003c987600] 0xc00000003c987600=
 (unreliable)
> [122457.164216] [c00000003c987670] [c000000000260950] make_task_dead+0xa=
0/0x1d0
> [122457.164276] [c00000003c9876f0] [c00000000002a314] oops_end+0x164/0x1=
a0
> [122457.164336] [c00000003c987770] [c000000000009b2c] program_check_comm=
on_virt+0x3bc/0x3c0
> [122457.164399] ---- interrupt: 700 at __list_add_valid_or_report+0xdc/0=
x140
> [122457.164454] NIP: =C2=A0c000000000e098fc LR: c000000000e098f8 CTR: 00=
00000000000000
> [122457.164509] REGS: c00000003c9877a0 TRAP: 0700 =C2=A0 Tainted: G =C2=A0=
 =C2=A0 =C2=A0D =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(6.18.8-=
200.fc43.ppc64le)
> [122457.164575] MSR: =C2=A0900000000282b033 <SF,HV,VEC,VSX,EE,FP,ME,IR,D=
R,RI,LE> =C2=A0CR: 24004240 =C2=A0XER: 00000156
> [122457.164654] CFAR: c00000000034542c IRQMASK: 0
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR00: c00000000=
0e098f8 c00000003c987a40 c0000000026ba900 0000000000000075
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR04: 00000000f=
fffbfff 0000000000000001 0000201ff71a0000 0000000000000001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR08: 000000000=
0000027 0000000000000000 0000000000000000 c00000003c987890
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR12: c000201ff=
f18ffa8 c000201fff7e8180 c000000000299c28 c000000005aba780
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR16: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000000
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR20: 000000000=
0000000 0000000000000000 0000000000000000 0000000000000001
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR24: 000000000=
0000000 c00000003c987c70 c000200060539800 c000200618eddb30
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR28: 000000000=
0000000 c000201485cbe738 c00000003bd42800 c000201485cbe6f0
> [122457.165148] NIP [c000000000e098fc] __list_add_valid_or_report+0xdc/0=
x140
> [122457.165191] LR [c000000000e098f8] __list_add_valid_or_report+0xd8/0x=
140
> [122457.165233] ---- interrupt: 700
> [122457.165273] [c00000003c987ab0] [c008000026e90ad4] release_stripe_plu=
g+0x9c/0x150 [raid456]
> [122457.165358] [c00000003c987b00] [c008000026e959f4] make_stripe_reques=
t+0x32c/0x560 [raid456]
> [122457.165405] [c00000003c987bd0] [c008000026e95df8] raid5_make_request=
+0x1d0/0x610 [raid456]
> [122457.165481] [c00000003c987d10] [c000000001369a04] md_handle_request+=
0x1c4/0x400
> [122457.165545] [c00000003c987da0] [c000000000d04010] __submit_bio+0x230=
/0x3d0
> [122457.165593] [c00000003c987e40] [c000000000d04244] __submit_bio_noacc=
t+0x94/0x250
> [122457.165648] [c00000003c987eb0] [c00000000138743c] dm_submit_bio_rema=
p+0x4c/0x120
> [122457.165744] [c00000003c987ef0] [c00800001dc226a8] dmcrypt_write+0x1a=
0/0x200 [dm_crypt]
> [122457.165832] [c00000003c987f90] [c000000000299da8] kthread+0x188/0x1a=
0
> [122457.165889] [c00000003c987fe0] [c00000000000ded8] start_kernel_threa=
d+0x14/0x18
> [122457.165960] Code: 91610008 f8010010 f821ff61 e92d0c78 f9210078 39200=
000 892d0932 552907fe 0b090000 e95f0c68 312affff 7d295110 <0b090000> ebbf0=
b90 ebdf0b88 7fa3eb78
> [122457.166065] ---[ end trace 0000000000000000 ]---
> On Monday, February 9th, 2026 at 12:38 AM, jfiusdq <jfiusdq@proton.me> w=
rote:
> =


> > Sorry for duplicate but it happened after a disk started failing durin=
g a check that was triggered on all my 3 RAID arrays and then after a good=
 while this bug happened. That's basically it.
> > =


> > [154043.105837] md: check of RAID array md125[154049.432225] md: check=
 of RAID array md126
> > [154055.718196] md: check of RAID array md127
> > [163101.001572] sd 1:0:0:0: [sda] tag#8069 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163101.001655] sd 1:0:0:0: [sda] tag#8069 CDB: Read(10) 28 00 1b 28 d=
1 80 00 02 80 00
> > [163101.001691] I/O error, dev sda, sector 455659904 op 0x0:(READ) fla=
gs 0x80700 phys_seg 5 prio class 2
> > [163101.412714] sd 1:0:0:0: Power-on or device reset occurred
> > [163101.698759] sd 1:0:0:0: [sda] tag#7728 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163101.698813] sd 1:0:0:0: [sda] tag#7728 CDB: Read(10) 28 00 74 70 6=
d 00 00 00 80 00
> > [163101.698843] I/O error, dev sda, sector 1953524992 op 0x0:(READ) fl=
ags 0x80700 phys_seg 1 prio class 2
> > [163102.162693] sd 1:0:0:0: Power-on or device reset occurred
> > [163102.447648] sd 1:0:0:0: [sda] Unaligned partial completion (resid=3D=
866300, sector_sz=3D512)
> > [163102.447723] sd 1:0:0:0: [sda] tag#8049 CDB: Read(10) 28 00 5e 21 d=
4 00 00 08 00 00
> > [163102.447751] sd 1:0:0:0: [sda] tag#8049 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163102.447789] sd 1:0:0:0: [sda] tag#8049 CDB: Read(10) 28 00 5e 21 d=
4 00 00 08 00 00
> > [163102.447855] I/O error, dev sda, sector 1579275264 op 0x0:(READ) fl=
ags 0x80700 phys_seg 8 prio class 2
> > [163102.912783] sd 1:0:0:0: Power-on or device reset occurred
> > [163103.662867] sd 1:0:0:0: Power-on or device reset occurred
> > [163104.413036] sd 1:0:0:0: Power-on or device reset occurred
> > [163105.163044] sd 1:0:0:0: Power-on or device reset occurred
> > [163105.913609] sd 1:0:0:0: Power-on or device reset occurred
> > [163106.663213] sd 1:0:0:0: Power-on or device reset occurred
> > [163107.289773] sd 1:0:0:0: Power-on or device reset occurred
> > [163107.932812] sd 1:0:0:0: Power-on or device reset occurred
> > [163108.913957] sd 1:0:0:0: Power-on or device reset occurred
> > [163109.664106] sd 1:0:0:0: Power-on or device reset occurred
> > [163110.414281] sd 1:0:0:0: Power-on or device reset occurred
> > [163111.164312] sd 1:0:0:0: Power-on or device reset occurred
> > [163111.913814] sd 1:0:0:0: Power-on or device reset occurred
> > [163112.663904] sd 1:0:0:0: Power-on or device reset occurred
> > [163113.414627] sd 1:0:0:0: Power-on or device reset occurred
> > [163113.699639] sd 1:0:0:0: [sda] Unaligned partial completion (resid=3D=
205820, sector_sz=3D512)
> > [163113.699771] sd 1:0:0:0: [sda] tag#7615 CDB: Read(10) 28 00 01 4d 8=
4 00 00 04 00 00
> > [163113.699976] sd 1:0:0:0: [sda] tag#7615 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163113.700198] sd 1:0:0:0: [sda] tag#7615 CDB: Read(10) 28 00 01 4d 8=
4 00 00 04 00 00
> > [163113.700329] I/O error, dev sda, sector 21857280 op 0x0:(READ) flag=
s 0x80700 phys_seg 4 prio class 2
> > [163114.164085] sd 1:0:0:0: Power-on or device reset occurred
> > [163114.914167] sd 1:0:0:0: Power-on or device reset occurred
> > [163115.664261] sd 1:0:0:0: Power-on or device reset occurred
> > [163115.959965] sd 1:0:0:0: [sda] tag#8044 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163115.959963] sd 1:0:0:0: [sda] Unaligned partial completion (resid=3D=
308220, sector_sz=3D512)
> > [163115.959996] sd 1:0:0:0: [sda] tag#8016 CDB: Read(10) 28 00 00 58 a=
0 00 00 04 00 00
> > [163115.960041] sd 1:0:0:0: [sda] tag#8044 CDB: Read(10) 28 00 1b 48 f=
c 00 00 04 00 00
> > [163115.960081] sd 1:0:0:0: [sda] tag#8016 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163115.960109] I/O error, dev sda, sector 457767936 op 0x0:(READ) fla=
gs 0x80700 phys_seg 8 prio class 2
> > [163115.960155] sd 1:0:0:0: [sda] tag#8016 CDB: Read(10) 28 00 00 58 a=
0 00 00 04 00 00
> > [163115.960402] I/O error, dev sda, sector 5808128 op 0x0:(READ) flags=
 0x80700 phys_seg 4 prio class 2
> > [163116.414438] sd 1:0:0:0: Power-on or device reset occurred
> > [163116.706739] sd 1:0:0:0: [sda] tag#8103 FAILED Result: hostbyte=3DD=
ID_SOFT_ERROR driverbyte=3DDRIVER_OK cmd_age=3D0s
> > [163116.706804] sd 1:0:0:0: [sda] tag#8103 CDB: Read(10) 28 00 0d 86 3=
c 00 00 08 00 00
> > [163116.706853] I/O error, dev sda, sector 226900992 op 0x0:(READ) fla=
gs 0x80700 phys_seg 12 prio class 2
> > [163117.109789] sd 1:0:0:0: Power-on or device reset occurred
> > [163117.914577] sd 1:0:0:0: Power-on or device reset occurred
> > [163497.189569] md: md126: check done.
> > [163829.231426] md: md127: check done.
> > [185096.100388] md: md125: check done.
> > =


> > =


> > and just after that, just the kernel logs you saw in my previous mail,=
 nothing in between.
> > On Monday, February 9th, 2026 at 12:19 AM, jfiusdq <jfiusdq@proton.me>=
 wrote:
> > =


> > > Hello,
> > > =


> > > =


> > > Today I was met with the following kernel log on IBM POWER9, abit wo=
rrying because of it concerning RAID6:
> > > =


> > > =


> > > [240888.555387] =C2=A0slab raid6-md125 start c000000d9371bf30 pointe=
r offset 16 size 2544
> > > [240888.555464] list_add corruption. prev->next should be next (c000=
00002a3fc3e0), but was c000000d9371bf40. (prev=3Dc000000d9371bf40).
> > > [240888.555582] ------------[ cut here ]------------
> > > [240888.555615] kernel BUG at lib/list_debug.c:32!
> > > [240888.555650] Oops: Exception in kernel mode, sig: 5 [#1]
> > > [240888.555703] LE PAGE_SIZE=3D64K MMU=3DRadix =C2=A0SMP NR_CPUS=3D2=
048 NUMA PowerNV
> > > [240888.555755] Modules linked in: vendor_reset(OE) vfio_pci vfio_pc=
i_core vfio_iommu_spapr_tce vfio iommufd vhost_net vhost vhost_iotlb tap t=
un nft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntr=
ack_tftp bridge stp llc kvm_hv kvm rfkill xt_conntrack nft_compat nft_fib_=
inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_r=
eject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_i=
pv6 nf_defrag_ipv4 nf_tables dm_cache_smq dm_cache raid456 async_raid6_rec=
ov async_memcpy async_pq async_xor async_tx sunrpc raid10 snd_hda_intel at=
24 joydev snd_intel_dspcfg snd_hda_codec snd_hda_core onboard_usb_dev snd_=
hwdep snd_seq snd_seq_device snd_pcm ofpart tg3 powernv_flash snd_timer at=
lantic vmx_crypto ipmi_powernv snd ipmi_devintf mtd ipmi_msghandler macsec=
 rtc_opal opal_prd soundcore i2c_opal fuse dm_multipath loop nfnetlink zra=
m lz4hc_compress lz4_compress xfs dm_thin_pool dm_persistent_data dm_bio_p=
rison dm_crypt raid1 nvme mpt3sas nvme_core uas usb_storage ast nvme_keyri=
ng
> > > [240888.555962] =C2=A0nvme_auth hkdf raid_class i2c_algo_bit scsi_tr=
ansport_sas scsi_dh_rdac scsi_dh_emc scsi_dh_alua i2c_dev aes_gcm_p10_cryp=
to crypto_simd cryptd
> > > [240888.556531] CPU: 33 UID: 0 PID: 2851 Comm: dmcrypt_write/2 Taint=
ed: G =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OE =C2=A0 =C2=A0 =C2=A0 6.18.8-20=
0.fc43.ppc64le #1 PREEMPT(voluntary)
> > > [240888.556608] Tainted: [O]=3DOOT_MODULE, [E]=3DUNSIGNED_MODULE
> > > [240888.556650] Hardware name: T2P9D01 REV 1.00 POWER9 (raw) 0x4e120=
2 opal:skiboot-ecb1dc7 PowerNV
> > > [240888.556721] NIP: =C2=A0c000000000e098fc LR: c000000000e098f8 CTR=
: 0000000000000000
> > > [240888.556766] REGS: c0000000295e77a0 TRAP: 0700 =C2=A0 Tainted: G =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 OE =C2=A0 =C2=A0 =C2=A0 =C2=A0(6.18.8-2=
00.fc43.ppc64le)
> > > [240888.556822] MSR: =C2=A09000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE=
> =C2=A0CR: 24004280 =C2=A0XER: 00000000
> > > [240888.556904] CFAR: c00000000034542c IRQMASK: 0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR00: c0000=
00000e098f8 c0000000295e7a40 c0000000026ba900 0000000000000075
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR04: 00000=
000ffffbfff 0000000000000001 0000001ffc2d0000 0000000000000001
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR08: 00000=
00000000027 0000000000000000 0000000000000000 c0000000295e7890
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR12: c0002=
01fff18ffa8 c000001ffffde600 c000000000299c28 c0002000113fdb40
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR16: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR20: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000001
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR24: 00000=
00000000000 c0000000295e7c70 c00000002bbce800 c000001126d57830
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR28: 00000=
00000000000 c000201d2995b588 c00020005f464000 c000201d2995b540
> > > [240888.557339] NIP [c000000000e098fc] __list_add_valid_or_report+0x=
dc/0x140
> > > [240888.557405] LR [c000000000e098f8] __list_add_valid_or_report+0xd=
8/0x140
> > > [240888.557463] Call Trace:
> > > [240888.557484] [c0000000295e7a40] [c000000000e098f8] __list_add_val=
id_or_report+0xd8/0x140 (unreliable)
> > > [240888.557541] [c0000000295e7ab0] [c0080000238f0ad4] release_stripe=
_plug+0x9c/0x150 [raid456]
> > > [240888.557607] [c0000000295e7b00] [c0080000238f59f4] make_stripe_re=
quest+0x32c/0x560 [raid456]
> > > [240888.557678] [c0000000295e7bd0] [c0080000238f5df8] raid5_make_req=
uest+0x1d0/0x610 [raid456]
> > > [240888.557765] [c0000000295e7d10] [c000000001369a04] md_handle_requ=
est+0x1c4/0x400
> > > [240888.557850] [c0000000295e7da0] [c000000000d04010] __submit_bio+0=
x230/0x3d0
> > > [240888.557927] [c0000000295e7e40] [c000000000d04244] __submit_bio_n=
oacct+0x94/0x250
> > > [240888.557998] [c0000000295e7eb0] [c00000000138743c] dm_submit_bio_=
remap+0x4c/0x120
> > > [240888.558070] [c0000000295e7ef0] [c00800001bce26a8] dmcrypt_write+=
0x1a0/0x200 [dm_crypt]
> > > [240888.558131] [c0000000295e7f90] [c000000000299da8] kthread+0x188/=
0x1a0
> > > [240888.558196] [c0000000295e7fe0] [c00000000000ded8] start_kernel_t=
hread+0x14/0x18
> > > [240888.558257] Code: f8c10060 f8010080 4b883b35 60000000 3c62ff82 3=
8639388 e8c10060 e9210068 e8a60000 7d244b78 4b53baf5 60000000 <0fe00000> 7=
c0802a6 7c852378 7c641b78
> > > [240888.558363] ---[ end trace 0000000000000000 ]---
> > > [240889.114586] pstore: backend (nvram) writing error (-1)
> > > =


> > > [240889.114636] note: dmcrypt_write/2[2851] exited with irqs disable=
d
> > > [240889.114756] ------------[ cut here ]------------
> > > [240889.114785] WARNING: CPU: 33 PID: 2851 at kernel/exit.c:903 do_e=
xit+0x5c/0x5b0
> > > [240889.114837] Modules linked in: vendor_reset(OE) vfio_pci vfio_pc=
i_core vfio_iommu_spapr_tce vfio iommufd vhost_net vhost vhost_iotlb tap t=
un nft_masq nft_reject_ipv4 act_csum cls_u32 sch_htb nf_nat_tftp nf_conntr=
ack_tftp bridge stp llc kvm_hv kvm rfkill xt_conntrack nft_compat nft_fib_=
inet nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4 nf_r=
eject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack nf_defrag_i=
pv6 nf_defrag_ipv4 nf_tables dm_cache_smq dm_cache raid456 async_raid6_rec=
ov async_memcpy async_pq async_xor async_tx sunrpc raid10 snd_hda_intel at=
24 joydev snd_intel_dspcfg snd_hda_codec snd_hda_core onboard_usb_dev snd_=
hwdep snd_seq snd_seq_device snd_pcm ofpart tg3 powernv_flash snd_timer at=
lantic vmx_crypto ipmi_powernv snd ipmi_devintf mtd ipmi_msghandler macsec=
 rtc_opal opal_prd soundcore i2c_opal fuse dm_multipath loop nfnetlink zra=
m lz4hc_compress lz4_compress xfs dm_thin_pool dm_persistent_data dm_bio_p=
rison dm_crypt raid1 nvme mpt3sas nvme_core uas usb_storage ast nvme_keyri=
ng
> > > [240889.114993] =C2=A0nvme_auth hkdf raid_class i2c_algo_bit scsi_tr=
ansport_sas scsi_dh_rdac scsi_dh_emc scsi_dh_alua i2c_dev aes_gcm_p10_cryp=
to crypto_simd cryptd
> > > [240889.115528] CPU: 33 UID: 0 PID: 2851 Comm: dmcrypt_write/2 Taint=
ed: G =C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0OE =C2=A0 =C2=A0 =C2=A0 6.18.8-20=
0.fc43.ppc64le #1 PREEMPT(voluntary)
> > > [240889.115641] Tainted: [D]=3DDIE, [O]=3DOOT_MODULE, [E]=3DUNSIGNED=
_MODULE
> > > [240889.115678] Hardware name: T2P9D01 REV 1.00 POWER9 (raw) 0x4e120=
2 opal:skiboot-ecb1dc7 PowerNV
> > > [240889.115771] NIP: =C2=A0c00000000026035c LR: c000000000260950 CTR=
: 0000000000000000
> > > [240889.115828] REGS: c0000000295e7330 TRAP: 0700 =C2=A0 Tainted: G =
=C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0OE =C2=A0 =C2=A0 =C2=A0 =C2=A0(6.18.8-2=
00.fc43.ppc64le)
> > > [240889.115875] MSR: =C2=A09000000002029033 <SF,HV,VEC,EE,ME,IR,DR,R=
I,LE> =C2=A0CR: 24004280 =C2=A0XER: 20040000
> > > [240889.115936] CFAR: c00000000026094c IRQMASK: 0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR00: c0000=
00000260950 c0000000295e75d0 c0000000026ba900 0000000000000005
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR04: 00000=
00000002710 0000000000000001 0000001ffc2d0000 0000000000000001
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR08: 00000=
00000000005 0000000000000001 c0000000295e7f18 0000000000004000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR12: c0002=
01fff18ffa8 c000001ffffde600 0000000000000000 0000000000000000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR16: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR20: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR24: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR28: 00000=
00000000005 0000000000000003 c000000003e3a900 c00000004555e800
> > > [240889.116379] NIP [c00000000026035c] do_exit+0x5c/0x5b0
> > > [240889.116407] LR [c000000000260950] make_task_dead+0xa0/0x1d0
> > > [240889.116427] Call Trace:
> > > [240889.116473] [c0000000295e75d0] [c0000000295e7600] 0xc0000000295e=
7600 (unreliable)
> > > [240889.116549] [c0000000295e7670] [c000000000260950] make_task_dead=
+0xa0/0x1d0
> > > [240889.116621] [c0000000295e76f0] [c00000000002a314] oops_end+0x164=
/0x1a0
> > > [240889.116689] [c0000000295e7770] [c000000000009b2c] program_check_=
common_virt+0x3bc/0x3c0
> > > [240889.116749] ---- interrupt: 700 at __list_add_valid_or_report+0x=
dc/0x140
> > > [240889.116799] NIP: =C2=A0c000000000e098fc LR: c000000000e098f8 CTR=
: 0000000000000000
> > > [240889.116838] REGS: c0000000295e77a0 TRAP: 0700 =C2=A0 Tainted: G =
=C2=A0 =C2=A0 =C2=A0D =C2=A0 =C2=A0OE =C2=A0 =C2=A0 =C2=A0 =C2=A0(6.18.8-2=
00.fc43.ppc64le)
> > > [240889.116905] MSR: =C2=A09000000000029033 <SF,HV,EE,ME,IR,DR,RI,LE=
> =C2=A0CR: 24004280 =C2=A0XER: 00000000
> > > [240889.116967] CFAR: c00000000034542c IRQMASK: 0
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR00: c0000=
00000e098f8 c0000000295e7a40 c0000000026ba900 0000000000000075
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR04: 00000=
000ffffbfff 0000000000000001 0000001ffc2d0000 0000000000000001
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR08: 00000=
00000000027 0000000000000000 0000000000000000 c0000000295e7890
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR12: c0002=
01fff18ffa8 c000001ffffde600 c000000000299c28 c0002000113fdb40
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR16: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000000
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR20: 00000=
00000000000 0000000000000000 0000000000000000 0000000000000001
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR24: 00000=
00000000000 c0000000295e7c70 c00000002bbce800 c000001126d57830
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 GPR28: 00000=
00000000000 c000201d2995b588 c00020005f464000 c000201d2995b540
> > > [240889.117343] NIP [c000000000e098fc] __list_add_valid_or_report+0x=
dc/0x140
> > > [240889.117400] LR [c000000000e098f8] __list_add_valid_or_report+0xd=
8/0x140
> > > [240889.117454] ---- interrupt: 700
> > > [240889.117487] [c0000000295e7ab0] [c0080000238f0ad4] release_stripe=
_plug+0x9c/0x150 [raid456]
> > > [240889.117544] [c0000000295e7b00] [c0080000238f59f4] make_stripe_re=
quest+0x32c/0x560 [raid456]
> > > [240889.117605] [c0000000295e7bd0] [c0080000238f5df8] raid5_make_req=
uest+0x1d0/0x610 [raid456]
> > > [240889.117678] [c0000000295e7d10] [c000000001369a04] md_handle_requ=
est+0x1c4/0x400
> > > [240889.117738] [c0000000295e7da0] [c000000000d04010] __submit_bio+0=
x230/0x3d0
> > > [240889.117792] [c0000000295e7e40] [c000000000d04244] __submit_bio_n=
oacct+0x94/0x250
> > > [240889.117859] [c0000000295e7eb0] [c00000000138743c] dm_submit_bio_=
remap+0x4c/0x120
> > > [240889.117956] [c0000000295e7ef0] [c00800001bce26a8] dmcrypt_write+=
0x1a0/0x200 [dm_crypt]
> > > [240889.118017] [c0000000295e7f90] [c000000000299da8] kthread+0x188/=
0x1a0
> > > [240889.118084] [c0000000295e7fe0] [c00000000000ded8] start_kernel_t=
hread+0x14/0x18
> > > [240889.118131] Code: 91610008 f8010010 f821ff61 e92d0c78 f9210078 3=
9200000 892d0932 552907fe 0b090000 e95f0c68 312affff 7d295110 <0b090000> e=
bbf0b90 ebdf0b88 7fa3eb78
> > > [240889.118320] ---[ end trace 0000000000000000 ]---
> > > =


> > > =


> > > If that's any useful to reveal a bug, about the tainting module, it'=
s a port of=C2=A0https://github.com/gnif/vendor-reset=C2=A0to ppc to reset=
 some older graphics cards, nothing that should affect what the log is tal=
king about, furthermore its been here for quite a long time without any er=
rors.
> > > =


> > > =


> > > Thanks
-----------------------84a2ad6ef82036717be673bbeec47f00
Content-Type: multipart/related;boundary=---------------------1c01de8b29a39b7fe3db4b2f3829bde4

-----------------------1c01de8b29a39b7fe3db4b2f3829bde4
Content-Type: text/html;charset=utf-8
Content-Transfer-Encoding: base64

PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDE0
cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUsIDI1NSwg
MjU1KTsiPkhlbGxvLDwvZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1z
ZXJpZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNv
bG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij48YnI+PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1p
bHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwg
MCk7IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUsIDI1NSwgMjU1KTsiPkkgaGF2ZSBiZWVuIGZh
Y2luZyBhIHRyb3VibGluZyBpc3N1ZSB3aXRoIHdlaXJkIHNpbGVudCBkYXRhIGxvc3Mgb24gbGF0
ZXN0IGxpbnV4IHN0YWJsZSBvbiBGZWRvcmEgOzwvZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5
OiBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDAp
OyBiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij48YnI+PC9kaXY+PGRpdiBz
dHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDE0cHg7IGNv
bG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUsIDI1NSwgMjU1KTsi
PkkgaW5pdGlhbGx5IHRob3VnaHQgaXQgY291bGQgYmUgYXJjaCBzcGVjaWZpYyBidXQgYXQgdGhl
IGVuZCBpdCBkb2VzIG5vdCBzZWVtIGxpa2UgaXQuIEhlbmNlIHdoeSBJIGluaXRpYWxseSBzZW50
IG15IHJlcG9ydCB0byBsaW51eC1wcGMgbWFpbGluZyBsaXN0LjwvZGl2PjxkaXYgc3R5bGU9ImZv
bnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdi
KDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij48YnI+PC9k
aXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6
IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUsIDI1
NSwgMjU1KTsiPkkgYWxzbyBvcGVuZWQgYW4gaXNzdWUgYXQgUkhFTCdzIEJ1Z3ppbGxhIDombmJz
cDs8c3Bhbj48YSB0YXJnZXQ9Il9ibGFuayIgcmVsPSJub3JlZmVycmVyIG5vZm9sbG93IG5vb3Bl
bmVyIiBocmVmPSJodHRwczovL2J1Z3ppbGxhLnJlZGhhdC5jb20vc2hvd19idWcuY2dpP2lkPTI0
Mzg4MzAiPmh0dHBzOi8vYnVnemlsbGEucmVkaGF0LmNvbS9zaG93X2J1Zy5jZ2k/aWQ9MjQzODgz
MDwvYT48L3NwYW4+PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNl
cmlmOyBmb250LXNpemU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29s
b3I6IHJnYigyNTUsIDI1NSwgMjU1KTsiPjxicj48L2Rpdj48ZGl2IHN0eWxlPSJmb250LWZhbWls
eTogQXJpYWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29sb3I6IHJnYigwLCAwLCAw
KTsgYmFja2dyb3VuZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpOyI+SSBhbSBjb250aW51b3Vz
bHkgbW9uaXRvcmluZyB0aGUgaXNzdWUgYW5kIHRyeWluZyB0byBnYXRoZXIgbW9yZSBkaWFnbm9z
dGljIGRhdGEsIEkgaGF2ZSBiZWVuIHVuYWJsZSB0byBmaW5kIHRoZSBjYXVzZSBhcyBvZiBub3cu
PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNp
emU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUs
IDI1NSwgMjU1KTsiPjxicj48L2Rpdj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTogQXJpYWwsIHNh
bnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29sb3I6IHJnYigwLCAwLCAwKTsgYmFja2dyb3Vu
ZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpOyI+SWYgeW91IGhhdmUgYW55IGlkZWEgd2hhdCdz
IGNhdXNpbmcgdGhpcywgYWxzbyBkb24ndCBoZXNpdGF0ZSB0byBhc2sgbWUgZm9yIG1vcmUgaW5m
byBpZiB5b3UgbmVlZCBpdC4gSSBhbSBzdXJwcmlzZWQgdGhhdCBpdCBzZWVtcyBub3QgbWFueSBw
ZW9wbGUgYXJlIGFmZmVjdGVkIGJ5IGl0LCBhdCBsZWFzdCBJIGNvdWxkIG5vdCBmaW5kIG1vcmUg
cmVwb3J0cyBvbmxpbmUgYWJvdXQgdGhpcyBzYW1lIGlzc3VlLCB3ZWlyZGx5LjwvZGl2PjxkaXYg
c3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxNHB4OyBj
b2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7
Ij48YnI+PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBm
b250LXNpemU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29sb3I6IHJn
YigyNTUsIDI1NSwgMjU1KTsiPlRoYW5rcyBhbG90PC9kaXY+PGRpdiBjbGFzcz0icHJvdG9ubWFp
bF9xdW90ZSI+CiAgICAgICAgLS0tLS0tLSBGb3J3YXJkZWQgTWVzc2FnZSAtLS0tLS0tPGJyPgog
ICAgICAgIEZyb206IGpmaXVzZHEgJmx0O2pmaXVzZHFAcHJvdG9uLm1lJmd0Ozxicj4KICAgICAg
ICBEYXRlOiBPbiBUdWVzZGF5LCBGZWJydWFyeSAxMHRoLCAyMDI2IGF0IDQ6NTcgUE08YnI+CiAg
ICAgICAgU3ViamVjdDogUmU6IHNsYWIgcmFpZDYtbWQxMjUgc3RhcnQgYzAwMDAwMGQ5MzcxYmYz
MCBwb2ludGVyIG9mZnNldCAxNiBzaXplIDI1NDQgaXN0X2FkZCBjb3JydXB0aW9uLiBwcmV2LSZn
dDtuZXh0IHNob3VsZCBiZSBuZXh0PGJyPgogICAgICAgIFRvOiBsaW51eHBwYy1kZXZAbGlzdHMu
b3psYWJzLm9yZyAmbHQ7bGludXhwcGMtZGV2QGxpc3RzLm96bGFicy5vcmcmZ3Q7PGJyPgogICAg
ICAgIDxicj4KICAgICAgICA8YmxvY2txdW90ZSBjbGFzcz0icHJvdG9ubWFpbF9xdW90ZSIgdHlw
ZT0iY2l0ZSI+CiAgICAgICAgICAgIDxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fu
cy1zZXJpZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5k
LWNvbG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij5JIGhhdmUgcmVtb3ZlZCBteSBvdXQgb2YgdHJl
ZSBtb2R1bGUgb3V0IG9mIHByZWNhdXRpb24gYW5kIGl0IHN0aWxsIGhhcHBlbmVkIGFnYWluLCB0
aGlzIHRpbWUgdW4tdGFpbnRlZCBrZXJuZWw6PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6
IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7
IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUsIDI1NSwgMjU1KTsiPjxicj48L2Rpdj48ZGl2IHN0
eWxlPSJmb250LWZhbWlseTogQXJpYWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29s
b3I6IHJnYigwLCAwLCAwKTsgYmFja2dyb3VuZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpOyI+
PHNwYW4+WzI0OTYyLjc2MDI5OF0gc2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0
IG9jY3VycmVkPC9zcGFuPjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODE4NzhdICZuYnNwO3NsYWIgcmFp
ZDYtbWQxMjUgc3RhcnQgYzAwMDAwMDY0ODdjMzFiMCBwb2ludGVyIG9mZnNldCAxNiBzaXplIDI1
NDQ8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4MTk3Ml0gbGlzdF9hZGQgY29ycnVw
dGlvbi4gcHJldi0mZ3Q7bmV4dCBzaG91bGQgYmUgbmV4dCAoYzAwMDIwMDA1YTM3NmNlMCksIGJ1
dCB3YXMgYzAwMDAwMDY0ODdjMzFjMC4gKHByZXY9YzAwMDAwMDY0ODdjMzFjMCkuPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODIwNjhdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0t
LS0tLS0tLS0tLTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTYuNTgyMDk3XSBrZXJuZWwg
QlVHIGF0IGxpYi9saXN0X2RlYnVnLmM6MzIhPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1
Ni41ODIxMzBdIE9vcHM6IEV4Y2VwdGlvbiBpbiBrZXJuZWwgbW9kZSwgc2lnOiA1IFsjMV08L3Nw
YW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4MjE4NV0gTEUgUEFHRV9TSVpFPTY0SyBNTVU9
UmFkaXggJm5ic3A7U01QIE5SX0NQVVM9MjA0OCBOVU1BIFBvd2VyTlY8L3NwYW4+PC9kaXY+PGRp
dj48c3Bhbj5bMTIyNDU2LjU4MjIzMV0gTW9kdWxlcyBsaW5rZWQgaW46IHZob3N0X25ldCB2aG9z
dCB2aG9zdF9pb3RsYiB0YXAgdHVuIG5mdF9tYXNxIG5mdF9yZWplY3RfaXB2NCBhY3RfY3N1bSBj
bHNfdTMyIHNjaF9odGIgbmZfbmF0X3RmdHAgbmZfY29ubnRyYWNrX3RmdHAgYnJpZGdlIHN0cCBs
bGMga3ZtX2h2IGt2bSByZmtpbGwgeHRfY29ubnRyYWNrIG5mdF9jb21wYXQgbmZ0X2ZpYl9pbmV0
IG5mdF9maWJfaXB2NCBuZnRfZmliX2lwdjYgbmZ0X2ZpYiBuZnRfcmVqZWN0X2luZXQgbmZfcmVq
ZWN0X2lwdjQgbmZfcmVqZWN0X2lwdjYgbmZ0X3JlamVjdCBuZnRfY3QgbmZ0X2NoYWluX25hdCBu
Zl9uYXQgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IG5mX3RhYmxl
cyBkbV9jYWNoZV9zbXEgZG1fY2FjaGUgcmFpZDQ1NiBhc3luY19yYWlkNl9yZWNvdiBhc3luY19t
ZW1jcHkgYXN5bmNfcHEgYXN5bmNfeG9yIGFzeW5jX3R4IHN1bnJwYyByYWlkMTAgc25kX2hkYV9p
bnRlbCBzbmRfaW50ZWxfZHNwY2ZnIHNuZF9oZGFfY29kZWMgc25kX2hkYV9jb3JlIGpveWRldiBz
bmRfaHdkZXAgc25kX3NlcSBzbmRfc2VxX2RldmljZSBhdDI0IG9uYm9hcmRfdXNiX2RldiBzbmRf
cGNtIHNuZF90aW1lciBhdGxhbnRpYyB0ZzMgc25kIG9mcGFydCBpcG1pX3Bvd2VybnYgbWFjc2Vj
IHNvdW5kY29yZSBwb3dlcm52X2ZsYXNoIGlwbWlfZGV2aW50ZiBtdGQgaXBtaV9tc2doYW5kbGVy
IHZteF9jcnlwdG8gb3BhbF9wcmQgcnRjX29wYWwgaTJjX29wYWwgZnVzZSBkbV9tdWx0aXBhdGgg
bG9vcCBuZm5ldGxpbmsgenJhbSBsejRoY19jb21wcmVzcyBsejRfY29tcHJlc3MgeGZzIGRtX3Ro
aW5fcG9vbCBkbV9wZXJzaXN0ZW50X2RhdGEgZG1fYmlvX3ByaXNvbiBkbV9jcnlwdCByYWlkMSBu
dm1lIG52bWVfY29yZSB1YXMgdXNiX3N0b3JhZ2UgbnZtZV9rZXlyaW5nIG1wdDNzYXMgbnZtZV9h
dXRoIGhrZGYgYXN0IHJhaWRfY2xhc3Mgc2NzaV90cmFuc3BvcnRfc2FzIGkyY19hbGdvX2JpdCBz
Y3NpX2RoX3JkYWM8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4MjQ2N10gJm5ic3A7
c2NzaV9kaF9lbWMgc2NzaV9kaF9hbHVhIGkyY19kZXYgYWVzX2djbV9wMTBfY3J5cHRvIGNyeXB0
b19zaW1kIGNyeXB0ZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTYuNTgzMTE5XSBDUFU6
IDUgVUlEOiAwIFBJRDogMjY5NyBDb21tOiBkbWNyeXB0X3dyaXRlLzIgTm90IHRhaW50ZWQgNi4x
OC44LTIwMC5mYzQzLnBwYzY0bGUgIzEgUFJFRU1QVCh2b2x1bnRhcnkpIDwvc3Bhbj48L2Rpdj48
ZGl2PjxzcGFuPlsxMjI0NTYuNTgzMjE2XSBIYXJkd2FyZSBuYW1lOiBUMlA5RDAxIFJFViAxLjAw
IFBPV0VSOSAocmF3KSAweDRlMTIwMiBvcGFsOnNraWJvb3QtZWNiMWRjNyBQb3dlck5WPC9zcGFu
PjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODMyOTJdIE5JUDogJm5ic3A7YzAwMDAwMDAwMGUw
OThmYyBMUjogYzAwMDAwMDAwMGUwOThmOCBDVFI6IDAwMDAwMDAwMDAwMDAwMDA8L3NwYW4+PC9k
aXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4MzM3MF0gUkVHUzogYzAwMDAwMDAzYzk4NzdhMCBUUkFQ
OiAwNzAwICZuYnNwOyBOb3QgdGFpbnRlZCAmbmJzcDsoNi4xOC44LTIwMC5mYzQzLnBwYzY0bGUp
PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODM0MzJdIE1TUjogJm5ic3A7OTAwMDAw
MDAwMjgyYjAzMyAmbHQ7U0YsSFYsVkVDLFZTWCxFRSxGUCxNRSxJUixEUixSSSxMRSZndDsgJm5i
c3A7Q1I6IDI0MDA0MjQwICZuYnNwO1hFUjogMDAwMDAxNTY8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5bMTIyNDU2LjU4MzQ5OF0gQ0ZBUjogYzAwMDAwMDAwMDM0NTQyYyBJUlFNQVNLOiAwIDwvc3Bh
bj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgR1BSMDA6IGMwMDAwMDAwMDBlMDk4ZjggYzAwMDAwMDAzYzk4N2E0
MCBjMDAwMDAwMDAyNmJhOTAwIDAwMDAwMDAwMDAwMDAwNzUgPC9zcGFuPjwvZGl2PjxkaXY+PHNw
YW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyBHUFIwNDogMDAwMDAwMDBmZmZmYmZmZiAwMDAwMDAwMDAwMDAwMDAxIDAwMDAyMDFmZjcxYTAw
MDAgMDAwMDAwMDAwMDAwMDAwMSA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjA4OiAwMDAwMDAw
MDAwMDAwMDI3IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBjMDAwMDAwMDNjOTg3
ODkwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMTI6IGMwMDAyMDFmZmYxOGZmYTggYzAwMDIw
MWZmZjdlODE4MCBjMDAwMDAwMDAwMjk5YzI4IGMwMDAwMDAwMDVhYmE3ODAgPC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBHUFIxNjogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAw
MDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjIw
OiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAw
MDAwMDAwMDAwMDAxIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMjQ6IDAwMDAwMDAwMDAwMDAw
MDAgYzAwMDAwMDAzYzk4N2M3MCBjMDAwMjAwMDYwNTM5ODAwIGMwMDAyMDA2MThlZGRiMzAgPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIyODogMDAwMDAwMDAwMDAwMDAwMCBjMDAwMjAxNDg1Y2Jl
NzM4IGMwMDAwMDAwM2JkNDI4MDAgYzAwMDIwMTQ4NWNiZTZmMCA8L3NwYW4+PC9kaXY+PGRpdj48
c3Bhbj5bMTIyNDU2LjU4Mzk2OF0gTklQIFtjMDAwMDAwMDAwZTA5OGZjXSBfX2xpc3RfYWRkX3Zh
bGlkX29yX3JlcG9ydCsweGRjLzB4MTQwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41
ODQwNDVdIExSIFtjMDAwMDAwMDAwZTA5OGY4XSBfX2xpc3RfYWRkX3ZhbGlkX29yX3JlcG9ydCsw
eGQ4LzB4MTQwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODQwOTNdIENhbGwgVHJh
Y2U6PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODQxMTVdIFtjMDAwMDAwMDNjOTg3
YTQwXSBbYzAwMDAwMDAwMGUwOThmOF0gX19saXN0X2FkZF92YWxpZF9vcl9yZXBvcnQrMHhkOC8w
eDE0MCAodW5yZWxpYWJsZSk8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4NDE4OV0g
W2MwMDAwMDAwM2M5ODdhYjBdIFtjMDA4MDAwMDI2ZTkwYWQ0XSByZWxlYXNlX3N0cmlwZV9wbHVn
KzB4OWMvMHgxNTAgW3JhaWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ni41ODQy
NThdIFtjMDAwMDAwMDNjOTg3YjAwXSBbYzAwODAwMDAyNmU5NTlmNF0gbWFrZV9zdHJpcGVfcmVx
dWVzdCsweDMyYy8weDU2MCBbcmFpZDQ1Nl08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2
LjU4NDMzM10gW2MwMDAwMDAwM2M5ODdiZDBdIFtjMDA4MDAwMDI2ZTk1ZGY4XSByYWlkNV9tYWtl
X3JlcXVlc3QrMHgxZDAvMHg2MTAgW3JhaWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEy
MjQ1Ni41ODQ0MThdIFtjMDAwMDAwMDNjOTg3ZDEwXSBbYzAwMDAwMDAwMTM2OWEwNF0gbWRfaGFu
ZGxlX3JlcXVlc3QrMHgxYzQvMHg0MDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4
NDQ4NF0gW2MwMDAwMDAwM2M5ODdkYTBdIFtjMDAwMDAwMDAwZDA0MDEwXSBfX3N1Ym1pdF9iaW8r
MHgyMzAvMHgzZDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4NDU2MF0gW2MwMDAw
MDAwM2M5ODdlNDBdIFtjMDAwMDAwMDAwZDA0MjQ0XSBfX3N1Ym1pdF9iaW9fbm9hY2N0KzB4OTQv
MHgyNTA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4NDYzNV0gW2MwMDAwMDAwM2M5
ODdlYjBdIFtjMDAwMDAwMDAxMzg3NDNjXSBkbV9zdWJtaXRfYmlvX3JlbWFwKzB4NGMvMHgxMjA8
L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4NDY5OF0gW2MwMDAwMDAwM2M5ODdlZjBd
IFtjMDA4MDAwMDFkYzIyNmE4XSBkbWNyeXB0X3dyaXRlKzB4MWEwLzB4MjAwIFtkbV9jcnlwdF08
L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4NDc2NV0gW2MwMDAwMDAwM2M5ODdmOTBd
IFtjMDAwMDAwMDAwMjk5ZGE4XSBrdGhyZWFkKzB4MTg4LzB4MWEwPC9zcGFuPjwvZGl2PjxkaXY+
PHNwYW4+WzEyMjQ1Ni41ODQ4MThdIFtjMDAwMDAwMDNjOTg3ZmUwXSBbYzAwMDAwMDAwMDAwZGVk
OF0gc3RhcnRfa2VybmVsX3RocmVhZCsweDE0LzB4MTg8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5b
MTIyNDU2LjU4NDg3OV0gQ29kZTogZjhjMTAwNjAgZjgwMTAwODAgNGI4ODNiMzUgNjAwMDAwMDAg
M2M2MmZmODIgMzg2MzkzODggZThjMTAwNjAgZTkyMTAwNjggZThhNjAwMDAgN2QyNDRiNzggNGI1
M2JhZjUgNjAwMDAwMDAgJmx0OzBmZTAwMDAwJmd0OyA3YzA4MDJhNiA3Yzg1MjM3OCA3YzY0MWI3
OCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU2LjU4NTAxNV0gLS0tWyBlbmQgdHJhY2Ug
MDAwMDAwMDAwMDAwMDAwMCBdLS0tPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjIw
NzRdIHBzdG9yZTogYmFja2VuZCAobnZyYW0pIHdyaXRpbmcgZXJyb3IgKC0xKTwvc3Bhbj48L2Rp
dj48ZGl2Pjxicj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTcuMTYyMTQxXSBub3RlOiBkbWNyeXB0
X3dyaXRlLzJbMjY5N10gZXhpdGVkIHdpdGggaXJxcyBkaXNhYmxlZDwvc3Bhbj48L2Rpdj48ZGl2
PjxzcGFuPlsxMjI0NTcuMTYyMjE0XSAtLS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0t
LS08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2MjI1N10gV0FSTklORzogQ1BVOiA1
IFBJRDogMjY5NyBhdCBrZXJuZWwvZXhpdC5jOjkwMyBkb19leGl0KzB4NWMvMHg1YjA8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2MjMxNF0gTW9kdWxlcyBsaW5rZWQgaW46IHZob3N0
X25ldCB2aG9zdCB2aG9zdF9pb3RsYiB0YXAgdHVuIG5mdF9tYXNxIG5mdF9yZWplY3RfaXB2NCBh
Y3RfY3N1bSBjbHNfdTMyIHNjaF9odGIgbmZfbmF0X3RmdHAgbmZfY29ubnRyYWNrX3RmdHAgYnJp
ZGdlIHN0cCBsbGMga3ZtX2h2IGt2bSByZmtpbGwgeHRfY29ubnRyYWNrIG5mdF9jb21wYXQgbmZ0
X2ZpYl9pbmV0IG5mdF9maWJfaXB2NCBuZnRfZmliX2lwdjYgbmZ0X2ZpYiBuZnRfcmVqZWN0X2lu
ZXQgbmZfcmVqZWN0X2lwdjQgbmZfcmVqZWN0X2lwdjYgbmZ0X3JlamVjdCBuZnRfY3QgbmZ0X2No
YWluX25hdCBuZl9uYXQgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0
IG5mX3RhYmxlcyBkbV9jYWNoZV9zbXEgZG1fY2FjaGUgcmFpZDQ1NiBhc3luY19yYWlkNl9yZWNv
diBhc3luY19tZW1jcHkgYXN5bmNfcHEgYXN5bmNfeG9yIGFzeW5jX3R4IHN1bnJwYyByYWlkMTAg
c25kX2hkYV9pbnRlbCBzbmRfaW50ZWxfZHNwY2ZnIHNuZF9oZGFfY29kZWMgc25kX2hkYV9jb3Jl
IGpveWRldiBzbmRfaHdkZXAgc25kX3NlcSBzbmRfc2VxX2RldmljZSBhdDI0IG9uYm9hcmRfdXNi
X2RldiBzbmRfcGNtIHNuZF90aW1lciBhdGxhbnRpYyB0ZzMgc25kIG9mcGFydCBpcG1pX3Bvd2Vy
bnYgbWFjc2VjIHNvdW5kY29yZSBwb3dlcm52X2ZsYXNoIGlwbWlfZGV2aW50ZiBtdGQgaXBtaV9t
c2doYW5kbGVyIHZteF9jcnlwdG8gb3BhbF9wcmQgcnRjX29wYWwgaTJjX29wYWwgZnVzZSBkbV9t
dWx0aXBhdGggbG9vcCBuZm5ldGxpbmsgenJhbSBsejRoY19jb21wcmVzcyBsejRfY29tcHJlc3Mg
eGZzIGRtX3RoaW5fcG9vbCBkbV9wZXJzaXN0ZW50X2RhdGEgZG1fYmlvX3ByaXNvbiBkbV9jcnlw
dCByYWlkMSBudm1lIG52bWVfY29yZSB1YXMgdXNiX3N0b3JhZ2UgbnZtZV9rZXlyaW5nIG1wdDNz
YXMgbnZtZV9hdXRoIGhrZGYgYXN0IHJhaWRfY2xhc3Mgc2NzaV90cmFuc3BvcnRfc2FzIGkyY19h
bGdvX2JpdCBzY3NpX2RoX3JkYWM8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2MjQ1
OV0gJm5ic3A7c2NzaV9kaF9lbWMgc2NzaV9kaF9hbHVhIGkyY19kZXYgYWVzX2djbV9wMTBfY3J5
cHRvIGNyeXB0b19zaW1kIGNyeXB0ZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTcuMTYz
MDExXSBDUFU6IDUgVUlEOiAwIFBJRDogMjY5NyBDb21tOiBkbWNyeXB0X3dyaXRlLzIgVGFpbnRl
ZDogRyAmbmJzcDsgJm5ic3A7ICZuYnNwO0QgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgNi4xOC44LTIwMC5mYzQzLnBwYzY0bGUgIzEgUFJFRU1QVCh2b2x1bnRhcnkp
IDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTcuMTYzMTIzXSBUYWludGVkOiBbRF09RElF
PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjMxNzFdIEhhcmR3YXJlIG5hbWU6IFQy
UDlEMDEgUkVWIDEuMDAgUE9XRVI5IChyYXcpIDB4NGUxMjAyIG9wYWw6c2tpYm9vdC1lY2IxZGM3
IFBvd2VyTlY8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2MzI0MF0gTklQOiAmbmJz
cDtjMDAwMDAwMDAwMjYwMzVjIExSOiBjMDAwMDAwMDAwMjYwOTUwIENUUjogMDAwMDAwMDAwMDAw
MDAwMDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTcuMTYzMzIyXSBSRUdTOiBjMDAwMDAw
MDNjOTg3MzMwIFRSQVA6IDA3MDAgJm5ic3A7IFRhaW50ZWQ6IEcgJm5ic3A7ICZuYnNwOyAmbmJz
cDtEICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyg2LjE4
LjgtMjAwLmZjNDMucHBjNjRsZSk8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2MzQw
Nl0gTVNSOiAmbmJzcDs5MDAwMDAwMDAyMDI5MDMzICZsdDtTRixIVixWRUMsRUUsTUUsSVIsRFIs
UkksTEUmZ3Q7ICZuYnNwO0NSOiAyNDAwNDI0MCAmbmJzcDtYRVI6IDIwMDQwMTU2PC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjM1MDFdIENGQVI6IGMwMDAwMDAwMDAyNjA5NGMgSVJR
TUFTSzogMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjAwOiBjMDAwMDAwMDAwMjYwOTUwIGMw
MDAwMDAwM2M5ODc1ZDAgYzAwMDAwMDAwMjZiYTkwMCAwMDAwMDAwMDAwMDAwMDA1IDwvc3Bhbj48
L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgR1BSMDQ6IDAwMDAwMDAwMDAwMDI3MTAgMDAwMDAwMDAwMDAwMDAwMSAw
MDAwMjAxZmY3MWEwMDAwIDAwMDAwMDAwMDAwMDAwMDEgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBH
UFIwODogMDAwMDAwMDAwMDAwMDAwNSAwMDAwMDAwMDAwMDAwMDAxIGMwMDAwMDAwM2M5ODdmMTgg
MDAwMDAwMDAwMDAwNDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjEyOiBjMDAwMjAxZmZm
MThmZmE4IGMwMDAyMDFmZmY3ZTgxODAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAw
IDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMTY6IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAw
MDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgPC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyBHUFIyMDogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAw
MDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjI0OiAw
MDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAw
MDAwMDAwMDAwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMjg6IDAwMDAwMDAwMDAwMDAwMDUg
MDAwMDAwMDAwMDAwMDAwMyBjMDAwMDAwMDAzZTNhOTAwIGMwMDAwMDAwMWJlMmEwMDAgPC9zcGFu
PjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjM5ODRdIE5JUCBbYzAwMDAwMDAwMDI2MDM1Y10g
ZG9fZXhpdCsweDVjLzB4NWIwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjQwMzdd
IExSIFtjMDAwMDAwMDAwMjYwOTUwXSBtYWtlX3Rhc2tfZGVhZCsweGEwLzB4MWQwPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjQwNzldIENhbGwgVHJhY2U6PC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+WzEyMjQ1Ny4xNjQxMjZdIFtjMDAwMDAwMDNjOTg3NWQwXSBbYzAwMDAwMDAzYzk4
NzYwMF0gMHhjMDAwMDAwMDNjOTg3NjAwICh1bnJlbGlhYmxlKTwvc3Bhbj48L2Rpdj48ZGl2Pjxz
cGFuPlsxMjI0NTcuMTY0MjE2XSBbYzAwMDAwMDAzYzk4NzY3MF0gW2MwMDAwMDAwMDAyNjA5NTBd
IG1ha2VfdGFza19kZWFkKzB4YTAvMHgxZDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3
LjE2NDI3Nl0gW2MwMDAwMDAwM2M5ODc2ZjBdIFtjMDAwMDAwMDAwMDJhMzE0XSBvb3BzX2VuZCsw
eDE2NC8weDFhMDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxMjI0NTcuMTY0MzM2XSBbYzAwMDAw
MDAzYzk4Nzc3MF0gW2MwMDAwMDAwMDAwMDliMmNdIHByb2dyYW1fY2hlY2tfY29tbW9uX3ZpcnQr
MHgzYmMvMHgzYzA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NDM5OV0gLS0tLSBp
bnRlcnJ1cHQ6IDcwMCBhdCBfX2xpc3RfYWRkX3ZhbGlkX29yX3JlcG9ydCsweGRjLzB4MTQwPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjQ0NTRdIE5JUDogJm5ic3A7YzAwMDAwMDAw
MGUwOThmYyBMUjogYzAwMDAwMDAwMGUwOThmOCBDVFI6IDAwMDAwMDAwMDAwMDAwMDA8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NDUwOV0gUkVHUzogYzAwMDAwMDAzYzk4NzdhMCBU
UkFQOiAwNzAwICZuYnNwOyBUYWludGVkOiBHICZuYnNwOyAmbmJzcDsgJm5ic3A7RCAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsoNi4xOC44LTIwMC5mYzQz
LnBwYzY0bGUpPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjQ1NzVdIE1TUjogJm5i
c3A7OTAwMDAwMDAwMjgyYjAzMyAmbHQ7U0YsSFYsVkVDLFZTWCxFRSxGUCxNRSxJUixEUixSSSxM
RSZndDsgJm5ic3A7Q1I6IDI0MDA0MjQwICZuYnNwO1hFUjogMDAwMDAxNTY8L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5bMTIyNDU3LjE2NDY1NF0gQ0ZBUjogYzAwMDAwMDAwMDM0NTQyYyBJUlFNQVNL
OiAwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMDA6IGMwMDAwMDAwMDBlMDk4ZjggYzAwMDAw
MDAzYzk4N2E0MCBjMDAwMDAwMDAyNmJhOTAwIDAwMDAwMDAwMDAwMDAwNzUgPC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7ICZuYnNwOyBHUFIwNDogMDAwMDAwMDBmZmZmYmZmZiAwMDAwMDAwMDAwMDAwMDAxIDAwMDAy
MDFmZjcxYTAwMDAgMDAwMDAwMDAwMDAwMDAwMSA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjA4
OiAwMDAwMDAwMDAwMDAwMDI3IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCBjMDAw
MDAwMDNjOTg3ODkwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMTI6IGMwMDAyMDFmZmYxOGZm
YTggYzAwMDIwMWZmZjdlODE4MCBjMDAwMDAwMDAwMjk5YzI4IGMwMDAwMDAwMDVhYmE3ODAgPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIxNjogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAw
MDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48
c3Bhbj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5i
c3A7IEdQUjIwOiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAw
MDAwMCAwMDAwMDAwMDAwMDAwMDAxIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMjQ6IDAwMDAw
MDAwMDAwMDAwMDAgYzAwMDAwMDAzYzk4N2M3MCBjMDAwMjAwMDYwNTM5ODAwIGMwMDAyMDA2MThl
ZGRiMzAgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIyODogMDAwMDAwMDAwMDAwMDAwMCBjMDAw
MjAxNDg1Y2JlNzM4IGMwMDAwMDAwM2JkNDI4MDAgYzAwMDIwMTQ4NWNiZTZmMCA8L3NwYW4+PC9k
aXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NTE0OF0gTklQIFtjMDAwMDAwMDAwZTA5OGZjXSBfX2xp
c3RfYWRkX3ZhbGlkX29yX3JlcG9ydCsweGRjLzB4MTQwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+
WzEyMjQ1Ny4xNjUxOTFdIExSIFtjMDAwMDAwMDAwZTA5OGY4XSBfX2xpc3RfYWRkX3ZhbGlkX29y
X3JlcG9ydCsweGQ4LzB4MTQwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4xNjUyMzNd
IC0tLS0gaW50ZXJydXB0OiA3MDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NTI3
M10gW2MwMDAwMDAwM2M5ODdhYjBdIFtjMDA4MDAwMDI2ZTkwYWQ0XSByZWxlYXNlX3N0cmlwZV9w
bHVnKzB4OWMvMHgxNTAgW3JhaWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzEyMjQ1Ny4x
NjUzNThdIFtjMDAwMDAwMDNjOTg3YjAwXSBbYzAwODAwMDAyNmU5NTlmNF0gbWFrZV9zdHJpcGVf
cmVxdWVzdCsweDMyYy8weDU2MCBbcmFpZDQ1Nl08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIy
NDU3LjE2NTQwNV0gW2MwMDAwMDAwM2M5ODdiZDBdIFtjMDA4MDAwMDI2ZTk1ZGY4XSByYWlkNV9t
YWtlX3JlcXVlc3QrMHgxZDAvMHg2MTAgW3JhaWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+
WzEyMjQ1Ny4xNjU0ODFdIFtjMDAwMDAwMDNjOTg3ZDEwXSBbYzAwMDAwMDAwMTM2OWEwNF0gbWRf
aGFuZGxlX3JlcXVlc3QrMHgxYzQvMHg0MDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3
LjE2NTU0NV0gW2MwMDAwMDAwM2M5ODdkYTBdIFtjMDAwMDAwMDAwZDA0MDEwXSBfX3N1Ym1pdF9i
aW8rMHgyMzAvMHgzZDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NTU5M10gW2Mw
MDAwMDAwM2M5ODdlNDBdIFtjMDAwMDAwMDAwZDA0MjQ0XSBfX3N1Ym1pdF9iaW9fbm9hY2N0KzB4
OTQvMHgyNTA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NTY0OF0gW2MwMDAwMDAw
M2M5ODdlYjBdIFtjMDAwMDAwMDAxMzg3NDNjXSBkbV9zdWJtaXRfYmlvX3JlbWFwKzB4NGMvMHgx
MjA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NTc0NF0gW2MwMDAwMDAwM2M5ODdl
ZjBdIFtjMDA4MDAwMDFkYzIyNmE4XSBkbWNyeXB0X3dyaXRlKzB4MWEwLzB4MjAwIFtkbV9jcnlw
dF08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NTgzMl0gW2MwMDAwMDAwM2M5ODdm
OTBdIFtjMDAwMDAwMDAwMjk5ZGE4XSBrdGhyZWFkKzB4MTg4LzB4MWEwPC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+WzEyMjQ1Ny4xNjU4ODldIFtjMDAwMDAwMDNjOTg3ZmUwXSBbYzAwMDAwMDAwMDAw
ZGVkOF0gc3RhcnRfa2VybmVsX3RocmVhZCsweDE0LzB4MTg8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5bMTIyNDU3LjE2NTk2MF0gQ29kZTogOTE2MTAwMDggZjgwMTAwMTAgZjgyMWZmNjEgZTkyZDBj
NzggZjkyMTAwNzggMzkyMDAwMDAgODkyZDA5MzIgNTUyOTA3ZmUgMGIwOTAwMDAgZTk1ZjBjNjgg
MzEyYWZmZmYgN2QyOTUxMTAgJmx0OzBiMDkwMDAwJmd0OyBlYmJmMGI5MCBlYmRmMGI4OCA3ZmEz
ZWI3OCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTIyNDU3LjE2NjA2NV0gLS0tWyBlbmQgdHJh
Y2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tPC9zcGFuPjwvZGl2PjxzcGFuPjwvc3Bhbj48YnI+PC9k
aXY+PGRpdiBjbGFzcz0icHJvdG9ubWFpbF9xdW90ZSI+CiAgICAgICAgT24gTW9uZGF5LCBGZWJy
dWFyeSA5dGgsIDIwMjYgYXQgMTI6MzggQU0sIGpmaXVzZHEgJmx0O2pmaXVzZHFAcHJvdG9uLm1l
Jmd0OyB3cm90ZTo8YnI+CiAgICAgICAgPGJsb2NrcXVvdGUgY2xhc3M9InByb3Rvbm1haWxfcXVv
dGUiIHR5cGU9ImNpdGUiPgogICAgICAgICAgICA8ZGl2IHN0eWxlPSJmb250LWZhbWlseTogQXJp
YWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29sb3I6IHJnYigwLCAwLCAwKTsgYmFj
a2dyb3VuZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpOyI+U29ycnkgZm9yIGR1cGxpY2F0ZSBi
dXQgaXQgaGFwcGVuZWQgYWZ0ZXIgYSBkaXNrIHN0YXJ0ZWQgZmFpbGluZyBkdXJpbmcgYSBjaGVj
ayB0aGF0IHdhcyB0cmlnZ2VyZWQgb24gYWxsIG15IDMgUkFJRCBhcnJheXMgYW5kIHRoZW4gYWZ0
ZXIgYSBnb29kIHdoaWxlIHRoaXMgYnVnIGhhcHBlbmVkLiBUaGF0J3MgYmFzaWNhbGx5IGl0Ljwv
ZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXpl
OiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjU1LCAy
NTUsIDI1NSk7Ij48YnI+PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5z
LXNlcmlmOyBmb250LXNpemU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQt
Y29sb3I6IHJnYigyNTUsIDI1NSwgMjU1KTsiPjxzcGFuPlsxNTQwNDMuMTA1ODM3XSBtZDogY2hl
Y2sgb2YgUkFJRCBhcnJheSBtZDEyNTwvc3Bhbj48ZGl2PjxzcGFuPlsxNTQwNDkuNDMyMjI1XSBt
ZDogY2hlY2sgb2YgUkFJRCBhcnJheSBtZDEyNjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNTQw
NTUuNzE4MTk2XSBtZDogY2hlY2sgb2YgUkFJRCBhcnJheSBtZDEyNzwvc3Bhbj48L2Rpdj48ZGl2
PjxzcGFuPlsxNjMxMDEuMDAxNTcyXSBzZCAxOjA6MDowOiBbc2RhXSB0YWcjODA2OSBGQUlMRUQg
UmVzdWx0OiBob3N0Ynl0ZT1ESURfU09GVF9FUlJPUiBkcml2ZXJieXRlPURSSVZFUl9PSyBjbWRf
YWdlPTBzPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwMS4wMDE2NTVdIHNkIDE6MDowOjA6
IFtzZGFdIHRhZyM4MDY5IENEQjogUmVhZCgxMCkgMjggMDAgMWIgMjggZDEgODAgMDAgMDIgODAg
MDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTAxLjAwMTY5MV0gSS9PIGVycm9yLCBkZXYg
c2RhLCBzZWN0b3IgNDU1NjU5OTA0IG9wIDB4MDooUkVBRCkgZmxhZ3MgMHg4MDcwMCBwaHlzX3Nl
ZyA1IHByaW8gY2xhc3MgMjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDEuNDEyNzE0XSBz
ZCAxOjA6MDowOiBQb3dlci1vbiBvciBkZXZpY2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5bMTYzMTAxLjY5ODc1OV0gc2QgMTowOjA6MDogW3NkYV0gdGFnIzc3MjggRkFJ
TEVEIFJlc3VsdDogaG9zdGJ5dGU9RElEX1NPRlRfRVJST1IgZHJpdmVyYnl0ZT1EUklWRVJfT0sg
Y21kX2FnZT0wczwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDEuNjk4ODEzXSBzZCAxOjA6
MDowOiBbc2RhXSB0YWcjNzcyOCBDREI6IFJlYWQoMTApIDI4IDAwIDc0IDcwIDZkIDAwIDAwIDAw
IDgwIDAwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwMS42OTg4NDNdIEkvTyBlcnJvciwg
ZGV2IHNkYSwgc2VjdG9yIDE5NTM1MjQ5OTIgb3AgMHgwOihSRUFEKSBmbGFncyAweDgwNzAwIHBo
eXNfc2VnIDEgcHJpbyBjbGFzcyAyPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwMi4xNjI2
OTNdIHNkIDE6MDowOjA6IFBvd2VyLW9uIG9yIGRldmljZSByZXNldCBvY2N1cnJlZDwvc3Bhbj48
L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDIuNDQ3NjQ4XSBzZCAxOjA6MDowOiBbc2RhXSBVbmFsaWdu
ZWQgcGFydGlhbCBjb21wbGV0aW9uIChyZXNpZD04NjYzMDAsIHNlY3Rvcl9zej01MTIpPC9zcGFu
PjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwMi40NDc3MjNdIHNkIDE6MDowOjA6IFtzZGFdIHRhZyM4
MDQ5IENEQjogUmVhZCgxMCkgMjggMDAgNWUgMjEgZDQgMDAgMDAgMDggMDAgMDA8L3NwYW4+PC9k
aXY+PGRpdj48c3Bhbj5bMTYzMTAyLjQ0Nzc1MV0gc2QgMTowOjA6MDogW3NkYV0gdGFnIzgwNDkg
RkFJTEVEIFJlc3VsdDogaG9zdGJ5dGU9RElEX1NPRlRfRVJST1IgZHJpdmVyYnl0ZT1EUklWRVJf
T0sgY21kX2FnZT0wczwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDIuNDQ3Nzg5XSBzZCAx
OjA6MDowOiBbc2RhXSB0YWcjODA0OSBDREI6IFJlYWQoMTApIDI4IDAwIDVlIDIxIGQ0IDAwIDAw
IDA4IDAwIDAwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwMi40NDc4NTVdIEkvTyBlcnJv
ciwgZGV2IHNkYSwgc2VjdG9yIDE1NzkyNzUyNjQgb3AgMHgwOihSRUFEKSBmbGFncyAweDgwNzAw
IHBoeXNfc2VnIDggcHJpbyBjbGFzcyAyPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwMi45
MTI3ODNdIHNkIDE6MDowOjA6IFBvd2VyLW9uIG9yIGRldmljZSByZXNldCBvY2N1cnJlZDwvc3Bh
bj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDMuNjYyODY3XSBzZCAxOjA6MDowOiBQb3dlci1vbiBv
ciBkZXZpY2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTA0LjQx
MzAzNl0gc2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFu
PjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwNS4xNjMwNDRdIHNkIDE6MDowOjA6IFBvd2VyLW9uIG9y
IGRldmljZSByZXNldCBvY2N1cnJlZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDUuOTEz
NjA5XSBzZCAxOjA6MDowOiBQb3dlci1vbiBvciBkZXZpY2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTA2LjY2MzIxM10gc2QgMTowOjA6MDogUG93ZXItb24gb3Ig
ZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzEwNy4yODk3
NzNdIHNkIDE6MDowOjA6IFBvd2VyLW9uIG9yIGRldmljZSByZXNldCBvY2N1cnJlZDwvc3Bhbj48
L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMDcuOTMyODEyXSBzZCAxOjA6MDowOiBQb3dlci1vbiBvciBk
ZXZpY2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTA4LjkxMzk1
N10gc2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzE2MzEwOS42NjQxMDZdIHNkIDE6MDowOjA6IFBvd2VyLW9uIG9yIGRl
dmljZSByZXNldCBvY2N1cnJlZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMTAuNDE0Mjgx
XSBzZCAxOjA6MDowOiBQb3dlci1vbiBvciBkZXZpY2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9k
aXY+PGRpdj48c3Bhbj5bMTYzMTExLjE2NDMxMl0gc2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2
aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzExMS45MTM4MTRd
IHNkIDE6MDowOjA6IFBvd2VyLW9uIG9yIGRldmljZSByZXNldCBvY2N1cnJlZDwvc3Bhbj48L2Rp
dj48ZGl2PjxzcGFuPlsxNjMxMTIuNjYzOTA0XSBzZCAxOjA6MDowOiBQb3dlci1vbiBvciBkZXZp
Y2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTEzLjQxNDYyN10g
c2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4+WzE2MzExMy42OTk2MzldIHNkIDE6MDowOjA6IFtzZGFdIFVuYWxpZ25lZCBw
YXJ0aWFsIGNvbXBsZXRpb24gKHJlc2lkPTIwNTgyMCwgc2VjdG9yX3N6PTUxMik8L3NwYW4+PC9k
aXY+PGRpdj48c3Bhbj5bMTYzMTEzLjY5OTc3MV0gc2QgMTowOjA6MDogW3NkYV0gdGFnIzc2MTUg
Q0RCOiBSZWFkKDEwKSAyOCAwMCAwMSA0ZCA4NCAwMCAwMCAwNCAwMCAwMDwvc3Bhbj48L2Rpdj48
ZGl2PjxzcGFuPlsxNjMxMTMuNjk5OTc2XSBzZCAxOjA6MDowOiBbc2RhXSB0YWcjNzYxNSBGQUlM
RUQgUmVzdWx0OiBob3N0Ynl0ZT1ESURfU09GVF9FUlJPUiBkcml2ZXJieXRlPURSSVZFUl9PSyBj
bWRfYWdlPTBzPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzExMy43MDAxOThdIHNkIDE6MDow
OjA6IFtzZGFdIHRhZyM3NjE1IENEQjogUmVhZCgxMCkgMjggMDAgMDEgNGQgODQgMDAgMDAgMDQg
MDAgMDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTEzLjcwMDMyOV0gSS9PIGVycm9yLCBk
ZXYgc2RhLCBzZWN0b3IgMjE4NTcyODAgb3AgMHgwOihSRUFEKSBmbGFncyAweDgwNzAwIHBoeXNf
c2VnIDQgcHJpbyBjbGFzcyAyPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzExNC4xNjQwODVd
IHNkIDE6MDowOjA6IFBvd2VyLW9uIG9yIGRldmljZSByZXNldCBvY2N1cnJlZDwvc3Bhbj48L2Rp
dj48ZGl2PjxzcGFuPlsxNjMxMTQuOTE0MTY3XSBzZCAxOjA6MDowOiBQb3dlci1vbiBvciBkZXZp
Y2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTE1LjY2NDI2MV0g
c2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4+WzE2MzExNS45NTk5NjVdIHNkIDE6MDowOjA6IFtzZGFdIHRhZyM4MDQ0IEZB
SUxFRCBSZXN1bHQ6IGhvc3RieXRlPURJRF9TT0ZUX0VSUk9SIGRyaXZlcmJ5dGU9RFJJVkVSX09L
IGNtZF9hZ2U9MHM8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTE1Ljk1OTk2M10gc2QgMTow
OjA6MDogW3NkYV0gVW5hbGlnbmVkIHBhcnRpYWwgY29tcGxldGlvbiAocmVzaWQ9MzA4MjIwLCBz
ZWN0b3Jfc3o9NTEyKTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMTUuOTU5OTk2XSBzZCAx
OjA6MDowOiBbc2RhXSB0YWcjODAxNiBDREI6IFJlYWQoMTApIDI4IDAwIDAwIDU4IGEwIDAwIDAw
IDA0IDAwIDAwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzExNS45NjAwNDFdIHNkIDE6MDow
OjA6IFtzZGFdIHRhZyM4MDQ0IENEQjogUmVhZCgxMCkgMjggMDAgMWIgNDggZmMgMDAgMDAgMDQg
MDAgMDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTE1Ljk2MDA4MV0gc2QgMTowOjA6MDog
W3NkYV0gdGFnIzgwMTYgRkFJTEVEIFJlc3VsdDogaG9zdGJ5dGU9RElEX1NPRlRfRVJST1IgZHJp
dmVyYnl0ZT1EUklWRVJfT0sgY21kX2FnZT0wczwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMx
MTUuOTYwMTA5XSBJL08gZXJyb3IsIGRldiBzZGEsIHNlY3RvciA0NTc3Njc5MzYgb3AgMHgwOihS
RUFEKSBmbGFncyAweDgwNzAwIHBoeXNfc2VnIDggcHJpbyBjbGFzcyAyPC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+WzE2MzExNS45NjAxNTVdIHNkIDE6MDowOjA6IFtzZGFdIHRhZyM4MDE2IENEQjog
UmVhZCgxMCkgMjggMDAgMDAgNTggYTAgMDAgMDAgMDQgMDAgMDA8L3NwYW4+PC9kaXY+PGRpdj48
c3Bhbj5bMTYzMTE1Ljk2MDQwMl0gSS9PIGVycm9yLCBkZXYgc2RhLCBzZWN0b3IgNTgwODEyOCBv
cCAweDA6KFJFQUQpIGZsYWdzIDB4ODA3MDAgcGh5c19zZWcgNCBwcmlvIGNsYXNzIDI8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTE2LjQxNDQzOF0gc2QgMTowOjA6MDogUG93ZXItb24gb3Ig
ZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzExNi43MDY3
MzldIHNkIDE6MDowOjA6IFtzZGFdIHRhZyM4MTAzIEZBSUxFRCBSZXN1bHQ6IGhvc3RieXRlPURJ
RF9TT0ZUX0VSUk9SIGRyaXZlcmJ5dGU9RFJJVkVSX09LIGNtZF9hZ2U9MHM8L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5bMTYzMTE2LjcwNjgwNF0gc2QgMTowOjA6MDogW3NkYV0gdGFnIzgxMDMgQ0RC
OiBSZWFkKDEwKSAyOCAwMCAwZCA4NiAzYyAwMCAwMCAwOCAwMCAwMDwvc3Bhbj48L2Rpdj48ZGl2
PjxzcGFuPlsxNjMxMTYuNzA2ODUzXSBJL08gZXJyb3IsIGRldiBzZGEsIHNlY3RvciAyMjY5MDA5
OTIgb3AgMHgwOihSRUFEKSBmbGFncyAweDgwNzAwIHBoeXNfc2VnIDEyIHByaW8gY2xhc3MgMjwv
c3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxNjMxMTcuMTA5Nzg5XSBzZCAxOjA6MDowOiBQb3dlci1v
biBvciBkZXZpY2UgcmVzZXQgb2NjdXJyZWQ8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzMTE3
LjkxNDU3N10gc2QgMTowOjA6MDogUG93ZXItb24gb3IgZGV2aWNlIHJlc2V0IG9jY3VycmVkPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+WzE2MzQ5Ny4xODk1NjldIG1kOiBtZDEyNjogY2hlY2sgZG9u
ZS48L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMTYzODI5LjIzMTQyNl0gbWQ6IG1kMTI3OiBjaGVj
ayBkb25lLjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsxODUwOTYuMTAwMzg4XSBtZDogbWQxMjU6
IGNoZWNrIGRvbmUuPC9zcGFuPjwvZGl2PjxzcGFuPjwvc3Bhbj48L2Rpdj48ZGl2IHN0eWxlPSJm
b250LWZhbWlseTogQXJpYWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29sb3I6IHJn
YigwLCAwLCAwKTsgYmFja2dyb3VuZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpOyI+PGJyPjwv
ZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXpl
OiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjU1LCAy
NTUsIDI1NSk7Ij5hbmQganVzdCBhZnRlciB0aGF0LCBqdXN0IHRoZSBrZXJuZWwgbG9ncyB5b3Ug
c2F3IGluIG15IHByZXZpb3VzIG1haWwsIG5vdGhpbmcgaW4gYmV0d2Vlbi48L2Rpdj48ZGl2IGNs
YXNzPSJwcm90b25tYWlsX3F1b3RlIj4KICAgICAgICBPbiBNb25kYXksIEZlYnJ1YXJ5IDl0aCwg
MjAyNiBhdCAxMjoxOSBBTSwgamZpdXNkcSAmbHQ7amZpdXNkcUBwcm90b24ubWUmZ3Q7IHdyb3Rl
Ojxicj4KICAgICAgICA8YmxvY2txdW90ZSBjbGFzcz0icHJvdG9ubWFpbF9xdW90ZSIgdHlwZT0i
Y2l0ZSI+CiAgICAgICAgICAgIDxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1z
ZXJpZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNv
bG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij48c3Bhbj5IZWxsbyw8L3NwYW4+PC9kaXY+PGRpdiBz
dHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBzYW5zLXNlcmlmOyBmb250LXNpemU6IDE0cHg7IGNv
bG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91bmQtY29sb3I6IHJnYigyNTUsIDI1NSwgMjU1KTsi
PjxzcGFuPjxicj48L3NwYW4+PC9kaXY+PGRpdiBzdHlsZT0iZm9udC1mYW1pbHk6IEFyaWFsLCBz
YW5zLXNlcmlmOyBmb250LXNpemU6IDE0cHg7IGNvbG9yOiByZ2IoMCwgMCwgMCk7IGJhY2tncm91
bmQtY29sb3I6IHJnYigyNTUsIDI1NSwgMjU1KTsiPjxzcGFuPlRvZGF5IEkgd2FzIG1ldCB3aXRo
IHRoZSBmb2xsb3dpbmcga2VybmVsIGxvZyBvbiBJQk0gUE9XRVI5LCBhYml0IHdvcnJ5aW5nIGJl
Y2F1c2Ugb2YgaXQgY29uY2VybmluZyBSQUlENjo8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj48YnI+
PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OC41NTUzODddICZuYnNwO3NsYWIgcmFpZDYt
bWQxMjUgc3RhcnQgYzAwMDAwMGQ5MzcxYmYzMCBwb2ludGVyIG9mZnNldCAxNiBzaXplIDI1NDQ8
L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NTQ2NF0gbGlzdF9hZGQgY29ycnVwdGlv
bi4gcHJldi0mZ3Q7bmV4dCBzaG91bGQgYmUgbmV4dCAoYzAwMDAwMDAyYTNmYzNlMCksIGJ1dCB3
YXMgYzAwMDAwMGQ5MzcxYmY0MC4gKHByZXY9YzAwMDAwMGQ5MzcxYmY0MCkuPC9zcGFuPjwvZGl2
PjxkaXY+PHNwYW4+WzI0MDg4OC41NTU1ODJdIC0tLS0tLS0tLS0tLVsgY3V0IGhlcmUgXS0tLS0t
LS0tLS0tLTwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODguNTU1NjE1XSBrZXJuZWwgQlVH
IGF0IGxpYi9saXN0X2RlYnVnLmM6MzIhPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OC41
NTU2NTBdIE9vcHM6IEV4Y2VwdGlvbiBpbiBrZXJuZWwgbW9kZSwgc2lnOiA1IFsjMV08L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NTcwM10gTEUgUEFHRV9TSVpFPTY0SyBNTVU9UmFk
aXggJm5ic3A7U01QIE5SX0NQVVM9MjA0OCBOVU1BIFBvd2VyTlY8L3NwYW4+PC9kaXY+PGRpdj48
c3Bhbj5bMjQwODg4LjU1NTc1NV0gTW9kdWxlcyBsaW5rZWQgaW46IHZlbmRvcl9yZXNldChPRSkg
dmZpb19wY2kgdmZpb19wY2lfY29yZSB2ZmlvX2lvbW11X3NwYXByX3RjZSB2ZmlvIGlvbW11ZmQg
dmhvc3RfbmV0IHZob3N0IHZob3N0X2lvdGxiIHRhcCB0dW4gbmZ0X21hc3EgbmZ0X3JlamVjdF9p
cHY0IGFjdF9jc3VtIGNsc191MzIgc2NoX2h0YiBuZl9uYXRfdGZ0cCBuZl9jb25udHJhY2tfdGZ0
cCBicmlkZ2Ugc3RwIGxsYyBrdm1faHYga3ZtIHJma2lsbCB4dF9jb25udHJhY2sgbmZ0X2NvbXBh
dCBuZnRfZmliX2luZXQgbmZ0X2ZpYl9pcHY0IG5mdF9maWJfaXB2NiBuZnRfZmliIG5mdF9yZWpl
Y3RfaW5ldCBuZl9yZWplY3RfaXB2NCBuZl9yZWplY3RfaXB2NiBuZnRfcmVqZWN0IG5mdF9jdCBu
ZnRfY2hhaW5fbmF0IG5mX25hdCBuZl9jb25udHJhY2sgbmZfZGVmcmFnX2lwdjYgbmZfZGVmcmFn
X2lwdjQgbmZfdGFibGVzIGRtX2NhY2hlX3NtcSBkbV9jYWNoZSByYWlkNDU2IGFzeW5jX3JhaWQ2
X3JlY292IGFzeW5jX21lbWNweSBhc3luY19wcSBhc3luY194b3IgYXN5bmNfdHggc3VucnBjIHJh
aWQxMCBzbmRfaGRhX2ludGVsIGF0MjQgam95ZGV2IHNuZF9pbnRlbF9kc3BjZmcgc25kX2hkYV9j
b2RlYyBzbmRfaGRhX2NvcmUgb25ib2FyZF91c2JfZGV2IHNuZF9od2RlcCBzbmRfc2VxIHNuZF9z
ZXFfZGV2aWNlIHNuZF9wY20gb2ZwYXJ0IHRnMyBwb3dlcm52X2ZsYXNoIHNuZF90aW1lciBhdGxh
bnRpYyB2bXhfY3J5cHRvIGlwbWlfcG93ZXJudiBzbmQgaXBtaV9kZXZpbnRmIG10ZCBpcG1pX21z
Z2hhbmRsZXIgbWFjc2VjIHJ0Y19vcGFsIG9wYWxfcHJkIHNvdW5kY29yZSBpMmNfb3BhbCBmdXNl
IGRtX211bHRpcGF0aCBsb29wIG5mbmV0bGluayB6cmFtIGx6NGhjX2NvbXByZXNzIGx6NF9jb21w
cmVzcyB4ZnMgZG1fdGhpbl9wb29sIGRtX3BlcnNpc3RlbnRfZGF0YSBkbV9iaW9fcHJpc29uIGRt
X2NyeXB0IHJhaWQxIG52bWUgbXB0M3NhcyBudm1lX2NvcmUgdWFzIHVzYl9zdG9yYWdlIGFzdCBu
dm1lX2tleXJpbmc8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NTk2Ml0gJm5ic3A7
bnZtZV9hdXRoIGhrZGYgcmFpZF9jbGFzcyBpMmNfYWxnb19iaXQgc2NzaV90cmFuc3BvcnRfc2Fz
IHNjc2lfZGhfcmRhYyBzY3NpX2RoX2VtYyBzY3NpX2RoX2FsdWEgaTJjX2RldiBhZXNfZ2NtX3Ax
MF9jcnlwdG8gY3J5cHRvX3NpbWQgY3J5cHRkPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4
OC41NTY1MzFdIENQVTogMzMgVUlEOiAwIFBJRDogMjg1MSBDb21tOiBkbWNyeXB0X3dyaXRlLzIg
VGFpbnRlZDogRyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IE9FICZuYnNwOyAm
bmJzcDsgJm5ic3A7IDYuMTguOC0yMDAuZmM0My5wcGM2NGxlICMxIFBSRUVNUFQodm9sdW50YXJ5
KSA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NjYwOF0gVGFpbnRlZDogW09dPU9P
VF9NT0RVTEUsIFtFXT1VTlNJR05FRF9NT0RVTEU8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQw
ODg4LjU1NjY1MF0gSGFyZHdhcmUgbmFtZTogVDJQOUQwMSBSRVYgMS4wMCBQT1dFUjkgKHJhdykg
MHg0ZTEyMDIgb3BhbDpza2lib290LWVjYjFkYzcgUG93ZXJOVjwvc3Bhbj48L2Rpdj48ZGl2Pjxz
cGFuPlsyNDA4ODguNTU2NzIxXSBOSVA6ICZuYnNwO2MwMDAwMDAwMDBlMDk4ZmMgTFI6IGMwMDAw
MDAwMDBlMDk4ZjggQ1RSOiAwMDAwMDAwMDAwMDAwMDAwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+
WzI0MDg4OC41NTY3NjZdIFJFR1M6IGMwMDAwMDAwMjk1ZTc3YTAgVFJBUDogMDcwMCAmbmJzcDsg
VGFpbnRlZDogRyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IE9FICZuYnNwOyAm
bmJzcDsgJm5ic3A7ICZuYnNwOyg2LjE4LjgtMjAwLmZjNDMucHBjNjRsZSk8L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5bMjQwODg4LjU1NjgyMl0gTVNSOiAmbmJzcDs5MDAwMDAwMDAwMDI5MDMzICZs
dDtTRixIVixFRSxNRSxJUixEUixSSSxMRSZndDsgJm5ic3A7Q1I6IDI0MDA0MjgwICZuYnNwO1hF
UjogMDAwMDAwMDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NjkwNF0gQ0ZBUjog
YzAwMDAwMDAwMDM0NTQyYyBJUlFNQVNLOiAwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMDA6
IGMwMDAwMDAwMDBlMDk4ZjggYzAwMDAwMDAyOTVlN2E0MCBjMDAwMDAwMDAyNmJhOTAwIDAwMDAw
MDAwMDAwMDAwNzUgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIwNDogMDAwMDAwMDBmZmZmYmZm
ZiAwMDAwMDAwMDAwMDAwMDAxIDAwMDAwMDFmZmMyZDAwMDAgMDAwMDAwMDAwMDAwMDAwMSA8L3Nw
YW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7IEdQUjA4OiAwMDAwMDAwMDAwMDAwMDI3IDAwMDAwMDAwMDAwMDAw
MDAgMDAwMDAwMDAwMDAwMDAwMCBjMDAwMDAwMDI5NWU3ODkwIDwvc3Bhbj48L2Rpdj48ZGl2Pjxz
cGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgR1BSMTI6IGMwMDAyMDFmZmYxOGZmYTggYzAwMDAwMWZmZmZkZTYwMCBjMDAwMDAwMDAwMjk5
YzI4IGMwMDAyMDAwMTEzZmRiNDAgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIxNjogMDAwMDAw
MDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAw
MDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjIwOiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAw
MDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAxIDwvc3Bhbj48L2Rp
dj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgR1BSMjQ6IDAwMDAwMDAwMDAwMDAwMDAgYzAwMDAwMDAyOTVlN2M3MCBjMDAw
MDAwMDJiYmNlODAwIGMwMDAwMDExMjZkNTc4MzAgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIy
ODogMDAwMDAwMDAwMDAwMDAwMCBjMDAwMjAxZDI5OTViNTg4IGMwMDAyMDAwNWY0NjQwMDAgYzAw
MDIwMWQyOTk1YjU0MCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NzMzOV0gTklQ
IFtjMDAwMDAwMDAwZTA5OGZjXSBfX2xpc3RfYWRkX3ZhbGlkX29yX3JlcG9ydCsweGRjLzB4MTQw
PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OC41NTc0MDVdIExSIFtjMDAwMDAwMDAwZTA5
OGY4XSBfX2xpc3RfYWRkX3ZhbGlkX29yX3JlcG9ydCsweGQ4LzB4MTQwPC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+WzI0MDg4OC41NTc0NjNdIENhbGwgVHJhY2U6PC9zcGFuPjwvZGl2PjxkaXY+PHNw
YW4+WzI0MDg4OC41NTc0ODRdIFtjMDAwMDAwMDI5NWU3YTQwXSBbYzAwMDAwMDAwMGUwOThmOF0g
X19saXN0X2FkZF92YWxpZF9vcl9yZXBvcnQrMHhkOC8weDE0MCAodW5yZWxpYWJsZSk8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NzU0MV0gW2MwMDAwMDAwMjk1ZTdhYjBdIFtjMDA4
MDAwMDIzOGYwYWQ0XSByZWxlYXNlX3N0cmlwZV9wbHVnKzB4OWMvMHgxNTAgW3JhaWQ0NTZdPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OC41NTc2MDddIFtjMDAwMDAwMDI5NWU3YjAwXSBb
YzAwODAwMDAyMzhmNTlmNF0gbWFrZV9zdHJpcGVfcmVxdWVzdCsweDMyYy8weDU2MCBbcmFpZDQ1
Nl08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1NzY3OF0gW2MwMDAwMDAwMjk1ZTdi
ZDBdIFtjMDA4MDAwMDIzOGY1ZGY4XSByYWlkNV9tYWtlX3JlcXVlc3QrMHgxZDAvMHg2MTAgW3Jh
aWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OC41NTc3NjVdIFtjMDAwMDAwMDI5
NWU3ZDEwXSBbYzAwMDAwMDAwMTM2OWEwNF0gbWRfaGFuZGxlX3JlcXVlc3QrMHgxYzQvMHg0MDA8
L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1Nzg1MF0gW2MwMDAwMDAwMjk1ZTdkYTBd
IFtjMDAwMDAwMDAwZDA0MDEwXSBfX3N1Ym1pdF9iaW8rMHgyMzAvMHgzZDA8L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj5bMjQwODg4LjU1NzkyN10gW2MwMDAwMDAwMjk1ZTdlNDBdIFtjMDAwMDAwMDAw
ZDA0MjQ0XSBfX3N1Ym1pdF9iaW9fbm9hY2N0KzB4OTQvMHgyNTA8L3NwYW4+PC9kaXY+PGRpdj48
c3Bhbj5bMjQwODg4LjU1Nzk5OF0gW2MwMDAwMDAwMjk1ZTdlYjBdIFtjMDAwMDAwMDAxMzg3NDNj
XSBkbV9zdWJtaXRfYmlvX3JlbWFwKzB4NGMvMHgxMjA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5b
MjQwODg4LjU1ODA3MF0gW2MwMDAwMDAwMjk1ZTdlZjBdIFtjMDA4MDAwMDFiY2UyNmE4XSBkbWNy
eXB0X3dyaXRlKzB4MWEwLzB4MjAwIFtkbV9jcnlwdF08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5b
MjQwODg4LjU1ODEzMV0gW2MwMDAwMDAwMjk1ZTdmOTBdIFtjMDAwMDAwMDAwMjk5ZGE4XSBrdGhy
ZWFkKzB4MTg4LzB4MWEwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OC41NTgxOTZdIFtj
MDAwMDAwMDI5NWU3ZmUwXSBbYzAwMDAwMDAwMDAwZGVkOF0gc3RhcnRfa2VybmVsX3RocmVhZCsw
eDE0LzB4MTg8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg4LjU1ODI1N10gQ29kZTogZjhj
MTAwNjAgZjgwMTAwODAgNGI4ODNiMzUgNjAwMDAwMDAgM2M2MmZmODIgMzg2MzkzODggZThjMTAw
NjAgZTkyMTAwNjggZThhNjAwMDAgN2QyNDRiNzggNGI1M2JhZjUgNjAwMDAwMDAgJmx0OzBmZTAw
MDAwJmd0OyA3YzA4MDJhNiA3Yzg1MjM3OCA3YzY0MWI3OCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5bMjQwODg4LjU1ODM2M10gLS0tWyBlbmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tPC9z
cGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4xMTQ1ODZdIHBzdG9yZTogYmFja2VuZCAobnZy
YW0pIHdyaXRpbmcgZXJyb3IgKC0xKTwvc3Bhbj48L2Rpdj48ZGl2Pjxicj48L2Rpdj48ZGl2Pjxz
cGFuPlsyNDA4ODkuMTE0NjM2XSBub3RlOiBkbWNyeXB0X3dyaXRlLzJbMjg1MV0gZXhpdGVkIHdp
dGggaXJxcyBkaXNhYmxlZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE0NzU2XSAt
LS0tLS0tLS0tLS1bIGN1dCBoZXJlIF0tLS0tLS0tLS0tLS08L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5bMjQwODg5LjExNDc4NV0gV0FSTklORzogQ1BVOiAzMyBQSUQ6IDI4NTEgYXQga2VybmVsL2V4
aXQuYzo5MDMgZG9fZXhpdCsweDVjLzB4NWIwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4
OS4xMTQ4MzddIE1vZHVsZXMgbGlua2VkIGluOiB2ZW5kb3JfcmVzZXQoT0UpIHZmaW9fcGNpIHZm
aW9fcGNpX2NvcmUgdmZpb19pb21tdV9zcGFwcl90Y2UgdmZpbyBpb21tdWZkIHZob3N0X25ldCB2
aG9zdCB2aG9zdF9pb3RsYiB0YXAgdHVuIG5mdF9tYXNxIG5mdF9yZWplY3RfaXB2NCBhY3RfY3N1
bSBjbHNfdTMyIHNjaF9odGIgbmZfbmF0X3RmdHAgbmZfY29ubnRyYWNrX3RmdHAgYnJpZGdlIHN0
cCBsbGMga3ZtX2h2IGt2bSByZmtpbGwgeHRfY29ubnRyYWNrIG5mdF9jb21wYXQgbmZ0X2ZpYl9p
bmV0IG5mdF9maWJfaXB2NCBuZnRfZmliX2lwdjYgbmZ0X2ZpYiBuZnRfcmVqZWN0X2luZXQgbmZf
cmVqZWN0X2lwdjQgbmZfcmVqZWN0X2lwdjYgbmZ0X3JlamVjdCBuZnRfY3QgbmZ0X2NoYWluX25h
dCBuZl9uYXQgbmZfY29ubnRyYWNrIG5mX2RlZnJhZ19pcHY2IG5mX2RlZnJhZ19pcHY0IG5mX3Rh
YmxlcyBkbV9jYWNoZV9zbXEgZG1fY2FjaGUgcmFpZDQ1NiBhc3luY19yYWlkNl9yZWNvdiBhc3lu
Y19tZW1jcHkgYXN5bmNfcHEgYXN5bmNfeG9yIGFzeW5jX3R4IHN1bnJwYyByYWlkMTAgc25kX2hk
YV9pbnRlbCBhdDI0IGpveWRldiBzbmRfaW50ZWxfZHNwY2ZnIHNuZF9oZGFfY29kZWMgc25kX2hk
YV9jb3JlIG9uYm9hcmRfdXNiX2RldiBzbmRfaHdkZXAgc25kX3NlcSBzbmRfc2VxX2RldmljZSBz
bmRfcGNtIG9mcGFydCB0ZzMgcG93ZXJudl9mbGFzaCBzbmRfdGltZXIgYXRsYW50aWMgdm14X2Ny
eXB0byBpcG1pX3Bvd2VybnYgc25kIGlwbWlfZGV2aW50ZiBtdGQgaXBtaV9tc2doYW5kbGVyIG1h
Y3NlYyBydGNfb3BhbCBvcGFsX3ByZCBzb3VuZGNvcmUgaTJjX29wYWwgZnVzZSBkbV9tdWx0aXBh
dGggbG9vcCBuZm5ldGxpbmsgenJhbSBsejRoY19jb21wcmVzcyBsejRfY29tcHJlc3MgeGZzIGRt
X3RoaW5fcG9vbCBkbV9wZXJzaXN0ZW50X2RhdGEgZG1fYmlvX3ByaXNvbiBkbV9jcnlwdCByYWlk
MSBudm1lIG1wdDNzYXMgbnZtZV9jb3JlIHVhcyB1c2Jfc3RvcmFnZSBhc3QgbnZtZV9rZXlyaW5n
PC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4xMTQ5OTNdICZuYnNwO252bWVfYXV0aCBo
a2RmIHJhaWRfY2xhc3MgaTJjX2FsZ29fYml0IHNjc2lfdHJhbnNwb3J0X3NhcyBzY3NpX2RoX3Jk
YWMgc2NzaV9kaF9lbWMgc2NzaV9kaF9hbHVhIGkyY19kZXYgYWVzX2djbV9wMTBfY3J5cHRvIGNy
eXB0b19zaW1kIGNyeXB0ZDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE1NTI4XSBD
UFU6IDMzIFVJRDogMCBQSUQ6IDI4NTEgQ29tbTogZG1jcnlwdF93cml0ZS8yIFRhaW50ZWQ6IEcg
Jm5ic3A7ICZuYnNwOyAmbmJzcDtEICZuYnNwOyAmbmJzcDtPRSAmbmJzcDsgJm5ic3A7ICZuYnNw
OyA2LjE4LjgtMjAwLmZjNDMucHBjNjRsZSAjMSBQUkVFTVBUKHZvbHVudGFyeSkgPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4xMTU2NDFdIFRhaW50ZWQ6IFtEXT1ESUUsIFtPXT1PT1Rf
TU9EVUxFLCBbRV09VU5TSUdORURfTU9EVUxFPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4
OS4xMTU2NzhdIEhhcmR3YXJlIG5hbWU6IFQyUDlEMDEgUkVWIDEuMDAgUE9XRVI5IChyYXcpIDB4
NGUxMjAyIG9wYWw6c2tpYm9vdC1lY2IxZGM3IFBvd2VyTlY8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5bMjQwODg5LjExNTc3MV0gTklQOiAmbmJzcDtjMDAwMDAwMDAwMjYwMzVjIExSOiBjMDAwMDAw
MDAwMjYwOTUwIENUUjogMDAwMDAwMDAwMDAwMDAwMDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsy
NDA4ODkuMTE1ODI4XSBSRUdTOiBjMDAwMDAwMDI5NWU3MzMwIFRSQVA6IDA3MDAgJm5ic3A7IFRh
aW50ZWQ6IEcgJm5ic3A7ICZuYnNwOyAmbmJzcDtEICZuYnNwOyAmbmJzcDtPRSAmbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsoNi4xOC44LTIwMC5mYzQzLnBwYzY0bGUpPC9zcGFuPjwvZGl2Pjxk
aXY+PHNwYW4+WzI0MDg4OS4xMTU4NzVdIE1TUjogJm5ic3A7OTAwMDAwMDAwMjAyOTAzMyAmbHQ7
U0YsSFYsVkVDLEVFLE1FLElSLERSLFJJLExFJmd0OyAmbmJzcDtDUjogMjQwMDQyODAgJm5ic3A7
WEVSOiAyMDA0MDAwMDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE1OTM2XSBDRkFS
OiBjMDAwMDAwMDAwMjYwOTRjIElSUU1BU0s6IDAgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIw
MDogYzAwMDAwMDAwMDI2MDk1MCBjMDAwMDAwMDI5NWU3NWQwIGMwMDAwMDAwMDI2YmE5MDAgMDAw
MDAwMDAwMDAwMDAwNSA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjA0OiAwMDAwMDAwMDAwMDAy
NzEwIDAwMDAwMDAwMDAwMDAwMDEgMDAwMDAwMWZmYzJkMDAwMCAwMDAwMDAwMDAwMDAwMDAxIDwv
c3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMDg6IDAwMDAwMDAwMDAwMDAwMDUgMDAwMDAwMDAwMDAw
MDAwMSBjMDAwMDAwMDI5NWU3ZjE4IDAwMDAwMDAwMDAwMDQwMDAgPC9zcGFuPjwvZGl2PjxkaXY+
PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyBHUFIxMjogYzAwMDIwMWZmZjE4ZmZhOCBjMDAwMDAxZmZmZmRlNjAwIDAwMDAwMDAwMDAw
MDAwMDAgMDAwMDAwMDAwMDAwMDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4mbmJzcDsgJm5i
c3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQUjE2OiAwMDAw
MDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAw
MDAwMDAwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMjA6IDAwMDAwMDAwMDAwMDAwMDAgMDAw
MDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyBHUFIyNDogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAwIDAw
MDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj4m
bmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7IEdQ
UjI4OiAwMDAwMDAwMDAwMDAwMDA1IDAwMDAwMDAwMDAwMDAwMDMgYzAwMDAwMDAwM2UzYTkwMCBj
MDAwMDAwMDQ1NTVlODAwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE2Mzc5XSBO
SVAgW2MwMDAwMDAwMDAyNjAzNWNdIGRvX2V4aXQrMHg1Yy8weDViMDwvc3Bhbj48L2Rpdj48ZGl2
PjxzcGFuPlsyNDA4ODkuMTE2NDA3XSBMUiBbYzAwMDAwMDAwMDI2MDk1MF0gbWFrZV90YXNrX2Rl
YWQrMHhhMC8weDFkMDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE2NDI3XSBDYWxs
IFRyYWNlOjwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE2NDczXSBbYzAwMDAwMDAy
OTVlNzVkMF0gW2MwMDAwMDAwMjk1ZTc2MDBdIDB4YzAwMDAwMDAyOTVlNzYwMCAodW5yZWxpYWJs
ZSk8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExNjU0OV0gW2MwMDAwMDAwMjk1ZTc2
NzBdIFtjMDAwMDAwMDAwMjYwOTUwXSBtYWtlX3Rhc2tfZGVhZCsweGEwLzB4MWQwPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4xMTY2MjFdIFtjMDAwMDAwMDI5NWU3NmYwXSBbYzAwMDAw
MDAwMDAyYTMxNF0gb29wc19lbmQrMHgxNjQvMHgxYTA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5b
MjQwODg5LjExNjY4OV0gW2MwMDAwMDAwMjk1ZTc3NzBdIFtjMDAwMDAwMDAwMDA5YjJjXSBwcm9n
cmFtX2NoZWNrX2NvbW1vbl92aXJ0KzB4M2JjLzB4M2MwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+
WzI0MDg4OS4xMTY3NDldIC0tLS0gaW50ZXJydXB0OiA3MDAgYXQgX19saXN0X2FkZF92YWxpZF9v
cl9yZXBvcnQrMHhkYy8weDE0MDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPlsyNDA4ODkuMTE2Nzk5
XSBOSVA6ICZuYnNwO2MwMDAwMDAwMDBlMDk4ZmMgTFI6IGMwMDAwMDAwMDBlMDk4ZjggQ1RSOiAw
MDAwMDAwMDAwMDAwMDAwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4xMTY4MzhdIFJF
R1M6IGMwMDAwMDAwMjk1ZTc3YTAgVFJBUDogMDcwMCAmbmJzcDsgVGFpbnRlZDogRyAmbmJzcDsg
Jm5ic3A7ICZuYnNwO0QgJm5ic3A7ICZuYnNwO09FICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNw
Oyg2LjE4LjgtMjAwLmZjNDMucHBjNjRsZSk8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5
LjExNjkwNV0gTVNSOiAmbmJzcDs5MDAwMDAwMDAwMDI5MDMzICZsdDtTRixIVixFRSxNRSxJUixE
UixSSSxMRSZndDsgJm5ic3A7Q1I6IDI0MDA0MjgwICZuYnNwO1hFUjogMDAwMDAwMDA8L3NwYW4+
PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExNjk2N10gQ0ZBUjogYzAwMDAwMDAwMDM0NTQyYyBJ
UlFNQVNLOiAwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMDA6IGMwMDAwMDAwMDBlMDk4Zjgg
YzAwMDAwMDAyOTVlN2E0MCBjMDAwMDAwMDAyNmJhOTAwIDAwMDAwMDAwMDAwMDAwNzUgPC9zcGFu
PjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7ICZuYnNwOyBHUFIwNDogMDAwMDAwMDBmZmZmYmZmZiAwMDAwMDAwMDAwMDAwMDAx
IDAwMDAwMDFmZmMyZDAwMDAgMDAwMDAwMDAwMDAwMDAwMSA8L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7
IEdQUjA4OiAwMDAwMDAwMDAwMDAwMDI3IDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAw
MCBjMDAwMDAwMDI5NWU3ODkwIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMTI6IGMwMDAyMDFm
ZmYxOGZmYTggYzAwMDAwMWZmZmZkZTYwMCBjMDAwMDAwMDAwMjk5YzI4IGMwMDAyMDAwMTEzZmRi
NDAgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZu
YnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIxNjogMDAwMDAwMDAwMDAwMDAwMCAwMDAwMDAw
MDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAwMDAwMDAwMDAwMCA8L3NwYW4+PC9kaXY+
PGRpdj48c3Bhbj4mbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJz
cDsgJm5ic3A7IEdQUjIwOiAwMDAwMDAwMDAwMDAwMDAwIDAwMDAwMDAwMDAwMDAwMDAgMDAwMDAw
MDAwMDAwMDAwMCAwMDAwMDAwMDAwMDAwMDAxIDwvc3Bhbj48L2Rpdj48ZGl2PjxzcGFuPiZuYnNw
OyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyAmbmJzcDsgR1BSMjQ6
IDAwMDAwMDAwMDAwMDAwMDAgYzAwMDAwMDAyOTVlN2M3MCBjMDAwMDAwMDJiYmNlODAwIGMwMDAw
MDExMjZkNTc4MzAgPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+Jm5ic3A7ICZuYnNwOyAmbmJzcDsg
Jm5ic3A7ICZuYnNwOyAmbmJzcDsgJm5ic3A7ICZuYnNwOyBHUFIyODogMDAwMDAwMDAwMDAwMDAw
MCBjMDAwMjAxZDI5OTViNTg4IGMwMDAyMDAwNWY0NjQwMDAgYzAwMDIwMWQyOTk1YjU0MCA8L3Nw
YW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExNzM0M10gTklQIFtjMDAwMDAwMDAwZTA5OGZj
XSBfX2xpc3RfYWRkX3ZhbGlkX29yX3JlcG9ydCsweGRjLzB4MTQwPC9zcGFuPjwvZGl2PjxkaXY+
PHNwYW4+WzI0MDg4OS4xMTc0MDBdIExSIFtjMDAwMDAwMDAwZTA5OGY4XSBfX2xpc3RfYWRkX3Zh
bGlkX29yX3JlcG9ydCsweGQ4LzB4MTQwPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4x
MTc0NTRdIC0tLS0gaW50ZXJydXB0OiA3MDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5
LjExNzQ4N10gW2MwMDAwMDAwMjk1ZTdhYjBdIFtjMDA4MDAwMDIzOGYwYWQ0XSByZWxlYXNlX3N0
cmlwZV9wbHVnKzB4OWMvMHgxNTAgW3JhaWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+PHNwYW4+WzI0
MDg4OS4xMTc1NDRdIFtjMDAwMDAwMDI5NWU3YjAwXSBbYzAwODAwMDAyMzhmNTlmNF0gbWFrZV9z
dHJpcGVfcmVxdWVzdCsweDMyYy8weDU2MCBbcmFpZDQ1Nl08L3NwYW4+PC9kaXY+PGRpdj48c3Bh
bj5bMjQwODg5LjExNzYwNV0gW2MwMDAwMDAwMjk1ZTdiZDBdIFtjMDA4MDAwMDIzOGY1ZGY4XSBy
YWlkNV9tYWtlX3JlcXVlc3QrMHgxZDAvMHg2MTAgW3JhaWQ0NTZdPC9zcGFuPjwvZGl2PjxkaXY+
PHNwYW4+WzI0MDg4OS4xMTc2NzhdIFtjMDAwMDAwMDI5NWU3ZDEwXSBbYzAwMDAwMDAwMTM2OWEw
NF0gbWRfaGFuZGxlX3JlcXVlc3QrMHgxYzQvMHg0MDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5b
MjQwODg5LjExNzczOF0gW2MwMDAwMDAwMjk1ZTdkYTBdIFtjMDAwMDAwMDAwZDA0MDEwXSBfX3N1
Ym1pdF9iaW8rMHgyMzAvMHgzZDA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExNzc5
Ml0gW2MwMDAwMDAwMjk1ZTdlNDBdIFtjMDAwMDAwMDAwZDA0MjQ0XSBfX3N1Ym1pdF9iaW9fbm9h
Y2N0KzB4OTQvMHgyNTA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExNzg1OV0gW2Mw
MDAwMDAwMjk1ZTdlYjBdIFtjMDAwMDAwMDAxMzg3NDNjXSBkbV9zdWJtaXRfYmlvX3JlbWFwKzB4
NGMvMHgxMjA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExNzk1Nl0gW2MwMDAwMDAw
Mjk1ZTdlZjBdIFtjMDA4MDAwMDFiY2UyNmE4XSBkbWNyeXB0X3dyaXRlKzB4MWEwLzB4MjAwIFtk
bV9jcnlwdF08L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExODAxN10gW2MwMDAwMDAw
Mjk1ZTdmOTBdIFtjMDAwMDAwMDAwMjk5ZGE4XSBrdGhyZWFkKzB4MTg4LzB4MWEwPC9zcGFuPjwv
ZGl2PjxkaXY+PHNwYW4+WzI0MDg4OS4xMTgwODRdIFtjMDAwMDAwMDI5NWU3ZmUwXSBbYzAwMDAw
MDAwMDAwZGVkOF0gc3RhcnRfa2VybmVsX3RocmVhZCsweDE0LzB4MTg8L3NwYW4+PC9kaXY+PGRp
dj48c3Bhbj5bMjQwODg5LjExODEzMV0gQ29kZTogOTE2MTAwMDggZjgwMTAwMTAgZjgyMWZmNjEg
ZTkyZDBjNzggZjkyMTAwNzggMzkyMDAwMDAgODkyZDA5MzIgNTUyOTA3ZmUgMGIwOTAwMDAgZTk1
ZjBjNjggMzEyYWZmZmYgN2QyOTUxMTAgJmx0OzBiMDkwMDAwJmd0OyBlYmJmMGI5MCBlYmRmMGI4
OCA3ZmEzZWI3OCA8L3NwYW4+PC9kaXY+PGRpdj48c3Bhbj5bMjQwODg5LjExODMyMF0gLS0tWyBl
bmQgdHJhY2UgMDAwMDAwMDAwMDAwMDAwMCBdLS0tPC9zcGFuPjwvZGl2PjxkaXYgc3R5bGU9ImZv
bnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJpZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdi
KDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNvbG9yOiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij48c3Bhbj48
YnI+PC9zcGFuPjwvZGl2PjxkaXYgc3R5bGU9ImZvbnQtZmFtaWx5OiBBcmlhbCwgc2Fucy1zZXJp
ZjsgZm9udC1zaXplOiAxNHB4OyBjb2xvcjogcmdiKDAsIDAsIDApOyBiYWNrZ3JvdW5kLWNvbG9y
OiByZ2IoMjU1LCAyNTUsIDI1NSk7Ij48c3Bhbj5JZiB0aGF0J3MgYW55IHVzZWZ1bCB0byByZXZl
YWwgYSBidWcsIGFib3V0IHRoZSB0YWludGluZyBtb2R1bGUsIGl0J3MgYSBwb3J0IG9mJm5ic3A7
PHNwYW4+PGEgdGFyZ2V0PSJfYmxhbmsiIHJlbD0ibm9yZWZlcnJlciBub2ZvbGxvdyBub29wZW5l
ciIgaHJlZj0iaHR0cHM6Ly9naXRodWIuY29tL2duaWYvdmVuZG9yLXJlc2V0Ij5odHRwczovL2dp
dGh1Yi5jb20vZ25pZi92ZW5kb3ItcmVzZXQ8L2E+PC9zcGFuPiZuYnNwO3RvIHBwYyB0byByZXNl
dCBzb21lIG9sZGVyIGdyYXBoaWNzIGNhcmRzLCBub3RoaW5nIHRoYXQgc2hvdWxkIGFmZmVjdCB3
aGF0IHRoZSBsb2cgaXMgdGFsa2luZyBhYm91dCwgZnVydGhlcm1vcmUgaXRzIGJlZW4gaGVyZSBm
b3IgcXVpdGUgYSBsb25nIHRpbWUgd2l0aG91dCBhbnkgZXJyb3JzLjwvc3Bhbj48L2Rpdj48ZGl2
IHN0eWxlPSJmb250LWZhbWlseTogQXJpYWwsIHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsg
Y29sb3I6IHJnYigwLCAwLCAwKTsgYmFja2dyb3VuZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUp
OyI+PHNwYW4+PGJyPjwvc3Bhbj48L2Rpdj48ZGl2IHN0eWxlPSJmb250LWZhbWlseTogQXJpYWws
IHNhbnMtc2VyaWY7IGZvbnQtc2l6ZTogMTRweDsgY29sb3I6IHJnYigwLCAwLCAwKTsgYmFja2dy
b3VuZC1jb2xvcjogcmdiKDI1NSwgMjU1LCAyNTUpOyI+PHNwYW4+VGhhbmtzPC9zcGFuPjwvZGl2
PjxzcGFuPjwvc3Bhbj48YnI+CiAgICAgICAgPC9ibG9ja3F1b3RlPjxicj4KICAgIDwvZGl2Pgog
ICAgICAgIDwvYmxvY2txdW90ZT48YnI+CiAgICA8L2Rpdj4KICAgICAgICA8L2Jsb2NrcXVvdGU+
PGJyPgogICAgPC9kaXY+
-----------------------1c01de8b29a39b7fe3db4b2f3829bde4--
-----------------------84a2ad6ef82036717be673bbeec47f00--
-----------------------df630996e73322e4e0947ceeea6a20cd
Content-Type: application/pgp-keys; filename="publickey - jfiusdq@proton.me - 0x344F580A.asc"; name="publickey - jfiusdq@proton.me - 0x344F580A.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - jfiusdq@proton.me - 0x344F580A.asc"; name="publickey - jfiusdq@proton.me - 0x344F580A.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCgp4ak1FYVJXRTZ4WUpLd1lCQkFI
YVJ3OEJBUWRBZi92VUlPRVlEcjl2OHZEQ1RicVlJdnhoUlJ0MjBhTm8KMTF1OUVuVGdyQ0hOSldw
bWFYVnpaSEZBY0hKdmRHOXVMbTFsSUR4cVptbDFjMlJ4UUhCeWIzUnZiaTV0ClpUN0N3QkVFRXhZ
S0FJTUZnbWtWaE9zREN3a0hDUkR0dzkxdmxVeGhSRVVVQUFBQUFBQWNBQ0J6WVd4MApRRzV2ZEdG
MGFXOXVjeTV2Y0dWdWNHZHdhbk11YjNKbk5wY3RzQ0hKRjBqUEZLY3Vod1lCQ1hMZ2Y0S28KZHFy
OWdXSmR4bVVPem5jREZRb0lCQllBQWdFQ0dRRUNtd01DSGdFV0lRUTBUMWdLY2hVRDBBWUZvajN0
Cnc5MXZsVXhoUkFBQWorWUEvMlFSRmkvOElBNFU4YWszNVBmN1hDWHdRQkxpTUZDUW16MDhYOWs1
SkNkZgpBUDBSWUpIWHdoZGZ1WUZBT0dsaE9iVzFQejBBM2FLM2dUa09SbE1VSTk5YURzNDRCR2tW
aE9zU0Npc0cKQVFRQmwxVUJCUUVCQjBDbmlSQ21tN0MrV2tOaXk5RVcrZFo4MHhsRnZqbk90MXRj
TkdrZUJDUVhOUU1CCkNBZkN2Z1FZRmdvQWNBV0NhUldFNndrUTdjUGRiNVZNWVVSRkZBQUFBQUFB
SEFBZ2MyRnNkRUJ1YjNSaApkR2x2Ym5NdWIzQmxibkJuY0dwekxtOXlaNUVQUDJ6b3diOG9zZUFP
MjRKQjdhMGxRWEVSZnJWK0t4Wm8KM214bldMdldBcHNNRmlFRU5FOVlDbklWQTlBR0JhSTk3Y1Bk
YjVWTVlVUUFBQTdRQVAwWjcreHdQRU9hCmpnT3FKR0Z0TEN1M1hsUXhJNUVKSThxdElMc3Z2Vk5i
dGdEK01UdjNJeGRvRmUrWmkxeGxnaGd3cjRBYwppdENwamlRL21Jc2lWTXlQb1EwPQo9U2tMTQot
LS0tLUVORCBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tCg==
-----------------------df630996e73322e4e0947ceeea6a20cd--

--------3ccc66f98350953d7ee2d3b7b147d15aa0f13c6791987991b9c8ae5abb81122e
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wrsEARYKAG0FgmmVwhgJEO3D3W+VTGFERRQAAAAAABwAIHNhbHRAbm90YXRp
b25zLm9wZW5wZ3Bqcy5vcmecnkl/QMpfD+Yz8P9sVvxUIMV0ltFKkY0b/hu8
jdfUUhYhBDRPWApyFQPQBgWiPe3D3W+VTGFEAAB+RAEA4IlxB3U0CaETYCY3
xvzPNP0gguazKvKeDg/wd74SSzYBAI59lQgzQiAFispFHl18crarYMeQwT+9
kj7yfRysvYkL
=HGBN
-----END PGP SIGNATURE-----


--------3ccc66f98350953d7ee2d3b7b147d15aa0f13c6791987991b9c8ae5abb81122e--

