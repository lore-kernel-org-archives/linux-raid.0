From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [LSF/MM TOPIC] De-clustered RAID with MD
Date: Tue, 30 Jan 2018 10:43:37 +0000
Message-ID: <5A704C59.4000705@youngman.org.uk>
References: <mqdvafkhep0.fsf@linux-x5ow.site>
 <5A6F4CA6.5060802@youngman.org.uk> <87fu6o5o83.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87fu6o5o83.fsf@notabene.neil.brown.name>
Sender: linux-block-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, lsf-pc@lists.linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 29/01/18 21:50, NeilBrown wrote:
> By doing declustered parity you can sanely do raid6 on 100 drives, using
> a logical stripe size that is much smaller than 100.
> When recovering a single drive, the 10-groups-of-10 would put heavy load
> on 9 other drives, while the decluster approach puts light load on 99
> other drives.  No matter how clever md is at throttling recovery, I
> would still rather distribute the load so that md has an easier job.

Not offering to do it ... :-)

But that sounds a bit like linux raid-10. Could a simple approach be to
do something like "raid-6,11,100", ie raid-6 with 9 data chunks, two
parity, striped across 100 drives? Okay, it's not as good as the
decluster approach, but it would spread the stress of a rebuild across
20 drives, not 10. And probably be fairly easy to implement.

Cheers,
Wol
