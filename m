From: Anthony Youngman <antlists@youngman.org.uk>
Subject: Re: [BUG] non-metadata arrays cannot use more than 27 component
 devices
Date: Sat, 25 Feb 2017 20:05:34 +0000
Message-ID: <c23b2aca-b6e6-37b8-3238-e59423d8f5a7@youngman.org.uk>
References: <20170224040816.41f2f372.ian_bruce@mail.ru>
 <41ea334c-ae1c-dac6-e1a1-480d3700a588@turmel.org>
 <20170224084024.4dfe83a2.ian_bruce@mail.ru>
 <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1e40da0d-b175-9ff5-d2e5-cf1f25aacc26@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, ian_bruce@mail.ru, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 24/02/17 20:46, Phil Turmel wrote:
> On 02/24/2017 11:40 AM, ian_bruce@mail.ru wrote:
>> On Fri, 24 Feb 2017 10:20:52 -0500 Phil Turmel <philip@turmel.org>
>> wrote:
>>
>>> Considering the existence of --build is strictly to support arrays
>>> that predate MD raid, it seems a bit of a stretch to claim this as
>>> a bug instead of a feature request.
>> quoting from the mdadm manual page:
> Quote all you like, it doesn't change the history. Note that build mode
> doesn't support a bunch of other MD raid features either, like all of
> the parity raid levels.  That it doesn't support v1+ metadata isn't a
> surprise, and isn't the only legacy feature that only uses legacy
> metadata (built-in kernel auto-assembly gets the most whining, actually).
>
> Anyways, though I can't speak for the maintainers, it seems that build
> mode is there to keep the MD maintainers from being yelled at by Linus
> for breaking legacy setups.  Nothing more.

Although I would have thought build mode was superb for doing backups 
without needing to stop using the system ... I haven't seen any 
documentation about things like breaking raid to do backups and all that 
sort of thing.

I need to investigate it, but I'd like to know how to suspend a mirror, 
back it up, and then resume. The databases I work with have an option 
that suspends all new writes, but flushes all current transactions to 
disk so the disk is consistent for backing up. So if you do that and 
back up the database you know your backup is consistent.

This is all a rather important usage of raid, actually, imho. It seems 
so obvious - create a temporary mirror, wait for the sync to complete, 
suspend i/o to get the disk consistent, then you can break the mirror 
and carry on. Terabytes :-) of data safely backed up in the space of 
seconds.

Cheers,
Wol
