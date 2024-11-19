Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A4661C9ED2;
	Tue, 19 Nov 2024 11:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732016147; cv=none; b=MW2OWRYZfQS1l3DvE61xVWXrOua0mSvzqwIk6Ro1QEbK2HiOgnovJhe3ZzaB4XIRw85JHxClzf2/aUEgIi26QA5EwfZ99K5NE0o8qQGyzB+hQZquR+UUjHKn0DgCdAjeHqAI58gzzvjH0AL1gVzCQqZ3WwSyGZ8SWUAF1tUR5yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732016147; c=relaxed/simple;
	bh=81kvxPsA0qdfUBUxmkpR9OXaMxv5K+9BApYz3Cb4qh4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oE2cOEWaHRzHBkCv4CyhQRjqBt4sVP9j2i3Ud0pKNiX/RYPP61Gpi585ELQ6wlRh0cJpa+rD1JQK2DGtGeoJi4+bBG42Cf2gy/AdtxZV8cRTaXqm5bNGPwlgwz6/gA56QMWCqJvCoJRssxYeATSvI3q2Yofs7iWPrOQQHebHrUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=G8I+cG0d; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="G8I+cG0d"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ3XOqZ017807;
	Tue, 19 Nov 2024 11:35:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=SbXDBh
	PGv+Qps7NDNZscpCvJ49b+QTQ/KAE1lRq+JEg=; b=G8I+cG0d8D4GPJncchYsM/
	AZ7jvaEruBx9jcq0LiOydSc2zacTQ3ZxMoD82NeLLsBIO6yZSxUMf8c0dK2fM/fi
	eiSKJvzOPiaQ8ZovmEiFnZHRa19mDUpU+qdIOThZlfQf2B0t2gr9avMtlbptMeD/
	efsj53GBr7WfetL+yNa1QzJQX881azsgiepGI2py4Wal7D9E358VXRkxDn05AMs1
	TpPwIsMf6RnVYzBa0K3d67RBcnvQ+ugMOq/QvI1B+tFCXCKYsgKqWrbEgrRBUvAV
	LHy2sAV+QDTxb3Yv3UBT47aAGfYYzNDJlqy1fEVF7Wvv73/cgxUSaJIBYr0Jy+6w
	==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 42xjw7ysxr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 11:35:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 4AJ23vmM011836;
	Tue, 19 Nov 2024 11:35:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 42y7xjmc62-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 19 Nov 2024 11:35:04 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 4AJBZ2vx40370648
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Nov 2024 11:35:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7FDF420043;
	Tue, 19 Nov 2024 11:35:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D288B20040;
	Tue, 19 Nov 2024 11:34:59 +0000 (GMT)
Received: from li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com (unknown [9.39.16.91])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue, 19 Nov 2024 11:34:59 +0000 (GMT)
Date: Tue, 19 Nov 2024 17:04:56 +0530
From: Ojaswin Mujoo <ojaswin@linux.ibm.com>
To: Genes Lists <lists@sapience.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux@leemhuis.info
Subject: Re: md-raid  6.11.8 page fault oops
Message-ID: <Zzx34Mm5K42GWyKj@li-bb2b2a4c-3307-11b2-a85c-8fa5c3a69313.ibm.com>
References: <0b579808e848171fc64e04f0629e24735d034d32.camel@sapience.com>
 <34333c67f5490cda041bc0cbe4336b94271d5b49.camel@sapience.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <34333c67f5490cda041bc0cbe4336b94271d5b49.camel@sapience.com>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: n5_1QxbsLod8Hs004SuvtD2000D_bWJm
X-Proofpoint-ORIG-GUID: n5_1QxbsLod8Hs004SuvtD2000D_bWJm
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-15_01,2024-10-11_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0 spamscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 malwarescore=0 phishscore=0
 lowpriorityscore=0 mlxscore=0 mlxlogscore=999 suspectscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.19.0-2409260000
 definitions=main-2411190083

On Sun, Nov 17, 2024 at 12:23:40PM -0500, Genes Lists wrote:
> On Fri, 2024-11-15 at 07:12 -0500, Genes Lists wrote:
> >=20
> >=20
> Another page fault oops this time when 6.11.8 was shutting to boot
> 6.11.9.=20
>=20
> This one is in ext4 -> rbtree and I don't see raid at all this time.
> (Soadding ext4 maintainers)
>=20
> The previous oops occurred in clone_endio from dm_mod.
>=20
> I note that 9 hours before the oops there was a an ext4 error - in case
> it's relevant.
>=20
> This oops occurred in rb_first+0x13 invoked from
> ext4_discard_preallocations+0xc3.
>=20
> journal summary below and full log attached.
>=20
> gene
>=20
> # --- line numbers -----
>=20
> rbtree line:
>  (gdb) list *(rb_first+0x13)
>   0xffffffff81de1af3 is in rb_first (lib/rbtree.c:473).
>   468       struct rb_node  *n;
>   469
>   470       n =3D root->rb_node;
>   471       if (!n)
>   472           return NULL;
>   473       while (n->rb_left)

Now this looks strange, we already make sure n is not NULL and then
somehow this line ends up in

 BUG: unable to handle page fault for address: 0000000000200010

Now, decoding the code with an x86 vmlinux, I see the fauling opcode
faulting:

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
   0:   0f 1f 80 00 00 00 00    nopl   0x0(%rax)
   7:   90                      nop
   8:   90                      nop
   9:   90                      nop
   a:   90                      nop
   b:   90                      nop
   c:   90                      nop
   d:   90                      nop
   e:   90                      nop
   f:   90                      nop

Now RAX is 0x200000 but I don't think the nopl instruction should have resu=
lted
in a mem access AFA my limited understanding of x86 ISA goes.

I also don't see nopl in my vmlinux in rb_first, my binary being compiled w=
ith
gcc 8.5. Are you by chance using clang or higher version or higher optimiza=
tion in gcc.

Regards,
ojaswin

>   474           n =3D n->rb_left;
>   475       return n;
>   476   }
>   477   EXPORT_SYMBOL(rb_first);

