From: Eric Mei <meijia@gmail.com>
Subject: write barrier in RAID5
Date: Wed, 01 Apr 2015 12:24:38 -0600
Message-ID: <551C37E6.6090201@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I can see how FUA is handled, but REQ_FLUSH seems problematic. My 
understanding of REQ_FLUSH semantics: all requests before the flush 
request must *complete* before the flush request complete. For IO remap 
layer like MD, we need to guarantee all previous requests are 
*submitted* to component devices before submitting the flush request. Is 
that correct?

If so why I don't see the code which make sure the pending write 
requests in stripe cache are processed & submitted before 
submit_flushes() get called? Thanks

Eric
