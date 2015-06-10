From: Ming Lin <mlin@kernel.org>
Subject: write performance of HW RAID VS MD RAID
Date: Wed, 10 Jun 2015 15:27:07 -0700
Message-ID: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Hi NeilBrown,

As you may already see, I run a lot of tests with 10 HDDs for the patchset
"simplify block layer based on immutable biovecs"

Here is the summary.
http://minggr.net/pub/20150608/fio_results/summary.log

MD RAID6 read performance is OK.
But write performance is much lower than HW RAID6.

Is it a known issue?

Thanks.
