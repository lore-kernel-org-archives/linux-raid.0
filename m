From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [PATCH md 3 of 4] Delete unplug timer before shutting down md array.
Date: Wed, 3 Nov 2004 11:29:42 +1100
Message-ID: <16776.9846.775539.684677@cse.unsw.edu.au>
References: <20041102143440.12019.patches@notabene>
	<E1COpUP-000392-Hw@notabene.cse.unsw.edu.au>
	<20041101205735.5fc68d69.akpm@osdl.org>
	<20041101210044.20c4a8e0.akpm@osdl.org>
	<16775.3329.279178.375487@cse.unsw.edu.au>
	<20041101213333.201769d0.akpm@osdl.org>
	<20041102071258.GA9190@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Luca Berra on Tuesday November 2
Sender: linux-raid-owner@vger.kernel.org
To: Luca Berra <bluca@comedia.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 2, bluca@comedia.it wrote:
> >hm, OK.  So perhaps using /dev/mdX as a control channel for creating and
> >destroying /dev/mdX was unfortunate design.  Ho hum.
> 
> would it be unfeasible to create a custom (misc) character device, say
> /dev/mdadm and use that to control arrays instead of /dev/md0?
> 

Sure it would.  Though I would rather so sort of filesystem interface.

But it is unreasonable to remove the current interface without a
reasonable transition period.  So the current code needs to be made to
work.

NeilBrown
