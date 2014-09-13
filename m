From: Ethan Wilson <ethan.wilson@shiftmail.org>
Subject: Re: Speeding up reading with RAID1 and --write-mostly
Date: Sat, 13 Sep 2014 13:56:54 +0200
Message-ID: <54143106.6030501@shiftmail.org>
References: <20140913060143.GA15849@fishbowl.rw.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140913060143.GA15849@fishbowl.rw.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/09/2014 08:01, martin f krafft wrote:
> Assuming there is a MMC fast enough out there, how about creating
> a RAID1 across MMC and parts of the rotational disk, with the
> rotational disk flagged --write-mostly? This RAID would then hold
> the system, while the data would sit on the rotational disk.

1) Firstly, MMC, SD etc are all very slow in random access. They are 
optimized for physical size and not for speed.

2) Secondly, in order to use --write-mostly, you need two devices of the 
same size, so you need an MMC as big as your HDD.

Something different from (2) is called SSD-caching, and in Linux kernel 
there are two approaches to do that, one is dm-cache and the other is 
bcache. Both are very young and I don't know how much stable.

