From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: wish for Linux MD mirrored raid types
Date: Fri, 06 May 2011 16:43:22 -0400
Message-ID: <4DC45D6A.5050905@meetinghouse.net>
References: <79.BD.29443.A4A54CD4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79.BD.29443.A4A54CD4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Leslie Rhorer wrote:
> 	The bottom line, however, is that even if RAID1 is at the code level
> just a specific implementation of RAID10, it still is a sufficiently
> distinct operational mode to warrant its own name, setting it aside from the
> more general RAID10 implementation.  Aside from that, when I say, "My
> servers boot from 2 disk RAID1 arrays", everyone knows exactly what I mean
> without my having to go into more detail about the layout.  For the most
> part, it doesn't really matter if I happened to create the array using a
> specific layout of RAID10.  This has its greatest importance for someone
> inexperienced with RAID systems, who perhaps is setting up his very first
> mirrored array with a pair of disks.  Having to try to learn all the ins and
> outs of RAID10 layouts just to be able to create a pair (or triplet) of
> mirrored disks is not appropriate.
>    

Good points all.

It is worth noting, that in this context, it's pretty silly to use a 
fancy setup for /boot and swap space - simple RAID1 mirrored partitions 
work just fine.  Where RAID10 is excellent is as a starting point for 
LVM, and volumes that support virtual machines.

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


