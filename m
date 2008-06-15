From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Weird corruptions read error.
Date: Sun, 15 Jun 2008 04:52:48 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0806150449430.2797@p34.internal.lan>
References: <1213508229.4854aa85e9f52@www.imp.polymtl.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1213508229.4854aa85e9f52@www.imp.polymtl.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Karl Dubois <karl-2.dubois@polymtl.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 15 Jun 2008, Karl Dubois wrote:

> Hey everyone!
>
> I'll make it quick. I've got two arrays, both composed of 4 disks. The first one
> works fine and is composed of 4 disk (sda4, sdb1, sdd2, sdf2).
>
> The second one is composed of four disk (sdc1, sdd1, sde1, sdf1) and gives some
1. Show smartctl -a output for all disks.
2. Have you tried swapping the disks?
    array1 -> array2's controller/port/cables
    array2 -> array1's controller/port/cables
    .. and see if the problem persists?
3. Also what filesystem?
4. Have you run an fsck?

Seems like a very odd problem since both arrays share some of the same 
disks: sdd/sdf

Have you tried isolating/putting the other two 'non-shared' disks of the 
second raid on a different controller?  Changing SATA cables/etc?

Justin.
