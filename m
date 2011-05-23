From: Joe Landman <joe.landman@gmail.com>
Subject: Re: HBA Adaptor Advice
Date: Mon, 23 May 2011 07:55:03 -0400
Message-ID: <4DDA4B17.7060806@gmail.com>
References: <4DDA41B2.8010003@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DDA41B2.8010003@wildgooses.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ed W <lists@wildgooses.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/23/2011 07:14 AM, Ed W wrote:
> Getting back on track of specific adaptor advice:
>
> To recap: I am looking for ideas on what to buy to upgrade our small
> office servers (not really stretched, just adding more backup disks and
> similar). My main requirement is to be able to buy equipment in single
> lots (one server at a time) and so I require the ability to take an
> array from one machine and use it in another machine using a different
> adaptor - therefore the previous thread has dissuaded me from looking at
> adaptors with writeback cache (and also hardware raid controllers)
>
> Therefore can I see a show of hands for "good value" HBA adaptors with
> 8, 12 and 24 ports? Ideally using fewer PCI slots is preferred and
> onboard expanders rather than separate expanders are preferred

Be aware that this won't be cheap.  Also be aware that many (most) 
expandor designs are performance limited due to their implementations. 
We see significant contention from bandwidth oversubscription in every 
day situations, regardless where the expandor is.

On the HBA side

http://www.lsi.com/storage_home/products_home/host_bus_adapters/sas_hbas/internal/sas9201-16i/index.html 


On the hardware RAID side of this:

http://www.lsi.com/storage_home/products_home/internal_raid/megaraid_sas/value_line/megaraid_sas_9260-16i/index.html

LSI controllers as HBAs are reasonably good.  Make sure you update your 
drivers and firmware to late revisions.

> Seems that previously we discovered that most LSI RAID cards were well
> supported and Marvel cards were frequently not.  Does this
> generalisation persist with pure HBA cards also?
>
> I can see the list of LSI HBA cards on their site, but any pointers for
> good value HBA adaptors appreciated? (Current chassis will be a tower
> chassic, but future upgrades are expected to be Supermicro/Norco 3/4U
> rack boxes)
> (is there a page on the wiki already covering any of this that we could
> try and distil this wisdom to?)

Don't skimp on power supply, or power distribution.  RAIDs hate that.

Don't skimp on cooling.  Drives hate that.

Regards,

Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
