From: Berkey B Walker <berk@panix.com>
Subject: Re: Growing a single disk into a 2 disk raid0
Date: Fri, 28 Jan 2011 12:53:58 -0500
Message-ID: <4D4302B6.2090208@panix.com>
References: <4D42FA3E.6000206@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D42FA3E.6000206@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Phillip Susi wrote:
> I had someone wanting to take an existing disk full of data and expand
> it by adding a second disk.  This seemed reasonable, and I thought of
> several ways you could do this, but none of them pan out:
>
> 1)  Create a single disk raid0 using the existing disk, then reshape it
> adding the second disk.  mdadm fails to add the second disk as a spare
> so that you can reshape, with the kernel complaining that personality
> does not support diskops.
>
> 2)  Create a single disk raid1 using the existing disk, then reshape it
> adding the second disk.  Apparently you can not reshape from raid1 to raid0.
>
> 3)  Create a raid10 using the existing disk, setting the number of near
> copies to only 1 so as to preserve the existing data, then reshape
> adding the second disk.  I ran into two problems here:
>
> a) mdadm refuses to create a single disk raid10, saying that at least
> two devices are needed for raid level 4 or 5.  I am surprised that you
> can not create a single disk raid10 even with --force, and the message
> mentions the wrong level.  I would think that a single disk raid10 with
> 2 far copies would be fairly useful.
>
> b) I tried 2 disks with one missing and mdadm refuses to create a raid10
> with only a single near copy.  The kernel complains that layout 0x101 is
> unsupported.
>
> Is there any way to accomplish this?
>
>    
Because 1) I'm old, and 2) I don't trust documentation, I do it the 
slow, easy way.  I use the blank disk and make a RAID missing a disk.  I 
then copy the data to the RAIDed disk.  If everything is OK, zero out 
the old data disk and add it to the raid (filling the "missing").  I do 
it this way any time I want to make  raid  of a disk full of data, to 
any level of raid.
b-