>=20
> ext4 line:
> (gdb) list *(ext4_discard_preallocations+0xc3)
>   0x372f3 is in ext4_discard_preallocations (fs/ext4/mballoc.c:5539).
>   5534              atomic_read(&ei->i_prealloc_active));
>   5535
>   5536  repeat:
>   5537      /* first, collect all pa's in the inode */
>   5538      write_lock(&ei->i_prealloc_lock);
>   5539      for (iter =3D rb_first(&ei->i_prealloc_node); iter;
>   5540           iter =3D rb_next(iter)) {
>   5541          pa =3D rb_entry(iter, struct ext4_prealloc_space,
>   5542                    pa_node.inode_node);
>   5543          BUG_ON(pa->pa_node_lock.inode_lock !=3D &ei-
> >i_prealloc_lock);
>=20
>=20
> # ----------- journal -------
>=20
> # This is =C2=A09 hours prior to oops
> [161780.846149]  EXT4-fs (dm-3): error count since last fsck: 2
> [161780.847081]  EXT4-fs (dm-3): initial error at time 1731742618:
> ext4_lookup:1813: inode 126161478
> [161780.847214]  EXT4-fs (dm-3): last error at time 1731742618:
> ext4_lookup:1813: inode 126161478
>=20
>=20
> [191322.007026]  EXT4-fs (sdg5): unmounting filesystem 3e25ed0e-ff2b-
> 4ad1-8227-6dc838055384.
> [191322.007093]  EXT4-fs (sdg4): unmounting filesystem 1b631410-216a-
> 4909-a02e-0362da57d241.
> [191322.011010]  EXT4-fs (nvme0n1p5): unmounting filesystem f6f66f4e-
> 1ed8-47fd-ac65-b91acd278d89.
> [191322.016010]  EXT4-fs (nvme0n1p2): unmounting filesystem bd94c712-
> f5f3-4f18-b1ed-b77ee42d4e0b.
> [191322.261047]  EXT4-fs (sdg2): unmounting filesystem 8f93166e-b18c-
> 4522-af8c-21fdc12ef3e2.
> [191331.777986]  BUG: unable to handle page fault for address:
> 0000000000200010
> [191331.778187]  #PF: supervisor read access in kernel mode
> [191331.781901]  #PF: error_code(0x0000) - not-present page
> [191331.781956]  PGD 0 P4D 0
> [191331.782037]  Oops: Oops: 0000 [#1] PREEMPT SMP PTI
> [191331.782075]  CPU: 1 UID: 0 PID: 37604 Comm: umount Not tainted
> 6.11.8-stable-1 #21 1400000003000000474e5500ae13c727d476f9ab
> [191331.782093]  Hardware name: To Be Filled By O.E.M. To Be Filled By
> O.E.M./Z370 Extreme4, BIOS P4.20 10/31/2019
> [191331.782105]  RIP: 0010:rb_first+0x13/0x30
> [191331.782120]  Code: 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90
> 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 07 48 85 c0 74 18 0f 1f 40 00 48
> 89 c2 <48> 8b 40 10 48 85 c0 75 f4 48 89 d0 c3 cc cc cc cc 31 d2 eb f4
> 0f
> [191331.782135]  RSP: 0018:ffffa95621d3f8d8 EFLAGS: 00010206
> [191331.782146]  RAX: 0000000000200000 RBX: ffffa95621d3f8f8 RCX:
> 0000000000000000
> [191331.782162]  RDX: 0000000000200000 RSI: 0000000000000000 RDI:
> ffff8f299ec75708
> [191331.782176]  RBP: ffffa95621d3f908 R08: 0000000000000001 R09:
> 000000000066001a
> [191331.782189]  R10: 000000000066001a R11: 0000000000000000 R12:
> ffff8f2585b77800
> [191331.782200]  R13: ffff8f299ec75468 R14: ffff8f299ec75710 R15:
> ffff8f297376c688
> [191331.782211]  FS:  00007f30f4a6db80(0000) GS:ffff8f2d1ec80000(0000)
> knlGS:0000000000000000
> [191331.782222]  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [191331.782234]  CR2: 0000000000200010 CR3: 000000011c868003 CR4:
> 00000000003706f0
> [191331.782252]  DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [191331.782283]  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [191331.782294]  Call Trace:
> [191331.782308]   <TASK>
> [191331.782320]   ? __die_body.cold+0x19/0x27
> [191331.782333]   ? page_fault_oops+0x15a/0x2d0
> [191331.782346]   ? exc_page_fault+0x7e/0x180
> [191331.782362]   ? asm_exc_page_fault+0x26/0x30
> [191331.782374]   ? rb_first+0x13/0x30
> [191331.782385]   ext4_discard_preallocations+0xc3/0x460 [ext4
> 1400000003000000474e5500fcb7142b958415b3]
> [191331.782401]   ext4_clear_inode+0x2a/0xb0 [ext4
> 1400000003000000474e5500fcb7142b958415b3]
> [191331.782414]   ext4_evict_inode+0xa1/0x6b0 [ext4
> 1400000003000000474e5500fcb7142b958415b3]
> [191331.782432]   evict+0x111/0x2c0
> [191331.782460]   ? fsnotify_destroy_marks+0x2a/0x1b0
> [191331.782470]   ? __call_rcu_common+0xc2/0x710
> [191331.782480]   evict_inodes+0x226/0x240
> [191331.782723]   generic_shutdown_super+0x3d/0x170
> [191331.782739]   kill_block_super+0x1a/0x40
> [191331.782753]   ext4_kill_sb+0x22/0x40 [ext4
> 1400000003000000474e5500fcb7142b958415b3]
> [191331.782766]   deactivate_locked_super+0x30/0xb0
> [191331.782776]   cleanup_mnt+0xba/0x150
> [191331.782786]   task_work_run+0x59/0x90
> [191331.782794]   syscall_exit_to_user_mode+0x1f4/0x200
> [191331.782805]   do_syscall_64+0x8e/0x160
> [191331.782815]   ? vfs_statx+0x8d/0x100
> [191331.782830]   ? vfs_fstatat+0x8a/0xb0
> [191331.782848]   ? __do_sys_newfstatat+0x3c/0x80
> [191331.782861]   ? syscall_exit_to_user_mode+0x10/0x200
> [191331.782805]   do_syscall_64+0x8e/0x160
> [191331.782815]   ? vfs_statx+0x8d/0x100
> [191331.782830]   ? vfs_fstatat+0x8a/0xb0
> [191331.782848]   ? __do_sys_newfstatat+0x3c/0x80
> [191331.782861]   ? syscall_exit_to_user_mode+0x10/0x200
> [191331.782871]   ? do_syscall_64+0x8e/0x160
> [191331.782884]   ? generic_permission+0x39/0x220
> [191331.782895]   ? mntput_no_expire+0x4a/0x260
> [191331.782907]   ? do_faccessat+0x1e1/0x2e0
> [191331.782916]   ? syscall_exit_to_user_mode+0x10/0x200
> [191331.782926]   ? do_syscall_64+0x8e/0x160
> [191331.782936]   ? do_user_addr_fault+0x36c/0x620
> [191331.782947]   ? exc_page_fault+0x7e/0x180
> [191331.782956]   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [191331.782969]  RIP: 0033:0x7f30f4bc21cb
> [191331.782981]  Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3
> 0f 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00
> 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 11 cb 0c 00 f7
> d8
> [191331.782995]  RSP: 002b:00007fff6233d1e8 EFLAGS: 00000246 ORIG_RAX:
> 00000000000000a6
> [191331.783039]  RAX: 0000000000000000 RBX: 0000561542af84e0 RCX:
> 00007f30f4bc21cb
> [191331.783053]  RDX: 0000000000000000 RSI: 0000000000000000 RDI:
> 0000561542af9180
> [191331.783099]  RBP: 00007fff6233d2c0 R08: 0000561542af6010 R09:
> 0000000000000007
> [191331.783115]  R10: 0000000000000000 R11: 0000000000000246 R12:
> 0000561542af85e8
> [191331.783126]  R13: 0000000000000000 R14: 0000561542af9180 R15:
> 0000561542af9570
> [191331.783143]   </TASK>
> [191331.783158]  Modules linked in: algif_hash af_alg nft_nat
> nft_chain_nat nf_nat nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4
> nf_tables rpcrdma rdma_cm iw_cm ib_cm wireguard curve25519_x86_64
> libchacha20poly1305 ib_core chacha_x86_64 poly1305_x86_64
> libcurve25519_generic libchacha ip6_udp_tunnel udp_tunnel nct6775
> nct6775_core hwmon_vid snd_hda_codec_hdmi snd_hda_codec_realtek
> snd_hda_codec_generic snd_hda_scodec_component dm_cache_smq dm_cache
> dm_persistent_data dm_bio_prison dm_bufio nls_iso8859_1 vfat fat
> intel_rapl_msr intel_rapl_common intel_uncore_frequency
> intel_uncore_frequency_common raid456 intel_tcc_cooling
> async_raid6_recov async_memcpy x86_pkg_temp_thermal async_pq
> snd_soc_avs async_xor intel_powerclamp async_tx snd_soc_hda_codec xor
> joydev coretemp snd_hda_ext_core raid6_pq libcrc32c snd_soc_core
> kvm_intel snd_compress i915 ac97_bus snd_pcm_dmaengine snd_hda_intel
> kvm snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core
> snd_hwdep rapl drm_buddy snd_pcm mei_hdcp mei_pxp i2c_algo_bit ee1004
> [191331.783217]   intel_cstate snd_timer ttm i2c_i801
> drm_display_helper snd mei_me i2c_smbus intel_uncore usbhid
> intel_wmi_thunderbolt pcspkr e1000e mxm_wmi i2c_mux soundcore cec mei
> intel_gtt intel_pmc_core intel_vsec md_mod pmt_telemetry pmt_class
> cfg80211 acpi_pad mac_hid rfkill nfsd auth_rpcgss nfs_acl lockd grace
> tcp_bbr loop dm_mod fuse sunrpc nfnetlink ip_tables x_tables ext4
> crc32c_generic crc16 mbcache jbd2 crct10dif_pclmul crc32_pclmul
> crc32c_intel polyval_clmulni polyval_generic ghash_clmulni_intel
> sha512_ssse3 sha256_ssse3 sha1_ssse3 nvme aesni_intel gf128mul
> crypto_simd cryptd xhci_pci nvme_core xhci_pci_renesas video wmi
> usbip_host usbip_core pkcs8_key_parser sg crypto_user
> [191331.783245]  CR2: 0000000000200010
> [191331.783259]  ---[ end trace 0000000000000000 ]---
> [191331.783277]  RIP: 0010:rb_first+0x13/0x30
> [191331.783289]  Code: 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90
> 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 07 48 85 c0 74 18 0f 1f 40 00 48
> 89 c2 <48> 8b 40 10 48 85 c0 75 f4 48 89 d0 c3 cc cc cc cc 31 d2 eb f4
> 0f
> [191331.783299]  RSP: 0018:ffffa95621d3f8d8 EFLAGS: 00010206
> [191331.783311]  RAX: 0000000000200000 RBX: ffffa95621d3f8f8 RCX:
> 0000000000000000
> [191331.783322]  RDX: 0000000000200000 RSI: 0000000000000000 RDI:
> ffff8f299ec75708
> [191331.783334]  RBP: ffffa95621d3f908 R08: 0000000000000001 R09:
> 000000000066001a
> [191331.783344]  R10: 000000000066001a R11: 0000000000000000 R12:
> ffff8f2585b77800
> [191331.783357]  R13: ffff8f299ec75468 R14: ffff8f299ec75710 R15:
> ffff8f297376c688
> [191331.783369]  FS:  00007f30f4a6db80(0000) GS:ffff8f2d1ec80000(0000)
> knlGS:0000000000000000
> [191331.783379]  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [191331.783389]  CR2: 0000000000200010 CR3: 000000011c868003 CR4:
> 00000000003706f0
> [191331.783399]  DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [191331.783407]  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [191331.783417]  note: umount[37604] exited with irqs disabled
> [191331.783430]  note: umount[37604] exited with preempt_count 1
> [191332.973053]  systemd-shutdown[1]: Syncing filesystems and block
> devices.
> [191362.979489]  systemd-shutdown[1]: Syncing filesystems and block
> devices - timed out, issuing SIGKILL to PID 37638.
> [191362.979558]  systemd-shutdown[1]: Sending SIGTERM to remaining
> processes...
>=20
>=20
> --=20
> Gene
>=20

> [   10.652496]  Linux version 6.11.8-stable-1 (linux-stable@saplinux) (gc=
c (GCC) 14.2.1 20240910, GNU ld (GNU Binutils) 2.43.0) #21 SMP PREEMPT_DYNA=
MIC Thu, 14 Nov 2024 14:03:00 +0000
> [   10.652516]  Command line: initrd=3D\initrd-linux-stable.img root=3D"U=
UID=3D7a1f5906-150c-4657-a3ea-b27c948b76b0" rw audit=3D0 nowatchdog
> [   10.652524]  BIOS-provided physical RAM map:
> [   10.652529]  BIOS-e820: [mem 0x0000000000000000-0x0000000000057fff] us=
able
> [   10.652534]  BIOS-e820: [mem 0x0000000000058000-0x0000000000058fff] re=
served
> [   10.652539]  BIOS-e820: [mem 0x0000000000059000-0x000000000009efff] us=
able
> [   10.652548]  BIOS-e820: [mem 0x000000000009f000-0x00000000000fffff] re=
served
> [   10.652553]  BIOS-e820: [mem 0x0000000000100000-0x0000000023eeefff] us=
able
> [   10.652558]  BIOS-e820: [mem 0x0000000023eef000-0x0000000023eeffff] AC=
PI NVS
> [   10.652563]  BIOS-e820: [mem 0x0000000023ef0000-0x0000000023ef0fff] re=
served
> [   10.652568]  BIOS-e820: [mem 0x0000000023ef1000-0x000000002c44bfff] us=
able
> [   10.652572]  BIOS-e820: [mem 0x000000002c44c000-0x000000002de65fff] re=
served
> [   10.652577]  BIOS-e820: [mem 0x000000002de66000-0x000000002deb7fff] AC=
PI data
> [   10.652583]  BIOS-e820: [mem 0x000000002deb8000-0x000000002e36cfff] AC=
PI NVS
> [   10.652589]  BIOS-e820: [mem 0x000000002e36d000-0x000000002effefff] re=
served
> [   10.652594]  BIOS-e820: [mem 0x000000002efff000-0x000000002effffff] us=
able
> [   10.652602]  BIOS-e820: [mem 0x000000002f000000-0x000000003fffffff] re=
served
> [   10.652607]  BIOS-e820: [mem 0x00000000e0000000-0x00000000efffffff] re=
served
> [   10.652612]  BIOS-e820: [mem 0x00000000fe000000-0x00000000fe010fff] re=
served
> [   10.652617]  BIOS-e820: [mem 0x00000000fec00000-0x00000000fec00fff] re=
served
> [   10.652622]  BIOS-e820: [mem 0x00000000fed00000-0x00000000fed00fff] re=
served
> [   10.652627]  BIOS-e820: [mem 0x00000000fee00000-0x00000000fee00fff] re=
served
> [   10.652632]  BIOS-e820: [mem 0x00000000ff000000-0x00000000ffffffff] re=
served
> [   10.652636]  BIOS-e820: [mem 0x0000000100000000-0x00000008beffffff] us=
able
> [   10.652641]  NX (Execute Disable) protection: active
> [   10.652646]  APIC: Static calls initialized
> [   10.652651]  e820: update [mem 0x20379018-0x2038d257] usable =3D=3D> u=
sable
> [   10.652656]  e820: update [mem 0x20368018-0x20378057] usable =3D=3D> u=
sable
> [   10.652661]  e820: update [mem 0x20357018-0x20367e57] usable =3D=3D> u=
sable
> [   10.652666]  extended physical RAM map:
> [   10.652671]  reserve setup_data: [mem 0x0000000000000000-0x00000000000=
57fff] usable
> [   10.652678]  reserve setup_data: [mem 0x0000000000058000-0x00000000000=
58fff] reserved
> [   10.652683]  reserve setup_data: [mem 0x0000000000059000-0x00000000000=
9efff] usable
> [   10.652687]  reserve setup_data: [mem 0x000000000009f000-0x00000000000=
fffff] reserved
> [   10.652692]  reserve setup_data: [mem 0x0000000000100000-0x00000000203=
57017] usable
> [   10.652697]  reserve setup_data: [mem 0x0000000020357018-0x00000000203=
67e57] usable
> [   10.652702]  reserve setup_data: [mem 0x0000000020367e58-0x00000000203=
68017] usable
> [   10.652707]  reserve setup_data: [mem 0x0000000020368018-0x00000000203=
78057] usable
> [   10.652712]  reserve setup_data: [mem 0x0000000020378058-0x00000000203=
79017] usable
> [   10.652717]  reserve setup_data: [mem 0x0000000020379018-0x00000000203=
8d257] usable
> [   10.652724]  reserve setup_data: [mem 0x000000002038d258-0x0000000023e=
eefff] usable
> [   10.652729]  reserve setup_data: [mem 0x0000000023eef000-0x0000000023e=
effff] ACPI NVS
> [   10.652734]  reserve setup_data: [mem 0x0000000023ef0000-0x0000000023e=
f0fff] reserved
> [   10.652739]  reserve setup_data: [mem 0x0000000023ef1000-0x000000002c4=
4bfff] usable
> [   10.652744]  reserve setup_data: [mem 0x000000002c44c000-0x000000002de=
65fff] reserved
> [   10.652749]  reserve setup_data: [mem 0x000000002de66000-0x000000002de=
b7fff] ACPI data
> [   10.652754]  reserve setup_data: [mem 0x000000002deb8000-0x000000002e3=
6cfff] ACPI NVS
> [   10.652759]  reserve setup_data: [mem 0x000000002e36d000-0x000000002ef=
fefff] reserved
> [   10.652764]  reserve setup_data: [mem 0x000000002efff000-0x000000002ef=
fffff] usable
> [   10.652769]  reserve setup_data: [mem 0x000000002f000000-0x000000003ff=
fffff] reserved
> [   10.652775]  reserve setup_data: [mem 0x00000000e0000000-0x00000000eff=
fffff] reserved
> [   10.652780]  reserve setup_data: [mem 0x00000000fe000000-0x00000000fe0=
10fff] reserved
> [   10.652785]  reserve setup_data: [mem 0x00000000fec00000-0x00000000fec=
00fff] reserved
> [   10.652790]  reserve setup_data: [mem 0x00000000fed00000-0x00000000fed=
00fff] reserved
> [   10.652795]  reserve setup_data: [mem 0x00000000fee00000-0x00000000fee=
00fff] reserved
> [   10.652799]  reserve setup_data: [mem 0x00000000ff000000-0x00000000fff=
fffff] reserved
> [   10.652804]  reserve setup_data: [mem 0x0000000100000000-0x00000008bef=
fffff] usable
> [   10.652809]  efi: EFI v2.7 by American Megatrends
> [   10.652814]  efi: ACPI 2.0=3D0x2dfb9000 ACPI=3D0x2dfb9000 SMBIOS=3D0x2=
edc4000 SMBIOS 3.0=3D0x2edc3000 MEMATTR=3D0x2af87018 ESRT=3D0x2ae02618 RNG=
=3D0x2deb7018 INITRD=3D0x23ff7b18=20
> [   10.652819]  random: crng init done
> [   10.652824]  efi: Remove mem83: MMIO range=3D[0xe0000000-0xefffffff] (=
256MB) from e820 map
> [   10.652829]  e820: remove [mem 0xe0000000-0xefffffff] reserved
> [   10.652834]  efi: Not removing mem84: MMIO range=3D[0xfe000000-0xfe010=
fff] (68KB) from e820 map
> [   10.652839]  efi: Not removing mem85: MMIO range=3D[0xfec00000-0xfec00=
fff] (4KB) from e820 map
> [   10.652844]  efi: Not removing mem86: MMIO range=3D[0xfed00000-0xfed00=
fff] (4KB) from e820 map
> [   10.652849]  efi: Not removing mem87: MMIO range=3D[0xfee00000-0xfee00=
fff] (4KB) from e820 map
> [   10.652856]  efi: Remove mem88: MMIO range=3D[0xff000000-0xffffffff] (=
16MB) from e820 map
> [   10.652860]  e820: remove [mem 0xff000000-0xffffffff] reserved
> [   10.652865]  SMBIOS 3.1.1 present.
> [   10.652870]  DMI: To Be Filled By O.E.M. To Be Filled By O.E.M./Z370 E=
xtreme4, BIOS P4.20 10/31/2019
> [   10.652875]  DMI: Memory slots populated: 2/4
> [   10.652880]  tsc: Detected 3700.000 MHz processor
> [   10.652885]  tsc: Detected 3699.850 MHz TSC
> [   10.652890]  e820: update [mem 0x00000000-0x00000fff] usable =3D=3D> r=
eserved
> [   10.652896]  e820: remove [mem 0x000a0000-0x000fffff] usable
> [   10.652901]  last_pfn =3D 0x8bf000 max_arch_pfn =3D 0x400000000
> [   10.652906]  MTRR map: 4 entries (3 fixed + 1 variable; max 23), built=
 from 10 variable MTRRs
> [   10.652911]  x86/PAT: Configuration [0-7]: WB  WC  UC- UC  WB  WP  UC-=
 WT =20
> [   10.652916]  last_pfn =3D 0x2f000 max_arch_pfn =3D 0x400000000
> [   10.652921]  found SMP MP-table at [mem 0x000fdcf0-0x000fdcff]
> [   10.652928]  esrt: Reserving ESRT space from 0x000000002ae02618 to 0x0=
00000002ae02650.
> [   10.652933]  e820: update [mem 0x2ae02000-0x2ae02fff] usable =3D=3D> r=
eserved
> [   10.652938]  Using GB pages for direct mapping
> [   10.652943]  Secure boot disabled
> [   10.652948]  RAMDISK: [mem 0x2038e000-0x218e3fff]
> [   10.652953]  ACPI: Early table checksum verification disabled
> [   10.652959]  ACPI: RSDP 0x000000002DFB9000 000024 (v02 ALASKA)
> [   10.652964]  ACPI: XSDT 0x000000002DFB90A8 0000D4 (v01 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.652969]  ACPI: FACP 0x000000002DFE56E0 000114 (v06 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.652974]  ACPI: DSDT 0x000000002DFB9218 02C4C3 (v02 ALASKA A M I   =
 01072009 INTL 20160422)
> [   10.652979]  ACPI: FACS 0x000000002E36CF00 000040
> [   10.652984]  ACPI: APIC 0x000000002DFE57F8 0000F4 (v03 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.652991]  ACPI: FPDT 0x000000002DFE58F0 000044 (v01 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.652996]  ACPI: FIDT 0x000000002DFE5938 00009C (v01 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.653006]  ACPI: MCFG 0x000000002DFE59D8 00003C (v01 ALASKA A M I   =
 01072009 MSFT 00000097)
> [   10.653016]  ACPI: SSDT 0x000000002DFE5A18 0003A3 (v01 SataRe SataTabl=
 00001000 INTL 20160422)
> [   10.653021]  ACPI: SSDT 0x000000002DFE5DC0 003165 (v02 SaSsdt SaSsdt  =
 00003000 INTL 20160422)
> [   10.653026]  ACPI: SSDT 0x000000002DFE8F28 0025F4 (v02 PegSsd PegSsdt =
 00001000 INTL 20160422)
> [   10.653031]  ACPI: HPET 0x000000002DFEB520 000038 (v01 INTEL  KBL     =
 00000001 MSFT 0000005F)
> [   10.653036]  ACPI: SSDT 0x000000002DFEB558 000CB8 (v02 INTEL  xh_kbl_s=
 00000000 INTL 20160422)
> [   10.653041]  ACPI: UEFI 0x000000002DFEC210 000048 (v01 ALASKA A M I   =
 00000002      01000013)
> [   10.653046]  ACPI: SSDT 0x000000002DFEC258 0017AE (v02 CpuRef CpuSsdt =
 00003000 INTL 20160422)
> [   10.653051]  ACPI: AAFT 0x000000002DFEDA08 0004B9 (v01 ALASKA OEMAAFT =
 01072009 MSFT 00000097)
> [   10.653059]  ACPI: LPIT 0x000000002DFEDEC8 000094 (v01 INTEL  KBL     =
 00000000 MSFT 0000005F)
> [   10.653064]  ACPI: SSDT 0x000000002DFEDF60 000141 (v02 INTEL  HdaDsp  =
 00000000 INTL 20160422)
> [   10.653069]  ACPI: SSDT 0x000000002DFEE0A8 000517 (v02 INTEL  TbtTypeC=
 00000000 INTL 20160422)
> [   10.653074]  ACPI: SSDT 0x000000002DFEE5C0 0002E9 (v02 INTEL  Wwan    =
 00000001 INTL 20160422)
> [   10.653079]  ACPI: DBGP 0x000000002DFEE8B0 000034 (v01 INTEL          =
 00000002 MSFT 0000005F)
> [   10.653084]  ACPI: DBG2 0x000000002DFEE8E8 000054 (v00 INTEL          =
 00000002 MSFT 0000005F)
> [   10.653089]  ACPI: DMAR 0x000000002DFEE940 0000A8 (v01 INTEL  EDK2    =
 00000001 INTL 00000001)
> [   10.653094]  ACPI: BGRT 0x000000002DFEE9E8 000038 (v01 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.653099]  ACPI: WSMT 0x000000002DFEEA20 000028 (v01 ALASKA A M I   =
 01072009 AMI  00010013)
> [   10.653104]  ACPI: Reserving FACP table memory at [mem 0x2dfe56e0-0x2d=
fe57f3]
> [   10.653109]  ACPI: Reserving DSDT table memory at [mem 0x2dfb9218-0x2d=
fe56da]
> [   10.653116]  ACPI: Reserving FACS table memory at [mem 0x2e36cf00-0x2e=
36cf3f]
> [   10.653121]  ACPI: Reserving APIC table memory at [mem 0x2dfe57f8-0x2d=
fe58eb]
> [   10.653126]  ACPI: Reserving FPDT table memory at [mem 0x2dfe58f0-0x2d=
fe5933]
> [   10.653132]  ACPI: Reserving FIDT table memory at [mem 0x2dfe5938-0x2d=
fe59d3]
> [   10.653141]  ACPI: Reserving MCFG table memory at [mem 0x2dfe59d8-0x2d=
fe5a13]
> [   10.653146]  ACPI: Reserving SSDT table memory at [mem 0x2dfe5a18-0x2d=
fe5dba]
> [   10.653151]  ACPI: Reserving SSDT table memory at [mem 0x2dfe5dc0-0x2d=
fe8f24]
> [   10.653156]  ACPI: Reserving SSDT table memory at [mem 0x2dfe8f28-0x2d=
feb51b]
> [   10.653161]  ACPI: Reserving HPET table memory at [mem 0x2dfeb520-0x2d=
feb557]
> [   10.653166]  ACPI: Reserving SSDT table memory at [mem 0x2dfeb558-0x2d=
fec20f]
> [   10.653171]  ACPI: Reserving UEFI table memory at [mem 0x2dfec210-0x2d=
fec257]
> [   10.653176]  ACPI: Reserving SSDT table memory at [mem 0x2dfec258-0x2d=
feda05]
> [   10.653181]  ACPI: Reserving AAFT table memory at [mem 0x2dfeda08-0x2d=
fedec0]
> [   10.653186]  ACPI: Reserving LPIT table memory at [mem 0x2dfedec8-0x2d=
fedf5b]
> [   10.653193]  ACPI: Reserving SSDT table memory at [mem 0x2dfedf60-0x2d=
fee0a0]
> [   10.653198]  ACPI: Reserving SSDT table memory at [mem 0x2dfee0a8-0x2d=
fee5be]
> [   10.653203]  ACPI: Reserving SSDT table memory at [mem 0x2dfee5c0-0x2d=
fee8a8]
> [   10.653208]  ACPI: Reserving DBGP table memory at [mem 0x2dfee8b0-0x2d=
fee8e3]
> [   10.653213]  ACPI: Reserving DBG2 table memory at [mem 0x2dfee8e8-0x2d=
fee93b]
> [   10.653218]  ACPI: Reserving DMAR table memory at [mem 0x2dfee940-0x2d=
fee9e7]
> [   10.653223]  ACPI: Reserving BGRT table memory at [mem 0x2dfee9e8-0x2d=
feea1f]
> [   10.653228]  ACPI: Reserving WSMT table memory at [mem 0x2dfeea20-0x2d=
feea47]
> [   10.653233]  No NUMA configuration found
> [   10.653240]  Faking a node at [mem 0x0000000000000000-0x00000008beffff=
ff]
> [   10.653245]  NODE_DATA(0) allocated [mem 0x8beffb000-0x8beffffff]
> [   10.653250]  Zone ranges:
> [   10.653255]    DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [   10.653260]    DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [   10.653265]    Normal   [mem 0x0000000100000000-0x00000008beffffff]
> [   10.653270]    Device   empty
> [   10.653275]  Movable zone start for each node
> [   10.653280]  Early memory node ranges
> [   10.653286]    node   0: [mem 0x0000000000001000-0x0000000000057fff]
> [   10.653291]    node   0: [mem 0x0000000000059000-0x000000000009efff]
> [   10.653296]    node   0: [mem 0x0000000000100000-0x0000000023eeefff]
> [   10.653301]    node   0: [mem 0x0000000023ef1000-0x000000002c44bfff]
> [   10.653307]    node   0: [mem 0x000000002efff000-0x000000002effffff]
> [   10.653312]    node   0: [mem 0x0000000100000000-0x00000008beffffff]
> [   10.653317]  Initmem setup node 0 [mem 0x0000000000001000-0x00000008be=
ffffff]
> [   10.653322]  On node 0, zone DMA: 1 pages in unavailable ranges
> [   10.653328]  On node 0, zone DMA: 1 pages in unavailable ranges
> [   10.653333]  On node 0, zone DMA: 97 pages in unavailable ranges
> [   10.653338]  On node 0, zone DMA32: 2 pages in unavailable ranges
> [   10.653343]  On node 0, zone DMA32: 11187 pages in unavailable ranges
> [   10.653348]  On node 0, zone Normal: 4096 pages in unavailable ranges
> [   10.653353]  On node 0, zone Normal: 4096 pages in unavailable ranges
> [   10.653358]  Reserving Intel graphics memory at [mem 0x30000000-0x3fff=
ffff]
> [   10.653363]  ACPI: PM-Timer IO Port: 0x1808
> [   10.653369]  ACPI: LAPIC_NMI (acpi_id[0x01] high edge lint[0x1])
> [   10.653375]  ACPI: LAPIC_NMI (acpi_id[0x02] high edge lint[0x1])
> [   10.653380]  ACPI: LAPIC_NMI (acpi_id[0x03] high edge lint[0x1])
> [   10.653385]  ACPI: LAPIC_NMI (acpi_id[0x04] high edge lint[0x1])
> [   10.653390]  ACPI: LAPIC_NMI (acpi_id[0x05] high edge lint[0x1])
> [   10.653395]  ACPI: LAPIC_NMI (acpi_id[0x06] high edge lint[0x1])
> [   10.653400]  ACPI: LAPIC_NMI (acpi_id[0x07] high edge lint[0x1])
> [   10.653405]  ACPI: LAPIC_NMI (acpi_id[0x08] high edge lint[0x1])
> [   10.653410]  ACPI: LAPIC_NMI (acpi_id[0x09] high edge lint[0x1])
> [   10.653415]  ACPI: LAPIC_NMI (acpi_id[0x0a] high edge lint[0x1])
> [   10.653420]  ACPI: LAPIC_NMI (acpi_id[0x0b] high edge lint[0x1])
> [   10.653425]  ACPI: LAPIC_NMI (acpi_id[0x0c] high edge lint[0x1])
> [   10.653430]  IOAPIC[0]: apic_id 2, version 32, address 0xfec00000, GSI=
 0-119
> [   10.653436]  ACPI: INT_SRC_OVR (bus 0 bus_irq 0 global_irq 2 dfl dfl)
> [   10.653442]  ACPI: INT_SRC_OVR (bus 0 bus_irq 9 global_irq 9 high leve=
l)
> [   10.653447]  ACPI: Using ACPI (MADT) for SMP configuration information
> [   10.653452]  ACPI: HPET id: 0x8086a201 base: 0xfed00000
> [   10.653457]  e820: update [mem 0x289e9000-0x28a29fff] usable =3D=3D> r=
eserved
> [   10.653462]  TSC deadline timer available
> [   10.653467]  CPU topo: Max. logical packages:   1
> [   10.653472]  CPU topo: Max. logical dies:       1
> [   10.653477]  CPU topo: Max. dies per package:   1
> [   10.653482]  CPU topo: Max. threads per core:   2
> [   10.653487]  CPU topo: Num. cores per package:     6
> [   10.653493]  CPU topo: Num. threads per package:  12
> [   10.653500]  CPU topo: Allowing 12 present CPUs plus 0 hotplug CPUs
> [   10.653505]  PM: hibernation: Registered nosave memory: [mem 0x0000000=
0-0x00000fff]
> [   10.653510]  PM: hibernation: Registered nosave memory: [mem 0x0005800=
0-0x00058fff]
> [   10.653515]  PM: hibernation: Registered nosave memory: [mem 0x0009f00=
0-0x000fffff]
> [   10.653520]  PM: hibernation: Registered nosave memory: [mem 0x2035700=
0-0x20357fff]
> [   10.653525]  PM: hibernation: Registered nosave memory: [mem 0x2036700=
0-0x20367fff]
> [   10.653530]  PM: hibernation: Registered nosave memory: [mem 0x2036800=
0-0x20368fff]
> [   10.653535]  PM: hibernation: Registered nosave memory: [mem 0x2037800=
0-0x20378fff]
> [   10.653540]  PM: hibernation: Registered nosave memory: [mem 0x2037900=
0-0x20379fff]
> [   10.653545]  PM: hibernation: Registered nosave memory: [mem 0x2038d00=
0-0x2038dfff]
> [   10.653550]  PM: hibernation: Registered nosave memory: [mem 0x23eef00=
0-0x23eeffff]
> [   10.653557]  PM: hibernation: Registered nosave memory: [mem 0x23ef000=
0-0x23ef0fff]
> [   10.653562]  PM: hibernation: Registered nosave memory: [mem 0x289e900=
0-0x28a29fff]
> [   10.653567]  PM: hibernation: Registered nosave memory: [mem 0x2ae0200=
0-0x2ae02fff]
> [   10.653572]  PM: hibernation: Registered nosave memory: [mem 0x2c44c00=
0-0x2de65fff]
> [   10.653577]  PM: hibernation: Registered nosave memory: [mem 0x2de6600=
0-0x2deb7fff]
> [   10.653582]  PM: hibernation: Registered nosave memory: [mem 0x2deb800=
0-0x2e36cfff]
> [   10.653587]  PM: hibernation: Registered nosave memory: [mem 0x2e36d00=
0-0x2effefff]
> [   10.653592]  PM: hibernation: Registered nosave memory: [mem 0x2f00000=
0-0x3fffffff]
> [   10.653597]  PM: hibernation: Registered nosave memory: [mem 0x4000000=
0-0xfdffffff]
> [   10.653602]  PM: hibernation: Registered nosave memory: [mem 0xfe00000=
0-0xfe010fff]
> [   10.653607]  PM: hibernation: Registered nosave memory: [mem 0xfe01100=
0-0xfebfffff]
> [   10.653612]  PM: hibernation: Registered nosave memory: [mem 0xfec0000=
0-0xfec00fff]
> [   10.653619]  PM: hibernation: Registered nosave memory: [mem 0xfec0100=
0-0xfecfffff]
> [   10.653624]  PM: hibernation: Registered nosave memory: [mem 0xfed0000=
0-0xfed00fff]
> [   10.653629]  PM: hibernation: Registered nosave memory: [mem 0xfed0100=
0-0xfedfffff]
> [   10.653634]  PM: hibernation: Registered nosave memory: [mem 0xfee0000=
0-0xfee00fff]
> [   10.653639]  PM: hibernation: Registered nosave memory: [mem 0xfee0100=
0-0xffffffff]
> [   10.653644]  [mem 0x40000000-0xfdffffff] available for PCI devices
> [   10.653649]  Booting paravirtualized kernel on bare hardware
> [   10.653654]  clocksource: refined-jiffies: mask: 0xffffffff max_cycles=
: 0xffffffff, max_idle_ns: 1910969940391419 ns
> [   10.653659]  setup_percpu: NR_CPUS:320 nr_cpumask_bits:12 nr_cpu_ids:1=
2 nr_node_ids:1
> [   10.653665]  percpu: Embedded 66 pages/cpu s233472 r8192 d28672 u524288
> [   10.653670]  pcpu-alloc: s233472 r8192 d28672 u524288 alloc=3D1*2097152
> [   10.653675]  pcpu-alloc: [0] 00 01 02 03 [0] 04 05 06 07=20
> [   10.653681]  pcpu-alloc: [0] 08 09 10 11=20
> [   10.653687]  Kernel command line: initrd=3D\initrd-linux-stable.img ro=
ot=3D"UUID=3D7a1f5906-150c-4657-a3ea-b27c948b76b0" rw audit=3D0 nowatchdog
> [   10.653692]  audit: disabled (until reboot)
> [   10.653697]  Dentry cache hash table entries: 4194304 (order: 13, 3355=
4432 bytes, linear)
> [   10.653702]  Inode-cache hash table entries: 2097152 (order: 12, 16777=
216 bytes, linear)
> [   10.653707]  Fallback order for Node 0: 0=20
> [   10.653712]  Built 1 zonelists, mobility grouping on.  Total pages: 83=
03592
> [   10.653717]  Policy zone: Normal
> [   10.653723]  mem auto-init: stack:all(zero), heap alloc:on, heap free:=
off
> [   10.653728]  software IO TLB: area num 16.
> [   10.653733]  SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0, CPUs=3D1=
2, Nodes=3D1
> [   10.653739]  Kernel/User page tables isolation: enabled
> [   10.653745]  ftrace: allocating 50756 entries in 199 pages
> [   10.653750]  ftrace: allocated 199 pages with 5 groups
> [   10.653755]  Dynamic Preempt: full
> [   10.653760]  rcu: Preemptible hierarchical RCU implementation.
> [   10.653765]  rcu:         RCU restricting CPUs from NR_CPUS=3D320 to n=
r_cpu_ids=3D12.
> [   10.653770]  rcu:         RCU priority boosting: priority 1 delay 500 =
ms.
> [   10.653776]          Trampoline variant of Tasks RCU enabled.
> [   10.653781]          Rude variant of Tasks RCU enabled.
> [   10.653786]          Tracing variant of Tasks RCU enabled.
> [   10.653791]  rcu: RCU calculated value of scheduler-enlistment delay i=
s 100 jiffies.
> [   10.653796]  rcu: Adjusting geometry for rcu_fanout_leaf=3D16, nr_cpu_=
ids=3D12
> [   10.653801]  RCU Tasks: Setting shift to 4 and lim to 1 rcu_task_cb_ad=
just=3D1 rcu_task_cpu_ids=3D12.
> [   10.653808]  RCU Tasks Rude: Setting shift to 4 and lim to 1 rcu_task_=
cb_adjust=3D1 rcu_task_cpu_ids=3D12.
> [   10.653813]  RCU Tasks Trace: Setting shift to 4 and lim to 1 rcu_task=
_cb_adjust=3D1 rcu_task_cpu_ids=3D12.
> [   10.653818]  NR_IRQS: 20736, nr_irqs: 2152, preallocated irqs: 16
> [   10.653823]  rcu: srcu_init: Setting srcu_struct sizes based on conten=
tion.
> [   10.653828]  kfence: initialized - using 2097152 bytes for 255 objects=
 at 0x(____ptrval____)-0x(____ptrval____)
> [   10.653833]  Console: colour dummy device 80x25
> [   10.653839]  printk: legacy console [tty0] enabled
> [   10.653844]  ACPI: Core revision 20240322
> [   10.653849]  clocksource: hpet: mask: 0xffffffff max_cycles: 0xfffffff=
f, max_idle_ns: 79635855245 ns
> [   10.653854]  APIC: Switch to symmetric I/O mode setup
> [   10.653859]  DMAR: Host address width 39
> [   10.653865]  DMAR: DRHD base: 0x000000fed90000 flags: 0x0
> [   10.653871]  DMAR: dmar0: reg_base_addr fed90000 ver 1:0 cap 1c0000c40=
660462 ecap 19e2ff0505e
> [   10.653876]  DMAR: DRHD base: 0x000000fed91000 flags: 0x1
> [   10.653881]  DMAR: dmar1: reg_base_addr fed91000 ver 1:0 cap d2008c406=
60462 ecap f050da
> [   10.653886]  DMAR: RMRR base: 0x0000002eb56000 end: 0x0000002ed9ffff
> [   10.653891]  DMAR: RMRR base: 0x0000002f800000 end: 0x0000003fffffff
> [   10.653896]  DMAR-IR: IOAPIC id 2 under DRHD base  0xfed91000 IOMMU 1
> [   10.653901]  DMAR-IR: HPET id 0 under DRHD base 0xfed91000
> [   10.653906]  DMAR-IR: Queued invalidation will be enabled to support x=
2apic and Intr-remapping.
> [   10.653911]  DMAR-IR: Enabled IRQ remapping in x2apic mode
> [   10.653916]  x2apic enabled
> [   10.653921]  APIC: Switched APIC routing to: cluster x2apic
> [   10.653928]  ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=
=3D-1
> [   10.653933]  clocksource: tsc-early: mask: 0xffffffffffffffff max_cycl=
es: 0x6aa99074b1c, max_idle_ns: 881590506587 ns
> [   10.653938]  Calibrating delay loop (skipped), value calculated using =
timer frequency.. 7399.70 BogoMIPS (lpj=3D3699850)
> [   10.653944]  x86/cpu: SGX disabled by BIOS.
> [   10.653949]  CPU0: Thermal monitoring enabled (TM1)
> [   10.653954]  Last level iTLB entries: 4KB 64, 2MB 8, 4MB 8
> [   10.653959]  Last level dTLB entries: 4KB 64, 2MB 0, 4MB 0, 1GB 4
> [   10.653964]  process: using mwait in idle threads
> [   10.653969]  Spectre V1 : Mitigation: usercopy/swapgs barriers and __u=
ser pointer sanitization
> [   10.653975]  Spectre V2 : Mitigation: IBRS
> [   10.653980]  Spectre V2 : Spectre v2 / SpectreRSB mitigation: Filling =
RSB on context switch
> [   10.653986]  Spectre V2 : Spectre v2 / SpectreRSB : Filling RSB on VME=
XIT
> [   10.653991]  RETBleed: Mitigation: IBRS
> [   10.653996]  Spectre V2 : mitigation: Enabling conditional Indirect Br=
anch Prediction Barrier
> [   10.654007]  Spectre V2 : User space: Mitigation: STIBP via prctl
> [   10.654013]  Speculative Store Bypass: Mitigation: Speculative Store B=
ypass disabled via prctl
> [   10.654018]  MDS: Mitigation: Clear CPU buffers
> [   10.654023]  TAA: Mitigation: TSX disabled
> [   10.654028]  MMIO Stale Data: Mitigation: Clear CPU buffers
> [   10.654033]  SRBDS: Mitigation: Microcode
> [   10.654038]  GDS: Mitigation: Microcode
> [   10.654043]  x86/fpu: Supporting XSAVE feature 0x001: 'x87 floating po=
int registers'
> [   10.654049]  x86/fpu: Supporting XSAVE feature 0x002: 'SSE registers'
> [   10.654055]  x86/fpu: Supporting XSAVE feature 0x004: 'AVX registers'
> [   10.654060]  x86/fpu: Supporting XSAVE feature 0x008: 'MPX bounds regi=
sters'
> [   10.654065]  x86/fpu: Supporting XSAVE feature 0x010: 'MPX CSR'
> [   10.654070]  x86/fpu: xstate_offset[2]:  576, xstate_sizes[2]:  256
> [   10.654075]  x86/fpu: xstate_offset[3]:  832, xstate_sizes[3]:   64
> [   10.654081]  x86/fpu: xstate_offset[4]:  896, xstate_sizes[4]:   64
> [   10.654086]  x86/fpu: Enabled xstate features 0x1f, context size is 96=
0 bytes, using 'compacted' format.
> [   10.654091]  Freeing SMP alternatives memory: 40K
> [   10.654096]  pid_max: default: 32768 minimum: 301
> [   10.654101]  LSM: initializing lsm=3Dcapability,landlock,lockdown,yama=
,bpf
> [   10.654106]  landlock: Up and running.
> [   10.654111]  Yama: becoming mindful.
> [   10.654118]  LSM support for eBPF active
> [   10.654123]  Mount-cache hash table entries: 65536 (order: 7, 524288 b=
ytes, linear)
> [   10.654128]  Mountpoint-cache hash table entries: 65536 (order: 7, 524=
288 bytes, linear)
> [   10.654133]  smpboot: CPU0: Intel(R) Core(TM) i7-8700K CPU @ 3.70GHz (=
family: 0x6, model: 0x9e, stepping: 0xa)
> [   10.654138]  Performance Events: PEBS fmt3+, Skylake events, 32-deep L=
BR, full-width counters, Intel PMU driver.
> [   10.654143]  ... version:                4
> [   10.654148]  ... bit width:              48
> [   10.654153]  ... generic registers:      4
> [   10.654159]  ... value mask:             0000ffffffffffff
> [   10.654164]  ... max period:             00007fffffffffff
> [   10.654169]  ... fixed-purpose events:   3
> [   10.654174]  ... event mask:             000000070000000f
> [   10.654180]  signal: max sigframe size: 2032
> [   10.654185]  Estimated ratio of average max frequency by base frequenc=
y (times 1024): 1217
> [   10.654191]  rcu: Hierarchical SRCU implementation.
> [   10.654196]  rcu:         Max phase no-delay instances is 400.
> [   10.654201]  Timer migration: 2 hierarchy levels; 8 children per group=
; 2 crossnode level
> [   10.654206]  smp: Bringing up secondary CPUs ...
> [   10.654211]  smpboot: x86: Booting SMP configuration:
> [   10.654216]  .... node  #0, CPUs:        #1  #2  #3  #4  #5  #6  #7  #=
8  #9 #10 #11
> [   10.654222]  MDS CPU bug present and SMT on, data leak possible. See h=
ttps://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/mds.html for more=
 details.
> [   10.654228]  MMIO Stale Data CPU bug present and SMT on, data leak pos=
sible. See https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/proce=
ssor_mmio_stale_data.html for more details.
> [   10.654233]  smp: Brought up 1 node, 12 CPUs
> [   10.654239]  smpboot: Total of 12 processors activated (88796.40 BogoM=
IPS)
> [   10.654245]  Memory: 32488580K/33214368K available (18432K kernel code=
, 2217K rwdata, 13492K rodata, 3456K init, 3388K bss, 711440K reserved, 0K =
cma-reserved)
> [   10.654250]  devtmpfs: initialized
> [   10.654255]  x86/mm: Memory block size: 128MB
> [   10.654260]  ACPI: PM: Registering ACPI NVS region [mem 0x23eef000-0x2=
3eeffff] (4096 bytes)
> [   10.654265]  ACPI: PM: Registering ACPI NVS region [mem 0x2deb8000-0x2=
e36cfff] (4935680 bytes)
> [   10.654270]  clocksource: jiffies: mask: 0xffffffff max_cycles: 0xffff=
ffff, max_idle_ns: 1911260446275000 ns
> [   10.654275]  futex hash table entries: 4096 (order: 6, 262144 bytes, l=
inear)
> [   10.654280]  pinctrl core: initialized pinctrl subsystem
> [   10.654285]  PM: RTC time: 11:04:41, date: 2024-11-15
> [   10.654290]  NET: Registered PF_NETLINK/PF_ROUTE protocol family
> [   10.654297]  DMA: preallocated 4096 KiB GFP_KERNEL pool for atomic all=
ocations
> [   10.654302]  DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA pool for at=
omic allocations
> [   10.654307]  DMA: preallocated 4096 KiB GFP_KERNEL|GFP_DMA32 pool for =
atomic allocations
> [   10.654313]  thermal_sys: Registered thermal governor 'fair_share'
> [   10.654318]  thermal_sys: Registered thermal governor 'bang_bang'
> [   10.654323]  thermal_sys: Registered thermal governor 'step_wise'
> [   10.654328]  thermal_sys: Registered thermal governor 'user_space'
> [   10.654333]  thermal_sys: Registered thermal governor 'power_allocator'
> [   10.654338]  cpuidle: using governor ladder
> [   10.654343]  cpuidle: using governor menu
> [   10.654348]  ACPI FADT declares the system doesn't support PCIe ASPM, =
so disable it
> [   10.654353]  acpiphp: ACPI Hot Plug PCI Controller Driver version: 0.5
> [   10.654360]  PCI: ECAM [mem 0xe0000000-0xefffffff] (base 0xe0000000) f=
or domain 0000 [bus 00-ff]
> [   10.654365]  PCI: Using configuration type 1 for base access
> [   10.654377]  kprobes: kprobe jump-optimization is enabled. All kprobes=
 are optimized if possible.
> [   10.654384]  HugeTLB: registered 1.00 GiB page size, pre-allocated 0 p=
ages
> [   10.654389]  HugeTLB: 16380 KiB vmemmap can be freed for a 1.00 GiB pa=
ge
> [   10.654394]  HugeTLB: registered 2.00 MiB page size, pre-allocated 0 p=
ages
> [   10.654399]  HugeTLB: 28 KiB vmemmap can be freed for a 2.00 MiB page
> [   10.654406]  ACPI: Added _OSI(Module Device)
> [   10.654411]  ACPI: Added _OSI(Processor Device)
> [   10.654416]  ACPI: Added _OSI(3.0 _SCP Extensions)
> [   10.654421]  ACPI: Added _OSI(Processor Aggregator Device)
> [   10.654425]  ACPI: 9 ACPI AML tables successfully acquired and loaded
> [   10.654431]  ACPI: Dynamic OEM Table Load:
> [   10.654436]  ACPI: SSDT 0xFFFF8F258179E800 0003FF (v02 PmRef  Cpu0Cst =
 00003001 INTL 20160422)
> [   10.654441]  ACPI: Dynamic OEM Table Load:
> [   10.654446]  ACPI: SSDT 0xFFFF8F2581796800 00077A (v02 PmRef  Cpu0Ist =
 00003000 INTL 20160422)
> [   10.654451]  ACPI: Dynamic OEM Table Load:
> [   10.654456]  ACPI: SSDT 0xFFFF8F25817A3000 000D14 (v02 PmRef  ApIst   =
 00003000 INTL 20160422)
> [   10.654461]  ACPI: Dynamic OEM Table Load:
> [   10.654466]  ACPI: SSDT 0xFFFF8F258179D000 000317 (v02 PmRef  ApHwp   =
 00003000 INTL 20160422)
> [   10.654471]  ACPI: Dynamic OEM Table Load:
> [   10.654478]  ACPI: SSDT 0xFFFF8F2581798400 00030A (v02 PmRef  ApCst   =
 00003000 INTL 20160422)
> [   10.654483]  ACPI: Interpreter enabled
> [   10.654488]  ACPI: PM: (supports S0 S3 S4 S5)
> [   10.654493]  ACPI: Using IOAPIC for interrupt routing
> [   10.654500]  PCI: Using host bridge windows from ACPI; if necessary, u=
se "pci=3Dnocrs" and report a bug
> [   10.654505]  PCI: Using E820 reservations for host bridge windows
> [   10.654510]  ACPI: Enabled 8 GPEs in block 00 to 7F
> [   10.654515]  ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-fe])
> [   10.654645]  acpi PNP0A08:00: _OSC: OS supports [ExtendedConfig ASPM C=
lockPM Segments MSI EDR HPX-Type3]
> [   10.654739]  acpi PNP0A08:00: _OSC: platform does not support [PCIeHot=
plug SHPCHotplug PME AER]
> [   10.654825]  acpi PNP0A08:00: _OSC: OS now controls [PCIeCapability LT=
R DPC]
> [   10.654909]  acpi PNP0A08:00: FADT indicates ASPM is unsupported, usin=
g BIOS configuration
> [   10.654917]  PCI host bridge to bus 0000:00
> [   10.655015]  pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 win=
dow]
> [   10.655099]  pci_bus 0000:00: root bus resource [io  0x0d00-0xffff win=
dow]
> [   10.655192]  pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000b=
ffff window]
> [   10.655280]  pci_bus 0000:00: root bus resource [mem 0x40000000-0xdfff=
ffff window]
> [   10.655372]  pci_bus 0000:00: root bus resource [mem 0xfd000000-0xfe7f=
ffff window]
> [   10.655457]  pci_bus 0000:00: root bus resource [bus 00-fe]
> [   10.655555]  pci 0000:00:00.0: [8086:3ec2] type 00 class 0x060000 conv=
entional PCI endpoint
> [   10.655652]  pci 0000:00:01.0: [8086:1901] type 01 class 0x060400 PCIe=
 Root Port
