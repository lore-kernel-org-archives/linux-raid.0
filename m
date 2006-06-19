From: "liu yang" <liudows2@gmail.com>
Subject: the question about raid0_make_request
Date: Mon, 19 Jun 2006 09:21:23 +0800
Message-ID: <4558af040606181821l17679796tf1c756de636ddb11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

When I read  the code of raid0_make_request,I meet some questions.

1\ block = bio->bi_sector >> 1,it's the device offset in kilotytes.
so why do we use block substract zone->zone_offset? The
zone->zone_offset is the zone offset relative the mddev in sectors.

2\ the codes below:
  x = block >> chunksize_bits;
  tmp_dev = zone->dev[sector_div(x, zone->nb_dev)];
actually, we get the underlying device by 'sector_div(x,
zone->nb_dev)'.The var x is the chunk nr relative to the start  of the
mddev in my opinion.But not all of the zone->nb_dev is the same, so we
cann't get the right rdev by 'sector_div(x, zone->nb_dev)', I think.

Why?Could you explain them to me?
Thanks!
Regards.

YangLiu
