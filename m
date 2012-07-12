From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: commit backport request
Date: Fri, 13 Jul 2012 00:28:00 +0300
Message-ID: <CAGRgLy4tBOS1B8raJmxoge1CaWc-18=c_fMe6E_oCqa1ntSHzQ@mail.gmail.com>
References: <20120709140230.3cf926ec@notabene.brown>
	<20120711220740.GE10930@kroah.com>
	<20120712141422.05809022@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120712141422.05809022@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
Is there any indication that can tell I am hitting this particular issue?
I think I hit something similar to that once, IOs were hang within a
raid5 and not returning. I issues w > sysrq-trigger and also have most
of the procfs/<pid> info, so is there something I can look at to
confirm?



On Thu, Jul 12, 2012 at 7:14 AM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 11 Jul 2012 15:07:40 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:
>
>> On Mon, Jul 09, 2012 at 02:02:30PM +1000, NeilBrown wrote:
>> >
>> > Hi Mr Stable,
>> >
>> >  please apply patch
>> >
>> > commit fab363b5ff502d1b39ddcfec04271f5858d9f26e
>> > Author: Shaohua Li <shli@kernel.org>
>> > Date:   Tue Jul 3 15:57:19 2012 +1000
>> >
>> >     raid5: delayed stripe fix
>> >
>> >
>> > to 3.4.y and 3.2.y.
>> >
>> > It fixes a deadlock in RAID5 which can cause all IO to hang.
>> > It has been demonstrated to fix a real-life problem (the race is not
>> > theoretical).
>>
>> Is it also needed for 3.0.x?  It seems to apply there just fine.
>
> Yes it is.  Don't know why I missed that.
> I see you've already included it - thanks.
>
> NeilBrown
