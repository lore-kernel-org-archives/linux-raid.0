From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: 4.1-rc6 radi5 OOPS
Date: Wed, 03 Jun 2015 21:44:06 -0400
Message-ID: <wrfjmw0gl02h.fsf@jes.lga.redhat.com>
References: <wrfjlhg0mtmi.fsf@jes.lga.redhat.com>
	<20150604064048.0cb2d7c9@notabene.brown>
	<wrfjzj4glajs.fsf@jes.lga.redhat.com>
	<20150604081557.55435f13@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150604081557.55435f13@notabene.brown> (NeilBrown's message of
	"Thu, 4 Jun 2015 08:15:57 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>, Xiao Ni <xni@redhat.com>
List-Id: linux-raid.ids

NeilBrown <neilb@suse.de> writes:
> On Wed, 03 Jun 2015 17:57:43 -0400 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>
>> NeilBrown <neilb@suse.de> writes:
>> > On Wed, 03 Jun 2015 16:20:21 -0400 Jes Sorensen <Jes.Sorensen@redhat.com>
>> > wrote:
>> >
>> >> Neil,
>> >> 
>> >> I was running testing on the current 4.1-rc6 tree (Linus' top of trunk
>> >> 8cd9234c64c584432f6992fe944ca9e46ca8ea76) and I am seeing the following
>> >> OOPS which is reproducible.
>> >> 
>> >> It shows up when running the mdadm test suite, 07changelevelintr to be
>> >> specific.
>> >> 
>> >> Is this something you have seen?
>> >> 
>> >> Cheers,
>> >> Jes
>> >> 
>> >> ------------[ cut here ]------------
>> >> kernel BUG at drivers/md/raid5.c:5391!
>> >
>> > No, I haven't seen that.  And I've been running the test suite quite a bit
>> > lately.
>> >
>> > Can you get it to print out the relevant numbers?  Include
>> > readpos/writepos/safepos too.
>> 
>> This enough? Let me know if you need more.
>> 
>> I suspect this started happening with the changes that went in between
>> 4.1-rc5 and 4.1-rc6. I will try to bisect it tomorrow.
>> 
>> Cheers,
>> Jes
>> 
>> mddev->dev_sectors: 0x9800, reshape_sectors: 0x0200 stripe_addr:
>> fffffffffffffdff, sector_nr 0, readpos 511, writepos -513, safepos
>> 512
>
> Those negative numbers look VERY suspicious.
> I'm actually on leave this week so I won't be looking at it any more, but
> I'll see what I can find on Monday.
> Thanks,
> NeilBrown

Thanks - I'll try and dig more into this in the mean time.

Cheers,
Jes
