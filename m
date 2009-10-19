From: Guy Martin <gmsoft@tuxicoman.be>
Subject: Re: Raid 5 to raid 6 reshape failure after reboot
Date: Mon, 19 Oct 2009 15:53:22 +0200
Message-ID: <20091019155322.65b4287f@zombie>
References: <20091018181033.0255346c@borg.bxl.tuxicoman.be>
	<358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <358606dfd356518f7fa42219f26082d2.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi Neil,

Same result with the latest commit after a reboot.

Maybe the problem comes from the fact that I first try to assemble
the array without providing a backup file ?

For reference I did the following :
mdadm --create /dev/md0 -l 5 -n 3 /dev/sd[bdf]1
mdadm --add /dev/md0 /dev/sde1
[wait for the raid 5 to rebuild]
mdadm --grow /dev/md0 --backup-file backup -l 6 -n 4
[wait a few hours]
reboot
mdadm --assemble /dev/md0 /dev/sd[bdef]1
mdadm --assemble /dev/md0 /dev/sd[bdef]1 --backup-file backup

Any other output you'd need ?

  Guy

On Mon, 19 Oct 2009 07:14:06 +1100
"NeilBrown" <neilb@suse.de> wrote:

> 
> Thanks for doing this testing!
> 
> > Any idea how to resolve this issue ?
> 
> Try pulling the very latest from my git repo.  I was doing some
> testing like this just last week and found a number of issues which I
> think I have fixed.
> 
> NeilBrown
> 

