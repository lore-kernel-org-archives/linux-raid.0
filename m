From: Adam Luter <luterac@bellsouth.net>
Subject: Re: In a pickle got out of most of it.
Date: Sun, 29 Sep 2002 12:13:47 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020929171347.GA490@smeagol>
References: <20020928110111.BJBJ4190.imf26bis.bellsouth.net@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020928110111.BJBJ4190.imf26bis.bellsouth.net@localhost>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I found out that the spare disk replaces the old disk transparantly,
after it syncs.  However, I also found out that one of my harddrives
had bad sectors! ( :( :( ).  And it wasn't the spare disk either.  So
I had to not sync (because trying to read the bad sectors would cause
that device to fail, bringing the whole array down).

Instead I just mounted ro, and copied the most important bits out
(well the ones that would fit on my sytem drive), then ran a badblock
program that I got from the manufacturer's site to "remove" the
badblocks (that is, hide them).  And finally rebuilt the array from
scratch.

The only lucky thing was that I still had the old array available,
just not onsite.  So after procuring it and copying it back onto the
new array (along with the saved bits) I've lost only about 10% of my
data.

-Gryn (Adam Luter)
