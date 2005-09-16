From: Jon Lewis <jlewis@lewis.org>
Subject: Re: Good, recent FS comparison?
Date: Thu, 15 Sep 2005 23:44:44 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0509152341440.10349@soloth.lewis.org>
References: <6d5bedd8050915131148b8108a@mail.gmail.com> <432A37BF.7060305@dtbb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <432A37BF.7060305@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 15 Sep 2005, Tyler wrote:

> You'd be best off trying some tests of your own, using files of the size and 
> quantity you expect to use on a regular basis.  I would consider ext3, xfs, 
> and reiser3/4... and run some tests with them.  We've had really good luck 
> using XFS on large raids, I personally had a bad experience with reiserfs 3,

What kernels/XFS versions have you had good luck with?  I have one large 
raid with XFS, and it keeps doing:

Corruption of in-memory data detected.  Shutting down filesystem

umount/mount fixes it...for a few days.  I gave SGI's latest 2.4 kernel 
CVS tree a try, and found it broke NFS export of XFS, so I couldn't run it 
long enough to see if it fixed the first problem.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                | 
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
