From: wilsonjonathan <piercing_male@hotmail.com>
Subject: Re: Is it possible to change the wait time before a drive is
 concidered failed?
Date: Tue, 22 Nov 2011 15:59:14 +0000
Message-ID: <BLU0-SMTP121C59F841CDA9046FA14ED98C80@phx.gbl>
References: <BLU0-SMTP264257376293BB9DBCEB7B798CA0@phx.gbl>
	 <20111121125806.316a58e0@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111121125806.316a58e0@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Having looked more indepth I think the answer to my first question may
be resolved by increasing the wait time in the individual sd* devices as
if I read it correctly soft raid doesn't have or use a time out value
(unless it does both have and use the value under the md* device) but
instead just waits until an individual device times out. 

If thats the case then I may just increase the time out of the sd*'s to
60 seconds from 30 seconds which should be more than enough time to
allow a drive to wind up and start to give back data.


Thanks for the helpful replies... 

> > 
> > I do have a couple of related questions...
> > 
> > I have already done some testing by setting up sd[ab] for md[2-4] but
> > with no file systems on top, and then pulling sdb and then putting it
> > back in.
> > 
> > q1, why does -add throw up the message : not performing --add, re-add
> > failed, zero superblock...
> 
> Because some people seem to use "--add" when they mean "--re-add" and that
> can cause data loss.  So to be safe, if want want to discard all the data on
> a device and add it as a true spare, you now need to --zero-superblock
> first.  Hopefully that isn't too much of a burden.

Thats what I thought was strange, as no data had changed (no file
system) after getting the above message when I tried --re-add I expected
it to add it back in and re-sync, but again it told me I couldn't so I
had to zero the supper block.

> 
> > 
> > q2, I setup md4 as a raid10 far 2, and I may not be understanding raid10
> > here; when I zero the superblock to add it as I did with the other raids
> > which worked ok, for some reason it causes sda4 to drop out and kills
> > the whole md4 raid.
> 
> You must be running linux-3.1.  It has a bug with exactly this behaviour.
> It should be fixed in the latest -stable release.  Upstream commit 
>    7fcc7c8acf0fba44d19a713207af7e58267c1179
> fixes it.

Thanks for that... I'm currently running an older kernel now as I'm
installing debian squeeze to further test the raids with a running
system (as opposed to off a live cd) 

> 
> 
> > 
> > q3, Is it preferable to have a write intent bitmap, and if so should I
> > put it in the meta-data as opposed to a file.
> 
> A write intent bitmap can make writes a little slower but makes resync after
> a crash much master.  You get to choose which you want.
> It is much more convenient in the internal metadata.  Having the bitmap in an
> external file and reduce the performance cost a bit (if the file is on a
> separate device).
> I would only recommend a separate file if you have an asymmetric mirror with
> one leg (the slow leg) marked write-mostly.  You don't really want the bitmap
> on that device, so put it somewhere else.

I will use the intent as you describe as the speed hit isn't a problem
for my use-case.

> 
> NeilBrown
> 

Jon

