From: Nix <nix@esperi.org.uk>
Subject: Re: A sector-of-mismatch warning patch (was Re: Fault tolerance with badblocks)
Date: Fri, 19 May 2017 11:32:43 +0100
Message-ID: <8737c13zn8.fsf@esperi.org.uk>
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
        <871sroscey.fsf@esperi.org.uk>
        <87h90hlac0.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87h90hlac0.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Fri, 19 May 2017 14:49:51 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>, Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 19 May 2017, NeilBrown said:

> On Tue, May 16 2017, Nix wrote:
>
>> On 16 May 2017, NeilBrown spake thusly:
>>
>>> Actually, I have another caveat.  I don't think we want these messages
>>> during initial resync, or any resync.  Only during a 'check' or
>>> 'repair'.
>>> So add a check for MD_RECOVERY_REQUESTED or maybe for
>>>   sh->sectors >= conf->mddev->recovery_cp
>>
>> I completely agree, but it's already inside MD_RECOVERY_CHECK:
>>
>> if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
>>         /* don't try to repair!! */
>>         set_bit(STRIPE_INSYNC, &sh->state);
>>         pr_warn_ratelimited("%s: mismatch sector in range "
>>                             "%llu-%llu\n", mdname(conf->mddev),
>>                             (unsigned long long) sh->sector,
>>                             (unsigned long long) sh->sector +
>>                             STRIPE_SECTORS);
>> } else {
>>
>> Doesn't that already mean that someone has explicitly triggered a check
>> action?
>
> Uhmm... yeah.  I lose track of which flags me what exactly.
> You log messages aren't generated when 'repair' is used, only when
> 'check' is.
> I can see why you might have chosen that, but I wonder if it is best.

I'm not sure what the point is of being told when repair is used: hey,
there was an inconsistency here but there isn't any more! I suppose you
could still use it to see if the repair did the right thing. My problem
on that front was that I'm not sure what flag should be used to catch
repair but not resync etc: everywhere else in the code, repair is in an
unadorned else branch... is it the *lack* of MD_RECOVERY_CHECK and the
presence of, uh, something else?

-- 
NULL && (void)
