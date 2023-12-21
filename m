Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E64C8C01
	for <linux-raid@vger.kernel.org>; Thu, 21 Dec 2023 04:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gpkSYwtb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6IawB2DN";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="gpkSYwtb";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="6IawB2DN"
Received: from studio.lan (unknown [10.149.192.130])
	by smtp-out1.suse.de (Postfix) with ESMTP id 256A8220D5;
	Thu, 21 Dec 2023 04:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703134171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Agoo+sdSFiHgwEWyvcqoL63Anj3TKxeTF6PK3zNQIG0=;
	b=gpkSYwtb8ls0Kz+RoZerY+X49szueZMcsjdZiZKCwD0NdsPoB2/sR3tHO2HEyQHkkER4Bd
	oxguMG3oswft6Avlp4cMv18mDXlwqnEjZ3+0I0SRGexCRy6vBjQbroFUzx46DYJMXmnkEA
	nqPaUdpfEVMMh/PW0Ce+HYawrOS6+Ew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703134171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Agoo+sdSFiHgwEWyvcqoL63Anj3TKxeTF6PK3zNQIG0=;
	b=6IawB2DN7NBYQ0aJXlhpFmASi587AmgAotyZGnRT0ZoV+mejzaJslB4J/fLqDr4DUdfkmy
	rqtRJJoFs2wyoUBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1703134171; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Agoo+sdSFiHgwEWyvcqoL63Anj3TKxeTF6PK3zNQIG0=;
	b=gpkSYwtb8ls0Kz+RoZerY+X49szueZMcsjdZiZKCwD0NdsPoB2/sR3tHO2HEyQHkkER4Bd
	oxguMG3oswft6Avlp4cMv18mDXlwqnEjZ3+0I0SRGexCRy6vBjQbroFUzx46DYJMXmnkEA
	nqPaUdpfEVMMh/PW0Ce+HYawrOS6+Ew=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1703134171;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Agoo+sdSFiHgwEWyvcqoL63Anj3TKxeTF6PK3zNQIG0=;
	b=6IawB2DN7NBYQ0aJXlhpFmASi587AmgAotyZGnRT0ZoV+mejzaJslB4J/fLqDr4DUdfkmy
	rqtRJJoFs2wyoUBA==
From: Coly Li <colyli@suse.de>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org,
	Coly Li <colyli@suse.de>,
	Joel Granados <j.granados@samsung.com>,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] Revert "raid: Remove now superfluous sentinel element from ctl_table array"
Date: Thu, 21 Dec 2023 12:49:25 +0800
Message-Id: <20231221044925.10178-1-colyli@suse.de>
X-Mailer: git-send-email 2.39.3 (Apple Git-145)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: ***
X-Spam-Score: 3.70
X-Spamd-Result: default: False [3.70 / 50.00];
	 ARC_NA(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 RCPT_COUNT_FIVE(0.00)[5];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 RCVD_COUNT_ZERO(0.00)[0];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+]
X-Spam-Flag: NO

This reverts commit dd6291c506490c195620b394dc96763675e7e5f4.

