From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: ANNOUNCE: mdadm 1.9.0 - A tool for managing Soft RAID under Linux
Date: Fri, 4 Feb 2005 16:03:00 +1100
Message-ID: <16899.516.611143.990559@cse.unsw.edu.au>
References: <16898.52171.979070.715369@cse.unsw.edu.au>
	<4202FFFB.6060604@fastmail.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
In-Reply-To: message from Max Waterman on Friday February 4
Sender: linux-raid-owner@vger.kernel.org
To: mwaterman@jingmei.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday February 4, davidmaxwaterman@fastmail.co.uk wrote:
> Neil Brown wrote:
> >
> > Release 1.9.0 adds:
> ...
> >     -   --assemble --auto recognises 'standard' name and insists on using
> >         the appropriate major/minor number for them.
> 
> Is this the problem I encountered when I added auto=md to my mdadm.conf 
> file?

Probably.

> 
> It caused all sorts of problems - which were recoverable, fortunately.
> 
> I ended up putting a '/sbin/MAKEDEV md' into /etc/rc.sysinit just before 
> the call to mdadm, but that creates all the md devices, not just those 
> that are needed.
> 
> Will this new version allow me to remove this line in rc.sysinit again 
> and put the 'auto=md' back into mdadm.conf?

I think so, yes.  It is certainly worth a try and I would appreciate
success of failure reports.

NeilBrown
