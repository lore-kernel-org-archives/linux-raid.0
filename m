From: Neil Brown <neilb@suse.de>
Subject: Re: misleading error message from raid1d
Date: Wed, 7 Apr 2010 12:14:56 +1000
Message-ID: <20100407121456.1ca034e4@notabene.brown>
References: <z2we17acde31004060002y71947818o9913a1a009d4e53@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <z2we17acde31004060002y71947818o9913a1a009d4e53@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Burgess <ozburgess@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 6 Apr 2010 15:02:16 +0800
Tim Burgess <ozburgess@gmail.com> wrote:

> Hi All,
> 
> We recently sent some a snippet of error logs to a vendor when
> returning a faulty drive, and received 2 replacement drives back
> (how's that for service!?) due to them misinterpreting the following
> message as an error on sdc (sdb was the drive that actually failed).
> 
> Mar 13 01:02:26 mds001 kernel: raid1: sdc2: redirecting sector 3355736
> to another mirror
> 
> This seems to originate from the following snippet of code:
> 
> 	if ((disk=read_balance(conf, r1_bio)) == -1) {
>         **************
>         } else {
> 				const bool do_sync = bio_rw_flagged(r1_bio->master_bio, BIO_RW_SYNCIO);
> 				r1_bio->bios[r1_bio->read_disk] =
> 					mddev->ro ? IO_BLOCKED : NULL;
> 				r1_bio->read_disk = disk;
> 				bio_put(bio);
> 				bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
> 				r1_bio->bios[r1_bio->read_disk] = bio;
> 				rdev = conf->mirrors[disk].rdev;
> 				if (printk_ratelimit())
> 					printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
> 					       " another mirror\n",
> 					       bdevname(rdev->bdev,b),
> 					       (unsigned long long)r1_bio->sector);
> 
> 
> Which as far as I can tell prints the name of the device on which the
> request is retried, rather than the failed device.  Is that what we
> want?

Yes, I can see that message is misleading.
As for "what do we want?" I don't really know.  Anything that isn't
misleading is probably fine.  It is tempting to just remove the message.
I don't think it is possible to reliably get the name of the failed drive at
this point - it could possibly have been removed already( though that is
unlikely).

I'll probably just change it to something like:

 raid1: redirecting sector %llu to other mirror: %s

Thanks for the report.
NeilBrown
