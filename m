From: Czigola Gabor <czigola@elte.hu>
Subject: Re: big raid5 trouble
Date: Mon, 2 Jan 2006 04:24:34 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0601020418570.15229@Kamorka>
References: <Pine.LNX.4.63.0601012310180.10488@Kamorka> <43B8649A.5030102@panix.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43B8649A.5030102@panix.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Jan 2006, berk walker wrote:

> I don 't think that will help you, per se.  Why do you say it is your last 
> chance? If you have n-1 disks OK, then you may be OK.  If not, a spare will 
> not help.  Can you tell us more?
> b-
>

So there is a RAID5 array with 4 disks. I had a long power failure, and 
during the boot sequence, I saw that the 4th disk got marked as non fresh. 
I started the process that should bring the 4th disk back in the array, 
but during this the 3th disk died. The 4th disk is now marked as spare.

Meanwhile a found the 4k superblock on the disk (strace mdadm -E), and I 
got - from the source of mdadm - the exact location of the spare flag. But 
I guess, I have to recalc the correct checksum of the new superblock.(?)

-- 
Czigola, Gabor


