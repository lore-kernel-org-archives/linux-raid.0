From: Eric Mei <meijia@gmail.com>
Subject: read error recovery threshold
Date: Mon, 15 Sep 2014 10:56:11 -0600
Message-ID: <CAK=nhWO75WOJNCOXG+_ynug3ta6939b-8fyz0R1D-ENXF7jEGg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

After a read error detected, RAID6 will initiate a recovery procedure
try to correct it, until the number of read error exceeds a threshold,
which is "conf->max_nr_stripes" (see raid5_end_read_request()), I'm
wondering the reasoning behind this. To me the threshold seems a drive
property, but max_nr_stripes is a array-wide cache setting and can be
changed at runtime. In our specific case, we observed a drive emitting
lots of read errors without being marked as faulty because the larger
max_nr_stripes
setting.

Look at other part of MD code, there is "mddev::max_corr_read_errors"
which is set to 20, but only RAID10 makes use of it. Also the comment
above MD_DEFAULT_MAX_CORRECTED_READ_ERRORS says "...We divide the read
error count by 2 for every hour elapsed between read errors", but I
don't see any code matching this description.

Any thoughts? Thanks

Eric
