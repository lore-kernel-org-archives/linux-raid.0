From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Checking if RAID does work?
Date: Wed, 19 Jan 2005 21:19:54 +0100
Message-ID: <a0s2c2-7i2.ln1@news.it.uc3m.es>
References: <20050117010355.GH347@unthought.net> <20050119195154.23514.qmail@web60405.mail.yahoo.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Poonam Dalya <poonamsbox@yahoo.com> wrote:
> I mounted my /dev/md1 on /mnt/raid. and then wrote a
> file on it. Then I tried to mount the raid disks
> /dev/hda10 on some other mount point and checked that
> mount point. But there was nothing in that mount
> point. Please could you please help me with this.

Don't do that then. Do you have any reason to suppose that buffers were
already written to the top level system yet, or that mounting the same
device twice will caus eanything but pain and confusion and much
wailing and gnashing of teeth?

>        Sir I tried the same steps with a RAID1 array

Don't.

>         Hoping for your reply.Thanking you in

Try a test that has actually got some sense to it and will not destroy
your data! Such as faulting one device out of the raid. Then you have
to be reading from the other one, no?

Peter

