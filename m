From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Assembly problems with kernel 2.6.30?
Date: Fri, 12 Jun 2009 12:00:03 +0400
Message-ID: <4A320B03.5080009@msgid.tls.msk.ru>
References: <20090611072538.GA7841@psychosis.jim.sh> <18993.45142.80174.321434@notabene.brown> <20090612023344.GA24806@psychosis.jim.sh>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090612023344.GA24806@psychosis.jim.sh>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Paris <jim@jtan.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Paris wrote:
[]
> Weird: /dev/sdc2 has both a 0.90 and 1.0 superblock.  I guess that's
> the problem.  How would that have happened?  mdadm --create over an 
> existing device without a --zero-superblock inbetween, I suppose?
> 
> I wonder why it was never a problem before.  For the root, only
> /dev/sda2 and /dev/sdb2 are necessary.  Maybe 2.6.30 changed the disk
> order, or the ordering of /proc/partitions, such that mdadm now
> examines this bad disk before the array is fully assembled, whereas it
> never needed to scan it before?

2.6.30 turned on "fastboot" option by default -- it's when
all disks/controllers gets scanned in parallel.

/mjt
