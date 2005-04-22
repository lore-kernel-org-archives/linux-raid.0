From: ross@lug.udel.edu
Subject: Re: RAID-1 reconstruction
Date: Fri, 22 Apr 2005 00:52:39 -0400
Message-ID: <20050422045238.GA22994@jose.lug.udel.edu>
References: <20050421182550.GA7926@jose.lug.udel.edu> <17000.21384.683427.186390@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17000.21384.683427.186390@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: ross@lug.udel.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Apr 22, 2005 at 11:29:44AM +1000, Neil Brown wrote:
> If there have been no writes to an MD array for 20millisecs, then it
> is marked as clean.  So if your machine crashes while the array is
> idle, it should come up clean.
> It looks like this happened in your case, which is good.

Awesome - I'm always amazed at how well Linux md works!


-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
