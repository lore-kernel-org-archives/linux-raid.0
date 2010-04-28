From: Joe Williams <jwilliams315@gmail.com>
Subject: Re: increasing stripe_cache_size decreases RAID-6 read throughput
Date: Wed, 28 Apr 2010 13:40:56 -0700
Message-ID: <m2t11f0870e1004281340v21421e55r2af9a813c0320b6b@mail.gmail.com>
References: <h2y11f0870e1004241636z1f3e302g913be494ec0aefa5@mail.gmail.com>
	 <20100427164126.2765f9e0@notabene.brown>
	 <n2x11f0870e1004271018t742e933tba7e0d37428271f2@mail.gmail.com>
	 <20100428072419.22779335@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100428072419.22779335@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I did some tests, starting with the default values of 256 for
stripe_cache_size and 3072 for read_ahead_kb, and doubling them both
until performance stopped improving. Here are the best results that I
saw:

# echo 2048 > /sys/block/md0/md/stripe_cache_size
# echo 24576 > /sys/block/md0/queue/read_ahead_kb
# iozone -a -y64K -q16M -s4G -e -f iotest -i0 -i1 -i2

                                                    random  random
      KB  reclen   write rewrite    read    reread    read   write
 4194304      64  241087  259892   243478   248102    7745   16161
 4194304     128  259503  261886   244612   247157   13417   26812
 4194304     256  260438  268077   240211   238916   21884   37527
 4194304     512  243511  250004   252507   252276   34694   48868
 4194304    1024  244744  253905   258920   250495   52351   76356
 4194304    2048  240910  250500   253800   265361   79848  100131
 4194304    4096  244283  253516   271940   272117  101737  137386
 4194304    8192  239110  246370   262118   269687  103437  164715
 4194304   16384  240698  249182   239378   253896  119437  198276


250 MB/s reads and writes is quite nice for a 5 drive RAID-6.

But I still do not understand why it is necessary to increase the
stripe_cache_size to 16 full stripes in order to optimize sequential
write speed.
