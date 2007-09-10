From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 10 Sep 2007 14:04:07 +1200
Message-ID: <46E4A617.9070905@sauce.co.nz>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E4A39C.8040509@amfes.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Daniel L. Miller wrote:

> And you didn't ask, but my mdadm.conf:
> DEVICE partitions
> ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
> UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a


Hi Daniel,

Try adding

auto=part

at the end of you mdadm.conf ARRAY line.

Regards,

Richard

