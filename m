From: Claudio Fleiner <raid@fleiner.com>
Subject: Re: raidtools-20010914
Date: Thu, 19 Dec 2002 16:22:45 GMT
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200212191622.gBJGMbK08626@ars.net>
References: <3E01CBD8.6A18B88F@softers.net>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E01CBD8.6A18B88F@softers.net>;	from Jarmo =?iso-8859-1?Q?J=E4rvenp=E4=E4?=         <Jarmo.Jarvenpaa@softers.net> on Thu, 19 Dec 2002 15:38:32 +0200
To: Jarmo =?iso-8859-1?Q?J=E4rvenp=E4=E4?= <Jarmo.Jarvenpaa@softers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I had the same problem and a quick look at the kernel shows
that although the ioctl for generating the fault exists
in the kernel, the main part is commented out and therefore
the operation is a noop.

This is true for the 2.4.19 and at least the beginning of
the 2.5.* kernels. If you want to use raidhotgenerateerror
you need to edit a few kernel files.

Claudio


on Thu, 19 Dec 2002 15:38:32 +0200 Jarmo =?iso-8859-1?Q?J=E4rvenp=E4=E4?= 
        <Jarmo.Jarvenpaa@softers.net> wrote:
> - 3 RAID 1 devices with each having 2 partitions mirrored together.
> - Kernel 2.4.20
> 
> I tried to remove /dev/hda1 from /dev/md0 by using raidhotgenerateerror
> and got this:
> 

----------------------------------------------------------------------------
Claudio Fleiner                                          claudio@fleiner.com


