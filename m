From: "David Lethe" <david@santools.com>
Subject: RE: Determining filename from absolute sector failure in raid0
Date: Tue, 7 Oct 2008 14:04:56 -0500
Message-ID: <A20315AE59B5C34585629E258D76A97C022DBA16@34093-C3-EVS3.exchange.rackspace.com>
References: <48EB6C22.9060302@zeniv.linux.org.uk> <A20315AE59B5C34585629E258D76A97C022DB5A5@34093-C3-EVS3.exchange.rackspace.com> <48EB8FAE.8060102@zeniv.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <48EB8FAE.8060102@zeniv.linux.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Bryce <bryce@zeniv.linux.org.uk>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Bryce
> Sent: Tuesday, October 07, 2008 11:35 AM
> To: Linux RAID Mailing List
> Subject: Re: Determining filename from absolute sector failure in
raid0
> 
> David Lethe wrote:
> > ------------------------------------------------
> > --------------------
> > What you need is a utility program that translates a physical device
> &
> > offset and converts that into a logical block in md0. Then
> > Something that maps a logical block in md0 to a file in a
filesystem.
> >
> > Unfortunately, I am not aware of any off-the-shelf utility to do
> this,
> > but put me down for being very interested in such a solution myself.
> > David
> >
> >
> >
> well another part of the 'what do i do now?' question is that
> /proc/mdstat shows the drives assembled thusly
> hdk1[0] hdg1[2] hdf1[1] hde1[3]
> 
> and mdadm --examine shows the order as hde 0 hdf 1 hdg 2 hdk 3
> err whats the actual order?
> 
> Phil
> =--=
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

It is not that easy, you have to look at the topology of the RAID,
factor in starting/ending block numbers, journaling, chunk/stripe size,
RAID level, etc..    in order to obtain the logical block number that
corresponds to any given physical disk number & raid configuration.

Lets call this magic routine PhysToLog(int mdNumber,char *PhysDev,
size_t PhysBlockNumber);

That routine in perfect world would query the md config and return a
64-bit logical block number (let's future-proof the code), and if you
had parity RAID, then would need to know the physical stripe number that
would need to get rebuilt in event the bad block mapped to a parity
(XOR) data.

Since you have RAID0, you have a lot of variables to eliminate, and can
extrapolate this information.  Part 2, which can be done independently,
is the logical block to physical block.

Let's assume you manually take it apart and now have a logical block
number in md0 that maps to the physical block ...

Look at this link: it will help to convert a known "bad block" to file's
inode, which is what you need.  
     http://mail-index.netbsd.org/tech-userlevel/2003/04/17/0000.html


Too bad there isn't a mapbadblock2file command that ties this all up
into a nice pretty package for everybody.  It would be a big hit in
dealing with data corruption and drive failures. I'm doing a 2TB rebuild
as we speak scanning for corrupted blocks.  

 

