From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: mismatch_cnt questions
Date: Sun, 4 Mar 2007 13:01:05 +0100
Message-ID: <bb145bd20703040401h413d996av24d55eb21fae63a8@mail.gmail.com>
References: <bb145bd20703040322g1e5e8784i93a933c0c61b43f6@mail.gmail.com>
	 <17898.45673.573800.56474@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17898.45673.573800.56474@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey, that was quick ... thanks!

> > 1) Where does the mismatch come from? The box hasn't been down since the creation of
> >  the array.
>
> Do you have swap on the mirror at all?

As a matter of fact I do, /dev/md0_p2 is a swap partition.

> I recently discovered/realised that when 'swap' writes to a raid1 it can end up with different
> data on the different devices.  This is perfectly acceptable as in that case the data will never
> be read.

Interesting ... care to elaborate a little?

Would disabling swap, running mkswap again and rerunning check return
0 in this case?

Regards,

C.