> [   10.655744]  pci 0000:00:01.0: PCI bridge to [bus 01]
> [   10.655831]  pci 0000:00:01.0: PME# supported from D0 D3hot D3cold
> [   10.655923]  pci 0000:00:01.1: [8086:1905] type 01 class 0x060400 PCIe=
 Root Port
> [   10.656019]  pci 0000:00:01.1: PCI bridge to [bus 02]
> [   10.656128]  pci 0000:00:01.1:   bridge window [mem 0xdc300000-0xdc3ff=
fff]
> [   10.656234]  pci 0000:00:01.1: PME# supported from D0 D3hot D3cold
> [   10.656345]  pci 0000:00:02.0: [8086:3e92] type 00 class 0x030000 PCIe=
 Root Complex Integrated Endpoint
> [   10.656451]  pci 0000:00:02.0: BAR 0 [mem 0xdb000000-0xdbffffff 64bit]
> [   10.656556]  pci 0000:00:02.0: BAR 2 [mem 0x50000000-0x5fffffff 64bit =
pref]
> [   10.656664]  pci 0000:00:02.0: BAR 4 [io  0xf000-0xf03f]
> [   10.656769]  pci 0000:00:02.0: Video device with shadowed ROM at [mem =
0x000c0000-0x000dffff]
> [   10.656879]  pci 0000:00:14.0: [8086:a2af] type 00 class 0x0c0330 conv=
entional PCI endpoint
> [   10.656986]  pci 0000:00:14.0: BAR 0 [mem 0xdc430000-0xdc43ffff 64bit]
> [   10.657100]  pci 0000:00:14.0: PME# supported from D3hot D3cold
> [   10.657212]  pci 0000:00:14.2: [8086:a2b1] type 00 class 0x118000 conv=
entional PCI endpoint
> [   10.657318]  pci 0000:00:14.2: BAR 0 [mem 0xdc44e000-0xdc44efff 64bit]
> [   10.657429]  pci 0000:00:16.0: [8086:a2ba] type 00 class 0x078000 conv=
entional PCI endpoint
> [   10.657534]  pci 0000:00:16.0: BAR 0 [mem 0xdc44d000-0xdc44dfff 64bit]
> [   10.657644]  pci 0000:00:16.0: PME# supported from D3hot
> [   10.657760]  pci 0000:00:17.0: [8086:a282] type 00 class 0x010601 conv=
entional PCI endpoint
> [   10.657868]  pci 0000:00:17.0: BAR 0 [mem 0xdc448000-0xdc449fff]
> [   10.657974]  pci 0000:00:17.0: BAR 1 [mem 0xdc44c000-0xdc44c0ff]
> [   10.658111]  pci 0000:00:17.0: BAR 2 [io  0xf090-0xf097]
> [   10.658202]  pci 0000:00:17.0: BAR 3 [io  0xf080-0xf083]
> [   10.658288]  pci 0000:00:17.0: BAR 4 [io  0xf060-0xf07f]
> [   10.658399]  pci 0000:00:17.0: BAR 5 [mem 0xdc44b000-0xdc44b7ff]
> [   10.658516]  pci 0000:00:17.0: PME# supported from D3hot
> [   10.658614]  pci 0000:00:1b.0: [8086:a2e7] type 01 class 0x060400 PCIe=
 Root Port
