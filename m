From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: async writes in raid1
Date: Tue, 15 Apr 2003 14:08:08 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E9C4A88.B84C8FCD@SteelEye.com>
References: <200304141932.h3EJWI909629@oboe.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: ptb@it.uc3m.es
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"Peter T. Breuer" wrote:
> 
> "A month of sundays ago ptb wrote:"
> > > Actually, I think you want to make sure, in the async case, that the
> > > write to the _primary_ disk completes, as opposed to just the first
> > > write...I think you could get the I/O completing out of order, right?
> >
> > Hmm .. that's a point. It's not a question of out of order, so much as
> > we want to give the maximum chance of getting one successful write and
> 
> Ooops .. I looked up the wrong bit of code in my reply. I looked at the
> final end_req, instead of the mirrored i/o end_req. Yes, don't worry,
> it's already done right. The ack happens early only if there is success
> to report ("uptodate" is set)..

Right, but what if the data is successfully written to the secondary and
then ACKed back to userland and then the primary server fails before the
data gets written locally (I know this is unlikely, but possible,
nonetheless)? The primary will now have out-of-date data that userland
thinks is committed...

--
Paul
