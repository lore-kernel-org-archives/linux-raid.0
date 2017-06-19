From: "Peter Sangas" <pete@wnsdev.com>
Subject: RE: mismatch_cnt > 0 during initial sync?
Date: Mon, 19 Jun 2017 14:54:33 -0700
Message-ID: <009901d2e946$a3eff400$ebcfdc00$@wnsdev.com>
References: <9A8A3C34-EED0-42FF-B631-7AD1D6EAF9A2@stanford.edu> <D974501A-3A8C-438B-A043-8E44DE6D18C7@stanford.edu> <87shix3rpi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87shix3rpi.fsf@notabene.neil.brown.name>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.com>, 'Stephane Thiell' <sthiell@stanford.edu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> From: NeilBrown [mailto:neilb@suse.com]
> Sent: Sunday, June 18, 2017 2:35 PM
> Subject: Re: mismatch_cnt > 0 during initial sync?
> 
> 
> From the perspective of md, the initial sync is no different from any
other sync.  It
> will count the number of mismatches that it finds and fixes.
> 

Should a sync always fix a mismatch it encounters?   I have a RAID1 with 3
disks.  Sometimes I need to replace one disk and after adding a replacement
disk syslog indicates  "RebuildFinished event detected on md device
/dev/md/2, component device  mismatches found: 256 (on raid level 1)" but
says nothing about fixing it.

cat /sys/block/md2/md/last_sync_action
recovery

mdadm -V
mdadm - v3.3 - 3rd September 2013


Thank you,
Pete