> [   10.658701]  pci 0000:00:1b.0: PCI bridge to [bus 03]
> [   10.658787]  pci 0000:00:1b.0:   bridge window [mem 0xdc200000-0xdc2ff=
fff]
> [   10.658872]  pci 0000:00:1b.0: PME# supported from D0 D3hot D3cold
> [   10.658964]  pci 0000:00:1b.4: [8086:a2eb] type 01 class 0x060400 PCIe=
 Root Port
> [   10.659056]  pci 0000:00:1b.4: PCI bridge to [bus 04-6e]
> [   10.659143]  pci 0000:00:1b.4:   bridge window [mem 0xac000000-0xda0ff=
fff]
> [   10.659229]  pci 0000:00:1b.4:   bridge window [mem 0x60000000-0xa9fff=
fff 64bit pref]
> [   10.659314]  pci 0000:00:1b.4: PME# supported from D0 D3hot D3cold
> [   10.659406]  pci 0000:00:1c.0: [8086:a290] type 01 class 0x060400 PCIe=
 Root Port
> [   10.659497]  pci 0000:00:1c.0: PCI bridge to [bus 6f]
> [   10.659583]  pci 0000:00:1c.0: PME# supported from D0 D3hot D3cold
> [   10.659674]  pci 0000:00:1c.1: [8086:a291] type 01 class 0x060400 PCIe=
 Root Port
> [   10.659761]  pci 0000:00:1c.1: PCI bridge to [bus 70]
> [   10.659846]  pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
> [   10.659931]  pci 0000:00:1c.1:   bridge window [mem 0xdc100000-0xdc1ff=
fff]
> [   10.660029]  pci 0000:00:1c.1: PME# supported from D0 D3hot D3cold
> [   10.660143]  pci 0000:00:1c.4: [8086:a294] type 01 class 0x060400 PCIe=
 Root Port
> [   10.660254]  pci 0000:00:1c.4: PCI bridge to [bus 71]
> [   10.660359]  pci 0000:00:1c.4:   bridge window [mem 0xdc000000-0xdc0ff=
fff]
> [   10.660464]  pci 0000:00:1c.4: PME# supported from D0 D3hot D3cold
> [   10.660579]  pci 0000:00:1c.7: [8086:a297] type 01 class 0x060400 PCIe=
 Root Port
> [   10.660686]  pci 0000:00:1c.7: PCI bridge to [bus 72]
> [   10.660792]  pci 0000:00:1c.7: PME# supported from D0 D3hot D3cold
> [   10.660904]  pci 0000:00:1d.0: [8086:a298] type 01 class 0x060400 PCIe=
 Root Port
> [   10.661017]  pci 0000:00:1d.0: PCI bridge to [bus 73]
> [   10.661126]  pci 0000:00:1d.0: PME# supported from D0 D3hot D3cold
> [   10.661242]  pci 0000:00:1f.0: [8086:a2c9] type 00 class 0x060100 conv=
entional PCI endpoint
> [   10.661356]  pci 0000:00:1f.2: [8086:a2a1] type 00 class 0x058000 conv=
entional PCI endpoint
> [   10.661462]  pci 0000:00:1f.2: BAR 0 [mem 0xdc444000-0xdc447fff]
> [   10.661573]  pci 0000:00:1f.3: [8086:a2f0] type 00 class 0x040300 conv=
entional PCI endpoint
> [   10.661680]  pci 0000:00:1f.3: BAR 0 [mem 0xdc440000-0xdc443fff 64bit]
> [   10.661786]  pci 0000:00:1f.3: BAR 4 [mem 0xdc420000-0xdc42ffff 64bit]
> [   10.661891]  pci 0000:00:1f.3: PME# supported from D3hot D3cold
> [   10.662012]  pci 0000:00:1f.4: [8086:a2a3] type 00 class 0x0c0500 conv=
entional PCI endpoint
> [   10.662106]  pci 0000:00:1f.4: BAR 0 [mem 0xdc44a000-0xdc44a0ff 64bit]
> [   10.662192]  pci 0000:00:1f.4: BAR 4 [io  0xf040-0xf05f]
> [   10.662287]  pci 0000:00:1f.6: [8086:15b8] type 00 class 0x020000 conv=
entional PCI endpoint
> [   10.662374]  pci 0000:00:1f.6: BAR 0 [mem 0xdc400000-0xdc41ffff]
> [   10.662459]  pci 0000:00:1f.6: PME# supported from D0 D3hot D3cold
> [   10.662546]  pci 0000:00:01.0: PCI bridge to [bus 01]
> [   10.662645]  pci 0000:02:00.0: [1b21:1166] type 00 class 0x010601 PCIe=
 Endpoint
> [   10.662736]  pci 0000:02:00.0: BAR 0 [mem 0xdc382000-0xdc383fff]
> [   10.662827]  pci 0000:02:00.0: BAR 5 [mem 0xdc380000-0xdc381fff]
> [   10.662917]  pci 0000:02:00.0: ROM [mem 0xdc300000-0xdc37ffff pref]
> [   10.663080]  pci 0000:02:00.0: PME# supported from D0 D3hot D3cold
> [   10.663171]  pci 0000:00:01.1: PCI bridge to [bus 02]
> [   10.663266]  pci 0000:03:00.0: [15b7:5017] type 00 class 0x010802 PCIe=
 Endpoint
> [   10.663358]  pci 0000:03:00.0: BAR 0 [mem 0xdc200000-0xdc203fff 64bit]
> [   10.663447]  pci 0000:03:00.0: 31.504 Gb/s available PCIe bandwidth, l=
imited by 8.0 GT/s PCIe x4 link at 0000:00:1b.0 (capable of 63.012 Gb/s wit=
h 16.0 GT/s PCIe x4 link)
> [   10.663533]  pci 0000:00:1b.0: PCI bridge to [bus 03]
> [   10.663621]  pci 0000:00:1b.4: PCI bridge to [bus 04-6e]
> [   10.663709]  pci 0000:00:1c.0: PCI bridge to [bus 6f]
> [   10.663805]  pci 0000:70:00.0: [1b21:0612] type 00 class 0x010601 PCIe=
 Legacy Endpoint
> [   10.663896]  pci 0000:70:00.0: BAR 0 [io  0xe050-0xe057]
> [   10.663989]  pci 0000:70:00.0: BAR 1 [io  0xe040-0xe043]
> [   10.664083]  pci 0000:70:00.0: BAR 2 [io  0xe030-0xe037]
> [   10.664173]  pci 0000:70:00.0: BAR 3 [io  0xe020-0xe023]
> [   10.664261]  pci 0000:70:00.0: BAR 4 [io  0xe000-0xe01f]
> [   10.664350]  pci 0000:70:00.0: BAR 5 [mem 0xdc100000-0xdc1001ff]
> [   10.664439]  pci 0000:00:1c.1: PCI bridge to [bus 70]
> [   10.664534]  pci 0000:71:00.0: [1b21:2142] type 00 class 0x0c0330 PCIe=
 Legacy Endpoint
> [   10.664623]  pci 0000:71:00.0: BAR 0 [mem 0xdc000000-0xdc007fff 64bit]
> [   10.664711]  pci 0000:71:00.0: enabling Extended Tags
> [   10.664799]  pci 0000:71:00.0: PME# supported from D0
> [   10.664890]  pci 0000:00:1c.4: PCI bridge to [bus 71]
> [   10.664977]  pci 0000:00:1c.7: PCI bridge to [bus 72]
> [   10.665066]  pci 0000:00:1d.0: PCI bridge to [bus 73]
> [   10.665074]  ACPI: PCI: Interrupt link LNKA configured for IRQ 11
> [   10.665079]  ACPI: PCI: Interrupt link LNKB configured for IRQ 10
> [   10.665085]  ACPI: PCI: Interrupt link LNKC configured for IRQ 11
> [   10.665090]  ACPI: PCI: Interrupt link LNKD configured for IRQ 11
> [   10.665095]  ACPI: PCI: Interrupt link LNKE configured for IRQ 11
> [   10.665100]  ACPI: PCI: Interrupt link LNKF configured for IRQ 11
> [   10.665105]  ACPI: PCI: Interrupt link LNKG configured for IRQ 11
> [   10.665110]  ACPI: PCI: Interrupt link LNKH configured for IRQ 11
> [   10.665116]  iommu: Default domain type: Translated
> [   10.665123]  iommu: DMA domain TLB invalidation policy: lazy mode
> [   10.665129]  SCSI subsystem initialized
> [   10.665134]  libata version 3.00 loaded.
> [   10.665139]  ACPI: bus type USB registered
> [   10.665144]  usbcore: registered new interface driver usbfs
> [   10.665149]  usbcore: registered new interface driver hub
> [   10.665154]  usbcore: registered new device driver usb
> [   10.665159]  pps_core: LinuxPPS API ver. 1 registered
> [   10.665164]  pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodol=
fo Giometti <giometti@linux.it>
> [   10.665169]  PTP clock support registered
> [   10.665174]  EDAC MC: Ver: 3.0.0
> [   10.665179]  efivars: Registered efivars operations
> [   10.665184]  NetLabel: Initializing
> [   10.665190]  NetLabel:  domain hash size =3D 128
> [   10.665195]  NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
> [   10.665200]  NetLabel:  unlabeled traffic allowed by default
> [   10.665207]  mctp: management component transport protocol core
> [   10.665212]  NET: Registered PF_MCTP protocol family
> [   10.665218]  PCI: Using ACPI for IRQ routing
> [   10.665223]  PCI: pci_cache_line_size set to 64 bytes
> [   10.665228]  e820: reserve RAM buffer [mem 0x00058000-0x0005ffff]
> [   10.665233]  e820: reserve RAM buffer [mem 0x0009f000-0x0009ffff]
> [   10.665239]  e820: reserve RAM buffer [mem 0x20357018-0x23ffffff]
> [   10.665244]  e820: reserve RAM buffer [mem 0x20368018-0x23ffffff]
> [   10.665249]  e820: reserve RAM buffer [mem 0x20379018-0x23ffffff]
> [   10.665254]  e820: reserve RAM buffer [mem 0x23eef000-0x23ffffff]
> [   10.665261]  e820: reserve RAM buffer [mem 0x289e9000-0x2bffffff]
> [   10.665268]  e820: reserve RAM buffer [mem 0x2ae02000-0x2bffffff]
> [   10.665273]  e820: reserve RAM buffer [mem 0x2c44c000-0x2fffffff]
> [   10.665278]  e820: reserve RAM buffer [mem 0x2f000000-0x2fffffff]
> [   10.665283]  e820: reserve RAM buffer [mem 0x8bf000000-0x8bfffffff]
> [   10.665368]  pci 0000:00:02.0: vgaarb: setting as boot VGA device
> [   10.665454]  pci 0000:00:02.0: vgaarb: bridge control possible
> [   10.665539]  pci 0000:00:02.0: vgaarb: VGA device added: decodes=3Dio+=
mem,owns=3Dio+mem,locks=3Dnone
> [   10.665547]  vgaarb: loaded
> [   10.665552]  hpet0: at MMIO 0xfed00000, IRQs 2, 8, 0, 0, 0, 0, 0, 0
> [   10.665557]  hpet0: 8 comparators, 64-bit 24.000000 MHz counter
> [   10.665562]  clocksource: Switched to clocksource tsc-early
> [   10.665567]  VFS: Disk quotas dquot_6.6.0
> [   10.665573]  VFS: Dquot-cache hash table entries: 512 (order 0, 4096 b=
ytes)
> [   10.665580]  pnp: PnP ACPI init
> [   10.665669]  system 00:00: [io  0x0280-0x028f] has been reserved
> [   10.665752]  system 00:00: [io  0x0290-0x029f] has been reserved
> [   10.665832]  system 00:00: [io  0x02a0-0x02af] has been reserved
> [   10.665911]  system 00:00: [io  0x02b0-0x02bf] has been reserved
> [   10.665999]  pnp 00:01: [dma 0 disabled]
> [   10.666101]  system 00:02: [io  0x0680-0x069f] has been reserved
> [   10.666184]  system 00:02: [io  0xffff] has been reserved
> [   10.666264]  system 00:02: [io  0xffff] has been reserved
> [   10.666346]  system 00:02: [io  0xffff] has been reserved
> [   10.666424]  system 00:02: [io  0x1800-0x18fe] has been reserved
> [   10.666503]  system 00:02: [io  0x164e-0x164f] has been reserved
> [   10.666587]  system 00:03: [io  0x0800-0x087f] has been reserved
> [   10.666673]  system 00:05: [io  0x1854-0x1857] has been reserved
> [   10.666758]  system 00:06: [mem 0xfed10000-0xfed17fff] has been reserv=
ed
> [   10.666838]  system 00:06: [mem 0xfed18000-0xfed18fff] has been reserv=
ed
> [   10.666917]  system 00:06: [mem 0xfed19000-0xfed19fff] has been reserv=
ed
> [   10.666996]  system 00:06: [mem 0xe0000000-0xefffffff] has been reserv=
ed
> [   10.667087]  system 00:06: [mem 0xfed20000-0xfed3ffff] has been reserv=
ed
> [   10.667166]  system 00:06: [mem 0xfed90000-0xfed93fff] could not be re=
served
> [   10.667245]  system 00:06: [mem 0xfed45000-0xfed8ffff] has been reserv=
ed
> [   10.667323]  system 00:06: [mem 0xff000000-0xffffffff] has been reserv=
ed
> [   10.667401]  system 00:06: [mem 0xfee00000-0xfeefffff] could not be re=
served
> [   10.667479]  system 00:06: [mem 0xdffe0000-0xdfffffff] has been reserv=
ed
> [   10.667564]  system 00:07: [mem 0xfd000000-0xfdabffff] has been reserv=
ed
> [   10.667643]  system 00:07: [mem 0xfdad0000-0xfdadffff] has been reserv=
ed
> [   10.667722]  system 00:07: [mem 0xfdb00000-0xfdffffff] has been reserv=
ed
> [   10.667800]  system 00:07: [mem 0xfe000000-0xfe01ffff] could not be re=
served
> [   10.667881]  system 00:07: [mem 0xfe036000-0xfe03bfff] has been reserv=
ed
> [   10.667959]  system 00:07: [mem 0xfe03d000-0xfe3fffff] has been reserv=
ed
> [   10.668063]  system 00:07: [mem 0xfe410000-0xfe7fffff] has been reserv=
ed
> [   10.668163]  system 00:08: [io  0xff00-0xfffe] has been reserved
> [   10.668257]  system 00:09: [mem 0xfdaf0000-0xfdafffff] has been reserv=
ed
> [   10.668338]  system 00:09: [mem 0xfdae0000-0xfdaeffff] has been reserv=
ed
> [   10.668421]  system 00:09: [mem 0xfdac0000-0xfdacffff] has been reserv=
ed
> [   10.668429]  pnp: PnP ACPI: found 10 devices
> [   10.668435]  clocksource: acpi_pm: mask: 0xffffff max_cycles: 0xffffff=
, max_idle_ns: 2085701024 ns
> [   10.668440]  NET: Registered PF_INET protocol family
> [   10.668448]  IP idents hash table entries: 262144 (order: 9, 2097152 b=
ytes, linear)
> [   10.668453]  tcp_listen_portaddr_hash hash table entries: 16384 (order=
: 6, 262144 bytes, linear)
> [   10.668458]  Table-perturb hash table entries: 65536 (order: 6, 262144=
 bytes, linear)
