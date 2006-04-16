From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 4 idea!
Date: Mon, 17 Apr 2006 09:53:17 +1000
Message-ID: <17474.55533.730535.21499@cse.unsw.edu.au>
References: <005901c65ad7$ea45f6c0$2c00a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Saturday April 8
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 8, djani22@dynamicweb.hu wrote:
> Hello, list,
> 
> I have one idea!
> 
> I using raid4, and found to be really good, but i think this can be more
> better! :-)
> 
> If the raid4 fails one disk (except the patiry disk), the md currently only
> drop the disk from array, but i think this could be more useful, if the md
> immediately starts to transform the parity disk into the place fo missing
> disk!

While this might sound easy to do, doing it in a way that is
crash-proof makes it a lot more complicated.

It may happen one day, but I'm afraid I don't see it as a priority.

NeilBrown
