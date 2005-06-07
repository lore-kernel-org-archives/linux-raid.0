From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Can "mdadm" linux RAID go large?
Date: Tue, 07 Jun 2005 16:46:15 -0700
Message-ID: <42A631C7.2060309@h3c.com>
References: <1118187516.15459.93.camel@seki.nac.uci.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1118187516.15459.93.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Not sure about the size limits per se
(http://www.suse.de/~aj/linux_lfs.html has good info there)

I can say that with a very large number of disks, you will hit
single-block read errors quite frequently due to the nature of the math
behind MTBF. This will lead to frequent drive expulsion / rebuild
cycles, as discussed in another thread today.

In another question (you could post them all as one mail,
incidentally...) you asked if it was stable. The only evidence appears
to be anecdotal, but it appears extremely stable to me, even under very
heavy testing - normal new machine cpu/network/ram burn-in tests,
combined with multiple bonnie++ processes hitting the array. Any
problems I've had have been attributable to hardware or hardware drivers
thus far.

There have been problems (like the recent set of looping-resync issues
for instance), but I don't remember hearing any that resulted in data
loss, and they get fixed quickly. Serious problems still leave you with
your data on a set of disks in a known format, which means that it may
be laborious but you can reconstruct. So it "degrades" more gracefully
than the black box that are some hardware raid systems.

It takes care to run well and safely though, as with any machine.

-Mike

Dan Stromberg wrote:
> Can mdadm linux RAID go past 2 terabytes reliably?
> 
> Can mdadm linux RAID go past 16 terabytes reliably?
> 
