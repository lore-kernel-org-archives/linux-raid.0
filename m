From: Shaohua Li <shli@kernel.org>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with
 badblocks)
Date: Wed, 17 May 2017 17:07:02 -0700
Message-ID: <20170518000624.xmvttuyio6llu25r@kernel.org>
References: <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk>
 <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk>
 <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
 <87bmr14u5f.fsf_-_@esperi.org.uk>
 <87efvpmqf6.fsf@notabene.neil.brown.name>
 <87bmqsmrre.fsf@notabene.neil.brown.name>
 <871sroscey.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <871sroscey.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: NeilBrown <neilb@suse.com>, Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 16, 2017 at 10:46:13PM +0100, Nix wrote:
> On 16 May 2017, NeilBrown spake thusly:
> 
> > Actually, I have another caveat.  I don't think we want these messages
> > during initial resync, or any resync.  Only during a 'check' or
> > 'repair'.
> > So add a check for MD_RECOVERY_REQUESTED or maybe for
> >   sh->sectors >= conf->mddev->recovery_cp
> 
> I completely agree, but it's already inside MD_RECOVERY_CHECK:
> 
> if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>         /* don't try to repair!! */
>         set_bit(STRIPE_INSYNC, &sh->state);
>         pr_warn_ratelimited("%s: mismatch sector in range "
>                             "%llu-%llu\n", mdname(conf->mddev),
>                             (unsigned long long) sh->sector,
>                             (unsigned long long) sh->sector +
>                             STRIPE_SECTORS);
> } else {
> 
> Doesn't that already mean that someone has explicitly triggered a check
> action?


Hi,
So the idea is: run 'check' and report mismatch, userspace (raid6check for
example) uses the reported info to fix the mismatch. The pr_warn_ratelimited
isn't a good way to communicate the info to userspace. I'm wondering why we
don't just run raid6check solely, it can do the job like what kernel does and
we avoid the crappy pr_warn_ratelimited.

Thanks,
Shaohua
