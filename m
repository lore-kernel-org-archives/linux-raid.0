From: PFC <lists@peufeu.com>
Subject: Re: block level vs. file level
Date: Mon, 13 Feb 2006 09:48:49 +0100
Message-ID: <op.s4wlfngxcigqcu@apollo13>
References: <43EF8CFB.5080403@kfa.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43EF8CFB.5080403@kfa.org>
Sender: linux-raid-owner@vger.kernel.org
To: it <itech@kfa.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> This also raises another point, which is relevant for both cases - same  
> exact models of hard disks have different number of cylinders, so if a  
> RAID partition is created on a larger drive it cannot be mirrored to a  
> smaller drive.

	I have a RAID5 with 5 250G drives, but some are 251 GiB (maxtors), some  
are 250.059 GiB (seagate)... say, if I started with 5 Seagates, I could  
later replace one of them with a Maxtor, but not the other way around, as  
the Seagate are just a tiny bit smaller.

	cfdisk says :

     sdb1      250994,42
     sdc1      250056,74

	I suggest, when using software raid, to create partitions that are, say,  
100 megabytes or even a gigabyte smaller than the size of the drive. You  
lose a bit of space, but if you ever need to change one, you won't feel  
stupid with a brand new drive that you can't use because it's a few  
sectors too short.

