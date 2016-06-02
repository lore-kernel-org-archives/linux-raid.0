From: Vikas Aggarwal <vik.reck@gmail.com>
Subject: Doubts on async_tx xor offload for raid5/6
Date: Thu, 2 Jun 2016 11:54:45 +0530
Message-ID: <CAOid5F-UWP-_jpA3XMFptfKa8=Gh7wBhhPZ1_DR_5UwJAxHriQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, dmaengine@vger.kernel.org
List-Id: linux-raid.ids

Hi  list,
Will appreciate if someone can clear my doubts with "some theoretical
examples". I am trying to improve XOR/GF offload for a multi-core SoC
(currently it has single XOR/GF  channel).

1) What is the purpose of device_prep_dma_interrupt  callback ?

2) My driver currently polls for posting  xor  completions
(dma_cookie_complete) and does'nt use  device_prep_dma_interrupt
callback at all.  What  gains/loss in terms of  latency/cpu
idleness/WRITE throughput  I can expect  by implementing this callback
in my async_tx driver.

3) Purpose of DMA_ACK as I read - it is  for higher layers to inform
dma driver that descriptors can now be freed. Can someone explain this
with an example as applicable with raid5/6 clients.

4) With example - why dma_run_dependencies(tx) needed  after the
hardware engine post completion for a descriptor.

5) Purpose of  tx->callback(cb_arg) - again with an example from a
raid5/6 offload perspective.

I want to use offload engine efficiently with multithreaded raid5/6.

I tried to dig through dma/drivers, crypto/async_xor.c, online
archives, linux/Documentation etc but could not get satisfactory
answers. Added two mail-lists as saw issues being discussed on both
ones.

Thanks and
Best Regards
Vikas Aggarwal
