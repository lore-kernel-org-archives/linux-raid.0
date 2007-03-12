From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Help with chunksize on raid10 -p o3 array
Date: Tue, 13 Mar 2007 07:45:52 +1300
Message-ID: <45F59FE0.2000307@sauce.co.nz>
References: <45ED4FE1.5020105@rabbit.us> <17908.55047.408840.852816@notabene.brown> <45F567BB.3090804@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45F567BB.3090804@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:

> Is this anywhere near the top of the todo list, or for now raid10 users 
> are bound to a maximum read speed of a two drive combination?

I have not done any testing with the md native RAID10 implementations, 
so perhaps there are some other advantages, but have you tried setting 
up your 4 drives as a RAID 0 made up of a pair of RAID1s?

I have had very good performance in this configuration - reads and 
writes of over 140MB/s for 4 x 7200 SATA.

Regards,

Richard
