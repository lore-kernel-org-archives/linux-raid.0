From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: NVRAM support
Date: Fri, 10 Feb 2006 12:38:38 -0500
Message-ID: <43ECCF9E.5050102@steeleye.com>
References: <43EC5655.1060504@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43EC5655.1060504@web.de>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko Benz <mirko.benz@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mirko Benz wrote:

> Does a high speed NVRAM device makes sense for Linux SW RAID? E.g. a PCI 
> card that exports battery backed memory.

Sure. There are a couple ways I can think of using such a thing:

1) put an md intent bitmap on the NVRAM device for faster resyncs

2) use the NVRAM as a write journal for md to make md raid4/5/6 reliable 
(if the system crashes while an md raid5 is degraded, i.e., missing a 
disk, there is a chance of silent data corruption). The md driver does 
not currently do write journalling, so this would require some code changes.

--
Paul
