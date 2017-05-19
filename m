From: Nix <nix@esperi.org.uk>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Fri, 19 May 2017 11:31:23 +0100
Message-ID: <877f1d3zpg.fsf@esperi.org.uk>
References: <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
        <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
        <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
        <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
        <87bmr14u5f.fsf_-_@esperi.org.uk>
        <87efvpmqf6.fsf@notabene.neil.brown.name>
        <87bmqsmrre.fsf@notabene.neil.brown.name>
        <871sroscey.fsf@esperi.org.uk>
        <20170518000624.xmvttuyio6llu25r@kernel.org>
        <87efvlla69.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efvlla69.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Fri, 19 May 2017 14:53:18 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19 May 2017, NeilBrown verbalised:

> On Wed, May 17 2017, Shaohua Li wrote:
>
>> On Tue, May 16, 2017 at 10:46:13PM +0100, Nix wrote:
>>> Doesn't that already mean that someone has explicitly triggered a check
>>> action?
>>
>> So the idea is: run 'check' and report mismatch, userspace (raid6check for
>> example) uses the reported info to fix the mismatch. The pr_warn_ratelimited
>> isn't a good way to communicate the info to userspace. I'm wondering why we
>> don't just run raid6check solely, it can do the job like what kernel does and
>> we avoid the crappy pr_warn_ratelimited.

It'll do when there are a few inconsistencies but you don't want to
spend days recovering a huge array to fix a small but nonzero
mismatch_cnt, or to reassure you that yes, these mismatch_cnts are in
swap, ignore them. When there are a lot, enough that a ratelimited
warning hits its rate limit, Neil's right: the array is probably toast.
The limit is then important to stop log flooding.

> If we really wanted a seamless "fix the raid6 thing" (which I don't
> think we do),

Oh, I want seamless everything -- the seamlessness and flexibility of md
are its killer features over hardware RAID in my eyes -- but I'm
convinced that this is probably too hard to test and simply too
disruptive to bother with for a likely vanishingly rare failure mode all
entangled with fairly hot paths.

>               we'd probably make the list of inconsistencies appear in a
> sysfs file.  That would be less 'crappy'.  But as I say, I don't think
> we really want to do that.

Aren't sysfs files in effect length-limited to one page (or at least
length-limited by virtue of being stored in memory?) It seems to me this
would just bring the same problem ratelimit is solving right back again,
except a sysfs file doesn't have a logging daemon sucking the contents
out constantly so you can overwrite your old output without worrying.
(And there is no other daemon running to do that, except mdadm in
monitor mode, which might not be running and really this job feels out
of scope for it anyway.)
