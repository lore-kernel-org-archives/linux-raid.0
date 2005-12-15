From: Brad Campbell <brad@wasp.net.au>
Subject: Re: First RAID Setup
Date: Fri, 16 Dec 2005 00:46:58 +0400
Message-ID: <43A1D642.2010301@wasp.net.au>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Callahan, Tom" <CallahanT@tessco.com>
Cc: 'Andargor The Wise' <andargor@yahoo.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Callahan, Tom wrote:

> It is always wise to build in a spare however, that being said about all
> raid levels. In your configuration, if a disk fails in your RAID5, your
> array will go down. RAID5 is usually 3+ disks, with a mirror. So you should
> have 3 disks at minimum, and then a 4th as a spare.
> 

/me wonders in the days of reliable RAID-6 why we use RAID-5 + spare?

RAID-6 has saved me twice now from dual drive failures on a 15 disk array.
It's schweeeeeeeeeett

Regards,
Brad
-- 
"Human beings, who are almost unique in having the ability
to learn from the experience of others, are also remarkable
for their apparent disinclination to do so." -- Douglas Adams
