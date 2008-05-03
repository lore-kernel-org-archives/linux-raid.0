From: Kasper Sandberg <lkml@metanurb.dk>
Subject: RE: Sharing disks amoung multiple software RAIDs
Date: Sat, 03 May 2008 05:11:40 +0200
Message-ID: <1209784300.7827.19.camel@localhost>
References: <1209692359.16523.2.camel@localhost>
	 <73000.21239.qm@web50212.mail.re2.yahoo.com>
	 <A20315AE59B5C34585629E258D76A97C335477@34093-C3-EVS3.exchange.rackspace.com>
	 <1209696179.16523.13.camel@localhost>
	 <72dbd3150805020006p7f976a04o487389840f03b4a2@mail.gmail.com>
	 <1209715763.7827.2.camel@localhost>  <481AD006.6050708@dgreaves.com>
	 <1209764630.7827.15.camel@localhost>
	 <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C335960@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: David Greaves <david@dgreaves.com>, David Rees <drees76@gmail.com>, alex14641@yahoo.com, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2008-05-02 at 17:24 -0500, David Lethe wrote:
> 
> -----Original Message-----
<snip>
> > *(or more accurately has saved me from having to restore my data)
> =======================
> Since I am the person that wrote that "Look how many problems people
> post to the thread on a weekly basis where people lose their data when md rebuilds go bad with
> non-shared disks", I think need to clarify.
>  
> I was being too literal. md is a good solution (I use it myself).  However, the OP wanted to "Make sure that if one disk dies, the data is still in tact".  
> 
> Only way to do that is have a good offsite backup.
> 
> Nothing can prevent opportunity for data loss.  I don't care what RAID level (with single redundancy) you use or whether you have software or hardware-based RAID .. rebuilds can not reconstruct data if you are in degraded mode and have an unrecoverable read error on surviving disks.  It is not md's job or design point to insure data consistency check/repairs are run 24x7.  As such, by definition, there is no way to insure that a md rebuild will always be successful.
I realize this, but the original wording really sounded like more like
"well, there is a CHANCE your reconstruct will work good", rather than
"well, there is a CHANCE your reconstruct will fail", if you get what i
mean :)

Naturally there can always be errors or bugs, but the whole point (for
me) in doing the raid1, is that i will have much lower chance of loosing
my data, since a disk can suddenly die, and hopefully in this case, the
other will not. and well, an extra disk doesent really cost so much.

Thanks for the clarification :)
> 
> David
> ---------
> 
> 
> 
> 
> 

