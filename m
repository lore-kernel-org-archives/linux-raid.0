From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Suggestion for hot-replace
Date: Sat, 24 Nov 2012 22:37:49 -0800
Message-ID: <50B1BCBD.70306@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I was looking at the hot-replace (want_replacement) feature, and I had a 
thought: it would be nice to have this in a form which *didn't* fail the 
incumbent drive after the operation is over, and instead turned it into 
a spare.  This would make it much easier and safer to periodically 
rotate and test any hot spares in the system.  The main problem with hot 
spares is that you don't actually know if they work properly until there 
is a failover...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

