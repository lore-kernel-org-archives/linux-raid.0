From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 14:25:09 +0100
Message-ID: <87eimv6oga.fsf@frosties.localdomain>
References: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com> (Leslie Rhorer's
	message of "Wed, 16 Dec 2009 02:06:09 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: "'Majed B.'" <majedb@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Leslie Rhorer" <lrhorer@satx.rr.com> writes:

>> Have you made sure that the value of
>> /proc/sys/dev/raid/speed_limit_min is high enough? (200000 means 200
>
> High enough?  Wouldn't a higher speed limit mean more stress on the systems?
> Its value is 1000.

A higher min value will block more normal IO (if there is
any). Raising min is usefull to ensure the job gets done in a certain
time, to not let normal IO slow down a rebuild too much.

>> MB/s) along with /proc/sys/dev/raid/speed_limit_max?
>
> It's 200,000

I only ever had to tune this once when too much IO would deadlock an
external enclosure. Otherwise keep this really high so it uses all
idle IO there is.



As to your initial question: Being able to keep the filesystem mounted
and used is the whole point of having online growing of the raid
system. If that weren't save then there would be no point to it as you
could just as well stop the raid if you already umounted it and grow
it offline.

MfG,
        Goswin
