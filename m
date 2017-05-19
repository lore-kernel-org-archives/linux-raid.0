From: Shaohua Li <shli@kernel.org>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with
 badblocks)
Date: Fri, 19 May 2017 09:48:00 -0700
Message-ID: <20170519164800.v76xyx3h4x3rydqz@kernel.org>
References: <878tm65kyx.fsf@esperi.org.uk>
 <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
 <87bmr14u5f.fsf_-_@esperi.org.uk>
 <87efvpmqf6.fsf@notabene.neil.brown.name>
 <87bmqsmrre.fsf@notabene.neil.brown.name>
 <871sroscey.fsf@esperi.org.uk>
 <20170518000624.xmvttuyio6llu25r@kernel.org>
 <87efvlla69.fsf@notabene.neil.brown.name>
 <877f1d3zpg.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f1d3zpg.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: NeilBrown <neilb@suse.com>, Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 19, 2017 at 11:31:23AM +0100, Nix wrote:
> On 19 May 2017, NeilBrown verbalised:
> 
> > On Wed, May 17 2017, Shaohua Li wrote:
> >
> >> On Tue, May 16, 2017 at 10:46:13PM +0100, Nix wrote:
> >>> Doesn't that already mean that someone has explicitly triggered a check
> >>> action?
> >>
> >> So the idea is: run 'check' and report mismatch, userspace (raid6check for
> >> example) uses the reported info to fix the mismatch. The pr_warn_ratelimited
> >> isn't a good way to communicate the info to userspace. I'm wondering why we
> >> don't just run raid6check solely, it can do the job like what kernel does and
> >> we avoid the crappy pr_warn_ratelimited.
> 
> It'll do when there are a few inconsistencies but you don't want to
> spend days recovering a huge array to fix a small but nonzero
> mismatch_cnt, or to reassure you that yes, these mismatch_cnts are in
> swap, ignore them. When there are a lot, enough that a ratelimited
> warning hits its rate limit, Neil's right: the array is probably toast.
> The limit is then important to stop log flooding.
> 
> > If we really wanted a seamless "fix the raid6 thing" (which I don't
> > think we do),
> 
> Oh, I want seamless everything -- the seamlessness and flexibility of md
> are its killer features over hardware RAID in my eyes -- but I'm
> convinced that this is probably too hard to test and simply too
> disruptive to bother with for a likely vanishingly rare failure mode all
> entangled with fairly hot paths.
> 
> >               we'd probably make the list of inconsistencies appear in a
> > sysfs file.  That would be less 'crappy'.  But as I say, I don't think
> > we really want to do that.
> 
> Aren't sysfs files in effect length-limited to one page (or at least
> length-limited by virtue of being stored in memory?) It seems to me this
> would just bring the same problem ratelimit is solving right back again,
> except a sysfs file doesn't have a logging daemon sucking the contents
> out constantly so you can overwrite your old output without worrying.
> (And there is no other daemon running to do that, except mdadm in
> monitor mode, which might not be running and really this job feels out
> of scope for it anyway.)

No, my question is not the print is ratelimited. The problem is dmesg isn't a
good way to communicate info to userspace. You can easily lose all dmesg info
with a simple 'dmesg -c'. sysfs file is more reliable. Length-limited isn't a
problem, as you said, if there are a lot of mismatch, the array is toast.

Alright, I'll accept Neil's suggestion. Unless your guys really need a seamless
fix (which I'm still thinking about doing it in usespace by optimizing
raid6check) and we'd take this simple warning patch.

Thanks,
Shaohua
