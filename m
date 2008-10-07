From: Bryce <bryce@zeniv.linux.org.uk>
Subject: Re: Determining filename from absolute sector failure in raid0
Date: Tue, 07 Oct 2008 17:34:54 +0100
Message-ID: <48EB8FAE.8060102@zeniv.linux.org.uk>
References: <48EB6C22.9060302@zeniv.linux.org.uk> <A20315AE59B5C34585629E258D76A97C022DB5A5@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C022DB5A5@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Lethe wrote:
> ------------------------------------------------
> --------------------
> What you need is a utility program that translates a physical device &
> offset and converts that into a logical block in md0. Then
> Something that maps a logical block in md0 to a file in a filesystem.
>
> Unfortunately, I am not aware of any off-the-shelf utility to do this,
> but put me down for being very interested in such a solution myself.
> David
>
>
>   
well another part of the 'what do i do now?' question is that
/proc/mdstat shows the drives assembled thusly
hdk1[0] hdg1[2] hdf1[1] hde1[3]

and mdadm --examine shows the order as hde 0 hdf 1 hdg 2 hdk 3
err whats the actual order?

Phil
=--=



