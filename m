From: Stef Telford <stef@chronozon.artofdns.com>
Subject: Re: Software RAID level 1 issue
Date: 31 May 2003 15:39:33 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1054409970.14937.296.camel@testlin.hades>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com>
	 <1054403067.14818.280.camel@testlin.hades> <3ED7B898.4409555F@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3ED7B898.4409555F@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Paul Clements wrote:
> Stef Telford wrote:
> 
> [snip]
> 
> > during resync's on raid-1 the mirror will not be available. 
> 
> I'm not sure I understand this. md/raid1 devices are accessible while
> resync is occurring...albeit with lower I/O throughput since the resync
> is consuming bandwidth.
> 

The way i read the original posters question was
that he/she was trying to restart the faulted 
'device', or rather was trying to re-activate the 
broken md device whilst the working copy was trying to
rebuild it. accessing the working copy should work, but
not the broken md (unless i have seriously misread
someplace :). Under raid5 or raid10, you can still 
access the broken md during a resync/rebuild, this
was what i thought the person was trying to do.

apologies if i misunderstood the original phrasing :)

regards 
Stef Telford <stef@chronozon.artofdns.com>

