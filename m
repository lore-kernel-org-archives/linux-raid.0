From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Is My Data DESTROYED?!
Date: Sun, 25 Oct 2009 14:38:58 +0100
Message-ID: <20091025133858.GA23319@boogie.lpds.sztaki.hu>
References: <7bc80d500910240759x443e7a00n4fdcb41f60ec9d73@mail.gmail.com>
 <903282.80364.qm@web38803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <903282.80364.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 25, 2009 at 05:46:04AM -0700, adfas asd wrote:

> I am shocked at all who think that human error is so prevalent, and in
> fact obviates the case for RAID as backup.  I've run Debian for 12
> years on all my personal servers and remember literally only 3 or 4
> cases in that time where I muggered something up and had to go to
> backup.  There must be alot of fsckups out there...

Again, RAID is _not_ backup. "Backup" is something that can retrieve a
file if you've deleted it or if you've accidentally overwritten it. RAID
cannot do that.

RAID is only good for increasing your availability, which means that you
have to restore data from backup _less often_, and you can survive _some_
hardware errors without having to shut down the system and restoring
everything from backup.

> Now a backup by cron is nice and all, but what if it silently fails in
> some obscure way?

There are a couple of golden rules about backups. One such rule is that
you should check at regular intervals that your backup is intact, and
you can in fact restore your data from the backup. A good backup
solution is never a "do it once and forget about it" kind of thing.

> This is one thing I like about RAID or ZFS, it lets
> you know when anything's wrong.

No. They let you know when a limited set of errors conditions occur.
Neither RAID nor ZFS will complain if you delete the wrong file or if
you accidentally overwrite the show you've recorded yesterday. A good
backup solution protects you from both.

> Also I've noticed rsync mentioned several times.  This seems to have
> facilities for incremental backups, but I've also read that it is
> non-secure over networks and that we should use scp instead.  But scp
> doesn't seem to have incremental attributes.  Yes, this is my home
> LAN, but I have a thing about security in and out.  Isn't there
> another way of syncing two disks (over a network)?

I don't know what you have read but rsync over ssh is certainly secure
enough.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
