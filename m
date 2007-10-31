From: Yuri Tikhonov <yur@emcraft.com>
Subject: Bug in processing dependencies by async_tx_submit() ?
Date: Wed, 31 Oct 2007 20:21:46 +0400
Message-ID: <200710311921.46609.yur@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Dan Williams <dan.j.williams@gmail.com>, Neil Brown <neilb@suse.de>, Wolfgang Denk <wd@denx.de>, Detlev Zundel <dzu@denx.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


 Hello Dan,

 I've run into a problem with the h/w accelerated RAID-5 driver (on the 
ppc440spe-based board). After some investigations I've come to conclusion 
that the issue is with the async_tx_submit() implementation in ASYNC_TX.

 Let's we have the following 3 dependent operations: OP1, OP2, OP3. The OP1 
operation has to be run on one, DMA0, channel, OP2 and OP3 operations have to 
be run on another, DMA1, channel. OP2 has to be run after completion of OP1, 
OP3 - after completion of OP2. I. e. :

 OP1 (DMA0) <--- OP2 (DMA1) <--- OP3 (DMA1).

 With the current implementation of async_tx_submit() we have the following 
picture when we sequentially call async_tx_submit() to submit these 3 
operations:

- the OP2 operation will *not be* submitted to the h/w channel, but, because 
of the (OP1->chan != OP2->chan) condition, will be put to depend_list of OP1; 
and it's RIGHT;

- the OP3 operation will *be* submitted to the h/w channel, because OP2 & OP3 
do not conform the (OP2->chan != OP3->chan) condition. Thus OP3 will be put 
to the h/w channel *before* its parent, OP2; and it's WRONG.

 It looks more logical for me to check in async_tx_submit() - does the dep_tx 
operation (on which the current tx operation is dependent on) depend on some 
other operation itself. If dep_tx depends on some other operation then, 
regardless of the channel on which tx has to be run, we should not put tx to 
the h/w but bind it to depend_list of dep_tx instead. Why there are no such 
algorithms in async_tx_submit() ?

 As far as the RAID-5 h/w accelerated driver is concerned this means that with 
the current implementation of async_tx_submit(), for example, the (PREXOR + 
BIODRAIN) combination works incorrectly for the cases when BIODRAIN is split 
into a sequence of MEMCPY operations and there are two different channels for 
XOR and COPY operations: only one, the first, MEMCPY will wait until 
completion of PREXOR, but all the others MEMCPYs of this BIODRAIN will be put 
into the h/w channel right away. Is it correct ? I think - not.

 Regards, Yuri

-- 
Yuri Tikhonov, Senior Software Engineer
Emcraft Systems, www.emcraft.com
