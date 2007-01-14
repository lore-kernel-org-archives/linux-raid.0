From: Neil Brown <neilb@suse.de>
Subject: Re: FailSpare event?
Date: Mon, 15 Jan 2007 08:20:10 +1100
Message-ID: <17834.40586.985089.343283@notabene.brown>
References: <eo6cn8$5se$1@sea.gmane.org>
	<17830.47341.560158.521091@notabene.brown>
	<200701121534.17618.earny@net4u.de>
	<873b6ere4s.fsf@hades.wkstn.nix>
	<87y7o5lkjx.fsf@hades.wkstn.nix>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Nix on Sunday January 14
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>
Cc: earny@net4u.de, Mike <mikee@mikee.ath.cx>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday January 14, nix@esperi.org.uk wrote:
> On 13 Jan 2007, nix@esperi.org.uk uttered the following:
> > mdadm-2.6 bug, I fear. I haven't tracked it down yet but will look
> > shortly: I can't afford to not run mdadm --monitor... odd, that
> > code hasn't changed during 2.6 development.
> 
> Whoo! Compile Monitor.c without optimization and the problem goes away.
> 
> Hunting: maybe it's a compiler bug (anyone not using GCC 4.1.1 seeing
> this?), maybe mdadm is tripping undefined behaviour somewhere...

Probably....

A quick look suggests that the following patch might make a
difference, but there is more to it than that.  I think there are
subtle differences due to the use of version-1 superblocks.  That
might be just another one-line change, but I want to make sure first.

Thanks,
NeilBrown



### Diffstat output
 ./Monitor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff .prev/Monitor.c ./Monitor.c
--- .prev/Monitor.c	2006-12-21 17:15:55.000000000 +1100
+++ ./Monitor.c	2007-01-15 08:17:30.000000000 +1100
@@ -383,7 +383,7 @@ int Monitor(mddev_dev_t devlist,
 						)
 						alert("SpareActive", dev, dv, mailaddr, mailfrom, alert_cmd, dosyslog);
 				}
-				st->devstate[i] = disc.state;
+				st->devstate[i] = newstate;
 				st->devid[i] = makedev(disc.major, disc.minor);
 			}
 			st->active = array.active_disks;
