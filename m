From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 22:24:59 +0100
Message-ID: <bqv2c2-uec.ln1@news.it.uc3m.es>
References: <20050117010355.GH347@unthought.net> <20050119195154.23514.qmail@web60405.mail.yahoo.com> <a0s2c2-7i2.ln1@news.it.uc3m.es> <200501192217.29258.maarten@ultratux.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

maarten <maarten@ultratux.net> wrote:
> On Wednesday 19 January 2005 21:19, Peter T. Breuer wrote:
> > Poonam Dalya <poonamsbox@yahoo.com> wrote:
> > > I mounted my /dev/md1 on /mnt/raid. and then wrote a
> > > file on it. Then I tried to mount the raid disks
> > > /dev/hda10 on some other mount point and checked that
> > > mount point. But there was nothing in that mount
> > > point. Please could you please help me with this.
> 
> You did not forget to format / mkfs it I suppose ?
> 
> > Don't do that then. Do you have any reason to suppose that buffers were
> > already written to the top level system yet, or that mounting the same
> > device twice will caus eanything but pain and confusion and much
> > wailing and gnashing of teeth?
> 
> Sigh.

You don't understand - he mounted the raw partitions that make up the
raid array WHILE THE RAID WAS RUNNING somewhere else.

If the mount had failed he would have said. Therefore it did not fail.
If he had unmounted the raid array first, then the umount would have
flushed buffers to that device (the kernel sends flush_buffers or
whatever it is called nowadays) and the file would have been visible
when he did the later mount.

It was not, therefore he did not.



Peter

