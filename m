From: Gordon Henderson <gordon@drogon.net>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Sun, 1 Aug 2004 08:08:05 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net>
References: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Aug 2004, Mikael Abrahamsson wrote:

> And also because scsi drives can do tagged queueing which makes it more
> efficient to do a lot of smaller operations. Historically the SCSI drives
> also had more cache memory which helps the situation, and the scsi
> RAID controllers probably also had more cache memory on them (I know RAID
> systems that have gigabytes of cache memory).

What I find amusing these days is trying to work out the "boundary" point
between a "traditional" server with an (external) RAID controller and say
a Linux server with software RAID in a purely fileserving environment (eg.
NFS/Samba, not used for local operations at all) ... Both systems as a
unit provide the same services - ie. filespace at the end of the Ether,
but what are the advantages of one over the other, and why would I ever
want a hardware RAID controller in a PCI slot in a Server PC?

Discuss... ;-)

Gordon
