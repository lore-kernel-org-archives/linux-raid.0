From: Richard <richard@sauce.co.nz>
Subject: Re: recovering from a controller failure
Date: Sun, 30 May 2010 09:18:21 +1200
Message-ID: <4C01849D.8080101@sauce.co.nz>
References: <20100529190751.GM2167@flews.lairds.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100529190751.GM2167@flews.lairds.us>
Sender: linux-raid-owner@vger.kernel.org
To: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kyler Laird wrote:

> I'd like to know if this is something I can recover.  I do have backups
> but it's a huge pain to recover this much data.

This happened to me before I discovered that LSI SAS1068E no longer 
reliably tolerate querying via smartd/smartctl.

Have a look at https://bugzilla.kernel.org/show_bug.cgi?id=14831

and there is a patch that seems to fix it here:

http://lkml.org/lkml/2010/4/26/335

Use hdparm if you need serial numbers.

In the the half dozen or so tests I have done, where more than 2 drives 
have been thrown out of md RAID6 arrays due to these controller resets,
reassembly using --force has worked with no data corruption, but this 
may have been good luck.

Regards,

Richard
