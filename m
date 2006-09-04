From: Neil Brown <neilb@suse.de>
Subject: Re: RAID-5 recovery
Date: Mon, 4 Sep 2006 14:39:01 +1000
Message-ID: <17659.44517.186189.152370@cse.unsw.edu.au>
References: <200609031148.56910.clive@vacuumtube.org.uk>
	<Pine.LNX.4.64.0609031530010.12203@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from dean gaudet on Sunday September 3
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Clive Messer <clive@vacuumtube.org.uk>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday September 3, dean@arctic.org wrote:
> On Sun, 3 Sep 2006, Clive Messer wrote:
> 
> > This leads me to a question. I understand from reading the linux-raid archives 
> > that the current behaviour when rebuilding with a single badblock on another 
> > disk is for that disk to also be kicked from the array.
> 
> that's not quite the current behaviour.  since 2.6.14 or .15 or so md will 
> reconstruct bad blocks from other disks and try writing them.  it's only 
> when this fails repeatedly that it knocks the disk out of the array.

"when rebuild" md/raid5 cannot reconstruct bad blocks because the
array is degraded, so a read error is immediately fatal.

NeilBrown

-- 
VGER BF report: H 3.53108e-11
