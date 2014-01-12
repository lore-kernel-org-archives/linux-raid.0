From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: Why 4k native drives haven't arrived
Date: Sun, 12 Jan 2014 13:32:44 -0500
Message-ID: <yq1lhylnj8z.fsf@sermon.lab.mkp.net>
References: <38C8AAEB-811B-442F-BA80-1EFAF00BADB1@colorremedies.com>
	<6AACF77C-5D54-4ABF-AA2D-FC3F4F1E141C@colorremedies.com>
	<yq1txd9nw2d.fsf@sermon.lab.mkp.net>
	<F92ECEC1-D375-498B-8C6A-C88C815C325F@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F92ECEC1-D375-498B-8C6A-C88C815C325F@colorremedies.com> (Chris
	Murphy's message of "Sun, 12 Jan 2014 11:14:00 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>>> "Chris" == Chris Murphy <lists@colorremedies.com> writes:

Chris> I think this is a pretty craptastic thing for a vendor to do to
Chris> users. It doesn't matter that the overwhelming majority will buy
Chris> the product as a unit, and never remove it. It means some users
Chris> will need esoteric knowledge to recover their own data, a
Chris> recovery from data loss that's induced by ill conceived product
Chris> behavior.

Removing the physical drive from the USB enclosure is getting pretty far
away from "intended purpose". I don't disagree that it's useful and that
I've done so in the past. But it is purely coincidental that this
particular recovery scenario has been possible at all. We are starting
to see drives where there is no physical SATA interface on the PCB, the
drive terminates in a USB connector. And with impending disk recording
technologies, detaching a drive from any host-facing logic will
definitely be a thing of the past.

-- 
Martin K. Petersen	Oracle Linux Engineering
