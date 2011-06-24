From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: Looking for the best way to do this
Date: Fri, 24 Jun 2011 12:59:42 -0400
Message-ID: <4E04C27E.7040608@cdf.toronto.edu>
References: <4E00DF31.2020406@gmail.com> <4E03929A.8000503@cdf.toronto.edu> <4E03B8DB.7010607@gmail.com> <4E04B8A9.1050502@cdf.toronto.edu> <4E04BCCF.9000604@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E04BCCF.9000604@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maurice <mhilarius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Maurice,

On 06/24/11 12:35, maurice wrote:
> Set aside (disconnect) 1 of the existing 2 disks.
> Boot from emergency recovery media, making sure the md version is
> relatively current ( newer than 3.0 ?)
>
> Create the R10 with the other 2 disks ( 1 old and 1 new) with 1 of the 3
> disks missing.
> I think I have to wipe the superblock on the disk that was formerly part
> of the RAID1 set.

I think your procedure can be made less risky by making a R10, with 
layout f3 with *two* missing disks. Since there are *3* copies in the 
R10, there is no problem with having just one "real" disk and two 
missing ones. This way, you don't have to live with just one of the R1 
disks and hope it doesn't go bad during the copy operation.

Then, you copy the data from your old R1 to your new R10 with the two 
missing disks. When the data is copied over, you can remove *one* of the 
disks from the R1, zero the superblock, and add it to the R10. When the 
rebuild is complete, and only then, zero the superblock of your last R1 
disk, and add it to the R10.

With this mod, your data never really lost redundancy during the entire 
procedure (except when you remove the first disk from the R1 and move it 
to the R10, but instead of redundancy, you have 2 copies - one on the 
R10 and one on the R1 at that point, so it's still redundant in a way).

Whether or not you use this revised procedure, write yourself a 
step-by-step guide with all the commands (a TO-DO list), and if you 
want, you can share it with the list if you're not confident.

Cheers,
Iordan
