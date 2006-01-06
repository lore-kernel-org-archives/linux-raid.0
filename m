From: Francois Barre <francois.barre@gmail.com>
Subject: Re: Fwd: Linux MD raid5 and reiser4... Any experience ?
Date: Fri, 6 Jan 2006 10:08:49 +0100
Message-ID: <fd8d0180601060108rbe9d663p@mail.gmail.com>
References: <fd8d0180601050104x15079396h@mail.gmail.com>
	 <fd8d0180601050106s5f5b4306o@mail.gmail.com>
	 <17341.8541.33899.167524@smtp.charter.net>
	 <fd8d0180601050603t6f62ff91o@mail.gmail.com>
	 <17341.27534.41206.232976@smtp.charter.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17341.27534.41206.232976@smtp.charter.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> No, backups do not mean snapshots.
> Snapshots are merely a way to take backups of a consistent view of the
filesystem...
[...]
> Don't mix them up, you'll be really really unhappy.
Wll, I may not be fully awoken yet, but what is the interrest of
having non-consistent backups ? For sure, backuping implies one of :
1. Forbidding write access to data for users
2. Having the capability to have snapshots.

> You're blaming the wrong part of the system for your data loss.  First
> off blame the user/sysadmin who set it up, then blame the person who
> put Linear RAID on your system and into MD/LVM.  :]
Hey, I already said I was wrong :-p.
The point is, as I still wish to keep it small & simple (kiss :-), LVM
has, no matter how deep I study it, an impact over complexity.

> Umm... not exactly.  He's more a pain in the butt to deal with at
> times, with an abrasive personality which only seems to care about his
> projects.  He doesn't like working with other people to make it FS
> work within the Linux kernel designs and philosophy.

I didn't know it... Pity, he sometimes has great ideas...

> All my opinion of course.  Plus, I've been a bunch of horror stories
> about Resierfs3 problems, though I admit not recently, say the past
> six months to a year.  But resierfs4 I wouldn't deploy production data
> on yet...

I agree with that now. You all convinced me.