> [   10.668464]  TCP established hash table entries: 262144 (order: 9, 209=
7152 bytes, linear)
> [   10.668469]  TCP bind hash table entries: 65536 (order: 9, 2097152 byt=
es, linear)
> [   10.668475]  TCP: Hash tables configured (established 262144 bind 6553=
6)
> [   10.668480]  MPTCP token hash table entries: 32768 (order: 7, 786432 b=
ytes, linear)
> [   10.668485]  UDP hash table entries: 16384 (order: 7, 524288 bytes, li=
near)
> [   10.668490]  UDP-Lite hash table entries: 16384 (order: 7, 524288 byte=
s, linear)
> [   10.668495]  NET: Registered PF_UNIX/PF_LOCAL protocol family
> [   10.668501]  NET: Registered PF_XDP protocol family
> [   10.668591]  pci 0000:00:1b.4: bridge window [io  0x1000-0x0fff] to [b=
us 04-6e] add_size 1000
> [   10.668679]  pci 0000:00:1b.4: bridge window [io  0x2000-0x2fff]: assi=
gned
> [   10.668767]  pci 0000:00:01.0: PCI bridge to [bus 01]
> [   10.668855]  pci 0000:00:01.1: PCI bridge to [bus 02]
> [   10.668944]  pci 0000:00:01.1:   bridge window [mem 0xdc300000-0xdc3ff=
fff]
> [   10.669062]  pci 0000:00:1b.0: PCI bridge to [bus 03]
> [   10.669164]  pci 0000:00:1b.0:   bridge window [mem 0xdc200000-0xdc2ff=
fff]
> [   10.669265]  pci 0000:00:1b.4: PCI bridge to [bus 04-6e]
> [   10.669369]  pci 0000:00:1b.4:   bridge window [io  0x2000-0x2fff]
> [   10.669469]  pci 0000:00:1b.4:   bridge window [mem 0xac000000-0xda0ff=
fff]
> [   10.669570]  pci 0000:00:1b.4:   bridge window [mem 0x60000000-0xa9fff=
fff 64bit pref]
> [   10.669672]  pci 0000:00:1c.0: PCI bridge to [bus 6f]
> [   10.669775]  pci 0000:00:1c.1: PCI bridge to [bus 70]
> [   10.669876]  pci 0000:00:1c.1:   bridge window [io  0xe000-0xefff]
> [   10.669981]  pci 0000:00:1c.1:   bridge window [mem 0xdc100000-0xdc1ff=
fff]
> [   10.670091]  pci 0000:00:1c.4: PCI bridge to [bus 71]
> [   10.670193]  pci 0000:00:1c.4:   bridge window [mem 0xdc000000-0xdc0ff=
fff]
> [   10.670295]  pci 0000:00:1c.7: PCI bridge to [bus 72]
> [   10.670396]  pci 0000:00:1d.0: PCI bridge to [bus 73]
> [   10.670489]  pci_bus 0000:00: resource 4 [io  0x0000-0x0cf7 window]
> [   10.670578]  pci_bus 0000:00: resource 5 [io  0x0d00-0xffff window]
> [   10.670669]  pci_bus 0000:00: resource 6 [mem 0x000a0000-0x000bffff wi=
ndow]
> [   10.670758]  pci_bus 0000:00: resource 7 [mem 0x40000000-0xdfffffff wi=
ndow]
> [   10.670847]  pci_bus 0000:00: resource 8 [mem 0xfd000000-0xfe7fffff wi=
ndow]
> [   10.670950]  pci_bus 0000:02: resource 1 [mem 0xdc300000-0xdc3fffff]
> [   10.671051]  pci_bus 0000:03: resource 1 [mem 0xdc200000-0xdc2fffff]
> [   10.671137]  pci_bus 0000:04: resource 0 [io  0x2000-0x2fff]
> [   10.671215]  pci_bus 0000:04: resource 1 [mem 0xac000000-0xda0fffff]
> [   10.671292]  pci_bus 0000:04: resource 2 [mem 0x60000000-0xa9ffffff 64=
bit pref]
> [   10.671375]  pci_bus 0000:70: resource 0 [io  0xe000-0xefff]
> [   10.671452]  pci_bus 0000:70: resource 1 [mem 0xdc100000-0xdc1fffff]
> [   10.671537]  pci_bus 0000:71: resource 1 [mem 0xdc000000-0xdc0fffff]
> [   10.671624]  pci 0000:00:14.0: quirk_usb_early_handoff+0x0/0x740 took =
16313 usecs
> [   10.671712]  pci 0000:71:00.0: PME# does not work under D0, disabling =
it
> [   10.671720]  PCI: CLS 64 bytes, default 64
> [   10.671733]  pci 0000:00:1f.1: [8086:a2a0] type 00 class 0x058000 conv=
entional PCI endpoint
> [   10.671744]  pci 0000:00:1f.1: BAR 0 [mem 0xfd000000-0xfdffffff 64bit]
> [   10.671750]  PCI-DMA: Using software bounce buffering for IO (SWIOTLB)
> [   10.671756]  software IO TLB: mapped [mem 0x000000001c357000-0x0000000=
020357000] (64MB)
> [   10.671761]  Trying to unpack rootfs image as initramfs...
> [   10.671766]  Initialise system trusted keyrings
> [   10.671771]  Key type blacklist registered
> [   10.671778]  workingset: timestamp_bits=3D41 max_order=3D23 bucket_ord=
er=3D0
> [   10.671783]  zbud: loaded
> [   10.671788]  integrity: Platform Keyring initialized
> [   10.671793]  integrity: Machine keyring initialized
> [   10.671798]  Key type asymmetric registered
> [   10.671804]  Asymmetric key parser 'x509' registered
> [   10.671808]  Block layer SCSI generic (bsg) driver version 0.4 loaded =
(major 242)
> [   10.671814]  io scheduler mq-deadline registered
> [   10.671818]  io scheduler kyber registered
> [   10.671823]  io scheduler bfq registered
> [   10.671828]  shpchp: Standard Hot Plug PCI Controller Driver version: =
0.4
> [   10.671833]  input: Sleep Button as /devices/LNXSYSTM:00/LNXSYBUS:00/P=
NP0C0E:00/input/input0
> [   10.671840]  ACPI: button: Sleep Button [SLPB]
> [   10.671845]  input: Power Button as /devices/LNXSYSTM:00/LNXSYBUS:00/P=
NP0C0C:00/input/input1
> [   10.671850]  ACPI: button: Power Button [PWRB]
> [   10.671854]  input: Power Button as /devices/LNXSYSTM:00/LNXPWRBN:00/i=
nput/input2
> [   10.671859]  ACPI: button: Power Button [PWRF]
> [   10.671864]  Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [   10.671869]  00:01: ttyS0 at I/O 0x3f8 (irq =3D 4, base_baud =3D 11520=
0) is a 16550A
> [   10.671874]  Non-volatile memory driver v1.3
> [   10.671879]  Linux agpgart interface v0.103
> [   10.671884]  ACPI: bus type drm_connector registered
> [   10.671970]  ahci 0000:00:17.0: version 3.0
> [   10.672060]  ahci 0000:00:17.0: AHCI vers 0001.0301, 32 command slots,=
 6 Gbps, SATA mode
> [   10.672147]  ahci 0000:00:17.0: 2/2 ports implemented (port mask 0xc)
> [   10.672232]  ahci 0000:00:17.0: flags: 64bit ncq sntf led clo only pio=
 slum part ems deso sadm sds apst=20
> [   10.672328]  scsi host0: ahci
> [   10.672418]  scsi host1: ahci
> [   10.672508]  scsi host2: ahci
> [   10.672599]  scsi host3: ahci
> [   10.672607]  ata1: DUMMY
> [   10.672612]  ata2: DUMMY
> [   10.672617]  ata3: SATA max UDMA/133 abar m2048@0xdc44b000 port 0xdc44=
b200 irq 129 lpm-pol 3
> [   10.672625]  ata4: SATA max UDMA/133 abar m2048@0xdc44b000 port 0xdc44=
b280 irq 129 lpm-pol 3
> [   10.672711]  ahci 0000:02:00.0: SSS flag set, parallel bus scan disabl=
ed
> [   10.672797]  ahci 0000:02:00.0: AHCI vers 0001.0301, 32 command slots,=
 6 Gbps, SATA mode
> [   10.672883]  ahci 0000:02:00.0: 30/32 ports implemented (port mask 0xf=
fffff3f)
> [   10.672968]  ahci 0000:02:00.0: flags: 64bit ncq sntf stag pm led only=
 pio sxs deso sadm sds apst=20
> [   10.673065]  scsi host4: ahci
> [   10.673159]  scsi host5: ahci
> [   10.673253]  scsi host6: ahci
> [   10.673347]  scsi host7: ahci
> [   10.673445]  scsi host8: ahci
> [   10.673538]  scsi host9: ahci
> [   10.673630]  scsi host10: ahci
> [   10.673724]  scsi host11: ahci
> [   10.673824]  scsi host12: ahci
> [   10.673917]  scsi host13: ahci
> [   10.674013]  scsi host14: ahci
> [   10.674110]  scsi host15: ahci
> [   10.674202]  scsi host16: ahci
> [   10.674294]  scsi host17: ahci
> [   10.674389]  scsi host18: ahci
> [   10.674481]  scsi host19: ahci
> [   10.674572]  scsi host20: ahci
> [   10.674664]  scsi host21: ahci
> [   10.674757]  scsi host22: ahci
> [   10.674854]  scsi host23: ahci
> [   10.674946]  scsi host24: ahci
> [   10.675046]  scsi host25: ahci
> [   10.675139]  scsi host26: ahci
> [   10.675231]  scsi host27: ahci
> [   10.675326]  scsi host28: ahci
> [   10.675418]  scsi host29: ahci
> [   10.675510]  scsi host30: ahci
> [   10.675606]  scsi host31: ahci
> [   10.675699]  scsi host32: ahci
> [   10.675792]  scsi host33: ahci
> [   10.675884]  scsi host34: ahci
> [   10.675977]  scsi host35: ahci
> [   10.675985]  ata5: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc38=
0100 irq 130 lpm-pol 0
> [   10.675990]  ata6: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc38=
0180 irq 130 lpm-pol 0
> [   10.675995]  ata7: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc38=
0200 irq 130 lpm-pol 0
> [   10.676015]  ata8: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc38=
0280 irq 130 lpm-pol 0
> [   10.676020]  ata9: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc38=
0300 irq 130 lpm-pol 0
> [   10.676025]  ata10: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80380 irq 130 lpm-pol 0
> [   10.676030]  ata11: DUMMY
> [   10.676035]  ata12: DUMMY
> [   10.676043]  ata13: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80500 irq 130 lpm-pol 0
> [   10.676048]  ata14: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80580 irq 130 lpm-pol 0
> [   10.676053]  ata15: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80600 irq 130 lpm-pol 0
> [   10.676058]  ata16: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80680 irq 130 lpm-pol 0
> [   10.676063]  ata17: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80700 irq 130 lpm-pol 0
> [   10.676068]  ata18: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80780 irq 130 lpm-pol 0
> [   10.676075]  ata19: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80800 irq 130 lpm-pol 0
> [   10.676080]  ata20: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80880 irq 130 lpm-pol 0
> [   10.676085]  ata21: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80900 irq 130 lpm-pol 0
> [   10.676091]  ata22: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80980 irq 130 lpm-pol 0
> [   10.676095]  ata23: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80a00 irq 130 lpm-pol 0
> [   10.676100]  ata24: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80a80 irq 130 lpm-pol 0
> [   10.676106]  ata25: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80b00 irq 130 lpm-pol 0
> [   10.676110]  ata26: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80b80 irq 130 lpm-pol 0
> [   10.676115]  ata27: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80c00 irq 130 lpm-pol 0
> [   10.676121]  ata28: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80c80 irq 130 lpm-pol 0
> [   10.676126]  ata29: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80d00 irq 130 lpm-pol 0
> [   10.676134]  ata30: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80d80 irq 130 lpm-pol 0
> [   10.676139]  ata31: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80e00 irq 130 lpm-pol 0
> [   10.676144]  ata32: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80e80 irq 130 lpm-pol 0
> [   10.676149]  ata33: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80f00 irq 130 lpm-pol 0
> [   10.676154]  ata34: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
80f80 irq 130 lpm-pol 0
> [   10.676159]  ata35: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
81000 irq 130 lpm-pol 0
> [   10.676164]  ata36: SATA max UDMA/133 abar m8192@0xdc380000 port 0xdc3=
81080 irq 130 lpm-pol 0
> [   10.676255]  ahci 0000:70:00.0: SSS flag set, parallel bus scan disabl=
ed
> [   10.676341]  ahci 0000:70:00.0: AHCI vers 0001.0200, 32 command slots,=
 6 Gbps, SATA mode
> [   10.676426]  ahci 0000:70:00.0: 2/2 ports implemented (port mask 0x3)
> [   10.676511]  ahci 0000:70:00.0: flags: 64bit ncq sntf stag led clo pmp=
 pio slum part ccc=20
> [   10.676607]  scsi host36: ahci
> [   10.676703]  scsi host37: ahci
> [   10.676711]  ata37: SATA max UDMA/133 abar m512@0xdc100000 port 0xdc10=
0100 irq 131 lpm-pol 3
> [   10.676716]  ata38: SATA max UDMA/133 abar m512@0xdc100000 port 0xdc10=
0180 irq 131 lpm-pol 3
> [   10.676721]  usbcore: registered new interface driver usbserial_generic
> [   10.676727]  usbserial: USB Serial support registered for generic
> [   10.676809]  rtc_cmos 00:04: RTC can wake from S4
> [   10.676886]  rtc_cmos 00:04: registered as rtc0
> [   10.676962]  rtc_cmos 00:04: setting system clock to 2024-11-15T11:04:=
41 UTC (1731668681)
> [   10.677046]  rtc_cmos 00:04: alarms up to one month, y3k, 242 bytes nv=
ram
> [   10.677057]  intel_pstate: Intel P-state driver initializing
> [   10.677062]  intel_pstate: Disabling energy efficiency optimization
> [   10.677067]  intel_pstate: HWP enabled
> [   10.677072]  ledtrig-cpu: registered to indicate activity on CPUs
> [   10.677077]  [drm] Initialized simpledrm 1.0.0 for simple-framebuffer.=
0 on minor 0
> [   10.677082]  Console: switching to colour frame buffer device 240x67
> [   10.677172]  simple-framebuffer simple-framebuffer.0: [drm] fb0: simpl=
edrmdrmfb frame buffer device
> [   10.677180]  hid: raw HID events driver (C) Jiri Kosina
> [   10.677185]  drop_monitor: Initializing network drop monitor service
> [   10.677190]  Initializing XFRM netlink socket
> [   10.677198]  NET: Registered PF_INET6 protocol family
> [   10.677203]  Freeing initrd memory: 21848K
> [   10.677208]  Segment Routing with IPv6
> [   10.677212]  RPL Segment Routing with IPv6
> [   10.677217]  In-situ OAM (IOAM) with IPv6
> [   10.677222]  NET: Registered PF_PACKET protocol family
> [   10.677227]  ENERGY_PERF_BIAS: Set to 'normal', was 'performance'
> [   10.677232]  microcode: Current revision: 0x000000f8
> [   10.677237]  microcode: Updated early from: 0x000000c6
> [   10.677242]  IPI shorthand broadcast: enabled
> [   10.677247]  sched_clock: Marking stable (451001012, 3407192)->(459204=
123, -4795919)
> [   10.677252]  registered taskstats version 1
> [   10.677259]  Loading compiled-in X.509 certificates
> [   10.677264]  Loaded X.509 cert 'Build time autogenerated kernel key: 6=
c797ccdc5a8e30261cf2b262fec980333c55ac1'
> [   10.677269]  Loaded X.509 cert 'Local Out of tree kernel module signin=
g key: 9e2b9d061cdadaf330120fb68b87843d0c736272'
> [   10.677274]  zswap: loaded using pool zstd/zsmalloc
> [   10.677279]  Demotion targets for Node 0: null
> [   10.677284]  Key type .fscrypt registered
> [   10.677289]  Key type fscrypt-provisioning registered
> [   10.677294]  PM:   Magic number: 0:836:74
> [   10.677384]  memory memory231: hash matches
> [   10.677392]  RAS: Correctable Errors collector initialized.
> [   10.677397]  clk: Disabling unused clocks
> [   10.677404]  PM: genpd: Disabling unused power domains
> [   10.677409]  ata4: SATA link down (SStatus 4 SControl 300)
> [   10.677414]  ata3: SATA link down (SStatus 4 SControl 300)
> [   10.677419]  ata37: SATA link down (SStatus 0 SControl 300)
> [   10.677424]  ata5: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.677429]  ata5.00: ATA-10: ST8000NE0021-2EN112, EN02, max UDMA/133
> [   10.677434]  ata5.00: 15628053168 sectors, multi 0: LBA48 NCQ (depth 3=
2), AA
> [   10.677439]  ata5.00: Features: NCQ-sndrcv
> [   10.677444]  ata5.00: configured for UDMA/133
> [   10.677548]  scsi 4:0:0:0: Direct-Access     ATA      ST8000NE0021-2EN=
 EN02 PQ: 0 ANSI: 5
> [   10.677646]  sd 4:0:0:0: [sda] 15628053168 512-byte logical blocks: (8=
=2E00 TB/7.28 TiB)
> [   10.677746]  sd 4:0:0:0: [sda] 4096-byte physical blocks
> [   10.677842]  sd 4:0:0:0: [sda] Write Protect is off
> [   10.677938]  sd 4:0:0:0: [sda] Mode Sense: 00 3a 00 00
> [   10.678043]  sd 4:0:0:0: [sda] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
> [   10.678141]  sd 4:0:0:0: [sda] Preferred minimum I/O size 4096 bytes
> [   10.678148]   sda: sda1
> [   10.678243]  sd 4:0:0:0: [sda] Attached SCSI disk
> [   10.678250]  ata6: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.678256]  ata6.00: ATA-11: ST8000NE001-2M7101, EN01, max UDMA/133
> [   10.678261]  ata6.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth =
32), AA
> [   10.678268]  ata6.00: Features: NCQ-sndrcv
> [   10.678273]  ata6.00: configured for UDMA/133
> [   10.678376]  scsi 5:0:0:0: Direct-Access     ATA      ST8000NE001-2M71=
 EN01 PQ: 0 ANSI: 5