With this patch, a kernel oops triggered when creating a md device,
[  311.224353][ T3545] BUG: unable to handle page fault for address: 000003e800030d40
[  311.314951][ T3545] #PF: supervisor read access in kernel mode
[  311.384748][ T3545] #PF: error_code(0x0000) - not-present page
[  311.454538][ T3545] PGD 12be1c067 P4D 0
[  311.501451][ T3545] Oops: 0000 [#1] PREEMPT SMP NOPTI
[  311.561888][ T3545] CPU: 19 PID: 3545 Comm: modprobe [snipped...]
[  311.869958][ T3545] RIP: 0010:string+0x48/0xe0
[  311.923116][ T3545] Code: 3b 45 89 d1 45 31 c0 49 01 f9 66 45 85 d2 75 1a eb 1f 48 39 f7 73 02 88 07 48 83 c7 01 41 83 c0 01 48 83 c2 01 4c 39 cf 74 07 <0f> b6 02 84 c0 75 e1 48 89 f2 44 89 c6 e9 c6 e3 ff ff 48 c7 c0 3d
[  312.156194][ T3545] RSP: 0018:ffa000000b877a70 EFLAGS: 00010086
[  312.227025][ T3545] RAX: 000003e80002fd40 RBX: ffa000000b877b86 RCX: ffff0a00ffffff04
[  312.320737][ T3545] RDX: 000003e800030d40 RSI: ffa000000b877b68 RDI: ffa000000b877b86
[  312.414449][ T3545] RBP: ffa000000b877b48 R08: 0000000000000000 R09: ffa000010b877b85
[  312.508160][ T3545] R10: ffffffffffffffff R11: 0000000000000040 R12: ffa000000b877b68
[  312.601873][ T3545] R13: ffffffff99c221fa R14: 0000000000000008 R15: ffffffff99c221fa
[  312.695583][ T3545] FS:  00007fea7a856740(0000) GS:ff11000fffd80000(0000) knlGS:0000000000000000
[  312.800733][ T3545] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  312.877805][ T3545] CR2: 000003e800030d40 CR3: 0000000123790001 CR4: 0000000000771ee0
[  312.971518][ T3545] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  313.065229][ T3545] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  313.158940][ T3545] PKRU: 55555554
[  313.199610][ T3545] Call Trace:
[  313.237162][ T3545]  <TASK>
[  313.270554][ T3545]  ? __die+0x23/0x70
[  313.315391][ T3545]  ? page_fault_oops+0x14d/0x490
[  313.372701][ T3545]  ? update_load_avg+0x7e/0x7d0
[  313.428972][ T3545]  ? exc_page_fault+0x71/0x160
[  313.484203][ T3545]  ? asm_exc_page_fault+0x26/0x30
[  313.542555][ T3545]  ? string+0x48/0xe0
[  313.588426][ T3545]  vsnprintf+0x2d5/0x5a0
[  313.637417][ T3545]  vprintk_store+0x15e/0x4b0
[  313.690567][ T3545]  ? schedule_timeout+0x147/0x160
[  313.748918][ T3545]  ? wait_for_completion_killable+0x1a6/0x1d0
[  313.819750][ T3545]  vprintk_emit+0xc9/0x230
[  313.870823][ T3545]  _printk+0x5c/0x80
[  313.915657][ T3545]  sysctl_err+0x6a/0x90
[  313.963610][ T3545]  ? __kmalloc+0x4d/0x150
[  314.013639][ T3545]  __register_sysctl_table+0x144/0x7d0
[  314.077192][ T3545]  ? kmalloc_trace+0x2a/0xa0
[  314.130341][ T3545]  md_init+0xd2/0xff0 [snipped...]
[  314.228226][ T3545]  ? __pfx_md_init+0x10/0x10 [snipped...]
[  314.333383][ T3545]  do_one_initcall+0x47/0x220
[  314.387576][ T3545]  ? kmalloc_trace+0x2a/0xa0
[  314.440726][ T3545]  do_init_module+0x60/0x240
[  314.493878][ T3545]  __do_sys_finit_module+0xac/0x120
[  314.554308][ T3545]  do_syscall_64+0x5d/0x90
[  314.605380][ T3545]  ? ksys_lseek+0x66/0xb0
[  314.655411][ T3545]  ? syscall_exit_to_user_mode+0x2b/0x40
[  314.721042][ T3545]  ? do_syscall_64+0x6c/0x90
[  314.774194][ T3545]  ? exit_to_user_mode_prepare+0x142/0x1f0
[  314.841906][ T3545]  ? syscall_exit_to_user_mode+0x2b/0x40
[  314.907535][ T3545]  ? do_syscall_64+0x6c/0x90
[  314.960685][ T3545]  ? exc_page_fault+0x71/0x160
[  315.015917][ T3545]  entry_SYSCALL_64_after_hwframe+0x72/0xdc
[  315.084667][ T3545] RIP: 0033:0x7fea79f161bd

The last NULL element in raid_table[] is necessary, after reverting this
patch, the above oops message is removed.

Fixes: dd6291c50649 ("raid: Remove now superfluous sentinel element from ctl_table array")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: Joel Granados <j.granados@samsung.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/md/md.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 9bdd57324c37..90481ed6fdbb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -312,6 +312,7 @@ static struct ctl_table raid_table[] = {
 		.mode		= S_IRUGO|S_IWUSR,
 		.proc_handler	= proc_dointvec,
 	},
+	{ }
 };
 
 static int start_readonly;
-- 
2.35.3

