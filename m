From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Adding larger disks to RAID5
Date: Tue, 22 May 2007 08:15:44 -0400
Message-ID: <20070522121544.GA4349@ti88.telemetry-investments.com>
References: <465204AA.90301@dhp.com> <18002.11374.159035.143026@notabene.brown> <20070521235735.GA26776@ti88.telemetry-investments.com> <18002.15343.525501.64958@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18002.15343.525501.64958@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christian <cjs@dhp.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On Monday May 21, brugolsky@telemetry-investments.com wrote:
> > One could start a RAID 4/5/6 array over a degraded RAID1 for each
> > component, (i.e., a degraded RAID1).
 
That was supposed to say "a degraded RAID5+1".

On Tue, May 22, 2007 at 10:40:15AM +1000, Neil Brown wrote:
> This doesn't really have anything to do with the metadata used - it is
> primarily an implementation issue (though you would need to be careful
> picking up the pieces after a crash).
 
Right.  Doing it all automatically would be great, but involves some
kernel work.

What I was suggesting is that one administratively stop an array
built conventionally, and manually start a degraded RAID1 for each
component.  It seems that is possible using "--build".  Then one can
manually assemble the RAID5+1 from those RAID1s, and proceed with the
disk-by-disk replacement while the array is online.  Looks as if that
ought to be possible.  I'll have to give it a try, as soon as I have an
afternoon to tinker [say, ... mid-summer :-/].

Many thanks, Neil.

	-Bill
