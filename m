From: Julian Cowley <julian@lava.net>
Subject: Re: [RAID] Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Mon, 2 Aug 2004 15:58:27 -1000 (HST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408021554070.7168@taurus.cesta.com>
References: <Pine.LNX.4.44.0408010858370.7382-100000@uplift.swm.pp.se>
 <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0408010804370.6442@lion.drogon.net>
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Aug 2004, Gordon Henderson wrote:
> On Sun, 1 Aug 2004, Mikael Abrahamsson wrote:
> > And also because scsi drives can do tagged queueing which makes it more
> > efficient to do a lot of smaller operations. Historically the SCSI drives
> > also had more cache memory which helps the situation, and the scsi
> > RAID controllers probably also had more cache memory on them (I know RAID
> > systems that have gigabytes of cache memory).
>
> What I find amusing these days is trying to work out the "boundary" point
> between a "traditional" server with an (external) RAID controller and say
> a Linux server with software RAID in a purely fileserving environment (eg.
> NFS/Samba, not used for local operations at all) ... Both systems as a
> unit provide the same services - ie. filespace at the end of the Ether,
> but what are the advantages of one over the other, and why would I ever
> want a hardware RAID controller in a PCI slot in a Server PC?
>
> Discuss... ;-)

Recently I did a survey of this very question (hardware vs. software
RAID) based on the comments from this mailing list:

Software
--------

- CPU must handle operations
- twice the I/O bandwidth when using RAID1
+ non-proprietary disk format
+ open source implementation
- limited or non-existent support for hot-swapping, even with SATA
  (see http://www.redhat.com/archives/fedora-test-list/2004-March/msg01204.html)
- OS-specific format (can't be shared between Linux, Windows, etc.)
+ drives can be anything (ie. a mixture of SATA, PATA, Firewire, USB, etc.)
- disk surface testing must be done manually (7/2004)
- no bad block relocation (7/2004)
- no parity verification (7/2004)
- no mirror verification (7/2004)
+ reputedly, much better performance than hardware raid

Hardware
--------

+ off-loads the CPU
+ I/O bandwidth needed on a RAID1 system is same as single disk
- proprietary disk format (although limited drivers are available for Linux)
- proprietary implementation
+ easy hot-swapping (some controllers even indicate the bad drive with an LED)
+ non-OS-specific (can share between Linux, Windows, etc.)
- some features may not be supported on non-Windows operating systems
+ able to create logical disks that seem like physical disks to the OS
+ bad sector relocation (on the fly?)
- drives must connect to the controller and all must be same type (e.g. SATA)
+ disk surface testing done automatically
+ automatic bad block relocation
+ parity verification
+ mirror verification
