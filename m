From: "Ivan Yordanov" <iyordanov@taxback.com>
Subject: Re: [Fwd: Re: Missing superblock on one of the raid devices on raid 0 with 1.2 metadata]
Date: Fri, 15 Mar 2013 10:24:05 +0200
Message-ID: <1363335845.18187.10.camel@gandalf.taxback.ess.ie>
References: <1363335578.29317.0.camel@hanna64.taxback.ess.ie>
Reply-To: "Ivan Yordanov" <iyordanov@taxback.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <1363335578.29317.0.camel@hanna64.taxback.ess.ie>
Sender: linux-raid-owner@vger.kernel.org
To: Nikolay Kichukov <nkichukov@taxback.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

The detailed info for this broken raid 0 is here:

mdadm --version
mdadm - v3.1.4 - 31st August 2010

mdadm -E /dev/sda1
mdadm: No md superblock detected on /dev/sda1.

mdadm -E /dev/sdb1
/dev/sdb1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 314351c1:8fd287cb:21bd5e93:56aa71c7
           Name : gandalf:0  (local to host gandalf)
  Creation Time : Mon Aug 23 13:47:57 2010
     Raid Level : raid0
   Raid Devices : 4

 Avail Dev Size : 312574594 (149.05 GiB 160.04 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4a303267:fd84a859:ecb68475:a797a615

    Update Time : Mon Aug 23 13:47:57 2010
       Checksum : 2739d1d7 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 1
   Array State : AAAA ('A' == active, '.' == missing)

mdadm -E /dev/sdc1
/dev/sdc1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 314351c1:8fd287cb:21bd5e93:56aa71c7
           Name : gandalf:0  (local to host gandalf)
  Creation Time : Mon Aug 23 13:47:57 2010
     Raid Level : raid0
   Raid Devices : 4

 Avail Dev Size : 312574594 (149.05 GiB 160.04 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 72c265f4:76e8edcc:7154fd89:77478688

    Update Time : Mon Aug 23 13:47:57 2010
       Checksum : af0b14cf - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 2
   Array State : AAAA ('A' == active, '.' == missing)

mdadm -E /dev/sdd1
/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 314351c1:8fd287cb:21bd5e93:56aa71c7
           Name : gandalf:0  (local to host gandalf)
  Creation Time : Mon Aug 23 13:47:57 2010
     Raid Level : raid0
   Raid Devices : 4

 Avail Dev Size : 312574594 (149.05 GiB 160.04 GB)
    Data Offset : 2048 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : e5f46d32:b2e0f6b4:0b361c98:9689dcb2

    Update Time : Mon Aug 23 13:47:57 2010
       Checksum : d916338 - correct
         Events : 0

     Chunk Size : 512K

   Device Role : Active device 3
   Array State : AAAA ('A' == active, '.' == missing)


uname -a  
Linux gandalf 3.5.0vs2.3.4-vs2.3.4 #1 SMP Tue Jan 8 08:31:15 EET 2013
x86_64 Intel(R) Core(TM) i3 CPU 530 @ 2.93GHz GenuineIntel GNU/Linux

Thanks for your help
Ivan Yordanov

On Fri, 2013-03-15 at 10:19 +0200, Nikolay Kichukov wrote:
> email message attachment, "Forwarded message - Re: Missing superblock
> on one of the raid devices on raid 0 with 1.2 metadata"
> > -------- Forwarded Message --------
> > From: Phil Turmel <philip@turmel.org>
> > To: Nikolay Kichukov <nkichukov@taxback.com>
> > Cc: linux-raid@vger.kernel.org, Ivan Yordanov
> > <iyordanov@taxback.com>
> > Subject: Re: Missing superblock on one of the raid devices on raid 0
> > with 1.2 metadata
> > Date: Thu, 14 Mar 2013 11:32:47 -0400
> > 
> > On 03/14/2013 10:27 AM, Nikolay Kichukov wrote:
> > > Hi all,
> > > 
> > > We are trying to recover a broken raid 0. It consisted of 4 raid
> > > devices. One of them got the metadata/superblock zeroed and now the raid
> > > cannot assemble.
> > > 
> > > OS: Gentoo Linux
> > > 
> > > My colleague will be able to provide more information regarding kernel
> > > version and mdadm version.
> > > 
> > > Is there a way to copy the superblock/metadata from one of the remaining
> > > drives and edit it prior to placing it on the zeroed drive so that the
> > > raid can be assembled?
> > > 
> > > Any hints and pointers are welcomed. Is it possible to fix the raid in
> > > the first place? If yes, then how do we locate the superblock/metadata
> > > that needs to be copied and edited from one of the raid member devices?
> > 
> > Start by showing the output of "mdadm -E /dev/sdX" for all of the other
> > member devices or partitions.  It's likely to be possible to fix your
> > problem.
> > 
> > Phil

