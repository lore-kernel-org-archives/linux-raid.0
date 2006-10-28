From: Roger Gammans <roger@computer-surgery.co.uk>
Subject: faulty.c does not accurately simulate failures...
Date: Sat, 28 Oct 2006 15:17:09 +0100
Message-ID: <20061028141709.GA4665@julia.computer-surgery.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

As the subject says there are differences in the behaviour of simulated 
failures by faulty, and of a real drive with bad sectors.

There are two ways this manifests itself:-
	
	1)  Bad sectors on reall devices often tend to occur a groups,
	    this is faulty.c is unlikely to generate runs of sectors.

	2)  (I haven't verified this against a real drive yet )
	    In the read case:-
	    faulty.c calls (bio->endio)() with all data data having
	    been transferred correctly eg, with bi_size=0. Whereas
	    in the errored data is unlikely to have been transfered
	    in the case of real failled hardware.

Are patches to change these behaviours welcome?  Or is the current
behaviour intention for a reason I haven't grokked.

TTFN
-- 
Roger.                          Home| http://www.sandman.uklinux.net/
Master of Peng Shui.      (Ancient oriental art of Penguin Arranging)
Work|Independent Sys Consultant | http://www.computer-surgery.co.uk/
So what are the eigenvalues and eigenvectors of 'The Matrix'? --anon
