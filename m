From: Neil Brown <neilb@suse.de>
Subject: Re: mismatch_cnt questions - how about raid10?
Date: Mon, 12 Mar 2007 16:35:35 +1100
Message-ID: <17908.59047.688420.79050@notabene.brown>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
	<17898.45673.573800.56474@notabene.brown>
	<bb145bd20703040401h413d996av24d55eb21fae63a8@mail.gmail.com>
	<17899.17901.429001.702653@notabene.brown>
	<45ED3CB1.8070003@rabbit.us>
	<17901.16476.282987.982971@notabene.brown>
	<45ED48DB.6030002@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter Rabbitson on Tuesday March 6
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday March 6, rabbit@rabbit.us wrote:
> > 
> 
> I see. So basically for those of us who want to run swap on raid 1 or 
> 10, and at the same time want to rely on mismatch_cnt for early problem 
> detection, the only option is to create a separate md device just for 
> the swap. Is this about right?

Though it is less likely, a regular filesystem could still (I think)
genuinely write different data to difference devices in a raid1/10.

So relying on mismatch_cnt for early problem detection probably isn't
really workable.

And I think that if a drive is returning bad data without signalling
an error, then you are very much into the 'late' side of problem
detection.

I see the 'check' and 'repair' functions mostly as valuable for the
fact that they read every block and will trigger sleeping bad blocks
early.  If they every find a discrepancy, then it is either perfectly
normal, or something seriously wrong that could have been wrong for a
while.... 

NeilBrown
