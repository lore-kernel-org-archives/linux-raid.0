From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Was: [RFC PATCH 2.6.23.1] md: add dm-raid1 read balancing
Date: Thu, 08 Nov 2007 20:43:35 +0100
Message-ID: <87mytoseu0.fsf@informatik.uni-tuebingen.de>
References: <1194084522.1353.10.camel@localhost>
	<87fxziju0z.fsf@informatik.uni-tuebingen.de>
	<1194520008.17369.19.camel@localhost>
	<87prykaeh6.fsf@informatik.uni-tuebingen.de>
	<20071108120625.7e0572b1@bree.surriel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071108120625.7e0572b1@bree.surriel.com> (Rik van Riel's
	message of "Thu, 8 Nov 2007 12:06:25 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Rik van Riel <riel@redhat.com>
Cc: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>, konstantin.sharlaimov@gmail.com, linux-raid <linux-raid@vger.kernel.org>, "; Ingo Molnar" <mingo@redhat.com>, "; Neil Brown" <neilb@suse.de>
List-Id: linux-raid.ids

Rik van Riel <riel@redhat.com> writes:

> On Thu, 08 Nov 2007 17:28:37 +0100
> Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de> wrote:
>
>> Maybe you need more parameter:
>
> Generally a bad idea, unless you can come up with sane defaults (which
> do not need tuning 99% of the time) or you can derive these parameters
> automatically from the RAID configuration (unlikely with RAID 1?).
>
> Before turning Konstantin's nice and simple code into something complex,
> it would be good to see benchmark results show that the complexity is
> actually needed.

A default of chunk=1, stripe=1, rotate=0 is what you have now. SO
there is no regression. It is also the right choice for any device
that isn't a (hardware) raid. I don't think 99% of all users have
hardware raid.

For stacked software raids the raid1 modul should detect the
underlying raid and default to values reflecting the raid disk below
(assuming the mirrors have reasonable equal layouts). That would
truely only leave hardware raids to be manually tuned.

MfG
        Goswin
