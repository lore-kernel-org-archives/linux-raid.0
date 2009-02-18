From: Jeff Rippy <jrippy@gmail.com>
Subject: raid 5 to 50 conversion
Date: Wed, 18 Feb 2009 09:28:07 -0600
Message-ID: <de6d3ea90902180728k1ba70cadg48f91ad8bdbfc195@mail.gmail.com>
References: <de6d3ea90902180726i2911b1dcm384cc1c507030d23@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <de6d3ea90902180726i2911b1dcm384cc1c507030d23@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I thought of this one day and was wondering if it is even possible, so
here goes.
Disclaimer: I have no system that I actually want to do this on, it
was merely a hypothetical thought

Let's say I have a working 4 drive raid-5 array and I want to add 4
more drives of the same capacity and convert it to raid 50.
So I assume first I would set up the new blank array as a raid 5 then
setup stripping across the 2 raid sets.
Now I think the raid 0 setup would tell me to initialize everything
but I was thinking that raid 5 reshapes the arrays and stripes when
you modify it (add/grow a drive) so why couldn't that same algorithm
be applied in this scenario.

Again, this was just a hypothetical.
I doubt its possibly right now (maybe I'll be surprised) but then
again maybe it will inspire one of you to actually make this possible
in the future.

Jeff
