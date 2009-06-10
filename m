From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] md: Use new topology calls to indicate alignment and  I/O sizes
Date: Wed, 10 Jun 2009 02:47:34 -0400
Message-ID: <yq1ws7k60vt.fsf@sermon.lab.mkp.net>
References: <yq1my8i6naw.fsf@sermon.lab.mkp.net>
	<6579bc561e648e03ed4a739799e51d9e.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6579bc561e648e03ed4a739799e51d9e.squirrel@neil.brown.name>
	(NeilBrown's message of "Tue, 9 Jun 2009 15:02:08 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Neil" == NeilBrown  <neilb@suse.de> writes:

>> + blk_queue_io_opt(mddev->queue, chunk_size * (mddev->raid_disks >>
>>  	blk_queue_io_opt(mddev->1));

Neil>  ">> 1" is wrong.  A raid10 may have more than 2 copies for each
Neil>  block.

I recall pondering when I wrote that.  Never got around to revisiting
the issue.  Your RAID10 implementation is a bit hipper than most :)


Neil>  This calculation needs to be a bit more subtle and take about of
Neil>  the particular layout (near, offset, or far).

Why would layout interfere with preferred I/O size?

How about:

    if (conf->raid_disks % conf->copies)
	blk_queue_io_opt(mddev->queue, chunk_size * conf->raid_disks);
    else
	blk_queue_io_opt(mddev->queue, chunk_size *
			 (conf->raid_disks / conf->copies));

I.e.:

2 drives, 2 copies: a1 a1       optimal I/O = 1 * chunk_size

3 drives, 2 copies: a1 a1 a2
                    a2 a3 a3    optimal I/O = 3 * chunk_size

4 drives, 2 copies: a1 a1 a2 a2	optimal I/O = 2 * chunk_size

4 drives, 3 copies: a1 a1 a1 a2
                    a2 a2 a3 a3
                    a3 a4 a4 a4 optimal I/O = 4 * chunk_size

And so on.  Does that make sense?  I.e. we try to keep all drives
equally busy.


Neil> You seem to be treating raid4 like raid6 :-)

Whoops.  I always forget about raid4.  Fixed.

-- 
Martin K. Petersen	Oracle Linux Engineering
