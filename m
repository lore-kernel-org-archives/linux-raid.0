From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: mismatch_cnt questions - how about raid10?
Date: Mon, 12 Mar 2007 15:26:49 +0100
Message-ID: <45F56329.4000407@rabbit.us>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>	<17898.45673.573800.56474@notabene.brown>	<bb145bd20703040401h413d996av24d55eb21fae63a8@mail.gmail.com>	<17899.17901.429001.702653@notabene.brown>	<45ED3CB1.8070003@rabbit.us>	<17901.16476.282987.982971@notabene.brown>	<45ED48DB.6030002@rabbit.us> <17908.59047.688420.79050@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17908.59047.688420.79050@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tuesday March 6, rabbit@rabbit.us wrote:
 >
> Though it is less likely, a regular filesystem could still (I think)
> genuinely write different data to difference devices in a raid1/10.
> 
> So relying on mismatch_cnt for early problem detection probably isn't
> really workable.
> 
> And I think that if a drive is returning bad data without signalling
> an error, then you are very much into the 'late' side of problem
> detection.

I agree with the later, but my concern is not that much with the cause, 
but with the effect. From past discussion on the list I gather that no 
special effort is made to determine which chunk to take as 'valid', even 
though more than 2 logically identical chunks might be present 
(raid1/10). And you also seem to think that the DMA syndrome might even 
apply to plain fast-changing filesystems, left alone something with 
multiple layers (fs on lvm on raid).
So here is my question: how (theoretically) safe it is to use a raid1/10 
array for something very disk intensive, e.g. a mail spool? How likely 
it is that the effect you described above will creep different blocks 
onto disks, and subsequently will return the wrong data to the kernel? 
Should I look into raid5/6 for this kind of activity, in case both 
uptime and data integrity are my number one priorities, and I am willing 
to sacrifice performance?

Thank you
