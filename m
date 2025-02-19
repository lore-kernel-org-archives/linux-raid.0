Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3EC922AE7B;
	Wed, 19 Feb 2025 19:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739994194; cv=none; b=fWcBLgYsKYXP1KgDw1URGJSLBNQ+ude3MmNZgIi8GY+vNUiA2CnA6Je/NVm9qYaVuywnMVlYeMjfJuzJeJRVvii2SQ0eLkTc1d8m0zjH0Qe4Gl1znHo92maroOK8m+TKT+Vl+couzI0HnFk2n15auL19K2atEU7+ZL8kcC0ew5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739994194; c=relaxed/simple;
	bh=YIpOELEUVURB7qN1oJGE7S1MIfkFeVWHoXtoa5ojiSs=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=rXzfwvdlyBpDUUv6jOxJjZLdHVWvJneDu1m01gTK9gnkpH4SEbw0Ew42ynsdxY4GEVvuIgzB0S8R7JvSxRiOlXOQ5xwuJCuZdIRyia79jAxElLff2T5DgnMkaivzL/YqIW5CpYWBDyPOqYeprV2qcJ6NCxrKrw7dwaE+5b3u5wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org; spf=pass smtp.mailfrom=morinfr.org; dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b=1aVLDQ0Y; arc=none smtp.client-ip=212.27.42.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morinfr.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b="1aVLDQ0Y"
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id 4D2212003B4;
	Wed, 19 Feb 2025 20:43:06 +0100 (CET)
Authentication-Results: smtp2-g21.free.fr;
	dkim=pass (1024-bit key; unprotected) header.d=morinfr.org header.i=@morinfr.org header.a=rsa-sha256 header.s=20170427 header.b=1aVLDQ0Y;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
	Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=GrKJx+/MbEDzZYuWfVXJ+zgryKzj0bF4dQ11RT3nh9w=; b=1aVLDQ0YWuX9ZokA/lP2xriXCr
	GOu68BzMPU0r5YMrHMU+oojmJExheASm2GRDa97TaeXm4Eqt2b9Uz/3VBuo6kiynTrv/hrsmdKrfP
	cgTnAlQrp8bYw1OVXftdY4gq6YmCPSyCuZnie7Y8eLXHm2kJY2Iz5u2ox8IexnSQrDWQ=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.96)
	(envelope-from <guillaume@morinfr.org>)
	id 1tkpyL-004t9q-1g;
	Wed, 19 Feb 2025 20:43:05 +0100
Date: Wed, 19 Feb 2025 20:43:05 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, song@kernel.org, yukuai3@huawei.com,
	guillaume@morinfr.org
Subject: [BUG] possible race between md_free_disk and md_notify_reboot
Message-ID: <Z7Y0SURoA8xwg7vn@bender.morinfr.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello, we experienced the following GPF during a systemd shutdown