> [   10.678475]  sd 5:0:0:0: [sdb] 15628053168 512-byte logical blocks: (8=
=2E00 TB/7.28 TiB)
> [   10.678572]  sd 5:0:0:0: [sdb] 4096-byte physical blocks
> [   10.678668]  sd 5:0:0:0: [sdb] Write Protect is off
> [   10.678764]  sd 5:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> [   10.678861]  sd 5:0:0:0: [sdb] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
> [   10.678957]  sd 5:0:0:0: [sdb] Preferred minimum I/O size 4096 bytes
> [   10.678964]   sdb: sdb1
> [   10.679068]  sd 5:0:0:0: [sdb] Attached SCSI disk
> [   10.679076]  tsc: Refined TSC clocksource calibration: 3695.998 MHz
> [   10.679081]  clocksource: tsc: mask: 0xffffffffffffffff max_cycles: 0x=
6a8d2284b57, max_idle_ns: 881590451434 ns
> [   10.679086]  clocksource: Switched to clocksource tsc
> [   10.679091]  ata7: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.679096]  ata7.00: ATA-10: ST10000NE0004-1ZF101, EN02, max UDMA/133
> [   10.679101]  ata7.00: 19532873728 sectors, multi 16: LBA48 NCQ (depth =
32), AA
> [   10.679106]  ata7.00: Features: NCQ-sndrcv
> [   10.679111]  ata7.00: configured for UDMA/133
> [   10.679215]  scsi 6:0:0:0: Direct-Access     ATA      ST10000NE0004-1Z=
 EN02 PQ: 0 ANSI: 5
> [   10.679312]  sd 6:0:0:0: [sdc] 19532873728 512-byte logical blocks: (1=
0.0 TB/9.10 TiB)
> [   10.679412]  sd 6:0:0:0: [sdc] 4096-byte physical blocks
> [   10.679509]  sd 6:0:0:0: [sdc] Write Protect is off
> [   10.679604]  sd 6:0:0:0: [sdc] Mode Sense: 00 3a 00 00
> [   10.679700]  sd 6:0:0:0: [sdc] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
> [   10.679797]  sd 6:0:0:0: [sdc] Preferred minimum I/O size 4096 bytes
> [   10.679804]   sdc: sdc1 sdc2
> [   10.679897]  sd 6:0:0:0: [sdc] Attached SCSI disk
> [   10.679904]  ata8: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.679910]  ata8.00: ATA-11: ST8000VN004-2M2101, SC60, max UDMA/133
> [   10.679915]  ata8.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth =
32), AA
> [   10.679920]  ata8.00: Features: NCQ-sndrcv
> [   10.679927]  ata8.00: configured for UDMA/133
> [   10.680033]  scsi 7:0:0:0: Direct-Access     ATA      ST8000VN004-2M21=
 SC60 PQ: 0 ANSI: 5
> [   10.680131]  sd 7:0:0:0: [sdd] 15628053168 512-byte logical blocks: (8=
=2E00 TB/7.28 TiB)
> [   10.680229]  sd 7:0:0:0: [sdd] 4096-byte physical blocks
> [   10.680325]  sd 7:0:0:0: [sdd] Write Protect is off
> [   10.680423]  sd 7:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> [   10.680518]  sd 7:0:0:0: [sdd] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
> [   10.680615]  sd 7:0:0:0: [sdd] Preferred minimum I/O size 4096 bytes
> [   10.680622]   sdd: sdd1
> [   10.680716]  sd 7:0:0:0: [sdd] Attached SCSI disk
> [   10.680726]  ata9: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.680732]  ata9.00: ATA-10: ST8000NE0004-1ZF11G, EN02, max UDMA/133
> [   10.680737]  ata9.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth =
32), AA
> [   10.680742]  ata9.00: Features: NCQ-sndrcv
> [   10.680747]  ata9.00: configured for UDMA/133
> [   10.680849]  scsi 8:0:0:0: Direct-Access     ATA      ST8000NE0004-1ZF=
 EN02 PQ: 0 ANSI: 5
> [   10.680946]  sd 8:0:0:0: [sde] 15628053168 512-byte logical blocks: (8=
=2E00 TB/7.28 TiB)
> [   10.681049]  sd 8:0:0:0: [sde] 4096-byte physical blocks
> [   10.681146]  sd 8:0:0:0: [sde] Write Protect is off
> [   10.681242]  sd 8:0:0:0: [sde] Mode Sense: 00 3a 00 00
> [   10.681341]  sd 8:0:0:0: [sde] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
> [   10.681437]  sd 8:0:0:0: [sde] Preferred minimum I/O size 4096 bytes
> [   10.681444]   sde: sde1
> [   10.681537]  sd 8:0:0:0: [sde] Attached SCSI disk
> [   10.681545]  ata10: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.681550]  ata10.00: ATA-10: ST8000NE0004-1ZF11G, EN02, max UDMA/133
> [   10.681555]  ata10.00: 15628053168 sectors, multi 16: LBA48 NCQ (depth=
 32), AA
> [   10.681560]  ata10.00: Features: NCQ-sndrcv
> [   10.681565]  ata10.00: configured for UDMA/133
> [   10.681666]  scsi 9:0:0:0: Direct-Access     ATA      ST8000NE0004-1ZF=
 EN02 PQ: 0 ANSI: 5
> [   10.681763]  sd 9:0:0:0: [sdf] 15628053168 512-byte logical blocks: (8=
=2E00 TB/7.28 TiB)
> [   10.681861]  sd 9:0:0:0: [sdf] 4096-byte physical blocks
> [   10.681957]  sd 9:0:0:0: [sdf] Write Protect is off
> [   10.682061]  sd 9:0:0:0: [sdf] Mode Sense: 00 3a 00 00
> [   10.682159]  sd 9:0:0:0: [sdf] Write cache: enabled, read cache: enabl=
ed, doesn't support DPO or FUA
> [   10.682255]  sd 9:0:0:0: [sdf] Preferred minimum I/O size 4096 bytes
> [   10.682262]   sdf: sdf1
> [   10.682358]  sd 9:0:0:0: [sdf] Attached SCSI disk
> [   10.682366]  ata13: SATA link down (SStatus 0 SControl 300)
> [   10.682371]  ata14: SATA link down (SStatus 0 SControl 300)
> [   10.682376]  ata15: SATA link down (SStatus 0 SControl 300)
> [   10.682381]  ata16: SATA link down (SStatus 0 SControl 300)
> [   10.682388]  ata17: SATA link down (SStatus 0 SControl 300)
> [   10.682393]  ata18: SATA link down (SStatus 0 SControl 300)
> [   10.682399]  ata19: SATA link down (SStatus 0 SControl 300)
> [   10.682403]  ata20: SATA link down (SStatus 0 SControl 300)
> [   10.682408]  ata21: SATA link down (SStatus 0 SControl 300)
> [   10.682413]  ata22: SATA link down (SStatus 0 SControl 300)
> [   10.682418]  ata23: SATA link down (SStatus 0 SControl 300)
> [   10.682423]  ata24: SATA link down (SStatus 0 SControl 300)
> [   10.682428]  ata25: SATA link down (SStatus 0 SControl 300)
> [   10.682433]  ata26: SATA link down (SStatus 0 SControl 300)
> [   10.682438]  ata27: SATA link down (SStatus 0 SControl 300)
> [   10.682442]  ata28: SATA link down (SStatus 0 SControl 300)
> [   10.682449]  ata29: SATA link down (SStatus 0 SControl 300)
> [   10.682454]  ata30: SATA link down (SStatus 0 SControl 300)
> [   10.682459]  ata31: SATA link down (SStatus 0 SControl 300)
> [   10.682463]  ata32: SATA link down (SStatus 0 SControl 300)
> [   10.682468]  ata33: SATA link down (SStatus 0 SControl 300)
> [   10.682473]  ata34: SATA link down (SStatus 0 SControl 300)
> [   10.682478]  ata35: SATA link down (SStatus 0 SControl 300)
> [   10.682483]  ata36: SATA link down (SStatus 0 SControl 300)
> [   10.682488]  ata38: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> [   10.682493]  ata38.00: ATA-10: ST4000NE0025-2EW107, EN02, max UDMA/133
> [   10.682498]  ata38.00: 7814037168 sectors, multi 16: LBA48 NCQ (depth =
32), AA
> [   10.682504]  ata38.00: Features: NCQ-sndrcv
> [   10.682509]  ata38.00: configured for UDMA/133
> [   10.682613]  scsi 37:0:0:0: Direct-Access     ATA      ST4000NE0025-2E=
W EN02 PQ: 0 ANSI: 5
> [   10.682711]  sd 37:0:0:0: [sdg] 7814037168 512-byte logical blocks: (4=
=2E00 TB/3.64 TiB)
> [   10.682807]  sd 37:0:0:0: [sdg] 4096-byte physical blocks
> [   10.682904]  sd 37:0:0:0: [sdg] Write Protect is off
> [   10.683003]  sd 37:0:0:0: [sdg] Mode Sense: 00 3a 00 00
> [   10.683100]  sd 37:0:0:0: [sdg] Write cache: enabled, read cache: enab=
led, doesn't support DPO or FUA
> [   10.683195]  sd 37:0:0:0: [sdg] Preferred minimum I/O size 4096 bytes
> [   10.683203]   sdg: sdg1 sdg2 sdg3 sdg4 sdg5
> [   10.683297]  sd 37:0:0:0: [sdg] Attached SCSI disk
> [   10.683306]  Freeing unused decrypted memory: 2028K
> [   10.683311]  Freeing unused kernel image (initmem) memory: 3456K
> [   10.683317]  Write protecting the kernel read-only data: 32768k
> [   10.683322]  Freeing unused kernel image (rodata/data gap) memory: 844K
> [   10.683327]  x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [   10.683331]  rodata_test: all tests were successful
> [   10.683336]  x86/mm: Checking user space page tables
> [   10.683342]  x86/mm: Checked W+X mappings: passed, no W+X pages found.
> [   10.683346]  Run /init as init process
> [   10.683351]    with arguments:
> [   10.683356]      /init
> [   10.683361]    with environment:
> [   10.683368]      HOME=3D/
> [   10.683373]      TERM=3Dlinux
> [   10.683379]  systemd[1]: Successfully made /usr/ read-only.
> [   10.683387]  systemd[1]: systemd 256.8-1-arch running in system mode (=
+PAM +AUDIT -SELINUX -APPARMOR -IMA +SMACK +SECCOMP +GCRYPT +GNUTLS +OPENSS=
L +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP =
+LIBCRYPTSETUP_PLUGINS +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +TPM2 =
+BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK +XKBCOMMON +UTMP -SYSVINIT +LIBA=
RCHIVE)
> [   10.683393]  systemd[1]: Detected architecture x86-64.
> [   10.683399]  systemd[1]: Running in initrd.
> [   10.683404]  systemd[1]: Hostname set to <>.
> [   10.683409]  systemd[1]: Queued start job for default target Initrd De=
fault Target.
> [   10.683416]  systemd[1]: Started Dispatch Password Requests to Console=
 Directory Watch.
> [   10.683421]  systemd[1]: Expecting device /dev/disk/by-uuid/7a1f5906-1=
50c-4657-a3ea-b27c948b76b0...
> [   10.683428]  systemd[1]: Expecting device /dev/disk/by-uuid/F1A0-E89B.=
=2E.
> [   10.683434]  systemd[1]: Expecting device /dev/disk/by-uuid/bd94c712-f=
5f3-4f18-b1ed-b77ee42d4e0b...
> [   10.683439]  systemd[1]: Reached target Initrd /usr File System.
> [   10.683445]  systemd[1]: Reached target Path Units.
> [   10.683450]  systemd[1]: Reached target Slice Units.
> [   10.683455]  systemd[1]: Reached target Swaps.
> [   10.683461]  systemd[1]: Reached target Timer Units.
> [   10.683467]  systemd[1]: Listening on Journal Socket (/dev/log).
> [   10.683472]  systemd[1]: Listening on Journal Sockets.
> [   10.683478]  systemd[1]: Listening on udev Control Socket.
> [   10.683484]  systemd[1]: Listening on udev Kernel Socket.
> [   10.683490]  systemd[1]: Reached target Socket Units.
> [   10.683495]  systemd[1]: Starting Create List of Static Device Nodes...
> [   10.683501]  systemd[1]: Starting Journal Service...
> [   10.683506]  systemd[1]: Starting Load Kernel Modules...
> [   10.683511]  systemd[1]: Starting Virtual Console Setup...
> [   10.683517]  systemd[1]: Finished Create List of Static Device Nodes.
> [   10.683522]  systemd[1]: Starting Create Static Device Nodes in /dev g=
racefully...
> [   10.683619]  sd 4:0:0:0: Attached scsi generic sg0 type 0
> [   10.683716]  sd 5:0:0:0: Attached scsi generic sg1 type 0
> [   10.683814]  sd 6:0:0:0: Attached scsi generic sg2 type 0
> [   10.683910]  sd 7:0:0:0: Attached scsi generic sg3 type 0
> [   10.684015]  sd 8:0:0:0: Attached scsi generic sg4 type 0
> [   10.684113]  sd 9:0:0:0: Attached scsi generic sg5 type 0
> [   10.684210]  sd 37:0:0:0: Attached scsi generic sg6 type 0
> [   10.684234]  systemd-journald[294]: Collecting audit messages is disab=
led.
> [   10.684252]  systemd[1]: Finished Virtual Console Setup.
> [   10.684258]  Asymmetric key parser 'pkcs8' registered
> [   10.684265]  systemd[1]: Starting dracut ask for additional cmdline pa=
rameters...
> [   10.684271]  systemd[1]: Finished Create Static Device Nodes in /dev g=
racefully.
> [   10.684276]  usbcore: registered new device driver usbip-host
> [   10.684281]  systemd[1]: Starting Create System Users...
> [   10.684287]  systemd[1]: Finished Load Kernel Modules.
> [   10.684292]  systemd[1]: Starting Apply Kernel Variables...
> [   10.684298]  systemd[1]: Finished dracut ask for additional cmdline pa=
rameters.
> [   10.684303]  systemd[1]: Starting dracut cmdline hook...
> [   10.684308]  systemd[1]: Finished Apply Kernel Variables.
> [   10.684314]  systemd[1]: Finished Create System Users.
> [   10.684319]  systemd[1]: Starting Create Static Device Nodes in /dev...
> [   10.684325]  systemd[1]: Finished Create Static Device Nodes in /dev.
> [   10.684332]  systemd[1]: Reached target Preparation for Local File Sys=
tems.
> [   10.684337]  systemd[1]: Reached target Local File Systems.
> [   10.685134]  systemd[1]: Started Journal Service.
> [   10.957014]  cryptd: max_cpu_qlen set to 1000
> [   10.957050]  xhci_hcd 0000:00:14.0: xHCI Host Controller
> [   10.971384]  xhci_hcd 0000:00:14.0: new USB bus registered, assigned b=
us number 1
> [   10.971538]  xhci_hcd 0000:00:14.0: hcc params 0x200077c1 hci version =
0x100 quirks 0x0000000000009810
> [   10.971683]  xhci_hcd 0000:00:14.0: xHCI Host Controller
> [   10.971823]  xhci_hcd 0000:00:14.0: new USB bus registered, assigned b=
us number 2
> [   10.971964]  xhci_hcd 0000:00:14.0: Host supports USB 3.0 SuperSpeed
> [   10.972121]  usb usb1: New USB device found, idVendor=3D1d6b, idProduc=
t=3D0002, bcdDevice=3D 6.11
> [   10.972264]  usb usb1: New USB device strings: Mfr=3D3, Product=3D2, S=
erialNumber=3D1
> [   10.972405]  usb usb1: Product: xHCI Host Controller
> [   10.972539]  usb usb1: Manufacturer: Linux 6.11.8-stable-1 xhci-hcd
> [   10.972680]  usb usb1: SerialNumber: 0000:00:14.0
> [   10.972791]  hub 1-0:1.0: USB hub found
> [   10.972917]  hub 1-0:1.0: 16 ports detected
> [   10.973055]  usb usb2: New USB device found, idVendor=3D1d6b, idProduc=
t=3D0003, bcdDevice=3D 6.11
> [   10.973173]  usb usb2: New USB device strings: Mfr=3D3, Product=3D2, S=
erialNumber=3D1
> [   10.973282]  usb usb2: Product: xHCI Host Controller
> [   10.973388]  usb usb2: Manufacturer: Linux 6.11.8-stable-1 xhci-hcd
> [   10.973492]  usb usb2: SerialNumber: 0000:00:14.0
> [   10.973597]  hub 2-0:1.0: USB hub found
> [   10.973716]  hub 2-0:1.0: 10 ports detected
> [   10.973830]  AES CTR mode by8 optimization enabled
> [   10.973843]  xhci_hcd 0000:71:00.0: xHCI Host Controller
> [   11.027483]  xhci_hcd 0000:71:00.0: new USB bus registered, assigned b=
us number 3
> [   11.027656]  nvme nvme0: pci function 0000:03:00.0
> [   11.027825]  nvme nvme0: allocated 32 MiB host memory buffer.
> [   11.027984]  nvme nvme0: 12/0/0 default/read/poll queues
> [   11.028158]   nvme0n1: p1 p2 p3 p4 p5 p6
> [   11.028174]  xhci_hcd 0000:71:00.0: hcc params 0x0200ef80 hci version =
0x110 quirks 0x0000000000800010
> [   11.028348]  xhci_hcd 0000:71:00.0: xHCI Host Controller
> [   11.028528]  xhci_hcd 0000:71:00.0: new USB bus registered, assigned b=
us number 4
> [   11.028701]  xhci_hcd 0000:71:00.0: Host supports USB 3.1 Enhanced Sup=
erSpeed
> [   11.028890]  usb usb3: New USB device found, idVendor=3D1d6b, idProduc=
t=3D0002, bcdDevice=3D 6.11
> [   11.029169]  usb usb3: New USB device strings: Mfr=3D3, Product=3D2, S=
erialNumber=3D1
> [   11.029407]  usb usb3: Product: xHCI Host Controller
> [   11.029606]  usb usb3: Manufacturer: Linux 6.11.8-stable-1 xhci-hcd
> [   11.029806]  usb usb3: SerialNumber: 0000:71:00.0
> [   11.030010]  hub 3-0:1.0: USB hub found
> [   11.030205]  hub 3-0:1.0: 2 ports detected
> [   11.030406]  usb usb4: We don't know the algorithms for LPM for this h=
ost, disabling LPM.
> [   11.030656]  usb usb4: New USB device found, idVendor=3D1d6b, idProduc=
t=3D0003, bcdDevice=3D 6.11
> [   11.030889]  usb usb4: New USB device strings: Mfr=3D3, Product=3D2, S=
erialNumber=3D1
> [   11.031084]  usb usb4: Product: xHCI Host Controller
> [   11.031235]  usb usb4: Manufacturer: Linux 6.11.8-stable-1 xhci-hcd
> [   11.031425]  usb usb4: SerialNumber: 0000:71:00.0
> [   11.031622]  hub 4-0:1.0: USB hub found
> [   11.031778]  hub 4-0:1.0: 2 ports detected
> [   11.211095]  usb 1-3: new high-speed USB device number 2 using xhci_hcd
> [   11.339091]  usb 1-3: New USB device found, idVendor=3D174c, idProduct=
=3D2074, bcdDevice=3D 1.00
> [   11.344919]  usb 1-3: New USB device strings: Mfr=3D2, Product=3D3, Se=
rialNumber=3D0
> [   11.345799]  usb 1-3: Product: ASM107x
> [   11.346661]  usb 1-3: Manufacturer: ASRock
> [   11.347381]  hub 1-3:1.0: USB hub found
> [   11.347977]  hub 1-3:1.0: 4 ports detected
> [   11.452116]  usb 2-7: new SuperSpeed USB device number 2 using xhci_hcd
> [   11.466086]  usb 2-7: New USB device found, idVendor=3D174c, idProduct=
=3D3074, bcdDevice=3D 1.00
> [   11.471109]  usb 2-7: New USB device strings: Mfr=3D2, Product=3D3, Se=
rialNumber=3D0
> [   11.471690]  usb 2-7: Product: ASM107x
> [   11.472261]  usb 2-7: Manufacturer: ASRock
> [   11.472755]  hub 2-7:1.0: USB hub found
> [   11.473391]  hub 2-7:1.0: 4 ports detected
> [   11.473930]  usb: port power management may be unreliable
> [   11.579116]  usb 1-8: new high-speed USB device number 3 using xhci_hcd
> [   11.705040]  usb 1-8: New USB device found, idVendor=3D1a40, idProduct=
=3D0801, bcdDevice=3D 1.00
> [   11.705531]  usb 1-8: New USB device strings: Mfr=3D0, Product=3D1, Se=
rialNumber=3D0
> [   11.705696]  usb 1-8: Product: USB 2.0 Hub
> [   11.705857]  hub 1-8:1.0: USB hub found
> [   11.706043]  hub 1-8:1.0: 4 ports detected
> [   11.739047]  EXT4-fs (nvme0n1p3): mounted filesystem 7a1f5906-150c-465=
7-a3ea-b27c948b76b0 r/w with ordered data mode. Quota mode: none.
> [   12.498887]  systemd-journald[294]: Received SIGTERM from PID 1 (syste=
md).
> [   12.499178]  usb 1-8.3: new low-speed USB device number 4 using xhci_h=
cd
> [   12.499228]  systemd[1]: systemd 256.8-1-arch running in system mode (=
+PAM +AUDIT -SELINUX -APPARMOR -IMA +SMACK +SECCOMP +GCRYPT +GNUTLS +OPENSS=
L +ACL +BLKID +CURL +ELFUTILS +FIDO2 +IDN2 -IDN +IPTC +KMOD +LIBCRYPTSETUP =
+LIBCRYPTSETUP_PLUGINS +LIBFDISK +PCRE2 +PWQUALITY +P11KIT +QRENCODE +TPM2 =
+BZIP2 +LZ4 +XZ +ZLIB +ZSTD +BPF_FRAMEWORK +XKBCOMMON +UTMP -SYSVINIT +LIBA=
RCHIVE)
> [   12.499260]  systemd[1]: Detected architecture x86-64.
> [   12.499437]  usb 1-8.3: New USB device found, idVendor=3D046d, idProdu=
ct=3Dc31c, bcdDevice=3D64.00
> [   12.499610]  usb 1-8.3: New USB device strings: Mfr=3D1, Product=3D2, =
SerialNumber=3D0
> [   12.499781]  usb 1-8.3: Product: USB Keyboard
> [   12.499951]  usb 1-8.3: Manufacturer: Logitech
> [   12.499978]  systemd[1]: bpf-restrict-fs: LSM BPF program attached
> [   12.499997]  systemd-ssh-generator[538]: Binding SSH to AF_UNIX socket=
 /run/ssh-unix-local/socket.
