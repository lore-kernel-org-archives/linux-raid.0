From: Jon Lewis <jlewis@lewis.org>
Subject: Re: Raid over 48 disks ... for real now
Date: Sat, 19 Jan 2008 00:16:15 -0500 (EST)
Message-ID: <Pine.LNX.4.61.0801190013461.3306@soloth.lewis.org>
References: <6b3a7f010801170819o59533c39qf4dada60a6f8701@mail.gmail.com>
 <20080117205049.32cf07e9@szpak>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080117205049.32cf07e9@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Jan 2008, Janek Kozicki wrote:

>> I wish RHEL would support XFS/ZFS, but for now, I'm stuck with ext3.
>
> there is ext4 (or ext4dev) - it's an ext3 modified to support 1024 PB size
> (1048576 TB). You could check if it's feasible. Personally I'd always
> stick with ext2/ext3/ext4 since it is most widely used and thus has
> the best recovery tools.

Something else to keep in mind...XFS fs repair tools require large amounts 
of memory.  If you were to create one or a few really huge fs's on this 
array, you might end up with fs's which can't be repaired because you 
don't have or even can't get a machine with enough RAM for the job...not 
to mention the amount of time it would take.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
