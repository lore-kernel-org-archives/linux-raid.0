From: mark delfman <markdelfman@googlemail.com>
Subject: Re: MD write performance issue - found Catalyst patches
Date: Sat, 31 Oct 2009 11:51:43 +0100
Message-ID: <66781b10910310351x7bb721c4mfba765fe9789cd7b@mail.gmail.com>
References: <66781b10910180300j2006a4b7q21444bb27dd9434e@mail.gmail.com>
	 <19177.14609.138378.581065@notabene.brown>
	 <4AE94D95.4060303@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AE94D95.4060303@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thank you Neil... if the commits improve overall the stability of
Linux then they are obviously important and hopefully there is another
way to achieve the same results... as you say if we can see that there
is an opportunity for significant performance gain (i think 600MBs
extra is significant), it=92s maybe worth some thought.

I would very much like to contribute to this and indeed ongoing
developments, but the only hurdle i have is that i am storage focused,
which means I work solely in storage environments (which is good) but
also means i know very little about linux and dramatically less about
programming (i have never even touched C for example).   I come from
hardware based storage into the world of linux, so lag behind greatly
in many ways.

I do have current access to equipment in which we can gain the
performance needed to see the effect of the commits (up to 600MBsec
difference) but i have the lack of ability to implement the ideas
which you have suggested.

I am hopeful that you or another member of this group could offer some
advice / patch to implement the print options you suggested... if so i
would happily allocated resource and time to do what i can to help
with this.

I appreciate that this group is generally aimed at those with linux
experience, but hopefully i can still add some value whether simply
with test equipment, comparisons or real life introduction for
feedback etc.

The print options you suggested... are these a simple introduction?
Could someone maybe offer a abc of how to add this?





On Thu, Oct 29, 2009 at 9:08 AM, Asdo <asdo@shiftmail.org> wrote:
> Neil Brown wrote:
>>
>> I've had a look at this and asked around and I'm afraid there doesn'=
t
>> seem to be an easy answer.
>>
>> The most likely difference between 'before' and 'after' those patche=
s
>> is that more pages are being written per call to generic_writepages =
in
>> the 'before' case. =A0This would generally improve throughput,
>> particularly with RAID5 which would get more full stripes.
>>
>> However that is largely a guess as the bugs which were fixed by the
>> patch could interact in interesting ways with XFS (which decrements
>> ->nr_to_write itself) and it isn't immediately clear to me that more
>> pages would be written...
>> In any case, the 'after' code is clearly correct, so if throughput c=
an
>> really be increased, the change should be somewhere else.
>>
>
> Thank you Neil for looking into this
>
> How can "writing less pages" be more correct than "writing more pages=
"?
> I can see the first as an optimization to the second, however if this
> reduces throughput then the optimization doesn't work...
> Isn't it possible to "fix" it so to write more pages and still be
> semantically correct?
>
>
> Thomas Fjellstrom wrote:
>>
>> I don't suppose this causes "bursty" writeout like I've been seeing
>> lately? For some reason writes go full speed for a short while and t=
hen just
>> stop for a short time, which averages out to 2-4x slower than what t=
he array
>> should be capable of.
>>
>
> I have definitely seen this bursty behaviour on 2.6.31.
>
> It would be interesting to know what are the CPUs doing or waiting fo=
r in
> the pause times. But I am not a kernel expert :-( how could one check=
 this?
>
> Thank you
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
