From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: mismatch_cnt > 0 during initial sync?
Date: Tue, 20 Jun 2017 13:23:52 -0700
Message-ID: <002e01d2ea03$232cb660$69862320$@wnsdev.com>
References: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu> <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu> <87shix3rpi.fsf@notabene.neil.brown.name> <009901d2e946$a3eff400$ebcfdc00$@wnsdev.com> <87lgon2t30.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgon2t30.fsf@notabene.neil.brown.name>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.com>, 'Stephane Thiell' <sthiell@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: NeilBrown [mailto:neilb@suse.com]
> Sent: Monday, June 19, 2017 9:15 PM
> Subject: RE: mismatch_cnt > 0 during initial sync?
> 
> This is a recovery, not a resync.  They are different.
 
Thank you for pointing this out and the nice explanation.    

From reading this list and other sources issuing a repair command as
follows:

"echo repair > /sys/block/md2/md/sync_action"

might be ill-advised since it's luck of the draw whether or not the
operation gets the right data instead of the bad data.

Is this correct? 

For reference I have a RAID1 with 3 disks.  mdadm - v3.3 - 3rd September
2013

Thank you,
Pete

