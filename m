From: Jon Lewis <jlewis@lewis.org>
Subject: Re: help
Date: Wed, 20 Oct 2004 21:47:12 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0410202146350.25752@web1.mmaero.com>
References: <8f8a5194041019220528e9d45@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8f8a5194041019220528e9d45@mail.gmail.com>
To: Srinivasa S <srinivasa.s@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 20 Oct 2004, Srinivasa S wrote:

> i've a raid 5 setup with 3 disks each of 1 GB. i'm using it for some
> experimentation purpose. resync is n progress and is not ending at
> all. its almost 15 hrs since the resync started and the "cat
> /proc/mdstat" always shows something like this.
>
> Personalities : [raid5]
> md0 : active raid5 sdj1[2] sdi1[1] sdh1[0]
>       2002688 blocks level 5, 8k chunk, algorithm 2 [3/3] [UUU]
>       [>....................]  resync =  0.0% (0/1001344)
> finish=442287.5min speed=0K/sec

What kind of disks?  My bad Maxtor SATA drive caused similar issues.

----------------------------------------------------------------------
 Jon Lewis                   |  I route
 Senior Network Engineer     |  therefore you are
 Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
