From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: raid5 endian question....
Date: Sun, 19 Jun 2005 18:05:22 -0400
Message-ID: <42B5EC22.4030906@steeleye.com>
References: <61C14314-53E9-4140-A4DB-3929A683FE67@blight.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <61C14314-53E9-4140-A4DB-3929A683FE67@blight.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Botsis <aaron@blight.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Aaron Botsis wrote:
> I'm attempting to move a raid5 array from a big endian ppc machine to  a 
> little endian x86.

> Upon trying to import the array, I get:
> mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc,  got 
> fc4e2ba9)

> I assume this to be an endianess issue...

Yes.

> Is this a bug? Is just the magic number whacked? or are the  superblock 
> data structures too?

The version 0.90 superblock is not "endian agnostic". It records data in 
whatever endian order the host machine is (Version 1 superblocks, by the 
way, fix this, but are not available unless you have the latest 2.6 
kernel and mdadm).

> what's the best way to fix this?

Unfortunately, I don't think there's an easy way. But, if you can get 
the array back up on the original machine and copy down all the 
information (or if you already have it) then you can re-create the array 
on the x86 machine using "mdadm -C", but be careful... :)

--
Paul
