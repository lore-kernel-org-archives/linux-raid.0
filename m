From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Thu, 10 Dec 2009 08:28:22 +0100
Message-ID: <20091210072822.GA29161@boogie.lpds.sztaki.hu>
References: <4B204334.1000605@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4B204334.1000605@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: xfs@oss.sgi.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Dec 10, 2009 at 01:39:16AM +0100, Asdo wrote:

> I'm copying a bagzillion of files (14TB) from a 26disk MD-raid 6
> array to a 16disk MD-raid 6 array.
> Filesystems are XFS for both arrays.
[...]
> So I have repeatedly catted /proc/pid/stack for the reader and
> writer processes: the *writer* is the bottleneck, and 90% of the
> times it is stuck in one of the following stacktraces:

What does iostat say about the disk utilization during the copy?

IMHO copying a large amount of relatively small files means lots of
metadata operations which in turn means lots of small, scattered writes.
For parity RAID, that kind of load is a killer since writes smaller than
the stripe size will turn into "read all disks - modify the stripe -
write it back".

Use RAID10 if you want good performance for that kind of load.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
