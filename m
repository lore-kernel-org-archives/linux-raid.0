Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A7D419D078
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 13:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731332385; cv=none; b=MQJfPEcC7UV+hRBL86mX0Fh4R58sy0kjMHWljTPonmYVbAChZPa+ogGmRHLDWV2VE08qG5/ArbwDwx6ezaNqzJXnAkbp9AjR2JOZvfEHneVUunhMs3hJMfw2pCDbSMPeSXX6/8iKNmubyfYOzFTHvJBFnvBZYc5fMK4R0ntjgMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731332385; c=relaxed/simple;
	bh=wnNuGCiIOcPisvgcPeOsG2VhFCAM92kS8lO7T7kHUS4=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=dkR8cxWmbHBnuOFkxsVSK/Jyu1gpFx1k0KLcb7H8WKAx41Q7WpFsvBHNdg9g3CKS2oIreNgWDq/wgFShhmZ8VPBjDy3z0c8jdEPDLQaS5My4o+INcXGhFgc4w5Rici9UZMNk7kbUVA/XG/tR1sjAVTU55zORESaSdYNTX9xb66U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xn9d41Xrsz4f3jrm
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 21:39:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 615011A0568
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 21:39:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4cYCTJnTEP1BQ--.22753S3;
	Mon, 11 Nov 2024 21:39:38 +0800 (CST)
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Haris Iqbal <haris.iqbal@ionos.com>, Xiao Ni <xni@redhat.com>,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>,
 linux-raid@vger.kernel.org, Jinpu Wang <jinpu.wang@ionos.com>,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
 <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com>
Date: Mon, 11 Nov 2024 21:39:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4cYCTJnTEP1BQ--.22753S3
X-Coremail-Antispam: 1UD129KBjvJXoWxGr1DJF4rWF1rArW8ZrW8WFg_yoW5Zr1rpr
	yUKr43Grs5K343Jr47tw4Uu3W7Gw4kZFsrJr4xJFyxZFW8Z3srtr17JF4UK3sxJr4rW343
	J3WkXrWUtrn8JaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26ryj6F1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kI
	c2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7V
	AKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCj
	r7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6x
	IIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAI
	w20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x
	0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd-B_UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/11 21:29, Haris Iqbal 写道:
> Hello,
> 
> I gave both the patches a try, and here are my findings.
> 

Thanks for the test!

> With the first patch by Yu, I did not see any hang or errors. I tried
> a number of bitmap chunk sizes, and ran fio for few hours, and there
> was no hang.

This is good news! However, there is still a long road for my approch
to land, this requires a lot of other changes to work.
> 
> With the second patch Xiao, I hit the following BUG_ON on the first
> minute of my fio run.

This is sad. :(
> 
> [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> loaded Not tainted 6.11.5-storage
> #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/2021
> [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]

Can you provide the addr2line of this?

gdb raid456.ko
list *(__add_stripe_bio+0x23f)

Thanks,
Kuai
> [  113.905232] Code: 29 ff ff ff 41 8b 84 24 80 01 00 00 83 c0 01 89
> 45 54 f0 80 4d 49 02 e9 11 ff ff ff 45 85 c0 0f 84 4e fe ff ff e9 31
> ff ff ff <0f
> [  113.906352] RSP: 0018:ffffb5d30ed27aa0 EFLAGS: 00010006
> [  113.906661] RAX: ffff992cb9549818 RBX: 0000000000000000 RCX: 0000000000000001
> [  113.907086] RDX: ffff992c989c3158 RSI: ffff992c989c3a58 RDI: 0000000000000000
> [  113.907511] RBP: ffff991d19e923a0 R08: 0000000000000000 R09: 0000000000000160
> [  113.907936] R10: 0000000000000007 R11: ffffb5d30ed27b70 R12: ffff991d0854b800
> [  113.908361] R13: 0000000000000001 R14: ffff991d19e92718 R15: 0000000000000001
> [  113.908786] FS:  0000000000000000(0000) GS:ffff993c3fc80000(0000)
> knlGS:0000000000000000
> [  113.909267] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  113.909609] CR2: 00007f21b85473d8 CR3: 000000145d82c001 CR4: 00000000001706f0
> [  113.910034] Call Trace:
> [  113.910181]  <TASK
> [  113.910304]  ? die+0x36/0x90
> [  113.910478]  ? do_trap+0xdd/0x100
> [  113.910675]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.910979]  ? do_error_trap+0x65/0x80
> [  113.911200]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.911503]  ? exc_invalid_op+0x50/0x70
> [  113.911731]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.912033]  ? asm_exc_invalid_op+0x1a/0x20
> [  113.912283]  ? __add_stripe_bio+0x23f/0x250 [raid456]
> [  113.912586]  raid5_make_request+0x35f/0x1210 [raid456]
> [  113.912896]  ? submit_bio_noacct+0x47/0x4c0
> [  113.913145]  ? __pfx_woken_wake_function+0x10/0x10
> [  113.913430]  ? bio_split_rw+0x143/0x290
> [  113.913659]  md_handle_request+0x156/0x270
> [  113.913905]  __submit_bio+0x15c/0x1f0
> [  113.914126]  submit_bio_noacct_nocheck+0x19a/0x3c0
> [  113.914412]  ? submit_bio_noacct+0x47/0x4c0
> [  113.914662]  rnbd_srv_rdma_ev+0x501/0xf70 [rnbd_server]
> [  113.914976]  ? rtrs_post_recv_empty+0x5d/0x80 [rtrs_core]
> [  113.930375]  process_io_req+0x169/0x4e0 [rtrs_server]
> [  113.945660]  __ib_process_cq+0x7b/0x170 [ib_core]

