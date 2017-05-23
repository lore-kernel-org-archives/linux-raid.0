From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: 4.11.2: reshape raid5 -> raid6 atop bcache deadlocks at start on
 md_attr_store / raid5_make_request
Date: Tue, 23 May 2017 15:16:08 +0100
Message-ID: <59244428.4050001@youngman.org.uk>
References: <87lgppz221.fsf@esperi.org.uk>
 <87a865jf9a.fsf@notabene.neil.brown.name> <87fufwy3lr.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fufwy3lr.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/05/17 22:38, Nix wrote:
> Everything else hangs the same way, too. This was surprising enough that
> I double-checked to be sure the patch was applied: it was. I suspect the
> deadlock is somewhat different than you supposed... (and quite possibly
> not a race at all, or I wouldn't be hitting it so consistently, every
> time. I mean, I only need to miss it *once* and I'll have reshaped... :) )
> 
> It seems I can reproduce this on demand, so if you want to throw a patch
> with piles of extra printks my way, feel free.

Could this be the long-standing bug that hangs raid5 and raid6 reshapes?
I don't remember it being found and fixed. iirc (it's too long ago) it
hit people adding a drive to a raid5 (occasionally a raid6), and was
fairly easy to get round. Again it's too long ago but stopping and
starting the reshape fixed it usually iirc.

Cheers,
Wol
