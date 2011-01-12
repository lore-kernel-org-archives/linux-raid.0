From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Cancel reshape?
Date: Wed, 12 Jan 2011 04:49:35 +0000
Message-ID: <4D2D32DF.9010002@anonymous.org.uk>
References: <4D2D2BD2.7000601@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2D2BD2.7000601@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/01/2011 04:19, John Robinson wrote:
[...]
> Can I cancel reshape that's currently running, and using the backup file
> that's actually on another (RAID-1) array on three of the same drives,
> and running at ~7MB/s, and try again?

Blast. I found this patch to add a revert-reshape option from archives 
of this list - http://www.spinics.net/lists/raid/msg30961.html - but 
it's not included in mdadm 3.1.4 and I'm running from a rescue CD so I 
can't rebuild mdadm with it. I think I might just have to wait a while.

Perhaps I can stop the reshape and restart it with the backup file 
elsewhere. Hmm, I've an SSD I haven't installed yet... Maybe time to 
give it a wee workout :-)

Cheers,

John.