> [   12.500026]  systemd-ssh-generator[538]: =E2=86=92 connect via 'ssh .h=
ost' locally
> [   12.500045]  systemd[1]: run-credentials-systemd\x2djournald.service.m=
ount: Deactivated successfully.
> [   12.500067]  systemd[1]: initrd-switch-root.service: Deactivated succe=
ssfully.
> [   12.500084]  systemd[1]: Stopped Switch Root.
> [   12.500119]  systemd[1]: systemd-journald.service: Scheduled restart j=
ob, restart counter is at 1.
> [   12.500141]  systemd[1]: Created slice Slice /system/dirmngr.
> [   12.500163]  systemd[1]: Created slice Slice /system/getty.
> [   12.500183]  systemd[1]: Created slice Slice /system/gpg-agent.
> [   12.500201]  systemd[1]: Created slice Slice /system/gpg-agent-browser.
> [   12.500217]  systemd[1]: Created slice Slice /system/gpg-agent-extra.
> [   12.500238]  systemd[1]: Created slice Slice /system/gpg-agent-ssh.
> [   12.500258]  systemd[1]: Created slice Slice /system/keyboxd.
> [   12.500276]  systemd[1]: Created slice Slice /system/systemd-fsck.
> [   12.500298]  systemd[1]: Created slice Slice /system/wg-quick.
> [   12.500317]  systemd[1]: Created slice User and Session Slice.
> [   12.500334]  systemd[1]: Started Dispatch Password Requests to Console=
 Directory Watch.
> [   12.500356]  systemd[1]: Started Forward Password Requests to Wall Dir=
ectory Watch.
> [   12.500373]  systemd[1]: Set up automount Arbitrary Executable File Fo=
rmats File System Automount Point.
> [   12.500395]  systemd[1]: Expecting device /dev/disk/by-uuid/1b631410-2=
16a-4909-a02e-0362da57d241...
> [   12.500412]  systemd[1]: Expecting device /dev/disk/by-uuid/3e25ed0e-f=
f2b-4ad1-8227-6dc838055384...
> [   12.500430]  systemd[1]: Expecting device /dev/disk/by-uuid/4e75f3f1-c=
01e-4133-b2b7-0614604c430a...
> [   12.500463]  systemd[1]: Expecting device /dev/disk/by-uuid/8f93166e-b=
18c-4522-af8c-21fdc12ef3e2...
> [   12.500494]  systemd[1]: Expecting device /dev/disk/by-uuid/ABF2-7542.=
=2E.
> [   12.500511]  systemd[1]: Expecting device /dev/disk/by-uuid/F1A0-E89B.=
=2E.
> [   12.500528]  systemd[1]: Expecting device /dev/disk/by-uuid/bd94c712-f=
5f3-4f18-b1ed-b77ee42d4e0b...
> [   12.500545]  systemd[1]: Expecting device /dev/disk/by-uuid/f6f66f4e-1=
ed8-47fd-ac65-b91acd278d89...
> [   12.500563]  systemd[1]: Expecting device /dev/vg_data/lv_data...
> [   12.500581]  systemd[1]: Reached target Local Encrypted Volumes.
> [   12.500597]  systemd[1]: Stopped target Switch Root.
> [   12.500615]  systemd[1]: Stopped target Initrd File Systems.
> [   12.500635]  systemd[1]: Stopped target Initrd Root File System.
> [   12.500652]  systemd[1]: Reached target Local Integrity Protected Volu=
mes.
> [   12.500672]  systemd[1]: Reached target Path Units.
> [   12.500690]  systemd[1]: Reached target Remote File Systems.
> [   12.500707]  systemd[1]: Reached target Slice Units.
> [   12.500725]  systemd[1]: Reached target Local Verity Protected Volumes.
> [   12.500742]  systemd[1]: Listening on Device-mapper event daemon FIFOs.
> [   12.500759]  systemd[1]: Listening on LVM2 poll daemon socket.
> [   12.500777]  systemd[1]: Listening on RPCbind Server Activation Socket.
> [   12.500794]  systemd[1]: Reached target RPC Port Mapper.
> [   12.500812]  systemd[1]: Listening on Process Core Dump Socket.
> [   12.500834]  systemd[1]: Listening on Credential Encryption/Decryption.
> [   12.500851]  systemd[1]: Listening on Network Service Netlink Socket.
> [   12.500869]  systemd[1]: TPM PCR Measurements was skipped because of a=
n unmet condition check (ConditionSecurity=3Dmeasured-uki).
> [   12.500888]  systemd[1]: Make TPM PCR Policy was skipped because of an=
 unmet condition check (ConditionSecurity=3Dmeasured-uki).
> [   12.500905]  systemd[1]: Listening on udev Control Socket.
> [   12.500922]  systemd[1]: Listening on udev Kernel Socket.
> [   12.500939]  systemd[1]: Mounting Huge Pages File System...
> [   12.500955]  systemd[1]: Mounting POSIX Message Queue File System...
> [   12.500973]  systemd[1]: Mounting NFSD configuration filesystem...
> [   12.500992]  systemd[1]: Mounting Kernel Debug File System...
> [   12.501027]  systemd[1]: Mounting Kernel Trace File System...
> [   12.501045]  systemd[1]: Kernel Module supporting RPCSEC_GSS was skipp=
ed because of an unmet condition check (ConditionPathExists=3D/etc/krb5.key=
tab).
> [   12.501078]  systemd[1]: Starting Create List of Static Device Nodes...
> [   12.501096]  systemd[1]: Starting Monitoring of LVM2 mirrors, snapshot=
s etc. using dmeventd or progress polling...
> [   12.501130]  systemd[1]: Starting Load Kernel Module configfs...
> [   12.501146]  systemd[1]: Starting Load Kernel Module dm_mod...
> [   12.501176]  systemd[1]: Starting Load Kernel Module drm...
> [   12.501193]  systemd[1]: Starting Load Kernel Module fuse...
> [   12.501210]  systemd[1]: Starting Load Kernel Module loop...
> [   12.501228]  systemd[1]: Clear Stale Hibernate Storage Info was skippe=
d because of an unmet condition check (ConditionPathExists=3D/sys/firmware/=
efi/efivars/HibernateLocation-8cf2644b-4b0b-428f-9387-6d876050dc67).
> [   12.501245]  systemd[1]: Starting Journal Service...
> [   12.501262]  systemd[1]: Starting Load Kernel Modules...
> [   12.501280]  systemd[1]: TPM PCR Machine ID Measurement was skipped be=
cause of an unmet condition check (ConditionSecurity=3Dmeasured-uki).
> [   12.501298]  systemd[1]: Starting Remount Root and Kernel File Systems=
=2E..
> [   12.501333]  systemd[1]: Early TPM SRK Setup was skipped because of an=
 unmet condition check (ConditionSecurity=3Dmeasured-uki).
> [   12.501364]  systemd[1]: Starting Load udev Rules from Credentials...
> [   12.501380]  systemd[1]: Starting Coldplug All udev Devices...
> [   12.501396]  systemd[1]: Mounted Huge Pages File System.
> [   12.501414]  systemd[1]: Mounted POSIX Message Queue File System.
> [   12.501430]  systemd[1]: Mounted Kernel Debug File System.
> [   12.501447]  systemd[1]: Mounted Kernel Trace File System.
> [   12.501464]  systemd[1]: Finished Create List of Static Device Nodes.
> [   12.501480]  systemd[1]: modprobe@configfs.service: Deactivated succes=
sfully.
> [   12.501495]  systemd[1]: Finished Load Kernel Module configfs.
> [   12.501516]  systemd[1]: modprobe@drm.service: Deactivated successfull=
y.
> [   12.501532]  systemd[1]: Finished Load Kernel Module drm.
> [   12.501548]  systemd[1]: Finished Load Kernel Modules.
> [   12.501565]  systemd[1]: Finished Load udev Rules from Credentials.
> [   12.501582]  systemd[1]: Starting Apply Kernel Variables...
> [   12.501604]  systemd[1]: Starting Create Static Device Nodes in /dev g=
racefully...
> [   12.501621]  EXT4-fs (nvme0n1p3): re-mounted 7a1f5906-150c-4657-a3ea-b=
27c948b76b0 r/w. Quota mode: none.
> [   12.501637]  systemd[1]: Finished Remount Root and Kernel File Systems.
> [   12.501654]  systemd[1]: Rebuild Hardware Database was skipped because=
 no trigger condition checks were met.
> [   12.501670]  systemd[1]: Starting Load/Save OS Random Seed...
> [   12.501688]  systemd[1]: TPM SRK Setup was skipped because of an unmet=
 condition check (ConditionSecurity=3Dmeasured-uki).
> [   12.501733]  systemd-journald[563]: Collecting audit messages is disab=
led.
> [   12.501783]  loop: module loaded
> [   12.501801]  fuse: init (API version 7.40)
> [   12.501817]  device-mapper: uevent: version 1.0.3
> [   12.501833]  device-mapper: ioctl: 4.48.0-ioctl (2023-03-01) initialis=
ed: dm-devel@lists.linux.dev
> [   12.501850]  systemd[1]: modprobe@loop.service: Deactivated successful=
ly.
> [   12.501867]  systemd[1]: Finished Load Kernel Module loop.
> [   12.501884]  systemd[1]: modprobe@dm_mod.service: Deactivated successf=
ully.
> [   12.501902]  systemd[1]: Finished Load Kernel Module dm_mod.
> [   12.501920]  systemd[1]: modprobe@fuse.service: Deactivated successful=
ly.
> [   12.501940]  systemd[1]: Finished Load Kernel Module fuse.
> [   12.501957]  systemd[1]: Finished Apply Kernel Variables.
> [   12.501977]  systemd[1]: Repartition Root Disk was skipped because no =
trigger condition checks were met.
> [   12.503073]  systemd[1]: Started Journal Service.
> [   12.505053]  RPC: Registered named UNIX socket transport module.
> [   12.505084]  RPC: Registered udp transport module.
> [   12.505100]  RPC: Registered tcp transport module.
> [   12.505116]  RPC: Registered tcp-with-tls transport module.
> [   12.505143]  RPC: Registered tcp NFSv4.1 backchannel transport module.
> [   12.682231]  systemd-journald[563]: Received client request to flush r=
untime journal.
> [   12.760013]  cfg80211: Loading compiled-in X.509 certificates for regu=
latory database
> [   12.760082]  EDAC ie31200: No ECC support
> [   12.760109]  EDAC ie31200: No ECC support
> [   12.764010]  Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> [   12.764083]  Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248=
db18c600'
> [   12.771007]  Adding 16777212k swap on /dev/nvme0n1p4.  Priority:-2 ext=
ents:1 across:16777212k SS
> [   12.781010]  resource: resource sanity check: requesting [mem 0x000000=
00fdffe800-0x00000000fe0007ff], which spans more than pnp 00:07 [mem 0xfdb0=
0000-0xfdffffff]
> [   12.781071]  caller get_primary_reg_base+0x4d/0xb0 [intel_pmc_core] ma=
pping multiple BARs
> [   12.781092]  intel_pmc_core INT33A1:00:  initialized
> [   12.804022]  input: PC Speaker as /devices/platform/pcspkr/input/input3
> [   12.808010]  input: Logitech USB Keyboard as /devices/pci0000:00/0000:=
00:14.0/usb1/1-8/1-8.3/1-8.3:1.0/0003:046D:C31C.0001/input/input4
> [   12.808065]  e1000e: Intel(R) PRO/1000 Network Driver
> [   12.808094]  e1000e: Copyright(c) 1999 - 2015 Intel Corporation.
> [   12.809028]  e1000e 0000:00:1f.6: Interrupt Throttling Rate (ints/sec)=
 set to dynamic conservative mode
> [   13.060561]  mei_me 0000:00:16.0: enabling device (0004 -> 0006)
> [   13.060733]  i801_smbus 0000:00:1f.4: SMBus using PCI interrupt
> [   13.060861]  i2c i2c-0: Successfully instantiated SPD at 0x51
> [   13.060985]  i2c i2c-0: Successfully instantiated SPD at 0x53
> [   13.061128]  ee1004 0-0051: 512 byte EE1004-compliant SPD EEPROM, read=
-only
> [   13.061232]  ee1004 0-0053: 512 byte EE1004-compliant SPD EEPROM, read=
-only
> [   13.061337]  RAPL PMU: API unit is 2^-32 Joules, 4 fixed counters, 655=
360 ms ovfl timer
> [   13.061747]  RAPL PMU: hw unit of domain pp0-core 2^-14 Joules
> [   13.061760]  RAPL PMU: hw unit of domain package 2^-14 Joules
> [   13.061775]  RAPL PMU: hw unit of domain dram 2^-14 Joules
> [   13.061784]  RAPL PMU: hw unit of domain pp1-gpu 2^-14 Joules
> [   13.062071]  e1000e 0000:00:1f.6 0000:00:1f.6 (uninitialized): registe=
red PHC clock
> [   13.062191]  e1000e 0000:00:1f.6 eth0: (PCI Express:2.5GT/s:Width x1) =
70:85:c2:73:77:8c
> [   13.062306]  e1000e 0000:00:1f.6 eth0: Intel(R) PRO/1000 Network Conne=
ction
> [   13.062419]  e1000e 0000:00:1f.6 eth0: MAC: 12, PHY: 12, PBA No: FFFFF=
F-0FF
> [   13.174044]  hid-generic 0003:046D:C31C.0001: input,hidraw0: USB HID v=
1.10 Keyboard [Logitech USB Keyboard] on usb-0000:00:14.0-8.3/input0
> [   13.178007]  input: Logitech USB Keyboard Consumer Control as /devices=
/pci0000:00/0000:00:14.0/usb1/1-8/1-8.3/1-8.3:1.1/0003:046D:C31C.0002/input=
/input5
> [   13.231009]  input: Logitech USB Keyboard System Control as /devices/p=
ci0000:00/0000:00:14.0/usb1/1-8/1-8.3/1-8.3:1.1/0003:046D:C31C.0002/input/i=
nput6
> [   13.231055]  hid-generic 0003:046D:C31C.0002: input,hidraw1: USB HID v=
1.10 Device [Logitech USB Keyboard] on usb-0000:00:14.0-8.3/input1
> [   13.231236]  usbcore: registered new interface driver usbhid
> [   13.231256]  usbhid: USB HID core driver
> [   13.297015]  i915 0000:00:02.0: [drm] Found COFFEELAKE (device ID 3e92=
) display version 9.00
> [   14.191329]  e1000e 0000:00:1f.6 eno1: renamed from eth0
> [   14.191473]  raid6: skipped pq benchmark and selected avx2x4
> [   14.191485]  raid6: using avx2x2 recovery algorithm
> [   14.191500]  Console: switching to colour dummy device 80x25
> [   14.191516]  xor: automatically using best checksumming function   avx=
      =20