[ 1221.198632] systemd-shutdown[1]: Rebooting.                                                                                                                                                                        
[ 1221.602276] md: md0: resync interrupted.                                                                                                                                                                           
[ 1221.604492] general protection fault, probably for non-canonical address 0xdead000000000100: 0000 [#1] SMP NOPTI                                                                                                   
[ 1221.613621] CPU: 87 PID: 1 Comm: systemd-shutdow Kdump: loaded Tainted: G           O       6.6.57 #1                                                                                                       
[ 1221.632201] RIP: 0010:md_notify_reboot+0xe8/0x150                                                                                                                                                                  
[ 1221.635868] Code: c6 58 59 40 b9 4c 89 f7 e8 65 d3 23 00 85 c0 74 08 4c 89 e7 e8 49 3b ff ff 48 c7 c7 58 59 40 b9 e8 ad 0f 28 00 b9 01 00 00 00 <48> 8b 83 d8 03 00 00 48 8d 93 d8 03 00 00 49 89 dc 48 2d d8 03 00
[ 1221.653555] RSP: 0018:ffffa7f200067d28 EFLAGS: 00010202                                                                                                                                                            
[ 1221.657740] RAX: 0000000000001002 RBX: deacfffffffffd28 RCX: 0000000000000001                                                                                                                                      
[ 1221.663829] RDX: ffff8a32cf2c33d8 RSI: ffffffffb9405958 RDI: ffffffffb9405958                                                                                                                                      
[ 1221.669918] RBP: ffffa7f200067d48 R08: 0000000000000000 R09: ffffa7f200067c70                                                                                                                                      
[ 1221.676008] R10: 0000000000000005 R11: 0000000000000057 R12: ffff8a32cf2c3000                                                                                                                                      
[ 1221.682097] R13: ffffffffb9405958 R14: ffff89b356ca0218 R15: ffffffffb8f03620                                                                                                                                      
[ 1221.688186] FS:  00007f6877c24900(0000) GS:ffff8a30bffc0000(0000) knlGS:0000000000000000                                                                                                                           
[ 1221.695226] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033                                                                                                                                                      
[ 1221.699930] CR2: 00007f6877c015a0 CR3: 00000003bb402005 CR4: 0000000000770ee0                                                                                                                                      
[ 1221.706019] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000                                                                                                                                      
[ 1221.712110] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400                                                                                                                                      
[ 1221.718197] PKRU: 55555554                                                                                                                                                                                         
[ 1221.719885] Call Trace:                                                                                                                                                                                            
[ 1221.721311]  <TASK>                                                                                                                                                                                                
[ 1221.722394]  ? show_regs+0x6a/0x80                                                                                                                                                                                 
[ 1221.724772]  ? die_addr+0x38/0xa0                                                                                                                                                                                  
[ 1221.727065]  ? exc_general_protection+0x192/0x2f0                                                                                                                                                                  
[ 1221.730739]  ? asm_exc_general_protection+0x27/0x30                                                                                                                                                                
[ 1221.734589]  ? md_notify_reboot+0xe8/0x150                                                                                                                                                                         
[ 1221.737660]  ? md_notify_reboot+0xe3/0x150                                                                                                                                                                         
[ 1221.740727]  notifier_call_chain+0x5c/0xc0                                                                                                                                                                         
[ 1221.743799]  blocking_notifier_call_chain+0x43/0x60                                                                                                                                                                
[ 1221.747648]  kernel_restart+0x22/0xa0                                                                                                                                                                              
[ 1221.750286]  __do_sys_reboot+0x1a2/0x220                                                                                                                                                                           
[ 1221.753183]  ? vfs_writev+0xd8/0x150                                                                                                                                                                               
[ 1221.755735]  ? __fput+0x198/0x320                                                                                                                                                                                  
[ 1221.758028]  ? do_writev+0x75/0x120                                                                                                                                                                                
[ 1221.760491]  __x64_sys_reboot+0x1e/0x30                                                                                                                                                                            
[ 1221.763304]  x64_sys_call+0x2000/0x2020                                                                                                                                                                            
[ 1221.766114]  do_syscall_64+0x33/0x80                                                                                                                                                                               
[ 1221.768665]  entry_SYSCALL_64_after_hwframe+0x78/0xe2                                                                                                                                                              
[ 1221.772689] RIP: 0033:0x7f68776d0453                                                                                                                                                                               
[ 1221.775258] Code: 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 89 fa be 69 19 12 28 bf ad de e1 fe b8 a9 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 05 c3 0f 1f 40 00 48 8b 15 09 fa 52 00 f7 d8
[ 1221.793040] RSP: 002b:00007ffdfee13e28 EFLAGS: 00000206 ORIG_RAX: 00000000000000a9                                                                                                                                 
[ 1221.799570] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f68776d0453                                                                                                                                      
[ 1221.805666] RDX: 0000000001234567 RSI: 0000000028121969 RDI: 00000000fee1dead                                                                                                                                      
[ 1221.811764] RBP: 00007f6877c247b0 R08: 0000000000000000 R09: 00007ffdfee13230                                                                                                                                      
[ 1221.817862] R10: 00007f6877c247b0 R11: 0000000000000206 R12: 0000000000000000                                                                                                                                      
[ 1221.823960] R13: 00007ffdfee13e90 R14: 00000000ffffffff R15: 0000000000000000                                                                                                                                      
[ 1221.830059]  </TASK>                                        

md_notify_reboot() tried to load a list poison value which triggered the
GPF.  The poison values are set during list_del(&mddev->all_mddevs). The
only call for this list is in mddev_free() called by md_free_disk()
(well it's also called in md_alloc() on failure but it's not relevant
here).  The kdump show all cpus besides the one triggering the GPF to be
idle.  Note that this crash happened on 6.6.x but afaict the related code
is mostly the same in the current tree.

We believe there is a simple race between the list_for_each_entry_safe()
loop in md_notify_reboot() which releases all_mddevs_lock during its
iteration over all_mddevs and mddev_free() which removes the mddev from
this list.
mddev_free() only grabs that lock before calling list_del().  If the
item pointed by the "n" pointer passed to list_for_each_entry_safe() is
removed while we're processing the current item, n->all_mddevs will
contain poisoned values.  Additionally since mddev_free() also frees the
mddev, there might be a possible use-after-free issue as well since
mddev_free() seems to make no attempt to avoid concurrent access to the
mddev.

There seems to be nothing in the code that tries to prevent this
specific race and not being familiar with this code I am not sure what
the right fix would be. In the current state of the code, it does not
seem safe to release all_mddevs_lock if mddev_free() can be called
concurrently.

Please let me know if we're missing anything or can provide some
additional info.

HTH

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
