From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 15:23:14 +0200
Message-ID: <j0p3g2$ua5$1@dough.gmane.org>
References: <20110727141652.7511fc51@notabene.brown> <j0p0d6$aj6$1@dough.gmane.org> <4E300828.3000601@anonymous.org.uk> <j0p2g2$nmp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j0p2g2$nmp$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/27/2011 03:06 PM, Lutz Vieweg wrote:
>> I don't think mdadm knows whether its constituent devices are SSDs.
>
> In block/cfq-iosched.c I see a test that looks like this:
>> if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
>> return;

I just verified that indeed, /sys/block/sd*/queue/rotational contains
0 for SSDs and 1 for magnetic disks.

One catch, though, seems to be that this attribute seems not to be
propagated through additional block device layers, so e.g.
a loop-device based on a SSD is, strangely, tagged as being "rotational",
as is a device-mapper based on the SSD.

So you can detect SSDs if given as underlying devices directly, only.

Regards,

Lutz Vieweg

