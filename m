From: antlists <antlists@youngman.org.uk>
Subject: Re: WD Red drives are now SMR drives?
Date: Fri, 22 May 2020 17:26:49 +0100
Message-ID: <b183a091-da81-0832-f1b6-a53738024eb1@youngman.org.uk>
References: <b012e351-54cb-47c5-5fd7-fd2ee22322ed@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b012e351-54cb-47c5-5fd7-fd2ee22322ed@youngman.org.uk>
Content-Language: en-GB
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/05/2020 00:38, antlists wrote:
> Has anyone else picked up on this? Apparently 1TB and 8TB drives are 
> still CMR, but new drives between 2 and 6 TB are now SMR drives.
> 
> https://www.extremetech.com/computing/309730-western-digital-comes-clean-shares-which-hard-drives-use-smr 
> 
> 
> What impact will this have on using them in raid arrays?
> 
Following up, two more articles ...

https://blocksandfiles.com/2020/04/15/shingled-drives-have-non-shingled-zones-for-caching-writes/

https://blocksandfiles.com/2020/04/15/seagate-2-4-and-8tb-barracuda-and-desktop-hdd-smr/

https://blocksandfiles.com/2020/04/16/toshiba-desktop-disk-drives-undocumented-shingle-magnetic-recording/

Note that for both Seagate and Toshiba it's only Desktop drives, and 
their raid lines are unaffected.

It's interesting to note that the interviewee in the first article is 
assuming that the WD firmware is buggy ... :-)

Cheers,
Wol
