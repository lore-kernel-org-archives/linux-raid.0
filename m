From: Maarten van den Berg <maarten@vbvb.nl>
Subject: Re: RAID 0 -> 1 possible?
Date: Fri, 12 Mar 2004 00:03:23 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403120003.23475.maarten@vbvb.nl>
References: <4050CF9C.6000704@microcenter.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4050CF9C.6000704@microcenter.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 11 March 2004 21:44, Jeff Hoffmann wrote:
> Hello list,
>
> Is it possible to convert from RAID 0 to 1 without data loss?
 
No, obviously.  Raid 1 is mirrored, so your useable space is only half of your 
total capacity at best. Raid 0 uses the full capacity of the disks, so until 
you can solve how to put twice as many data onto the same space, one cannot 
convert from raid0 -> raid1 without 'losing data'...

> Given a system with two disks, three partitions on each: boot, /, and swap.
>
> Convert / from RAID 0 to 1 without requiring a backup/reinstall/restore
> scenario

Even without the <total data size> problems as outlined above, you cannot 
touch either disks of a raid 0 set without destroying data, that is the whole 
point of raid 0.  So, even an online-migration tool sounds implaudible. 

> Any RAID-mojo-masters with the answer?

I'm not a RAID-mojo-master, but then again I don't believe one needs to be one 
to answer this. It stems directly from the theory of operation of the levels. 

Maarten

