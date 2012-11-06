From: Shaohua Li <shli@kernel.org>
Subject: Re: Problem with DISCARD and RAID10
Date: Tue, 6 Nov 2012 19:40:17 +0800
Message-ID: <20121106114017.GB19182@kernel.org>
References: <5098D92A.3000503@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5098D92A.3000503@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <brad@fnarfbargle.com>
Cc: linux RAID <linux-raid@vger.kernel.org>, martin.petersen@oracle.com
List-Id: linux-raid.ids

On Tue, Nov 06, 2012 at 05:32:26PM +0800, Brad Campbell wrote:
> G'day Shaohua,
> 
> I'm testing Vanilla 3.7.0-rc4 and bumping up against squillions of these :
> 
> [   41.094726] request botched: dev sdc: type=1, flags=122d8081
> [   41.094774]   sector 28317178, nr/cnr 0/32
> [   41.094815]   bio ffff8807fe885300, biotail ffff8807fe887300,
> buffer           (null), len 0
> [   41.100045] request botched: dev sda: type=1, flags=122d8081
> [   41.100094]   sector 28317403, nr/cnr 0/32
> [   41.100134]   bio ffff8807fe885840, biotail ffff8807fe887840,
> buffer           (null), len 0
> [   41.100718] request botched: dev sdb: type=1, flags=122d8081
> [   41.100767]   sector 28317179, nr/cnr 0/224
> [   41.100808]   bio ffff8807fe885a80, biotail ffff8807fe887d80,
> buffer           (null), len 0
> [   41.104649] request botched: dev sdc: type=1, flags=122d8081
> [   41.104697]   sector 28317179, nr/cnr 0/224
> [   41.104738]   bio ffff8807fe886000, biotail ffff8807fe887300,
> buffer           (null), len 0

cc Martin to check if he has idea.

Hmm, I thought such problem is already fixed by Martin's discard merge patches
and my last test in SATA SSD doesn't show this problem. Maybe there is still
a corner case we didn't handle discard request merge well. Time run out today,
I'll check tomorrow.

Thanks,
Shaohua
