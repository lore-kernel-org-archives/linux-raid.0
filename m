From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Need Advice regarding chunk size of RAID6 regarding HFS+
Date: Tue, 18 Feb 2014 18:38:05 -0600
Message-ID: <5303FCED.3060105@hardwarefreak.com>
References: <FDEECA55-97E1-448E-AA80-76155613D8FD@gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FDEECA55-97E1-448E-AA80-76155613D8FD@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Florian Lampel <florian.lampel@gmail.com>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/18/2014 4:40 PM, Florian Lampel wrote:
> Hi everyone,
> 
> thanks again for getting me up and running again. I'm in the process
> of copying over my backups, but even when connecting my RAID6 via
> iSCSI directly via a dedicated ethernet cable using a dedicated
> IP-Range and Subnet, I only get write speeds of about 55MB/s and read
> speeds of about 68MB/s when copying a single, large file.

First eliminate the network as the bottleneck.  What's your iperf
throughput?  You have over 1 GB/s peak throughput at the disks.
Anything less than 100 MB/s through the interface points to network
limitations, either ASICs or the IP stacks on the hosts.  If any of your
network ASICs are Realtek or Marvell, i.e. the cheapos, that'll be a
limiting factor.  With the Intel and Broadcom ASICs you typically get
close to wire speed.

> Having read enough about chunk sizes to make my head spin, I would
> like to know what chunk size you'd recommend for the following
> scenario:
> 
> *) The filesystem used is HFS+, and this means it's hard-coded to a
> 4kb block size.
> 
> *) The RAID is a RAID6 consisting of 12 HDDs (Western Digital RED,
> 2TB) using a chunk size of 512k (I stuck with the default).

Chunk size isn't your limiting factor with the large file write/read.

> *) Typical Usage consists of downloading material using Bittorrent
> and JDownloader (aka: lots of small writes) 

Then write throughput isn't a factor here, thus the RMW resulting from
partial stripe writes isn't a factor.

> and feeding an AppleTV
> and Macs using iTunes (aka: Large files (Movies) being read from the
> RAID).

Your stripe width is 5MB, which should be fine for streaming reads of
large files.

> *) While the Filesystem is encrypted using LUKS, I got everything to
> align properly and my CPU supports AES-NI, so there is no performance
> penalty on this front.

There is always a performance penalty when doing full disk encryption.
You should still have well over 100 MB/s throughput though, so your
network is limiting you far more than your encryption.

> *) The filesystem gets exported to a Mac Mini via iSCSI and then
> shared over the network using AFP and iTunes.
> 
> 
> Any ideas?

Yes.  Your network is deficient.

-- 
Stan

