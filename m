From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: Raid 5: Lossless music archive server recommendations
Date: Tue, 1 Jun 2004 19:18:02 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0406011916360.3895@twinlark.arctic.org>
References: <002501c44837$64699a20$0201a8c0@windows>   
 <20040602012500.12304.qmail@web61004.mail.yahoo.com>
 <1433.153.90.196.102.1086140077.squirrel@web1.cs.montana.edu>
 <001601c44844$617cee90$0201a8c0@windows>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <001601c44844$617cee90$0201a8c0@windows>
To: TJ Harrell <systemloc@earthlink.net>
Cc: admin@cs.montana.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 1 Jun 2004, TJ Harrell wrote:

>
> > I have a system that uses drives on all channels, eg master/slave.
> > and I have encountered any slowdown, by using primary and secondary disks
> > in the same channel.
> > Yes it is slower, but for me performance is good enough.
>
> With two drives per channel, doesn't a disk failure pull down the other
> drive, causing the entire array to fail, and require a reboot to bring the
> degraded array back online?

yes that is an additional failure mode possible when you use two ata
drives on a channel.  this isn't really a recommended configuration.

you might have to dork with raid superblocks to recover from such a
failure.  in fact chances are you *will* have to dork with raid
superblocks to recover.

-dean
