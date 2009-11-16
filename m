From: Christopher Chen <muffaleta@gmail.com>
Subject: Re: raid10 layout for 2xSSDs
Date: Mon, 16 Nov 2009 08:08:49 -0800
Message-ID: <7bc80d500911160808o4ca4d335gdeeb50fff61b2149@mail.gmail.com>
References: <1258381745.31633.35.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1258381745.31633.35.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Kasper Sandberg <postmaster@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Nov 16, 2009 at 6:29 AM, Kasper Sandberg <postmaster@metanurb.dk> wrote:
> Hello.
>
> I've been wanting to create a raid10 array of two SSDs, and I am
> currently considering the layout.
>
> As i understand it, near layout is similar to raid1, and will only
> provide a speedup if theres 2 reads at the same time, not a single
> sequential read.
>
> so the choice is really between far and offset. As i see it, the
> difference is, that offset tries to reduce the seeking for writing
> compared to far, but that if you dont consider the seeking penalty,
> average sequential write speed across the entire array should be roughly
> the same with offset and far, with offset perhaps being a tad more
> "stable", is this a correct assumption? if it is, that would mean offset
> provides a higher "garantueed" speed than far, but with a lower maximum
> speed.

Do you plan to have more than two devices in the array? Raid 10 isn't
magic. If you don't have more than do devices, I suppose your seek
time might be half for reads (and higher for writes), but you won't be
able to do any striping.

I'm a bit confused as to the number of people popping in recently
wanting to run raid 10 on two disk "arrays".

cc

-- 
Chris Chen <muffaleta@gmail.com>
"The fact that yours is better than anyone else's
is not a guarantee that it's any good."
-- Seen on a wall
