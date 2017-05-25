From: Nix <nix@esperi.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on md_attr_store / raid5_make_request
Date: Thu, 25 May 2017 13:14:43 +0100
Message-ID: <87d1axb0b0.fsf@esperi.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
        <87a865jf9a.fsf@notabene.neil.brown.name>
        <87fufwy3lr.fsf@esperi.org.uk>
        <87poezhwsa.fsf@notabene.neil.brown.name>
        <87bmqio03i.fsf@esperi.org.uk>
        <874lw9iuwn.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <874lw9iuwn.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Thu, 25 May 2017 11:31:52 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 25 May 2017, NeilBrown spake thusly:

> On Wed, May 24 2017, Nix wrote:
>>
>> (I'm not sure what to do if it *works* -- how do I test any later
>> changes? I might reshape back to RAID-5 + spare again just so I can test
>> later stuff, but that would take ages: the array is over 14TiB...)
>
> If it works (which it did), then we'll have enough understanding that it
> should be easy to simulate the problem accurately in a VM.
> I don't think there is any need for you to experiment further on your
> data.

If you need me to, I can -- this machine isn't commissioned yet (though
the plan *is* to do so next weekend, I can put it off: I've put it off
before...)

Plus I have plenty of backups. :)

-- 
NULL && (void)
