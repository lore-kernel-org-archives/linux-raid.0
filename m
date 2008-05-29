From: Michal Soltys <soltys@ziu.info>
Subject: Re: Performance Characteristics of All Linux RAIDs (mdadm/bonnie++)
Date: Thu, 29 May 2008 08:37:42 +0200
Message-ID: <483E4F36.8050902@ziu.info>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483DE612.5000804@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483DE612.5000804@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Bill Davidsen <davidsen@tmr.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids

> 
> A very nice bit of work, my only questions is if you ever feel motivated 
> to repeat this test, it would be fun to do it with ext3 (or ext4) using 
> the stride= parameter. I did limited testing and it really seemed to 
> help, but nothing remotely as format as your test.
> 

Speaking about which, it would probably be good to adjust a little how 
the filesystem is created and mounted (both in xfs and ext3/4 cases). 
E.g. lazy-count=1 is still not the default last time I checked mkfs.xfs. 
And even ext4.txt from kernel documentation recommends mounting it with 
data=writeback,nobh when doing comparison with metadata journaling 
filesystems (the same would go for ext3).

Along with different journal sizes, keeping an eye on stripe & 
stripe-width, and other settings that might be of interest.
