From: George Duffield <forumscollective@gmail.com>
Subject: Re: Understanding raid array status: Active vs Clean
Date: Sat, 28 Jun 2014 05:01:00 +0200
Message-ID: <CAG__1a7T2atsQ1eQMhR1Wp6xd72fNdyf5XX+kbihRbY1Urd0Ww@mail.gmail.com>
References: <CAG__1a4MRV6gJL38XLAurtoSiD3rLBTmWpcS5HYvPpSfPR88UQ@mail.gmail.com>
	<20140529151658.3bfc97e5@notabene.brown>
	<1C901CF6-75BD-4B54-9F5D-7E2C35633CBC@gmail.com>
	<20140529160623.5b9e37e5@notabene.brown>
	<CAG__1a5j-0O7LOb6opz4MLPCjbxRNDXiaG6W=Xxt3JJ9eXfRRA@mail.gmail.com>
	<CAG__1a5XK1yt70ox_12hLjpBpY=YRcaJ6-MYHiEJ_RTpxFujoA@mail.gmail.com>
	<20140618150326.GA28569@cthulhu.home.robinhill.me.uk>
	<CAG__1a7m2BakDGUtP==YunzmBr8WDXVVv4i2WE=sYhBNKYjM1w@mail.gmail.com>
	<CAG__1a7zGbxzkR_a2ci4rw3xacxGYt07aBiAsFjGPYowXBPCcQ@mail.gmail.com>
	<CAG__1a4kX1gM+ntmcLkevCm6kwVbgSMGmPi-ec6+b1RGKznouw@mail.gmail.com>
	<20140623120102.7d85ac52@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140623120102.7d85ac52@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> > changing the value to 0.500:
>> > # echo 0.503 > /sys/block/md0/md/safe_mode_delay
>> >
>> > makes no difference to the array state.
>
> What if you write a smaller number?  e.g. 0.1

No change to array state.

> What does /sys/block/md0/md/array_state show?

Funnily enough, it shows Clean
