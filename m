From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-6
Date: Thu, 29 Dec 2005 10:29:57 -0800 (PST)
Message-ID: <dp19v5$sjr$1@terminus.zytor.com>
References: <437701DE.7060400@wasp.net.au> <17271.4092.24066.572971@cse.unsw.edu.au> <437B7264.50506@tmr.com> <1132173592.23464.459.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Followup to:  <1132173592.23464.459.camel@seki.nac.uci.edu>
By author:    Dan Stromberg <strombrg@dcs.nac.uci.edu>
In newsgroup: linux.dev.raid
>
> 
> My understanding is that RAID 5 -always- stripes parity.  If it didn't,
> I believe it would be RAID 4.
> 
> You may find http://linux.cudeso.be/raid.php of interest.
> 
> I don't think RAID level 6 was in the original RAID paper, so vendors
> may have decided on their own that it should mean what they're
> selling.  :)
> 

RAID-6 wasn't in the original RAID paper, but the term RAID-6 with the
P+Q parity defintion is by far the dominant use of the term, and I
believe it is/was recognized by the RAID Advisory Board, which is as
close as you can get to an official statement.  The RAB seems to have
gotten defunct, with a standard squatter page on their previous web
address.

	-hpa



