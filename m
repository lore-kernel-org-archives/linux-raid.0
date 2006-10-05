From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm RAID5 Grow
Date: Fri, 6 Oct 2006 08:30:07 +1000
Message-ID: <17701.34671.136633.775362@cse.unsw.edu.au>
References: <6652499.post@talk.nabble.com>
	<17700.35743.152233.689956@cse.unsw.edu.au>
	<4524FD70.6070609@mickg.net>
	<17701.504.201046.256698@cse.unsw.edu.au>
	<45257D7B.90401@mickg.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from mickg on Thursday October 5
Sender: linux-raid-owner@vger.kernel.org
To: mickg <mickg@mickg.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday October 5, mickg@mickg.net wrote:
> 
> There is a
>    sysfs   /sys    sysfs   noauto 0 0
> line in /etc/fstab
> I am assuming noauto is the culprit?
> 
> Should it be made to automount ?

Maybe.  You could try and see...
But I suggest checking with someone who knows about these details in
your particular distro.
Maybe there is some init.d script that is meant to "mount /sys" and
some appropriate time.  Quite possibly it is mean to be mounted
*before* other 'auto' filesystems in fstab.

NeilBrown
