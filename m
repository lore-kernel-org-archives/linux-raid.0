From: Nix <nix@esperi.org.uk>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Fri, 02 Jun 2017 13:28:52 +0100
Message-ID: <877f0upo8r.fsf@esperi.org.uk>
References: <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
        <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
        <87bmr14u5f.fsf_-_@esperi.org.uk>
        <87efvpmqf6.fsf@notabene.neil.brown.name>
        <87bmqsmrre.fsf@notabene.neil.brown.name>
        <871sroscey.fsf@esperi.org.uk>
        <20170518000624.xmvttuyio6llu25r@kernel.org>
        <87efvlla69.fsf@notabene.neil.brown.name>
        <877f1d3zpg.fsf@esperi.org.uk>
        <20170519164800.v76xyx3h4x3rydqz@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170519164800.v76xyx3h4x3rydqz@kernel.org> (Shaohua Li's
        message of "Fri, 19 May 2017 09:48:00 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: NeilBrown <neilb@suse.com>, Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[getting back to this...]

On 19 May 2017, Shaohua Li told this:
> On Fri, May 19, 2017 at 11:31:23AM +0100, Nix wrote:
>> On 19 May 2017, NeilBrown verbalised:
>> >               we'd probably make the list of inconsistencies appear in a
>> > sysfs file.  That would be less 'crappy'.  But as I say, I don't think
>> > we really want to do that.
>> 
>> Aren't sysfs files in effect length-limited to one page (or at least
>> length-limited by virtue of being stored in memory?) It seems to me this
>> would just bring the same problem ratelimit is solving right back again,
>> except a sysfs file doesn't have a logging daemon sucking the contents
>> out constantly so you can overwrite your old output without worrying.
>> (And there is no other daemon running to do that, except mdadm in
>> monitor mode, which might not be running and really this job feels out
>> of scope for it anyway.)
>
> No, my question is not the print is ratelimited. The problem is dmesg isn't a
> good way to communicate info to userspace. You can easily lose all dmesg info
> with a simple 'dmesg -c'. sysfs file is more reliable. Length-limited isn't a
> problem, as you said, if there are a lot of mismatch, the array is toast.

I agree that in future having a mechanism for reporting this more easily
usable by programs would be good, and sysfs does seem like just such a
mechanism.

-- 
NULL && (void)
