Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9084913FF4
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 07:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1oPi9niK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xtepv643";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="1oPi9niK";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Xtepv643"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 74B6022077;
	Thu, 21 Dec 2023 07:11:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703142713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXGAlsUyCVFCKcf8cXOpYHfSbLn7SKDe5/aWhNL1Iwo=;
	b=1oPi9niKrcgI0HZDlqUy4p9k4LLKsxojffWTAqDpET5Q60aOJPrtA7yMVKG3jDr/Xk7ma2
	ZBxCWkNwqEzX8XoA6i5XvVA/XIYvBb3kao08Ptfcx5nh+9SR8/kYqiqZ28B340EQ6YqrKp
	Yz0JT6u5Q5mBtkYV0MMqgt7P0TNDZrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703142713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXGAlsUyCVFCKcf8cXOpYHfSbLn7SKDe5/aWhNL1Iwo=;
	b=Xtepv643ZnryzaWp4iGpVMeu+cEnVOEUHJY3E4w+Cmh1aKbBew4Y/npn44cPNpMSH5eVEM
	Iwukms8a06NwA5Dw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703142713; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXGAlsUyCVFCKcf8cXOpYHfSbLn7SKDe5/aWhNL1Iwo=;
	b=1oPi9niKrcgI0HZDlqUy4p9k4LLKsxojffWTAqDpET5Q60aOJPrtA7yMVKG3jDr/Xk7ma2
	ZBxCWkNwqEzX8XoA6i5XvVA/XIYvBb3kao08Ptfcx5nh+9SR8/kYqiqZ28B340EQ6YqrKp
	Yz0JT6u5Q5mBtkYV0MMqgt7P0TNDZrM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703142713;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CXGAlsUyCVFCKcf8cXOpYHfSbLn7SKDe5/aWhNL1Iwo=;
	b=Xtepv643ZnryzaWp4iGpVMeu+cEnVOEUHJY3E4w+Cmh1aKbBew4Y/npn44cPNpMSH5eVEM
	Iwukms8a06NwA5Dw==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 2377013C18;
	Thu, 21 Dec 2023 07:11:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id 0r2JMDblg2VtHwAAn2gu4w
	(envelope-from <colyli@suse.de>); Thu, 21 Dec 2023 07:11:50 +0000
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.300.61.1.2\))
Subject: Re: [PATCH] Revert "raid: Remove now superfluous sentinel element
 from ctl_table array"
From: Coly Li <colyli@suse.de>
In-Reply-To: <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
Date: Thu, 21 Dec 2023 15:11:37 +0800
Cc: Song Liu <song@kernel.org>,
 "Kernel.org-Linux-RAID" <linux-raid@vger.kernel.org>,
 Joel Granados <j.granados@samsung.com>,
 Luis Chamberlain <mcgrof@kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DA283F34-30A1-49CE-8FD9-C3A98F491779@suse.de>
References: <20231221044925.10178-1-colyli@suse.de>
 <aef386e9-90b2-9847-89cd-1566a5969a08@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3774.300.61.1.2)
