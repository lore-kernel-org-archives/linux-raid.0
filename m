From: Neil Brown <neilb@suse.de>
Subject: Re: Why does one get mismatches?
Date: Thu, 11 Feb 2010 16:14:44 +1100
Message-ID: <20100211161444.7a0ea7bb@notabene.brown>
References: <869541.92104.qm@web51304.mail.re2.yahoo.com>
	<4B67451F.8040206@tmr.com>
	<20100202093738.44b4fece@notabene.brown>
	<4B684087.50001@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B684087.50001@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Jon@eHardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 02 Feb 2010 10:11:03 -0500
Bill Davidsen <davidsen@tmr.com> wrote:

> Neil Brown wrote:
> > On Mon, 01 Feb 2010 16:18:23 -0500
> > Bill Davidsen <davidsen@tmr.com> wrote:
> >
> >   
> >> Comment: when there is a three way RAID-1, why doesn't repair *vote* on 
> >> the correct value instead of just making a guess?
> >>
> >>     
> >
> > Because truth is not democratic.
> >
> > (and I defy you to define "correct" in any general way in this context).
> >   
> 
> If you are willing to accept that the reconstructed data from RAID-[56] 
> is "correct" then the data from RAID-1 majority opinion is "correct." If 
> you say that such recovered data is the "most likely to match what was 
> written," then data consistent on (N+1)/2 drives of a RAID-1 should be 
> viewed in the same light. Call it "most likely to be correct" if you 
> prefer, but picking a value from a drive at random is less likely.
> 
> This whole discussion simply shows that for RAID-1 software RAID is less 
> reliable than hardware RAID (no, I don't mean fake-RAID), because it 
> doesn't pin the data buffer until all copies are written.
> 

That doesn't make it less reliable.  It just makes it more confusing.

But for a more complete discussion on raid recovery and when it might be
sensible to "vote" among the blocks, see
   http://neil.brown.name/blog/20100211050355

NeilBrown

