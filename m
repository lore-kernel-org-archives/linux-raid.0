From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm --assemble --scan not finding devices
Date: Thu, 6 Mar 2003 10:03:47 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15974.33363.660207.918455@notabene.cse.unsw.edu.au>
References: <8075D5C3061B9441944E137377645118012E7F@cinshrexc03.shermfin.com>
	<15974.32855.282065.392208@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Thursday March 6
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 6, neilb@cse.unsw.edu.au wrote:
> > 
> > ARRAY /dev/md0
> >         level=raid1
> >         devices=/dev/sd[c,d,y,z]1
> 
> "glob" patterns are allowed in DEVICE lines but *not* in devices=
> words.   Sorry.
> 

Nope, I lied.
devices= *does* accept "glob" patterns (I forgot I had done that).

However, it is treated as a comma separated list of device name, so
in this example, it will only accept devices which match:

    /dev/sd[c
    d
    y
    z]1

none of which will be valid device names.

You dont' need commads in [] sets so:
    devices=/dev/sd[cdyz]1
should work for you.

However I still recommend NOT using device=, and using "UUID="
instead.

NeilBrown
