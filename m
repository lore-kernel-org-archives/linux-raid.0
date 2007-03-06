From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: mismatch_cnt questions - how about raid10?
Date: Tue, 06 Mar 2007 11:04:33 +0100
Message-ID: <45ED3CB1.8070003@rabbit.us>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<bb145bd20703040401h413d996av24d55eb21fae63a8@mail.gmail.com> <17899.17901.429001.702653@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17899.17901.429001.702653@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> When we write to a raid1, the data is DMAed from memory out to each
> device independently, so if the memory changes between the two (or
> more) DMA operations, you will get inconsistency between the devices.

Does this apply to raid 10 devices too? And in case of LVM if swap is on 
top of a LV which is a part of a VG which has a single PV as the raid 
array - will this happen as well? Or will the LVM layer take the data 
once and distribute exact copies of it to the PVs (in this case just the 
raid) effectively giving the raid array invariable data?
