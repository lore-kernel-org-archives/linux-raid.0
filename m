From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 fallen apart
Date: Mon, 28 Aug 2006 22:28:17 +1000
Message-ID: <17650.57697.725755.359936@cse.unsw.edu.au>
References: <87y7tcxu71.fsf@szonett.ki.iif.hu>
	<17650.20238.346014.292009@cse.unsw.edu.au>
	<200608281420.20820.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dexter Filmore on Monday August 28
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 28, Dexter.Filmore@gmx.de wrote:
> Am Montag, 28. August 2006 04:03 schrieben Sie:
> > The easiest thing to do is simply recreate the array, making sure to
> > have the drives in the correct order, and any options (like chunk
> > size) the same.  This will not hurt the data (if done correctly).
> 
> First time I hear this. Good to know.
> Thought recreate implies sync.

It does.  But 'sync' doesn't destroy data. It just updates parity
information.

NeilBrown
