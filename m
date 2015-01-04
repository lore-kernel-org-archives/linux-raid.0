From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Reassembling RAID1 after good drive was offline [newbie]
Date: Sun, 4 Jan 2015 11:10:28 +0000
Message-ID: <21673.8100.414752.391418@tree.ty.sabi.co.uk>
References: <54A6E5B1.2090602@tigertech.com>
	<20150104102009.GA4511@deb76.aryehleib.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150104102009.GA4511@deb76.aryehleib.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yet another of an endless (but not too frequent fortunately)
stream of "wildly optimistic" messages to this mailing list...

> Would the resync just copy all the data from the "good" drive
> back to the "failed" drive?

This seems to me quite "imaginative" based on the dream that
resync has psychic powers.

> For diagnostic purposes, it would actually be a lot more
> informative to compare the two drives and see if there really
> is data corruption on one of them or not.

This seems to me "wildly optimistic" that when two blocks differ
it is possible in the general case to determine whether one (and
which one) or both are "corrupted".

> Is there a way to do that?

'man cmp' may show a way to "compare the two drives".

> If I were to demonstrate that the data are in sync, I would
> want to reassemble without resync.

"Fantastic logic".

> Also, in my situation, since for now I'm just using a pair of
> external drives, I could easily imagine accidentally trying to
> assemble the array when one of the drives is powered down.
> Then this situation would arise again without faulty hardware.

This may be based on the "amazing insight" that differences in
content and event counts are the same as data corruption.

> Prudence notwithstanding, I do think there are valid cases for 
> reassembling this array without resync.

I believe that you think that but I also believe the manual when
it says "Use this only if you really know what you are doing";
because many MD users may not have the level of skills and
insight about RAID that you think you have, MD is designed to
protect users by default from their own "amazing optimism",
especially users that haven't read yet:

  https://raid.wiki.kernel.org/index.php/RAID_Recovery
  https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID

> If there's a way to do that, I'd still like to know.

'man mdadm' may show a way to assemble "without resync".
