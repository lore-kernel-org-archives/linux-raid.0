From: Nix <nix@esperi.org.uk>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Tue, 16 May 2017 22:46:13 +0100
Message-ID: <871sroscey.fsf@esperi.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
        <590B3039.3060000@youngman.org.uk>
        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
        <87vapb6s9h.fsf@esperi.org.uk>
        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
        <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
        <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
        <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
        <87bmr14u5f.fsf_-_@esperi.org.uk>
        <87efvpmqf6.fsf@notabene.neil.brown.name>
        <87bmqsmrre.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87bmqsmrre.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Wed, 17 May 2017 07:11:17 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16 May 2017, NeilBrown spake thusly:

> Actually, I have another caveat.  I don't think we want these messages
> during initial resync, or any resync.  Only during a 'check' or
> 'repair'.
> So add a check for MD_RECOVERY_REQUESTED or maybe for
>   sh->sectors >= conf->mddev->recovery_cp

I completely agree, but it's already inside MD_RECOVERY_CHECK:

if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
        /* don't try to repair!! */
        set_bit(STRIPE_INSYNC, &sh->state);
        pr_warn_ratelimited("%s: mismatch sector in range "
                            "%llu-%llu\n", mdname(conf->mddev),
                            (unsigned long long) sh->sector,
                            (unsigned long long) sh->sector +
                            STRIPE_SECTORS);
} else {

Doesn't that already mean that someone has explicitly triggered a check
action?
