From: Brad Campbell <brad@wasp.net.au>
Subject: Re: libata and md issues with 2.9.1-rc1
Date: Tue, 24 Aug 2004 21:50:07 +0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <412B7FCF.4070502@wasp.net.au>
References: <412B79DF.2000705@wasp.net.au> <412B7D8C.5070403@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <412B7D8C.5070403@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: linux-ide@vger.kernel.org, RAID Linux <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Is there a difference between 2.6.8.1 and 2.6.9-rc1?

Oooh good point. I was using 2.6.8.1 but with yesterdays BK cset applied. I'll try a raw 2.6.8.1 now.

> Any chance we could narrow it down to a specific change?

I'm thinking about a binary search between 2.6.5 and 2.6.9-rc1. I'm just rebuilding the array at the 
moment and restoring the backups I took this afternoon (Talk about timing!).
Then I'll slot another couple of disks in and try some regression testing.

At least it's easily reproducible.
It has given the error recovery patch a good workout though! :p)

I mainly posted it just as a warning to be careful when upgrading until I figure out what is causing 
the issue.

I'll keep you posted.

Regards,
Brad
