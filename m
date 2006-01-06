From: Daniel Pittman <daniel@rimspace.net>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 06 Jan 2006 17:33:41 +1100
Message-ID: <87fyo127cq.fsf@rimspace.net>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	<fd8d0180601050106s5f5b4306o@mail.gmail.com>
	<87oe2r2d93.fsf@rimspace.net>
	<fd8d0180601050321k19f12f53r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Francois Barre <francois.barre@gmail.com> writes:
> 2006/1/5, Daniel Pittman <daniel@rimspace.net>:
>> Francois Barre <francois.barre@gmail.com> writes:
>>
>> G'day Francois.
>>
>> > Well, I think everything is in the subject... I am looking at this
>> > solution for a 6*250GB raid5 data server, evolving in a 12*250 rai5 in
>> > the months to come... Performance is absolutely not a big issue for
>> > me, but I would not appreciate any data loss.
>>
>> If your key interest is data integrity, and you don't care a fig about
>> performance, you would be much better off using ext3 on that filesystem.
>>
>> Depending on the test, ext3 may not do better than other filesystems,
>> but it is really quite hard to go past the long history of reliability
>> and stability that it has.
>>
> [...]
>
> Well, as far as I understood it (that is, not so far :-p), reiser4
> seemed to have a stronger and more efficient journal than ext3. 

I can't comment on the design of reiserfs4, but it isn't hard to believe
that the journaling could be more efficient than ext3, which journals
complete metadata blocks rather than individual operations.

That method is quite safe, but may not be as fast as other journaling
methods.  Of course, that depends on your workload: in some cases it is
distinctly faster. :)

> That is not what everyone believes, but reiser4 was to be designed
> that way more or less... But I guess that ext3 and its
> very-heavily-tested journal can still be more trusted than any
> newcomer.

That is very true: all code has bugs, no matter how good the people
writing it are.  With ext3, other people have paid the cost of testing
to find and resolve many of those bugs, so your data is safe.

With reiserfs4 you get to be one of the brave early adopters, today,
which means that it may be your data that gets eaten while those bugs
are found.

> Truth is, I would have been glad to play with reiser4 on a large
> amount of data, just because I was interrested on the theories behind
> it (including the database-filesystem strange wedding Hans tried to
> organize). Maybe it's too great a risk for a production system.
>
> Well, anyway, thanks for the advice. Guess I'll have to stay on ext3
> if I don't want to have nightmares...

That would certainly be my advice.  It may not have the performance or
features that reiserfs4 promises[1], and that XFS delivers, but it is
surely a lot safer for you. :)

       Daniel

Footnotes: 
[1]  I have not tested this, and last time I saw results they were still
     somewhat mixed.


