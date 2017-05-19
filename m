From: Shaohua Li <shli@kernel.org>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with
 badblocks)
Date: Fri, 19 May 2017 09:55:17 -0700
Message-ID: <20170519165517.257ny67pxkcbtpkq@kernel.org>
References: <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk>
 <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
 <87bmr14u5f.fsf_-_@esperi.org.uk>
 <87efvpmqf6.fsf@notabene.neil.brown.name>
 <87bmqsmrre.fsf@notabene.neil.brown.name>
 <871sroscey.fsf@esperi.org.uk>
 <87h90hlac0.fsf@notabene.neil.brown.name>
 <8737c13zn8.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <8737c13zn8.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: NeilBrown <neilb@suse.com>, Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 19, 2017 at 11:32:43AM +0100, Nix wrote:
> On 19 May 2017, NeilBrown said:
> 
> > On Tue, May 16 2017, Nix wrote:
> >
> >> On 16 May 2017, NeilBrown spake thusly:
> >>
> >>> Actually, I have another caveat.  I don't think we want these messages
> >>> during initial resync, or any resync.  Only during a 'check' or
> >>> 'repair'.
> >>> So add a check for MD_RECOVERY_REQUESTED or maybe for
> >>>   sh->sectors >= conf->mddev->recovery_cp
> >>
> >> I completely agree, but it's already inside MD_RECOVERY_CHECK:
> >>
> >> if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
> >>         /* don't try to repair!! */
> >>         set_bit(STRIPE_INSYNC, &sh->state);
> >>         pr_warn_ratelimited("%s: mismatch sector in range "
> >>                             "%llu-%llu\n", mdname(conf->mddev),
> >>                             (unsigned long long) sh->sector,
> >>                             (unsigned long long) sh->sector +
> >>                             STRIPE_SECTORS);
> >> } else {
> >>
> >> Doesn't that already mean that someone has explicitly triggered a check
> >> action?
> >
> > Uhmm... yeah.  I lose track of which flags me what exactly.
> > You log messages aren't generated when 'repair' is used, only when
> > 'check' is.
> > I can see why you might have chosen that, but I wonder if it is best.
> 
> I'm not sure what the point is of being told when repair is used: hey,
> there was an inconsistency here but there isn't any more! I suppose you
> could still use it to see if the repair did the right thing. My problem
> on that front was that I'm not sure what flag should be used to catch
> repair but not resync etc: everywhere else in the code, repair is in an
> unadorned else branch... is it the *lack* of MD_RECOVERY_CHECK and the
> presence of, uh, something else?
MD_RECOVERY_SYNC && MD_RECOVERY_REQUESTED && MD_RECOVERY_CHECK == check
MD_RECOVERY_SYNC && MD_RECOVERY_REQUESTED == repair
MD_RECOVERY_SYNC && !MD_RECOVERY_REQUESTED == resync

Don't see the poin to print the info for 'repair'. 'repair' already changes the
data, how could we use the info?

Thanks,
Shaohua
