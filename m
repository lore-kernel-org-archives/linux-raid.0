From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [ANNOUNCE][PATCH 2.6] md: persistent (file-backed) bitmap and
 async writes
Date: Tue, 06 Jul 2004 10:52:16 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40EABCA0.4070007@steeleye.com>
References: <40198E85.29EBC8E0@SteelEye.com>	<16422.62911.755570.855200@notabene.cse.unsw.edu.au>	<4027E342.D02202F1@SteelEye.com>	<16424.8182.876520.280031@notabene.cse.unsw.edu.au>	<402D3A86.97CF894F@SteelEye.com>	<16456.2775.641721.204171@notabene.cse.unsw.edu.au>	<4048F9AA.1BBD67F@SteelEye.com>	<406B1024.7BF88C@SteelEye.com>	<16528.49083.998593.199805@cse.unsw.edu.au>	<40C6273B.2060200@steeleye.com> <16590.38597.170409.499394@cse.unsw.edu.au> <40D9FA9E.9010003@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40D9FA9E.9010003@steeleye.com>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org, ptb@it.uc3m.es, mingo@redhat.com, "james.bottomley" <james.bottomley@steeleye.com>
List-Id: linux-raid.ids

Paul Clements wrote:
> Hi Neil,
> 
> Here's the next round of patches:
> 
> kernel patch against 2.6.7:
> --------------------------
> http://www.parisc-linux.org/~jejb/md_bitmap/md_bitmap_2_32_2_6_7.diff

A quick note for anyone who is interested: this patch misses the 
poolinfo structure changes that were made to raid1 between 2.6.6 and 
2.6.7. Unfortunately, the mempool interfaces use casts from void *, so 
this wasn't caught by the compiler. Trivial changes need to be made to 
r1bio_pool_free for the code to work with 2.6.7.

Thanks,
Paul
