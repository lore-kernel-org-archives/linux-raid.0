From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: commit backport request
Date: Mon, 16 Jul 2012 11:59:06 +0300
Message-ID: <CAGRgLy73UuvD0829rbozHmocgw5OUb5uBQjTBBdSzzOF98uHZQ@mail.gmail.com>
References: <20120709140230.3cf926ec@notabene.brown>
	<20120711220740.GE10930@kroah.com>
	<20120712141422.05809022@notabene.brown>
	<CAGRgLy4tBOS1B8raJmxoge1CaWc-18=c_fMe6E_oCqa1ntSHzQ@mail.gmail.com>
	<20120716132300.11fad63c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120716132300.11fad63c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks.
Not sure if this is the issue I saw. I did not see any thread blocked
on get_active_stripe(). In my case "stripe_cache_active" got stuck on
a high value and was never decreased. But some IOs (perhaps on other
stripes?) managed to go through. In addition, in one case, after
several hours(!), somehow the stuck IOs got freed and
stripe_cache_active dropped and everything got back to normal.

Alex.


On Mon, Jul 16, 2012 at 6:23 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 13 Jul 2012 00:28:00 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
> wrote:
>
>> Hi,
>> Is there any indication that can tell I am hitting this particular issue?
>> I think I hit something similar to that once, IOs were hang within a
>> raid5 and not returning. I issues w > sysrq-trigger and also have most
>> of the procfs/<pid> info, so is there something I can look at to
>> confirm?
>
> IO stops, processes get blocked in get_active_stripe().  Increasing
> stripe_cache_size allows a bit more IO through it eventually all fills up
> again.
>
> NeilBrown
>
>>
>>
>>
>> On Thu, Jul 12, 2012 at 7:14 AM, NeilBrown <neilb@suse.de> wrote:
>> > On Wed, 11 Jul 2012 15:07:40 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:
>> >
>> >> On Mon, Jul 09, 2012 at 02:02:30PM +1000, NeilBrown wrote:
>> >> >
>> >> > Hi Mr Stable,
>> >> >
>> >> >  please apply patch
>> >> >
>> >> > commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
>> >> > Author: Shaohua Li <shli@kernel.org>
>> >> > Date:   Tue Jul 3 15:57:19 2012 +1000
>> >> >
>> >> >     raid5: delayed stripe fix
>> >> >
>> >> >
>> >> > to 3.4.y and 3.2.y.
>> >> >
>> >> > It fixes a deadlock in RAID5 which can cause all IO to hang.
>> >> > It has been demonstrated to fix a real-life problem (the race is not
>> >> > theoretical).
>> >>
>> >> Is it also needed for 3.0.x?  It seems to apply there just fine.
>> >
>> > Yes it is.  Don't know why I missed that.
>> > I see you've already included it - thanks.
>> >
>> > NeilBrown
>
