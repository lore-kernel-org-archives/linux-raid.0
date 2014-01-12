From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sun, 12 Jan 2014 12:04:53 -0700
Message-ID: <B202E185-81A8-4F10-A311-521F2E7086BA@colorremedies.com>
References: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com> <6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com> <yq1txd9nw2d.fsf@sermon.lab.mkp.net> <F92ECEC1-D375-498B-8C6A-C88C815C325F@colorremedies.com> <yq1lhylnj8z.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1lhylnj8z.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids


On Jan 12, 2014, at 11:32 AM, "Martin K. Petersen" <martin.petersen@oracle.com> wrote:

>>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:
> 
> Chris> I think this is a pretty craptastic thing for a vendor to do to
> Chris> users. It doesn't matter that the overwhelming majority will buy
> Chris> the product as a unit, and never remove it. It means some users
> Chris> will need esoteric knowledge to recover their own data, a
> Chris> recovery from data loss that's induced by ill conceived product
> Chris> behavior.
> 
> Removing the physical drive from the USB enclosure is getting pretty far
> away from "intended purpose".

It's common enough that it's predictable that a significant minority users will get into trouble with a product of this type. That even Mac users are pulling drives out of enclosures, for reasons other than troubleshooting, further demonstrates that it's not at all uncommon practice.

> I don't disagree that it's useful and that
> I've done so in the past. But it is purely coincidental that this
> particular recovery scenario has been possible at all.

It doesn't seem to be by coincidence at all, but that doesn't even matter, it's been this way for so long that it's expected a drive in and out of an enclosure will have identical behavior with respect to size, number of sectors, and the value of those sectors.


> We are starting
> to see drives where there is no physical SATA interface on the PCB, the
> drive terminates in a USB connector.

> And with impending disk recording
> technologies, detaching a drive from any host-facing logic will
> definitely be a thing of the past.

Great. That will obviate this particular problem because there's no behavioral change in or out of the enclosure. The scenario in question, however, clearly seems half-baked and premature for almost no benefit for users.

Is there even a single GPT partitioning tool that doesn't align to at least 8-sector boundaries? So far every one of these drives in enclosures is sufficiently large that they're going to be GPT partitioned in any case.


Chris Murphy

