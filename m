From: "Jon Nelson" <jnelson-linux-raid@jamponi.net>
Subject: raid10 performance question
Date: Sun, 23 Dec 2007 08:26:55 -0600
Message-ID: <cccedfc60712230626t2db70cfcl5b0b49390cd6e609@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've found in some tests that raid10,f2 gives me the best I/O of any
raid5 or raid10 format. However, the performance of raid10,o2 and
raid10,n2 in degraded mode is nearly identical to the non-degraded
mode performance (for me, this hovers around 100MB/s).  raid10,f2 has
degraded mode performance, writing, that is indistinguishable from
it's non-degraded mode performance. It's the raid10,f2 *read*
performance in degraded mode that is strange - I get almost exactly
50% of the non-degraded mode read performance. Why is that?


-- 
Jon
