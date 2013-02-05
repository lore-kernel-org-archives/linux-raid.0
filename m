From: Hans-Peter Jansen <hpj@urpla.net>
Subject: Re: Interpreting mdstat output
Date: Tue, 05 Feb 2013 23:43:38 +0100
Message-ID: <1827669.aUsTuMxdDb@xrated>
References: <7952623.6.1360067441417.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7952623.6.1360067441417.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Dienstag, 5. Februar 2013, 13:30:41 schrieben Sie:
> > (Ubuntu 12.04.2, kernel 3.2.0-37-generic)
> > 
> > I created a RAID5 array with 22 data disks and 2 hot spares, like
> > this:
> > 
> > # mdadm --create /dev/md/dbs -l raid5 -n 22 -x 2 -c 512 -b internal
> > /dev/sd{b..y}
> 
> I beleive using 22 drives in a single RAID-5 is something like BASE jumping
> with a large umbrella.

That is Bungee-Jumping with the cord tied to your testicles...

SCR,
Pete

https://lkml.org/lkml/2002/7/14/142

