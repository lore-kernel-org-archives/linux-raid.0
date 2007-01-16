From: dean gaudet <dean@arctic.org>
Subject: Re: raid5 software vs hardware: parity calculations?
Date: Mon, 15 Jan 2007 16:48:54 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701151643270.16472@twinlark.arctic.org>
References: <2A887D754684B6703B52E126@emerald.sei.cmu.edu>
 <Pine.LNX.4.64.0701120935000.18431@twinlark.arctic.org>
 <F4B05AD60951BBA089A81535@emerald.sei.cmu.edu>
 <e9c3a7c20701130120o246f5cf1i8d364777123c50d8@mail.gmail.com>
 <45A917B8.2060706@tmr.com> <eobpl9$df3$1@sea.gmane.org> <45AB9DC6.50509@tmr.com>
 <45ABAA43.2000902@robinbowes.com> <Pine.LNX.4.64.0701151321190.16472@twinlark.arctic.org>
 <45AC1DD9.9070402@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45AC1DD9.9070402@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: berk walker <berk@panix.com>
Cc: Robin Bowes <robin-lists@robinbowes.com>, Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 15 Jan 2007, berk walker wrote:

> dean gaudet wrote:
> > echo check >/sys/block/mdX/md/sync_action
> > 
> > it'll read the entire array (parity included) and correct read errors as
> > they're discovered.

> 
> Could I get a pointer as to how I can do this "check" in my FC5 [BLAG] system?
> I can find no appropriate "check", nor "md" available to me.  It would be a
> "good thing" if I were able to find potentially weak spots, rewrite them to
> good, and know that it might be time for a new drive.
> 
> All of my arrays have drives of approx the same mfg date, so the possibility
> of more than one showing bad at the same time can not be ignored.

it should just be:

echo check >/sys/block/mdX/md/sync_action

if you don't have a /sys/block/mdX/md/sync_action file then your kernel is 
too old... or you don't have /sys mounted... (or you didn't replace X with 
the raid number :)

iirc there were kernel versions which had the sync_action file but didn't 
yet support the "check" action (i think possibly even as recent as 2.6.17 
had a small bug initiating one of the sync_actions but i forget which 
one).  if you can upgrade to 2.6.18.x it should work.

debian unstable (and i presume etch) will do this for all your arrays 
automatically once a month.

-dean
