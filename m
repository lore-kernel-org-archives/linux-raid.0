From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Is this likely to cause me problems?
Date: Wed, 22 Sep 2010 12:25:35 +0100
Message-ID: <4C99E7AF.4090503@anonymous.org.uk>
References: <672252.64237.qm@web51306.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <672252.64237.qm@web51306.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/09/2010 07:42, Jon Hardcastle wrote:
[...]
> So do you have any recommendations? I would like to 'trust' the new version of fdisk but I can not risk torpedoing myself. I have 2 more drives I need to 'phase out' at some point; but they will liklely be with 1.5TB drives.

The new layout you've got is meant for SSDs and drives with 4K sectors; 
the old layout is fine for you.

> My gut tells me that i should whilst I have other drives the same size use the same paratermeters... then when i have a bigger drive that is definately not going to cause any size issues let fdisk do its magic.
>
> So following that premsis is there any down side to copy the partition table off another drive?

I can't think of one. For backup, if I remember correctly Doug Ledford's 
hot-swap auto-rebuilding onto virgin drives work was going to create 
partition tables by copying them from existing drives (or by having the 
user copy the required partition table from a drive in advance).

Cheers,

John.