X-Spam-Level: 
X-Spam-Level: 
X-Spamd-Result: default: False [-2.60 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 BAYES_HAM(-3.00)[100.00%];
	 FROM_HAS_DN(0.00)[];
	 MV_CASE(0.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 RCPT_COUNT_FIVE(0.00)[6];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 TO_DN_ALL(0.00)[];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Score: -2.60
X-Spam-Flag: NO



> 2023=E5=B9=B412=E6=9C=8821=E6=97=A5 14:19=EF=BC=8CYu Kuai =
<yukuai1@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>=20
> =E5=9C=A8 2023/12/21 12:49, Coly Li =E5=86=99=E9=81=93:
>> This reverts commit dd6291c506490c195620b394dc96763675e7e5f4.
>> With this patch, a kernel oops triggered when creating a md device,
>> [  311.224353][ T3545] BUG: unable to handle page fault for address: =
000003e800030d40
>> [  311.314951][ T3545] #PF: supervisor read access in kernel mode
>> [  311.384748][ T3545] #PF: error_code(0x0000) - not-present page
>> [  311.454538][ T3545] PGD 12be1c067 P4D 0
>> [  311.501451][ T3545] Oops: 0000 [#1] PREEMPT SMP NOPTI
>> [  311.561888][ T3545] CPU: 19 PID: 3545 Comm: modprobe [snipped...]
>> [  311.869958][ T3545] RIP: 0010:string+0x48/0xe0
>> [  311.923116][ T3545] Code: 3b 45 89 d1 45 31 c0 49 01 f9 66 45 85 =
d2 75 1a eb 1f 48 39 f7 73 02 88 07 48 83 c7 01 41 83 c0 01 48 83 c2 01 =
4c 39 cf 74 07 <0f> b6 02 84 c0 75 e1 48 89 f2 44 89 c6 e9 c6 e3 ff ff =
48 c7 c0 3d
>> [  312.156194][ T3545] RSP: 0018:ffa000000b877a70 EFLAGS: 00010086
>> [  312.227025][ T3545] RAX: 000003e80002fd40 RBX: ffa000000b877b86 =
RCX: ffff0a00ffffff04
>> [  312.320737][ T3545] RDX: 000003e800030d40 RSI: ffa000000b877b68 =
RDI: ffa000000b877b86
>> [  312.414449][ T3545] RBP: ffa000000b877b48 R08: 0000000000000000 =
R09: ffa000010b877b85
>> [  312.508160][ T3545] R10: ffffffffffffffff R11: 0000000000000040 =
R12: ffa000000b877b68
>> [  312.601873][ T3545] R13: ffffffff99c221fa R14: 0000000000000008 =
R15: ffffffff99c221fa
>> [  312.695583][ T3545] FS:  00007fea7a856740(0000) =
GS:ff11000fffd80000(0000) knlGS:0000000000000000
>> [  312.800733][ T3545] CS:  0010 DS: 0000 ES: 0000 CR0: =
0000000080050033
>> [  312.877805][ T3545] CR2: 000003e800030d40 CR3: 0000000123790001 =
CR4: 0000000000771ee0
>> [  312.971518][ T3545] DR0: 0000000000000000 DR1: 0000000000000000 =
DR2: 0000000000000000
>> [  313.065229][ T3545] DR3: 0000000000000000 DR6: 00000000fffe0ff0 =
DR7: 0000000000000400
>> [  313.158940][ T3545] PKRU: 55555554
>> [  313.199610][ T3545] Call Trace:
>> [  313.237162][ T3545]  <TASK>
>> [  313.270554][ T3545]  ? __die+0x23/0x70
>> [  313.315391][ T3545]  ? page_fault_oops+0x14d/0x490
>> [  313.372701][ T3545]  ? update_load_avg+0x7e/0x7d0
>> [  313.428972][ T3545]  ? exc_page_fault+0x71/0x160
>> [  313.484203][ T3545]  ? asm_exc_page_fault+0x26/0x30
>> [  313.542555][ T3545]  ? string+0x48/0xe0
>> [  313.588426][ T3545]  vsnprintf+0x2d5/0x5a0
>> [  313.637417][ T3545]  vprintk_store+0x15e/0x4b0
>> [  313.690567][ T3545]  ? schedule_timeout+0x147/0x160
>> [  313.748918][ T3545]  ? wait_for_completion_killable+0x1a6/0x1d0
>> [  313.819750][ T3545]  vprintk_emit+0xc9/0x230
>> [  313.870823][ T3545]  _printk+0x5c/0x80
>> [  313.915657][ T3545]  sysctl_err+0x6a/0x90
>> [  313.963610][ T3545]  ? __kmalloc+0x4d/0x150
>> [  314.013639][ T3545]  __register_sysctl_table+0x144/0x7d0
>> [  314.077192][ T3545]  ? kmalloc_trace+0x2a/0xa0
>> [  314.130341][ T3545]  md_init+0xd2/0xff0 [snipped...]
>> [  314.228226][ T3545]  ? __pfx_md_init+0x10/0x10 [snipped...]
>> [  314.333383][ T3545]  do_one_initcall+0x47/0x220
>> [  314.387576][ T3545]  ? kmalloc_trace+0x2a/0xa0
>> [  314.440726][ T3545]  do_init_module+0x60/0x240
>> [  314.493878][ T3545]  __do_sys_finit_module+0xac/0x120
>> [  314.554308][ T3545]  do_syscall_64+0x5d/0x90
>> [  314.605380][ T3545]  ? ksys_lseek+0x66/0xb0
>> [  314.655411][ T3545]  ? syscall_exit_to_user_mode+0x2b/0x40
>> [  314.721042][ T3545]  ? do_syscall_64+0x6c/0x90
>> [  314.774194][ T3545]  ? exit_to_user_mode_prepare+0x142/0x1f0
>> [  314.841906][ T3545]  ? syscall_exit_to_user_mode+0x2b/0x40
>> [  314.907535][ T3545]  ? do_syscall_64+0x6c/0x90
>> [  314.960685][ T3545]  ? exc_page_fault+0x71/0x160
>> [  315.015917][ T3545]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
>> [  315.084667][ T3545] RIP: 0033:0x7fea79f161bd
>> The last NULL element in raid_table[] is necessary, after reverting =
this
>=20

Hi Kuai,

> Based on commit message, avoid last NULL element is exactly what [1]
> did, if this is not true, can you explame more how sysctl_err() is
> called from md_init()? I can't find this by code review, and I think
> maybe it's better to fix this in sysctl error path.
>=20

I feel you are right! The test was based on a backport of stable tree, =
and the register_sysctl() related code was not included.
After look at the changes of sysctl, I feel the oops should go away =
after taking the sysctl changes.

Thanks, and please ignore the noise.

Coly Li

[snipped]=
