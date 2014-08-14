From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Raid5 to raid6 reshape or recreate?
Date: Thu, 14 Aug 2014 11:29:18 +0800
Message-ID: <53EC2D0E.2070402@fnarfbargle.com>
References: <53EAB9F1.5030905@gmail.com> <CABY_QbU4KWwtqp-TfOz13QMO134WA1J7i5jEFDozwy8aQwV1QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABY_QbU4KWwtqp-TfOz13QMO134WA1J7i5jEFDozwy8aQwV1QQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/08/14 01:25, Ram Ramesh wrote:

> On a slightly different topic, will it be faster after a disk
> fail/replacement as opposed to raid reshaping?

Much.
I just re-striped a RAID6 changing the chunk size from 128k to 64k. This 
took 12 days all up. It's the seeking that kills it. To replace a disk 
or do a resync on the same array takes less than 10 hours.



