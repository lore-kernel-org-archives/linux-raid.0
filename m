From: Gordon Henderson <gordon@drogon.net>
Subject: Re: PERC5 - MegaRaid-SAS problems..
Date: Tue, 17 Oct 2006 21:22:09 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0610171944530.5144@lion.drogon.net>
References: <Pine.LNX.4.56.0610121246400.11816@lion.drogon.net>
 <Pine.LNX.4.56.0610171138400.4600@lion.drogon.net>
 <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <df1ef2450610171058i15ad6b47kb8579fc3f1a7e8ee@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Moise <chops@demiurgestudios.com>
Cc: linux-poweredge@dell.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 Oct 2006, Andrew Moise wrote:

> On 10/17/06, Gordon Henderson <gordon@drogon.net> wrote:
> > Anyway, it's currently in a RAID-1 configuration (which I used for some
> > initial soaktests) and seems to be just fine:
> >
> > Filesystem            Size  Used Avail Use% Mounted on
> > /dev/md9              6.8T   33M  6.7T   1% /mnt
>
>   Incidentally, what filesystem are you using?  We may be setting up a
> similar situation soon, and I'm considering ext3 and XFS.  ext3
> apparently has a low max fs size, though, and I've heard bad things
> about XFS's behavior on unclean shutdowns...

I'm using ext3, and it's now RAID-6, so a little smaller:

Filesystem            Size  Used Avail Use% Mounted on
/dev/md9              5.9T   33M  5.7T   1% /archive

And slower:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
bertha           2G           186290  96 111105  75           262779  71 602.0 2


I've looked at, and tried XFS (and JFS) and keep coming back to ext3,
which I have on many, many servers and have never had an issue with it.

I have had problems with XFS, but that was about 2 years ago, so things
might have improved by then.

This is the biggest server I've setup so-far, it beats my previous record
of 3TB (which I have on 2 identical servers halfway round the world from
each other and they've been doing well for several months now).

After your comment about ext3 max FS size, I had a bit of a oo-er
situation so had to do a bit of looking to make sure I was OK, and it
seems that 16TB is the current limit, so OK there for a while, at least...
(/usr/src/linux/documentation/filesystems/ext2.txt)

Gordon
