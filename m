From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Speed up reshape? (was Re: Cancel reshape?)
Date: Thu, 13 Jan 2011 19:14:55 +0000
Message-ID: <4D2F4F2F.5070101@anonymous.org.uk>
References: <4D2D2BD2.7000601@anonymous.org.uk>	<4D2D32DF.9010002@anonymous.org.uk>	<20110112163258.699a6fe0@notabene.brown>	<4D2D41E4.1000109@anonymous.org.uk> <20110112170211.3e88fdcb@notabene.brown> <4D2F01AB.5090909@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D2F01AB.5090909@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 13/01/2011 13:44, John Robinson wrote:
[...]
> I may test this by doing another in-place reshape, changing the chunk
> size to 512KB, which I expect will run at twice the speed of the reshape
> on 256KB chunks.

Well, I got that wrong. Currently doing ~9MB/s, though the backup file 
is writing faster (~27MB/s). Another 30 hours reshaping. Oh well it 
should be worth it in the end.

Cheers,

John.

