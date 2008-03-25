From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: Redundancy check using "echo check > sync_action": error reporting?
Date: Tue, 25 Mar 2008 10:19:56 +0100 (MET)
Message-ID: <Pine.GSO.4.64.0803251011480.15900@montezuma.acc.umu.se>
References: <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl>
 <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl>
 <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us>
 <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <20080321171348.GK7991@mit.edu>
 <47E3F1EF.3030705@rabbit.us> <20080322132733.GR7991@mit.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080322132733.GR7991@mit.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Theodore Tso <tytso@MIT.EDU>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, Bill Davidsen <davidsen@tmr.com>, Bas van Schaik <bas@tuxes.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 22 Mar 2008, Theodore Tso wrote:

> On Fri, Mar 21, 2008 at 06:35:43PM +0100, Peter Rabbitson wrote:
>>
>> Of course it would be possible to instruct md to always read all
>> data+parity chunks and make a comparison on every read. The performance
>> would not be much to write home about though.
>
> Yeah, and that's probably the real problem with this scheme.  You
> basically reduce the read bandwidth of your array down to a single
> (slowest) disk --- basically the same reason why RAID-2 is a
> commercial failure.

I don't really see this as a problem. Most of my filesystems are not 
anywhere near their performance limit and reading a strip from the parity 
disks as well as all the strips from the data disks in a raid6 setup 
probably would be less than a 50% performance hit, so I would very much 
appriciate a "paranoid parity check on every read" flag to set on _some_ 
of my raids.

/Mattias Wadenstein
