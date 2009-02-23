From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-10 unbalanced reads
Date: Tue, 24 Feb 2009 00:24:15 +0100
Message-ID: <20090223232415.GA24493@lazy.lzy>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk> <20090223221532.GA23542@lazy.lzy> <20090223225202.GA28505@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090223225202.GA28505@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> You think the sdb2 read rate of 151 blks/s vs sda2 63 blks/s is strange?
> Well, it does look strange. OTOH the tps is 
> 
> sdb2   5.93
> sda2   5.42 
> 
> Which is not so big a difference. 

Also the whole RAID tps somehow matches
the (sum of the) single devices.

> what is sdb1 and sda1 used for? the fugures there seems even stranger.
> It also looks strnge that the sdb disk is the slower about 80 MB/s
> while sda is around 110 MB/s - and then sdb produces more than sda...

The first partion (sda1, sdb1) is the /boot,
around 100MB, the rest (sda2, sdb2) is the LVM
physical volume, around 320GB.

Also this looks strange:

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
sdb2              4.98       109.30        64.28    1444432     849528
md1              10.45        95.23        51.27    1258536     677608

sdb2 has more reads than the whole RAID it belongs,
but tps are OK...

The only thing that *could* do something on the
raw devices is "smartd", I cannot think anything
else. Maybe I will disable it, for now...

bye,

-- 

piergiorgio
