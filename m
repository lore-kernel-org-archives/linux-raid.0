From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: mismatch_cnt questions - how about raid10?
Date: Tue, 06 Mar 2007 11:56:27 +0100
Message-ID: <45ED48DB.6030002@rabbit.us>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<bb145bd20703040401h413d996av24d55eb21fae63a8@mail.gmail.com>	<17899.17901.429001.702653@notabene.brown>	<45ED3CB1.8070003@rabbit.us> <17901.16476.282987.982971@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17901.16476.282987.982971@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday March 6, rabbit@rabbit.us wrote:
>> Neil Brown wrote:
>>> When we write to a raid1, the data is DMAed from memory out to each
>>> device independently, so if the memory changes between the two (or
>>> more) DMA operations, you will get inconsistency between the devices.
>> Does this apply to raid 10 devices too? And in case of LVM if swap is on 
>> top of a LV which is a part of a VG which has a single PV as the raid 
>> array - will this happen as well? Or will the LVM layer take the data 
>> once and distribute exact copies of it to the PVs (in this case just the 
>> raid) effectively giving the raid array invariable data?
> 
> Yes, it applies to raid10 too.
> 
> I don't know the details of the inner workings of LVM, but I doubt it
> will make a difference.  Copying the data in memory is just too costly
> to do if it can be avoided.  With LVM and raid1/10 it can be avoided
> with no significant cost.
> With raid4/5/6, not copying into the cache can cause data corruption.
> So we always copy.
> 

I see. So basically for those of us who want to run swap on raid 1 or 
10, and at the same time want to rely on mismatch_cnt for early problem 
detection, the only option is to create a separate md device just for 
the swap. Is this about right?
