From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Using the new bad-block-log in md for Linux 3.1
Date: Wed, 27 Jul 2011 15:06:10 +0200
Message-ID: <j0p2g2$nmp$1@dough.gmane.org>
References: <20110727141652.7511fc51@notabene.brown> <j0p0d6$aj6$1@dough.gmane.org> <4E300828.3000601@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E300828.3000601@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/27/2011 02:44 PM, John Robinson wrote:
>> Can you describe the criteria for MD considering a block as faulty?
>
> I'll try to answer this having followed some of the discussion around it.

Thanks a lot for the explanation!

> Once the controller or power issues are resolved, the bad block list can be
> administratively modified or cleared.

Ah, that's good.

> I don't think mdadm knows whether its constituent devices are SSDs.

In block/cfq-iosched.c I see a test that looks like this:
>         if (blk_queue_nonrot(cfqd->queue) && cfqd->hw_tag)
>                 return;

If that isn't conclusive, putting a note into the mdadm man-page is probably
the best one can do.

Regards,

Lutz Vieweg


