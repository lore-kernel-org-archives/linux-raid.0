From: Richard Scobie <richard@sauce.co.nz>
Subject: Life's too short ...(Raid 1 sync times)
Date: Mon, 01 Mar 2004 08:27:37 +1300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40423D29.1050401@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am in the process of benchmarking a 4 x 250GB on 3ware 7506 to try and
sort out the myriad of options for RAID and XFS, in order to get best
performance for my workload.

I have tested with software RAID5 and have just attempted to do the same
for software RAID 10. Unfortunately, it is going to take 31000 minutes,
or around 21 days to sync this array and I wish to test 3 different
stripe sizes. Is there some way to allow more bandwidth for the sync up?

The RAID 5 took 70 minutes and was allowed up 100MB/s of idle IO
bandwidth - RAID 1 seems to use < 200kB/s.

While I am very pleased with the hardware RAID 10 result (98261kB write,
97148kB read), I would prefer to use software RAID 10 for a few reasons,
if the performance is similar.

Regards,

Richard


