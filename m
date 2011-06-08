From: Namhyung Kim <namhyung@gmail.com>
Subject: Re: [PATCH/RFC] md/raid10: optimize read_balance() for 'far copies' arrays
Date: Wed, 08 Jun 2011 16:42:27 +0900
Message-ID: <877h8w93bw.fsf@gmail.com>
References: <1307516445-3208-1-git-send-email-namhyung@gmail.com>
	<20110608172157.4d6ac2a8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110608172157.4d6ac2a8@notabene.brown> (NeilBrown's message of
	"Wed, 8 Jun 2011 17:21:57 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:

> On Wed,  8 Jun 2011 16:00:45 +0900 Namhyung Kim <namhyung@gmail.com> wrote:
>
>> If @conf->far_offset > 0, there is only 1 stripe so that we can treat
>> the array same as 'near' arrays. Furthermore we could calculate new
>> distance from the previous position even for the real 'far' array
>> cases if the position of given disk is already in the lowest stripe.
>> 
> I agree that it still make sense to to balancing if far_offset != 0.
> However  there is absolutely no point in your change to the calculation of
> new_distance.
> You only wont new_distance to contain a distance from head position if we
> want to choose the device with the 'closest' head.  But we don't.  We want to
> choose the device were the data is closest to the start of the device.  So
> the current value for new_distance is correct.
>

Still can't understand why we choose the closest-to-the-start disk in
case we could have possible sequencial access on other disk. Probably
because of the lack of my understanding how md/disk works :(


> If you would like to resubmit with just the first change I'll happily apply
> the patch.
>

OK. Will do that right soon.


> If you have performed some tests and can demonstrate some cases where this
> makes something faster, and can show us the results of those tests, I would
> be even more happy!!!
>

I wish I could. :) However, unfortunately, I don't have such a real system
to test on.

Thanks.

