From: Nix <nix@esperi.org.uk>
Subject: Re: 9 second recovery when re-adding a drive that got kicked out?
Date: Wed, 21 Jun 2017 12:08:59 +0100
Message-ID: <87fuetvbqs.fsf@esperi.org.uk>
References: <20170604223817.ntxlvafgfa2umww2@merlins.org>
        <87r2yxdazc.fsf@notabene.neil.brown.name>
        <20170620182745.rbufznqe4tuxqttq@merlins.org>
        <20170620183154.GA5303@merlins.org>
        <87efue2x06.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efue2x06.fsf@notabene.neil.brown.name> (NeilBrown's message of
        "Wed, 21 Jun 2017 07:02:33 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Marc MERLIN <marc@merlins.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20 Jun 2017, NeilBrown verbalised:

> On Tue, Jun 20 2017, Marc MERLIN wrote:
>> The progress meter was wrong, it recovered in 3mn:
>> Jun 20 11:19:28 gargamel kernel: [  916.007017] md: recovery of RAID array md8
>> Jun 20 11:22:41 gargamel kernel: [ 1108.395580] md: md8: recovery done.
>
> It is a progress bar - haven't you learned by now that they are *always*
> wrong :-)

I'd call this progress bar remarkably right by the standards of the
field -- it never jumps backwards :)

-- 
NULL && (void)
