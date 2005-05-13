From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: MD bug or me being stupid?
Date: Fri, 13 May 2005 12:55:29 +1000
Message-ID: <17028.5921.815691.401690@cse.unsw.edu.au>
References: <62b0912f0504220345349335f9@mail.gmail.com>
	<62b0912f050512015585a6ba5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Thursday May 12
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday May 12, molle.bestefich@gmail.com wrote:
> On 4/22/05, Molle Bestefich wrote:
> > Just upgraded a MD RAID 5 box to 2.6.11 from 2.4.something.
> > 
> > Found out one disk was failing completely, got a replacement from Maxtor.  Neat.
> > Replaced disk, rebooted..
> > Added the new disk to the array with 'raidhotadd'.
> > MD started syncing.
> > 
> > A couple of minutes into the process, it started *seriously* spamming
> > the console with messages:
> > 
> > ==========================
> > Apr 22 01:47:00 linux kernel: ..<6>md: syncing RAID array md1
> > Apr 22 01:47:00 linux kernel: md: minimum _guaranteed_ reconstruction
> > speed: 1000 KB/sec/disc.
> > Apr 22 01:47:00 linux kernel: md: using maximum available idle IO bandwith (but
> > not more than 200000 KB/sec) for reconstruction.
> > Apr 22 01:47:00 linux kernel: md: using 128k window, over a total of
> > 199141632 blocks.
> > Apr 22 01:47:00 linux kernel: md: md1: sync done.
> > Apr 22 01:47:00 linux kernel: ..<6>md: syncing RAID array md1
> > Apr 22 01:47:01 linux kernel: md: minimum _guaranteed_ reconstruction
> > speed: 1000 KB/sec/disc.
> > Apr 22 01:47:01 linux kernel: md: using maximum available idle IO bandwith (but
> > not more than 200000 KB/sec) for reconstruction.
> > Apr 22 01:47:01 linux kernel: md: using 128k window, over a total of
> > 199141632 blocks.
> > Apr 22 01:47:01 linux kernel: md: md1: sync done.
> > ==========================
> 
> [snip]
> 
> > afterwards, I can see that the above messages repeat themselves.
> > cat /var/log/messages | grep md | grep 'Apr 22 01:47:01' | grep 'sync done'
> > tells me that the messages were repeated 12 times per second.  The
> 
> Ping!...
> Neil, just wondering, any comments regarding this particular endless loop in MD?
> (Anything I can test or some such?)

Thanks for the ping, things sometimes get lost in the noise....

This sounds a bit like the problem that is addressed by 
  md-make-raid5-and-raid6-robust-against-failure-during-recovery.patch 
in the current -mm patches (look in the brokenout directory).

This would only happen if you have multiple failed devices.  So maybe
while the rebuild was happening, another device failed (which seems to
happen more and more as device sizes are increasing and reliability is
going the other way).

Could this (another drive failure) be the case?

NeilBrown
