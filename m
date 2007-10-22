From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: slow raid5 performance
Date: Tue, 23 Oct 2007 08:23:09 +1300
Message-ID: <471CF89D.6020104@sauce.co.nz>
References: <352991.69437.qm@web52803.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <352991.69437.qm@web52803.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter wrote:
> Thanks Justin, good to hear about some real world experience. 

Hi Peter,

I recently built a 3 drive RAID5 using the onboard SATA controllers on 
an MCP55 based board and get around 115MB/s write and 141MB/s read.

A fourth drive was added some time later and after growing the array and 
filesystem (XFS), saw 160MB/s write and 178MB/s read, with the array 60% 
full.

Regards,

Richard
