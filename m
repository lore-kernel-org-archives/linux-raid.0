From: Max Waterman <davidmaxwaterman@fastmail.co.uk>
Subject: Re: ANNOUNCE: mdadm 1.9.0 - A tool for managing Soft RAID under Linux
Date: Fri, 04 Feb 2005 12:54:19 +0800
Message-ID: <4202FFFB.6060604@fastmail.co.uk>
References: <16898.52171.979070.715369@cse.unsw.edu.au>
Reply-To: mwaterman@jingmei.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
In-Reply-To: <16898.52171.979070.715369@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>
> Release 1.9.0 adds:
...
>     -   --assemble --auto recognises 'standard' name and insists on using
>         the appropriate major/minor number for them.

Is this the problem I encountered when I added auto=md to my mdadm.conf 
file?

It caused all sorts of problems - which were recoverable, fortunately.

I ended up putting a '/sbin/MAKEDEV md' into /etc/rc.sysinit just before 
the call to mdadm, but that creates all the md devices, not just those 
that are needed.

Will this new version allow me to remove this line in rc.sysinit again 
and put the 'auto=md' back into mdadm.conf?

Max.
