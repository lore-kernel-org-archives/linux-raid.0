From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Tue, 8 May 2012 08:52:07 -0700
Message-ID: <CABE8wwtZKrerxq4OFGnjUOgjvRb-6FNWdgUkiVwUVuV-uycv6Q@mail.gmail.com>
References: <20120417083552.483324288@kernel.org>
	<20120417084632.306032602@kernel.org>
	<CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
	<20120418062641.000e881c@notabene.brown>
	<4F8E11A6.7090305@kernel.org>
	<20120418144841.04ce1a10@notabene.brown>
	<4F8E5185.8050809@kernel.org>
	<20120418155749.4afae9cb@notabene.brown>
	<4F8E605C.9090803@kernel.org>
	<20120425034307.GA454@kernel.org>
	<20120508101653.GA9757@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120508101653.GA9757@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

On Tue, May 8, 2012 at 3:16 AM, Shaohua Li <shli@kernel.org> wrote:
>> > Writing the parity disk is worse. Discard is to improve the garbage
>> > collection
>> > of SSD firmware, so improve later write performance. While write is bad for
>> > SSD, because SSD can be wear leveling out with extra write and also write
>> > increases garbage collection overhead. So the result of small
>> > discard is data
>> > disk garbage collection is improved but parity disk gets worse and
>> > parity disk
>> > gets fast to end of its life, which doesn't make sense. This is even
>> > worse when
>> > the parity is distributed.
>> Neil,
>> Any comments about the patches?
> ping!
>

So, are we still in the position of needing to degrade individual
stripes to support trim?  Is there any benefit to making this a
temporary condition?  I.e. trim large ranges, including the parity
disk, and then once all the trim sequences have coalesced resync the
stripes that remain only partially trimmed?
