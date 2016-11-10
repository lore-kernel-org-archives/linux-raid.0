From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Question on blocks periodic writes
Date: Thu, 10 Nov 2016 16:10:01 +0000
Message-ID: <58249BD9.8000303@youngman.org.uk>
References: <CAOzB0-6NYUqrzUyx3iQ8CbPwFh-dctKTVwE6GKupdYM-8AfOrg@mail.gmail.com>
 <8760nwm6vu.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8760nwm6vu.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Theophanis Kontogiannis <tkonto@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/11/16 02:00, NeilBrown wrote:
>> [ 8664.858104] xfsaild/md1(658): WRITE block 0 on md1 (8 sectors)
> This is XFS doing something.  md cannot possibly stop all IO while the
> filesystem performs occasional IO.  If these continue, you need to
> discuss with xfs developers how to stop it.  If the writes to individual
> drives continue after there are no writes to 'md1', then it is worth
> coming back here to ask.
> 
> 
Would the new journal feature be any help?

I haven't dug in enough to understand it properly, and it would increase
the vulnerability of the system to a journal failure, but the feature
itself seems almost perfect for batching writes and enabling the disks
to spin down for extended periods.

Cheers,
Wol
