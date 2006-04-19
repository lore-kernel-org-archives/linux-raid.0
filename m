From: Tim Moore <linux-raid@nsr500.net>
Subject: Re: Real Time Mirroring of a NAS
Date: Tue, 18 Apr 2006 21:23:54 -0700
Message-ID: <4445BB5A.8060201@nsr500.net>
References: <44364336.7060704@aol.com> <8110058661.20060407200418@2ka.mipt.ru> <4436984A.9020803@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4436984A.9020803@aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



andy liebman wrote:
 > ...
> By the way, I use 3ware 9550SX cards. On a 16 drive RAID-5 SATA array, I 
> can get sequential reads that top 600 MBs/sec. That's megabytes, not 
> megabits. And write speeds are close to 400 MB/sec with the new faster 
> on-board XOR processing. And random reads are at least 200 MB/sec. So, 
> 10 GbE is a must, really.

A 400MB/s network input stream means either 1x10GbE or 4xGbE's to 
PCI-X/PCI-e bus, then to disk, then to PCI-X/PCI-e bus, then across another 
net to the backup system, so the I/O subsystem alone must handle 800MB/s.

3ware may actually do a single 400MB/s stream, but what about 4x100MB/s or 
8x50MB/s?  It's really hard to do that much I/O _and_ provide data 
integrity.  If your data rates and the mirroring requirements are that 
critical you might want to look at the fast NAS systems coming out (eg- 
agami.com) built on top of AMD's HT architecture.

Cheers,


> 
> Andy
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
  | for direct mail add "private_" in front of user name
