From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: [PATCH] secure write for RAID1
Date: Mon, 25 Apr 2005 17:52:11 +0200
Message-ID: <bagvj2-ul3.ln1@news.it.uc3m.es>
References: <1toqj2-sjd.ln1@news.it.uc3m.es> <20050425123328.GP32085@marowsky-bree.de>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Marowsky-Bree <lmb@suse.de> wrote:
> Would it make sense to generalize and introduce a "write quorum" for
> arrays with more than 2 mirrors - ie, must be committed to at least n
> disks?

I'm sure it would. But to get the information in (at present), it would
require more fields in the info structs (for mdadm) and more fields in
the array structs (mddev?) which mdadm gains influence over via md.c.
So it's definitively Neil's call.

> This would also apply to RAID6, actually. One could say that it needs to
> be committed to N-1 disks; as RAID6 could cope with N-2 failures,
> redundancy would still be preserved.

Sure. 

Unless one allows personality-driven extensions to the info structs
(how?), I don't see mdadm as the perfect controller at present - it
would be as easy for it to talk via sysctl (sysfs?) as via ioctls, and
it wouldn't then need extension every time the driver got extensions.

Peter