> [   14.191530]  async_tx: api initialized (async)
> [   14.191541]  i915 0000:00:02.0: vgaarb: deactivate vga console
> [   14.191662]  i915 0000:00:02.0: vgaarb: VGA decodes changed: olddecode=
s=3Dio+mem,decodes=3Dio+mem:owns=3Dio+mem
> [   14.191828]  i915 0000:00:02.0: [drm] Finished loading DMC firmware i9=
15/kbl_dmc_ver1_04.bin (v1.4)
> [   14.192026]  intel_tcc_cooling: Programmable TCC Offset detected
> [   14.192042]  md/raid:md127: not clean -- starting background reconstru=
ction
> [   14.192056]  md/raid:md127: device sdc1 operational as raid disk 2
> [   14.192071]  md/raid:md127: device sda1 operational as raid disk 0
> [   14.192081]  md/raid:md127: device sdb1 operational as raid disk 1
> [   14.192092]  md/raid:md127: device sde1 operational as raid disk 4
> [   14.192102]  md/raid:md127: device sdf1 operational as raid disk 5
> [   14.192110]  md/raid:md127: device sdd1 operational as raid disk 3
> [   14.192122]  md/raid:md127: raid level 6 active with 6 out of 6 device=
s, algorithm 2
> [   14.192135]  md127: detected capacity change from 0 to 62511144960
> [   14.192145]  md: resync of RAID array md127
> [   14.192156]  intel_rapl_common: Found RAPL domain package
> [   14.192169]  intel_rapl_common: Found RAPL domain core
> [   14.192178]  intel_rapl_common: Found RAPL domain uncore
> [   14.192627]  intel_rapl_common: Found RAPL domain dram
> [   14.192648]  EXT4-fs (nvme0n1p2): mounted filesystem bd94c712-f5f3-4f1=
8-b1ed-b77ee42d4e0b r/w with ordered data mode. Quota mode: none.
> [   14.192674]  EXT4-fs (sdg2): mounted filesystem 8f93166e-b18c-4522-af8=
c-21fdc12ef3e2 r/w with ordered data mode. Quota mode: none.
> [   14.192697]  EXT4-fs (nvme0n1p5): mounted filesystem f6f66f4e-1ed8-47f=
d-ac65-b91acd278d89 r/w with ordered data mode. Quota mode: none.
> [   14.192718]  device-mapper: cache: Origin device (dm-2) discard unsupp=
orted: Disabling discard passdown.
> [   14.192747]  i915 0000:00:02.0: [drm] [ENCODER:98:DDI A/PHY A] failed =
to retrieve link info, disabling eDP
> [   14.192947]  mei_hdcp 0000:00:16.0-b638ab7e-94e2-4ea2-a552-d1c54b627f0=
4: bound 0000:00:02.0 (ops i915_hdcp_ops [i915])
> [   14.192982]  [drm] Initialized i915 1.6.0 for 0000:00:02.0 on minor 1
> [   14.193006]  ACPI: video: Video Device [GFX0] (multi-head: yes  rom: n=
o  post: no)
> [   14.193044]  input: Video Bus as /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0=
A08:00/LNXVIDEO:00/input/input7
> [   14.193066]  fbcon: i915drmfb (fb0) is primary device
> [   14.193087]  Console: switching to colour frame buffer device 240x67
> [   14.193106]  i915 0000:00:02.0: [drm] fb0: i915drmfb frame buffer devi=
ce
> [   14.299012]  snd_hda_intel 0000:00:1f.3: bound 0000:00:02.0 (ops i915_=
audio_component_bind_ops [i915])
> [   14.332061]  snd_hda_codec_realtek hdaudioC0D0: autoconfig for ALC1220=
: line_outs=3D3 (0x14/0x15/0x16/0x0/0x0) type:line
> [   14.343305]  snd_hda_codec_realtek hdaudioC0D0:    speaker_outs=3D0 (0=
x0/0x0/0x0/0x0/0x0)
> [   14.343498]  snd_hda_codec_realtek hdaudioC0D0:    hp_outs=3D1 (0x1b/0=
x0/0x0/0x0/0x0)
> [   14.343686]  snd_hda_codec_realtek hdaudioC0D0:    mono: mono_out=3D0x0
> [   14.343853]  snd_hda_codec_realtek hdaudioC0D0:    dig-out=3D0x1e/0x0
> [   14.343992]  snd_hda_codec_realtek hdaudioC0D0:    inputs:
> [   14.344106]  snd_hda_codec_realtek hdaudioC0D0:      Rear Mic=3D0x18
> [   14.344199]  snd_hda_codec_realtek hdaudioC0D0:      Front Mic=3D0x19
> [   14.344295]  snd_hda_codec_realtek hdaudioC0D0:      Line=3D0x1a
> [   14.360221]  input: HDA Intel PCH Rear Mic as /devices/pci0000:00/0000=
:00:1f.3/sound/card0/input8
> [   14.360653]  input: HDA Intel PCH Front Mic as /devices/pci0000:00/000=
0:00:1f.3/sound/card0/input9
> [   14.360686]  input: HDA Intel PCH Line as /devices/pci0000:00/0000:00:=
1f.3/sound/card0/input10
> [   14.360711]  input: HDA Intel PCH Line Out Front as /devices/pci0000:0=
0/0000:00:1f.3/sound/card0/input11
> [   14.361009]  input: HDA Intel PCH Line Out Surround as /devices/pci000=
0:00/0000:00:1f.3/sound/card0/input12
> [   14.363063]  input: HDA Intel PCH Line Out CLFE as /devices/pci0000:00=
/0000:00:1f.3/sound/card0/input13
> [   14.364023]  input: HDA Intel PCH Front Headphone as /devices/pci0000:=
00/0000:00:1f.3/sound/card0/input14
> [   14.365032]  input: HDA Intel PCH HDMI/DP,pcm=3D3 as /devices/pci0000:=
00/0000:00:1f.3/sound/card0/input15
> [   14.365101]  input: HDA Intel PCH HDMI/DP,pcm=3D7 as /devices/pci0000:=
00/0000:00:1f.3/sound/card0/input16
> [   14.365122]  input: HDA Intel PCH HDMI/DP,pcm=3D8 as /devices/pci0000:=
00/0000:00:1f.3/sound/card0/input17
> [   14.463004]  EXT4-fs (sdg5): mounted filesystem 3e25ed0e-ff2b-4ad1-822=
7-6dc838055384 r/w with ordered data mode. Quota mode: none.
> [   14.544071]  EXT4-fs (sdg4): mounted filesystem 1b631410-216a-4909-a02=
e-0362da57d241 r/w with ordered data mode. Quota mode: none.
> [   16.560054]  e1000e 0000:00:1f.6 eno1: NIC Link is Up 1000 Mbps Full D=
uplex, Flow Control: None
> [   52.023087]  md: md127: resync done.
> [   68.840044]  EXT4-fs (dm-3): recovery complete
> [   68.840102]  EXT4-fs (dm-3): mounted filesystem fc136644-47ad-4c1f-863=
1-3ddbc4b4dd2a r/w with ordered data mode. Quota mode: none.
> [   69.184019]  nct6775: Found NCT6791D or compatible chip at 0x2e:0x290
> [   69.440021]  RPC: Registered rdma transport module.
> [   69.440456]  RPC: Registered rdma backchannel transport module.
> [   69.440480]  wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com =
for information.
> [   69.440493]  wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Ja=
son@zx2c4.com>. All Rights Reserved.
> [   69.552014]  NFSD: Using nfsdcld client tracking operations.
> [   69.552061]  NFSD: no clients to reclaim, skipping NFSv4 grace period =
(net f0000000)
> [  220.303034]  systemd-ssh-generator[2211]: Binding SSH to AF_UNIX socke=
t /run/ssh-unix-local/socket.
> [  220.303167]  systemd-ssh-generator[2211]: =E2=86=92 connect via 'ssh .=
host' locally
> [25490.714041]  systemd-ssh-generator[9902]: Binding SSH to AF_UNIX socke=
t /run/ssh-unix-local/socket.
> [25490.714146]  systemd-ssh-generator[9902]: =E2=86=92 connect via 'ssh .=
host' locally
> [25507.821065]  block nvme0n1: No UUID available providing old NGUID
> [25507.821654]  block nvme0n1: the capability attribute has been deprecat=
ed.
> [25513.564057]  NET: Registered PF_ALG protocol family
> [73937.536025]  EXT4-fs error (device dm-3): ext4_lookup:1813: inode #126=
161478: comm rsync: iget: checksum invalid
> [73937.537023]  EXT4-fs error (device dm-3): ext4_lookup:1813: inode #126=
161478: comm rsync: iget: checksum invalid
> [88234.664019]  systemd-ssh-generator[20898]: Binding SSH to AF_UNIX sock=
et /run/ssh-unix-local/socket.
> [88234.664085]  systemd-ssh-generator[20898]: =E2=86=92 connect via 'ssh =
=2Ehost' locally
> [107920.658019]  systemd-ssh-generator[23019]: Binding SSH to AF_UNIX soc=
ket /run/ssh-unix-local/socket.
> [107920.658098]  systemd-ssh-generator[23019]: =E2=86=92 connect via 'ssh=
 .host' locally
> [140052.054085]  systemd-ssh-generator[25529]: Binding SSH to AF_UNIX soc=
ket /run/ssh-unix-local/socket.
> [140052.054401]  systemd-ssh-generator[25529]: =E2=86=92 connect via 'ssh=
 .host' locally
> [161780.846149]  EXT4-fs (dm-3): error count since last fsck: 2
> [161780.847081]  EXT4-fs (dm-3): initial error at time 1731742618: ext4_l=
ookup:1813: inode 126161478
> [161780.847214]  EXT4-fs (dm-3): last error at time 1731742618: ext4_look=
up:1813: inode 126161478
> [175840.906026]  systemd-ssh-generator[27822]: Binding SSH to AF_UNIX soc=
ket /run/ssh-unix-local/socket.
> [175840.906114]  systemd-ssh-generator[27822]: =E2=86=92 connect via 'ssh=
 .host' locally
> [191322.007026]  EXT4-fs (sdg5): unmounting filesystem 3e25ed0e-ff2b-4ad1=
-8227-6dc838055384.
> [191322.007093]  EXT4-fs (sdg4): unmounting filesystem 1b631410-216a-4909=
-a02e-0362da57d241.
> [191322.011010]  EXT4-fs (nvme0n1p5): unmounting filesystem f6f66f4e-1ed8=
-47fd-ac65-b91acd278d89.
> [191322.016010]  EXT4-fs (nvme0n1p2): unmounting filesystem bd94c712-f5f3=
-4f18-b1ed-b77ee42d4e0b.
> [191322.261047]  EXT4-fs (sdg2): unmounting filesystem 8f93166e-b18c-4522=
-af8c-21fdc12ef3e2.
> [191331.777986]  BUG: unable to handle page fault for address: 0000000000=
200010
> [191331.778187]  #PF: supervisor read access in kernel mode
> [191331.781901]  #PF: error_code(0x0000) - not-present page
> [191331.781956]  PGD 0 P4D 0=20
> [191331.782037]  Oops: Oops: 0000 [#1] PREEMPT SMP PTI
> [191331.782075]  CPU: 1 UID: 0 PID: 37604 Comm: umount Not tainted 6.11.8=
-stable-1 #21 1400000003000000474e5500ae13c727d476f9ab
> [191331.782093]  Hardware name: To Be Filled By O.E.M. To Be Filled By O.=
E.M./Z370 Extreme4, BIOS P4.20 10/31/2019
> [191331.782105]  RIP: 0010:rb_first+0x13/0x30
> [191331.782120]  Code: 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90=
 90 90 90 90 90 90 f3 0f 1e fa 48 8b 07 48 85 c0 74 18 0f 1f 40 00 48 89 c2=
 <48> 8b 40 10 48 85 c0 75 f4 48 89 d0 c3 cc cc cc cc 31 d2 eb f4 0f
> [191331.782135]  RSP: 0018:ffffa95621d3f8d8 EFLAGS: 00010206
> [191331.782146]  RAX: 0000000000200000 RBX: ffffa95621d3f8f8 RCX: 0000000=
000000000
> [191331.782162]  RDX: 0000000000200000 RSI: 0000000000000000 RDI: ffff8f2=
99ec75708
> [191331.782176]  RBP: ffffa95621d3f908 R08: 0000000000000001 R09: 0000000=
00066001a
> [191331.782189]  R10: 000000000066001a R11: 0000000000000000 R12: ffff8f2=
585b77800
> [191331.782200]  R13: ffff8f299ec75468 R14: ffff8f299ec75710 R15: ffff8f2=
97376c688
> [191331.782211]  FS:  00007f30f4a6db80(0000) GS:ffff8f2d1ec80000(0000) kn=
lGS:0000000000000000
> [191331.782222]  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [191331.782234]  CR2: 0000000000200010 CR3: 000000011c868003 CR4: 0000000=
0003706f0
> [191331.782252]  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> [191331.782283]  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> [191331.782294]  Call Trace:
> [191331.782308]   <TASK>
> [191331.782320]   ? __die_body.cold+0x19/0x27
> [191331.782333]   ? page_fault_oops+0x15a/0x2d0
> [191331.782346]   ? exc_page_fault+0x7e/0x180
> [191331.782362]   ? asm_exc_page_fault+0x26/0x30
> [191331.782374]   ? rb_first+0x13/0x30
> [191331.782385]   ext4_discard_preallocations+0xc3/0x460 [ext4 1400000003=
000000474e5500fcb7142b958415b3]
> [191331.782401]   ext4_clear_inode+0x2a/0xb0 [ext4 1400000003000000474e55=
00fcb7142b958415b3]
> [191331.782414]   ext4_evict_inode+0xa1/0x6b0 [ext4 1400000003000000474e5=
500fcb7142b958415b3]
> [191331.782432]   evict+0x111/0x2c0
> [191331.782460]   ? fsnotify_destroy_marks+0x2a/0x1b0
> [191331.782470]   ? __call_rcu_common+0xc2/0x710
> [191331.782480]   evict_inodes+0x226/0x240
> [191331.782723]   generic_shutdown_super+0x3d/0x170
> [191331.782739]   kill_block_super+0x1a/0x40
> [191331.782753]   ext4_kill_sb+0x22/0x40 [ext4 1400000003000000474e5500fc=
b7142b958415b3]
> [191331.782766]   deactivate_locked_super+0x30/0xb0
> [191331.782776]   cleanup_mnt+0xba/0x150
> [191331.782786]   task_work_run+0x59/0x90
> [191331.782794]   syscall_exit_to_user_mode+0x1f4/0x200
> [191331.782805]   do_syscall_64+0x8e/0x160
> [191331.782815]   ? vfs_statx+0x8d/0x100
> [191331.782830]   ? vfs_fstatat+0x8a/0xb0
> [191331.782848]   ? __do_sys_newfstatat+0x3c/0x80
> [191331.782861]   ? syscall_exit_to_user_mode+0x10/0x200
> [191331.782871]   ? do_syscall_64+0x8e/0x160
> [191331.782884]   ? generic_permission+0x39/0x220
> [191331.782895]   ? mntput_no_expire+0x4a/0x260
> [191331.782907]   ? do_faccessat+0x1e1/0x2e0
> [191331.782916]   ? syscall_exit_to_user_mode+0x10/0x200
> [191331.782926]   ? do_syscall_64+0x8e/0x160
> [191331.782936]   ? do_user_addr_fault+0x36c/0x620
> [191331.782947]   ? exc_page_fault+0x7e/0x180
> [191331.782956]   entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [191331.782969]  RIP: 0033:0x7f30f4bc21cb
> [191331.782981]  Code: c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 f3 0f=
 1e fa 31 f6 e9 05 00 00 00 0f 1f 44 00 00 f3 0f 1e fa b8 a6 00 00 00 0f 05=
 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 11 cb 0c 00 f7 d8
> [191331.782995]  RSP: 002b:00007fff6233d1e8 EFLAGS: 00000246 ORIG_RAX: 00=
000000000000a6
> [191331.783039]  RAX: 0000000000000000 RBX: 0000561542af84e0 RCX: 00007f3=
0f4bc21cb
> [191331.783053]  RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000561=
542af9180
> [191331.783099]  RBP: 00007fff6233d2c0 R08: 0000561542af6010 R09: 0000000=
000000007
> [191331.783115]  R10: 0000000000000000 R11: 0000000000000246 R12: 0000561=
542af85e8
> [191331.783126]  R13: 0000000000000000 R14: 0000561542af9180 R15: 0000561=
542af9570
> [191331.783143]   </TASK>
> [191331.783158]  Modules linked in: algif_hash af_alg nft_nat nft_chain_n=
at nf_nat nft_ct nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 nf_tables rpcrd=
ma rdma_cm iw_cm ib_cm wireguard curve25519_x86_64 libchacha20poly1305 ib_c=
ore chacha_x86_64 poly1305_x86_64 libcurve25519_generic libchacha ip6_udp_t=
unnel udp_tunnel nct6775 nct6775_core hwmon_vid snd_hda_codec_hdmi snd_hda_=
codec_realtek snd_hda_codec_generic snd_hda_scodec_component dm_cache_smq d=
m_cache dm_persistent_data dm_bio_prison dm_bufio nls_iso8859_1 vfat fat in=
tel_rapl_msr intel_rapl_common intel_uncore_frequency intel_uncore_frequenc=
y_common raid456 intel_tcc_cooling async_raid6_recov async_memcpy x86_pkg_t=
emp_thermal async_pq snd_soc_avs async_xor intel_powerclamp async_tx snd_so=
c_hda_codec xor joydev coretemp snd_hda_ext_core raid6_pq libcrc32c snd_soc=
_core kvm_intel snd_compress i915 ac97_bus snd_pcm_dmaengine snd_hda_intel =
kvm snd_intel_dspcfg snd_intel_sdw_acpi snd_hda_codec snd_hda_core snd_hwde=
p rapl drm_buddy snd_pcm mei_hdcp mei_pxp i2c_algo_bit ee1004
> [191331.783217]   intel_cstate snd_timer ttm i2c_i801 drm_display_helper =
snd mei_me i2c_smbus intel_uncore usbhid intel_wmi_thunderbolt pcspkr e1000=
e mxm_wmi i2c_mux soundcore cec mei intel_gtt intel_pmc_core intel_vsec md_=
mod pmt_telemetry pmt_class cfg80211 acpi_pad mac_hid rfkill nfsd auth_rpcg=
ss nfs_acl lockd grace tcp_bbr loop dm_mod fuse sunrpc nfnetlink ip_tables =
x_tables ext4 crc32c_generic crc16 mbcache jbd2 crct10dif_pclmul crc32_pclm=
ul crc32c_intel polyval_clmulni polyval_generic ghash_clmulni_intel sha512_=
ssse3 sha256_ssse3 sha1_ssse3 nvme aesni_intel gf128mul crypto_simd cryptd =
xhci_pci nvme_core xhci_pci_renesas video wmi usbip_host usbip_core pkcs8_k=
ey_parser sg crypto_user
> [191331.783245]  CR2: 0000000000200010
> [191331.783259]  ---[ end trace 0000000000000000 ]---
> [191331.783277]  RIP: 0010:rb_first+0x13/0x30
> [191331.783289]  Code: 0f 1f 80 00 00 00 00 90 90 90 90 90 90 90 90 90 90=
 90 90 90 90 90 90 f3 0f 1e fa 48 8b 07 48 85 c0 74 18 0f 1f 40 00 48 89 c2=
 <48> 8b 40 10 48 85 c0 75 f4 48 89 d0 c3 cc cc cc cc 31 d2 eb f4 0f
> [191331.783299]  RSP: 0018:ffffa95621d3f8d8 EFLAGS: 00010206
> [191331.783311]  RAX: 0000000000200000 RBX: ffffa95621d3f8f8 RCX: 0000000=
000000000
> [191331.783322]  RDX: 0000000000200000 RSI: 0000000000000000 RDI: ffff8f2=
99ec75708
> [191331.783334]  RBP: ffffa95621d3f908 R08: 0000000000000001 R09: 0000000=
00066001a
> [191331.783344]  R10: 000000000066001a R11: 0000000000000000 R12: ffff8f2=
585b77800
> [191331.783357]  R13: ffff8f299ec75468 R14: ffff8f299ec75710 R15: ffff8f2=
97376c688
> [191331.783369]  FS:  00007f30f4a6db80(0000) GS:ffff8f2d1ec80000(0000) kn=
lGS:0000000000000000
> [191331.783379]  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [191331.783389]  CR2: 0000000000200010 CR3: 000000011c868003 CR4: 0000000=
0003706f0
> [191331.783399]  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000=
000000000
> [191331.783407]  DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000=
000000400
> [191331.783417]  note: umount[37604] exited with irqs disabled
> [191331.783430]  note: umount[37604] exited with preempt_count 1
> [191332.973053]  systemd-shutdown[1]: Syncing filesystems and block devic=
es.
> [191362.979489]  systemd-shutdown[1]: Syncing filesystems and block devic=
es - timed out, issuing SIGKILL to PID 37638.
> [191362.979558]  systemd-shutdown[1]: Sending SIGTERM to remaining proces=
ses...
> [191362.986536]  systemd-journald[563]: Received SIGTERM from PID 1 (syst=
emd-shutdow).
> [191362.986767]  systemd-journald[563]: Failed to send WATCHDOG=3D1 notif=
ication message: Connection refused



