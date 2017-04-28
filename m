From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Recover array after I panicked
Date: Fri, 28 Apr 2017 11:52:52 +0200
Message-ID: <20170428095252.GA3793@metamorpher.de>
References: <20170424133946.GA7057@metamorpher.de>
 <727eeaf5-b856-305d-99b6-e42f3383b699@powerlamerz.org>
 <20170425001614.GA3936@metamorpher.de>
 <CAHKno4A7umuNBUPaHk0vmgj2fnjPgBi2oZJWidhKKaRX7ekgKA@mail.gmail.com>
 <20170425090122.GA4488@metamorpher.de>
 <CAHKno4AuKNxYiMazUy+hRJ2kJCdNNYw5L0uExvWc_52Ocn5V=g@mail.gmail.com>
 <20170425110807.GA5159@metamorpher.de>
 <5c3f7876-1b25-7020-5e7d-01776e7c9903@powerlamerz.org>
 <20170427231242.GA5138@metamorpher.de>
 <CAHKno4DBXT5n7wYosie_WHBhzXnHj0CFkdjv7_VAN2NVF-Ng4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHKno4DBXT5n7wYosie_WHBhzXnHj0CFkdjv7_VAN2NVF-Ng4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Patrik =?iso-8859-1?Q?Dahlstr=F6m?= <risca@powerlamerz.org>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 28, 2017 at 09:11:45AM +0200, Patrik Dahlström wrote:
> Is it missing a 'skip=<offset/1M>'  here?

In this example the offset is provided by the loop devices.

If you don't like loop devices you can use seek=X skip=X (same X)
but you should triple check the offset is correct, data at this 
offset should be identical on both arrays. (What my example 
checks using `cmp` which should return differ at byte xxxxxxxxx. 
Have a look at it with hexdump too so it's not just zeroes...)

Regards
Andreas Klauer
