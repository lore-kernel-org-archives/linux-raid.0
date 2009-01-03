From: Matt Garman <matthew.garman@gmail.com>
Subject: southbridge/sata controller performance?
Date: Sat, 3 Jan 2009 13:34:29 -0600
Message-ID: <20090103193429.GA17462@sewage.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


When using Linux software RAID, I was thinking that, from a
performance perspective, the southbridge/SATA controller is probably
one of the most important components (assuming a reasonable CPU).
Is this a correct generalization?

If it is, has anyone done a study or benchmarked SATA controller
performance?  Particularly with consumer-grade hardware?

I haven't been able to find much info about this on the web; the
Tech Report seems to consistently benchmark SATA performance:

    AMD SB600: http://techreport.com/articles.x/13832/5
    AMD SB700: http://techreport.com/articles.x/14261/10
    AMD SB750: http://techreport.com/articles.x/13628/9
    Intel ICH10: http://techreport.com/articles.x/15653/9
    nVidia GeForce 8300: http://techreport.com/articles.x/14993/9

My (over) generalization of the above is that SB600 is to be
avoided, and performance ranking is Intel/nVidia over AMD.

But this is just one set of benchmarks and obviously they used
Windows and therefore Windows drivers, so my simplification really
isn't fair.

Thoughts?

Matt

