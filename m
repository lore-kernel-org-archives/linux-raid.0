From: Neil Brown <neilb@suse.de>
Subject: Re: RAID0 performance question
Date: Sun, 27 Nov 2005 10:27:05 +1100
Message-ID: <17288.61257.912938.278958@cse.unsw.edu.au>
References: <437E2CB6.2030903@xss.co.at>
	<17282.22120.327672.720044@cse.unsw.edu.au>
	<20051122220531.GU26862@skl-net.de>
	<015c01c5f292$57e0e270$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from JaniD++ on Saturday November 26
Sender: linux-raid-owner@vger.kernel.org
To: JaniD++ <djani22@dynamicweb.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 26, djani22@dynamicweb.hu wrote:
> Hello list,
> 
> I have searching the bottleneck of my system, and found something what i
> cant cleanly understand.
> 
> I have use NBD with 4 disk nodes. (raidtab is the bottom of mail)
> 
> The cat /dev/nb# >/dev/null    makes ~ 350 Mbit/s on each nodes.
> The cat /dev/nb0 + nb1 + nb2 + nb3 in one time parallel makes ~ 780-800
> Mbit/s. - i think this is my network bottleneck.
> 
> But the cat /dev/md31 >/dev/null (RAID0, the sum of 4 nodes) only makes
> ~450-490 Mbit/s, and i dont know why....
> 
> Somebody have an idea? :-)

Try increasing the read-ahead setting on /dev/md31 using 'blockdev'.
network block devices are likely to have latency issues and would
benefit from large read-ahead.

NeilBrown
