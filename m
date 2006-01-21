From: carlos@fisica.ufpr.br (Carlos Carvalho)
Subject: Re: blog entry on RAID limitation
Date: Sat, 21 Jan 2006 18:43:41 -0200
Message-ID: <17362.40189.185082.715095@fisica.ufpr.br>
References: <8E5ACAE05E6B9E44A2903C693A5D4E8A097F6C86@hqemmail02.nvidia.com>
	<1137487538.309F9186@bd12.dngr.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1137487538.309F9186@bd12.dngr.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach (jeff@jab.org) wrote on 17 January 2006 00:45:
 >Is this a real issue or ignorable Sun propoganda?
 >
 >-----Original Message-----
 >From: I-Gene Leong
 >Subject: RE: [colo] OT: Server Hardware Recommendations
 >Date: Mon, 16 Jan 2006 14:10:33 -0800
 >
 >There was an interesting blog entry out in relation to Sun's RAID-Z
 >talking about RAID-5 shortcomings:
 >
 >http://blogs.sun.com/roller/page/bonwick?entry=raid_z
 >
 >It sounds to me like RAID-1 would also be vulnerable to the write hole
 >mentioned inside.

The write-hole exists ONLY when the machine stops without a proper
shutdown AND with an incomplete array (eg. one disk out of the array
in a raid5). Sometimes this happens when the machine crashes or power
goes down and on reboot one disk fails.

If I understand Sun's marketing ZFS always writes full stripes in all
disks, which means the array is never dirty. Therefore the write-hole
indeed doesn't exist.

The problem with the argument is that the write-hole is not so big of
a problem in a well-behaving server because the probability of a crash
and an incomplete array happening simultaneously is very small, so
Sun's feature is not so important.
