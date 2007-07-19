From: Neil Brown <neilb@suse.de>
Subject: Re: asynchronous write
Date: Thu, 19 Jul 2007 21:41:14 +1000
Message-ID: <18079.19930.835893.78600@notabene.brown>
References: <200707180824.l6I8O7Ik006820@betty.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Peter T. Breuer on Wednesday July 18
Sender: linux-raid-owner@vger.kernel.org
To: ptb@inv.it.uc3m.es
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday July 18, ptb@inv.it.uc3m.es wrote:
> Did the asynchronous write stuff (as it was in fr1) ever get into kernel
> software raid?

Hmmm... what was 'fr1' again??.. asks google.

  http://www.it.uc3m.es/ptb/fr1/

Yes, that sound like the 'bitmap' support currently in md.
The bitmap is stored on disk which I think is different from what fr1
did.
Possibly having a volatile bitmap would be valuable.  It would remove
the current extra cost of writes, and would still allow fast recovery
if you fail, then re-add a drive...

> 
> I see from the raid acceleration ("ioat") patching going on that some
> sort of asynchronicity is being contemplated, but blessed if I can make
> head or tail of the descriptions I've read.  It looks vaguely like
> purely memory-management stuff to me (what?) for external hardware raid,
> but what do I know ...

Yes.  The ,'ioat' is for raid5/6 and allows the xor calculation,
memcpys and some other functions to be off-loaded to a co-processor.

NeilBrown
