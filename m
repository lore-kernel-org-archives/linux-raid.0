From: Spelic <spelic@shiftmail.org>
Subject: Re: filesystem corruption
Date: Wed, 05 Jan 2011 16:52:04 +0100
Message-ID: <4D2493A4.9010209@shiftmail.org>
References: <4D212D4A.3040003@feystorm.net>
 <20110103141603.632fdf3e@notabene.brown>
 <AANLkTinL_nz58f8rSPuhYvVwGY5jdu1XVkNLC1ky5A65@mail.gmail.com>
 <4D247FFB.3090209@feystorm.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=KOI8-R
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4D247FFB.3090209@feystorm.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick H." <linux-raid@feystorm.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/05/2011 03:28 PM, Patrick H. wrote:
> No, my drives are battery backed as well.

what drives are they, if I can ask? OCZ SSDs with supercapacitor maybe?

Do you know if they will really flush the whole write cache on sudden 
power off? I read smoky sentences about this for the OCZ drives. In 
certain points it seemed like the supercapacitor was only able to 
provide the same guarantees of a HDD, that is, no further data loss due 
to erase-then-rewrite-32K and flash wear levelling stuff, but was not 
able to flush the write cache.
Did you try with e.g. a stream of simple databases transactions then 
disconnecting the cable suddenly like this test
http://www.mysqlperformanceblog.com/2009/03/02/ssd-xfs-lvm-fsync-write-cache-barrier-and-lost-transactions/
?

Thank you
