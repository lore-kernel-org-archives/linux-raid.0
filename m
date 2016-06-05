From: Vikas Aggarwal <vik.reck@gmail.com>
Subject: (unknown)
Date: Sun, 5 Jun 2016 17:58:22 +0530
Message-ID: <CAOid5F-+FSGkOLk-H+50A4s7Op9VSbKD4QBCn=4ue=kVQu+e0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Subject: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello All,

Will appreciate if someone can clear my doubts regarding  XOR/GF
offload for raid5/6.

1) What is the purpose of device_prep_dma_interrupt  callback ?

2) My driver currently polls for checking the xor  completions
 and does'nt implement device_prep_dma_interrupt
callback at all.  What  performance variation  I can expect  by
implementing this callback
in my async_tx driver.

3) Purpose of DMA_ACK as I read - it is  for higher layers to inform
dma driver that descriptors can now be freed. Can someone explain this
with an example as applicable with raid5/6 clients.

4) With example - why dma_run_dependencies(tx) needed  after the
hardware engine posts completion for a descriptor.

5) Purpose of  tx->callback(cb_arg) - again with an example from a
raid5/6 offload perspective.

Goal: I want to use offload engine efficiently with recent
multithreaded raid5/6.

I tried to dig through code and linux/Documentation etc but not
thoroughly clear of functionality.

Thanks & Regards
Vikas Aggarwal
