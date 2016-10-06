From: Bernd Petrovitsch <bernd@petrovitsch.priv.at>
Subject: Re: [PATCH 37/54] md/raid5: Replace a seq_printf() call by
 seq_puts() in raid5_status()
Date: Thu, 06 Oct 2016 20:33:28 +0200
Message-ID: <1475778808.2520.10.camel@petrovitsch.priv.at>
References: <566ABCD9.1060404@users.sourceforge.net>
         <786843ef-4b6f-eb04-7326-2f6f5b408826@users.sourceforge.net>
         <92c52f1d-d151-cea6-e9ac-31378e6862d0@users.sourceforge.net>
         <1475771699.1914.10.camel@perches.com>
         <d896b697-6735-e50d-00b0-2b3d9f371c99@users.sourceforge.net>
         <1475775403.1914.13.camel@perches.com>
         <c158cfe0-d8d8-e433-0cea-2ef1fc51e48b@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c158cfe0-d8d8-e433-0cea-2ef1fc51e48b@users.sourceforge.net>
Sender: linux-raid-owner@vger.kernel.org
To: SF Markus Elfring <elfring@users.sourceforge.net>, Joe Perches <joe@perches.com>
Cc: linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>, Guoqing Jiang <gqjiang@suse.com>, Jens Axboe <axboe@fb.com>, Mike Christie <mchristi@redhat.com>, Neil Brown <neilb@suse.com>, Shaohua Li <shli@kernel.org>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>, LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
List-Id: linux-raid.ids

Hi all!

On Thu, 2016-10-06 at 19:49 +0200, SF Markus Elfring wrote:
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > > > []
> > > > > 
> > > > > @@ -7044,7 +7044,7 @@ static void raid5_status(struct
> > > > > seq_file *seq, struct mddev *mddev)
> > > > >  			   rdev && test_bit(In_sync, &rdev-
> > > > > >flags) ? "U" : "_");
> > > > >  	}
> > > > >  	rcu_read_unlock();
> > > > > -	seq_printf (seq, "]");
> > > > > +	seq_puts(seq, "]");
> > > > seq_putc
> > > How do you think about the possibility that the script
> > > "checkpatch.pl" can also point
> > > such a source code transformation out directly?
> > 
> > Why don't _you_ try to implement that in checkpatch instead?
> 
> How are the chances that any other software developer would be
> quicker (than me) for such
> an addition because of more practical knowledge for the programming
> language "Perl"?

The above is BTW a pretty simple thing and thus good for a learning
experience for regular expressions and copy-pasting a few lines in that
perl-script and editing them.

MfG,
	Bernd

PS: Sry for the noise - it's somewhat OT here ....
-- 
Bernd Petrovitsch                  Email : bernd@petrovitsch.priv.at
                     LUGA : http://www.luga.at
