From: hank peng <pengxihan@gmail.com>
Subject: OOPS on MPC8548 board when writing RAID5 array
Date: Tue, 10 Nov 2009 19:44:46 +0800
Message-ID: <389deec70911100344j5969e834nc80a9fd330935ef3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxppc-dev@ozlabs.org, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

CPU is MPC8548, kernel version is 2.6.31.5,CONFIG_FSL_DMA and
CONFIG_ASYNC_TX_DMA options are all enabled.
#mdadm -C /dev/md0 --assume-clean -l5 -n3 /dev/sd{a,b,c}
#dd if=/dev/zero of=/dev/md0 bs=1M count=1000
Oops: Exception in kernel mode, sig: 5 [#1]
MPC85xx CDS
Modules linked in:
NIP: c01c45d8 LR: c01c4d48 CTR: 00000000
REGS: c2dd5c80 TRAP: 0700   Not tainted  (2.6.31.5)
MSR: 00029000 <EE,ME,CE>  CR: 22004028  XER: 00000000
TASK = e820a580[3804] 'md0_raid5' THREAD: c2dd4000
GPR00: 00000001 c2dd5d30 e820a580 c2fb1088 00000001 00000000 00000002 00001000
GPR08: 00000001 c0485a20 00000000 ef8092f8 22002024 55555555 c2d67870 c0282d2c
GPR16: 00001000 e8355c00 c2eff964 00000000 00000000 00000019 01000040 c2dd5e00
GPR24: c2dd5dfc 00000001 c2dd5dc0 c099c420 00000000 c2d67838 00000002 c2dd5d58
NIP [c01c45d8] async_tx_quiesce+0x28/0x74
LR [c01c4d48] async_xor+0x208/0x350
Call Trace:
[c2dd5d30] [c02a80f8] fsl_dma_alloc_descriptor+0x24/0x70 (unreliable)
[c2dd5d40] [c01c4d48] async_xor+0x208/0x350
[c2dd5db0] [c02839ec] ops_run_postxor+0xfc/0x1c0
[c2dd5df0] [c0284700] handle_stripe5+0xb24/0x15c0
[c2dd5e70] [c02864c8] handle_stripe+0x34/0x12d4
[c2dd5f10] [c02879ac] raid5d+0x244/0x458
[c2dd5f70] [c02938d4] md_thread+0x5c/0x124
[c2dd5fc0] [c004cc9c] kthread+0x78/0x7c
[c2dd5ff0] [c000f50c] kernel_thread+0x4c/0x68
Instruction dump:
7c0803a6 4e800020 9421fff0 7c0802a6 93e1000c 7c7f1b78 90010014 80630000
2f830000 419e0034 80030004 5400fffe <0f000000> 480e19b1 2f830002 419e0030

I checked the kernel source code, and find that this OOPS was caused
by the following BUG_ON code:
It is in crypto/async_tx/async_tx.c:
void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
{
        if (*tx) {
                /* if ack is already set then we cannot be sure
                 * we are referring to the correct operation
                 */
                BUG_ON(async_tx_test_ack(*tx));
   /* OOPS occured */
                if (dma_wait_for_async_tx(*tx) == DMA_ERROR)
                        panic("DMA_ERROR waiting for transaction\n");
                async_tx_ack(*tx);
                *tx = NULL;
        }
}


-- 
The simplest is not all best but the best is surely the simplest!
