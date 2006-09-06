From: Josh Litherland <josh@temp123.org>
Subject: Re: Superblock checksum problems
Date: Wed, 06 Sep 2006 09:26:13 -0400
Message-ID: <1157549173.2424.5.camel@localhost>
References: <1157236610.8070.7.camel@localhost>
	 <17659.46517.979409.131348@cse.unsw.edu.au>
	 <1157385612.2990.4.camel@localhost> <1157403347.2990.11.camel@localhost>
	 <1157404398.2990.14.camel@localhost>
	 <17660.39978.663609.990424@cse.unsw.edu.au>
	 <1157406418.2990.20.camel@localhost>  <1157411506.6946.1.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1157411506.6946.1.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Stranger than we dreamt it...

I got a new, identical card, the Syba 4-port PCI card and had EXACTLY
the same problems.  Tried with all new cables, exact same problems.
Moved the card into each PCI slot in the system.  Same problems.

I put the drives and cables into a different system onto an onboard SATA
controller, and they work fine, so drives and cables are "known good".

It seems unlikely that two identical cards would be broken in exactly
the same way, so I have to revert back to my previous suspicion: bad
interaction between the card's firmware and the driver.

This evening, I will try out the weird card in the new system's
motherboard, to see if it's something in the old mobo that doesn't like
this card.

I will hold on to this card at least until weekend for testing, and
longer if anyone thinks they might have a patch for me to test.

My thanks to everyone who's still paying attention to this thread.  =)

-- 
Josh Litherland (josh@temp123.org)

