From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: Couldn't umount on /mnt/md0-device busy???
Date: Thu, 18 Jul 2002 20:58:24 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020719005823.GA9116@willow.seitz.com>
References: <Pine.LNX.4.33.0207161515560.29547-100000@pandora.is.bizsystems.com> <15668.41627.988382.451061@notabene.cse.unsw.edu.au> <003c01c22db8$57b86590$5701a8c0@bomoon> <3D35BCD6.7030300@cfht.hawaii.edu> <06d001c22def$eaa10510$5701a8c0@bomoon> <009d01c22e54$54d968a0$f6de11cc@black> <073d01c22e7e$299d8020$5701a8c0@bomoon> <20020718174720.GD4712@willow.seitz.com> <000501c22ebd$59bc3b40$5701a8c0@bomoon>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000501c22ebd$59bc3b40$5701a8c0@bomoon>
To: bo <bo@sosnetwork.net>
Cc: Mike Black <mblack@csi-inc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jul 18, 2002 at 05:43:50PM -0700, bo wrote:
> Yes, you may be right.
> >showmount
>   Host on P300
>   10.0.0.2
>   192.168.1.151
> 
> It looks like it got the old mount information from manufacturing test.
> I do not have those connections(users) now.

I do not know if this is the kosher, most correct way to do this, but
look at the files in /var/lib/nfs (that's where they are on my Slackware
box, and a Debian machine at work).

There's a bunch of files in there that have NFS mount info.  Make sure
all clients actually have it umounted, shutdown NFS and nuke that dir
(well, move it to someplace else, and recreated it in case it blows up).

You could probably edit it and remove the non-existant client as well,
but I haven't ever done it this way.

Ross Vandegrift
ross@willow.seitz.com
