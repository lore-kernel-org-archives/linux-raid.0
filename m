From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [patch 0/4 v2] optimize raid1 read balance for SSD
Date: Wed, 27 Jun 2012 22:47:05 -0300
Message-ID: <CABYL=TqKKCLPFi4NFoWFi=Lsw+oD3roLzy28=UoeaU46SML5kA@mail.gmail.com>
References: <20120613090922.971820942@kernel.org>
	<20120628110616.79d4481e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120628110616.79d4481e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org, axboe@kernel.dk
List-Id: linux-raid.ids

hi guys,
some time ago i made some tests in raid1 md code, and a 'good'
algorithm could improve 1% (mean) with some small variation (sometimes
3% sometime 0%) of performance boost (using new algorithm instead disk
distance), in other words... read of 1GB could be improved to 1,01GB
(10MB of improvement), well that was the result (about 1 year ago) and
for a busy database server, that=B4s a good improvement (some guys tell
that 0.01% of improvement is a improvement and should be used... well
doesn=B4t matter...)

IMHO, i think that a general algorithm to select 'best device to
read', should work with device information, and device information
functions (sata/scsi/etc), i don=B4t know if it=B4s implemented but if
not, should be implemented to work with this ideas....

putting code to select best distance is nice too, but it=B4s not genera=
l
(think about a disk with 2 heads... a hardware raid1 for example...)
the solution should be, get expected disks times to do some read job,
and select the disk with smallest time
for example, instead putting a lot of statistics code in md, put this
statistic in sata, scsi, or other 'under' device (nbd drbd ...) and
their elevators functions (noop cfq, etc...)

check that md should implement a prediction function too, for example
we could put a 2 pairs of raid1, and one raid0 over it, (a raid 1 + 0)
and raid0 will contact raid1 devices to know what=B4s the best disk to
read... well in this case just call 'unders' devices function to get a
estimate time and select the 'best' disk

this is a bit 'hard' and a lot of work should be done, but IMHO,
that=B4s what i think about 'ideal general solution'

at 'unders devices' (sata/scsi/drbd/nbd), today they could use
statistic based on read/write times without big problems (this is good
to have low cpu usage when we don=B4t know what=B4s the device is
constructed), or maybe in future this could be implement at disk
controller?! why not? see ssd drives, they implement a garbage
collection! why not implement a 'time prediction function'?!

just some ideas....=3D)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
