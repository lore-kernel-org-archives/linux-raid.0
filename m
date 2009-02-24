From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: RAID-10 unbalanced reads
Date: Tue, 24 Feb 2009 10:00:34 +0100
Message-ID: <20090224090034.GA8051@rap.rap.dk>
References: <20090209202728.GA11996@lazy.lzy> <20090209231138.GB13450@rap.rap.dk> <20090223221532.GA23542@lazy.lzy> <20090223225202.GA28505@rap.rap.dk> <20090223232415.GA24493@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090223232415.GA24493@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 24, 2009 at 12:24:15AM +0100, Piergiorgio Sartor wrote:
> Hi,
> 
> > You think the sdb2 read rate of 151 blks/s vs sda2 63 blks/s is strange?
> > Well, it does look strange. OTOH the tps is 
> > 
> > sdb2   5.93
> > sda2   5.42 
> > 
> > Which is not so big a difference. 
> 
> Also the whole RAID tps somehow matches
> the (sum of the) single devices.

And is about equal +- 10 % for the two devices.

The boot partition is most likely a raid1 partition, which is quite
oriented towards a very uneven usage, theory will tell that if you are
mostly reading sequentially, you are better off just reading from one
device, as you can always read all content in the same time as it would
take to only read hlaf of the content, because you have to skip data
otherwise.


> > what is sdb1 and sda1 used for? the fugures there seems even stranger.
> > It also looks strnge that the sdb disk is the slower about 80 MB/s
> > while sda is around 110 MB/s - and then sdb produces more than sda...
> 
> The first partion (sda1, sdb1) is the /boot,
> around 100MB, the rest (sda2, sdb2) is the LVM
> physical volume, around 320GB.
> 
> Also this looks strange:
> 
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> sdb2              4.98       109.30        64.28    1444432     849528
> md1              10.45        95.23        51.27    1258536     677608
> 
> sdb2 has more reads than the whole RAID it belongs,
> but tps are OK...

Depends on how you measure things. It could be that sdb2 has delivered
some blocks that md1 did not use, and thus did not register as read.

Are these numbers taken like just after a boot?
Activity on /boot indicates this. You seldomly use /boot after booting.
If so, it is a bit interesting that you have about 1/3 of the IO done in
writing. Why is there so much wroting? I thought that booting was 
almost only reading.

And sdb2 reading should only be about 1/2 of total md1 reading, 
the rest should be on sda2.
> 
> The only thing that *could* do something on the
> raw devices is "smartd", I cannot think anything
> else. Maybe I will disable it, for now...

I think that would be a good idea for your testing.

best regards
keld
