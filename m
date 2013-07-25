From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Thu, 25 Jul 2013 18:27:52 -0500
Message-ID: <51F1B478.4050901@hardwarefreak.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com> <51F19E0F.5000400@tmr.com> <CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/25/2013 5:36 PM, Roberto Spadim wrote:

> i don't know what's the best xfs parameters / fdisk parameters to
> align disk with filesystem, should i add some parameter?

You don't align a filesystem with fdisk.  fdisk creates partitions.  As
I said earlier, start your first partition at sector 2048, and create
each successive partition to be of a size evenly divisible by 4096 bytes.

WRT mkfs.xfs, use the defaults.  It reads the md config and configures
automatically.  You only need to specify command line values when using
hardware RAID or LVM atop hard or software RAID.

And in your case, with only two mirrored spindles, you simply can't do
anything to tweak XFS performance anyway.

-- 
Stan

