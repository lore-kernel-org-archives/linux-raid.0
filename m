From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 Read stats for parity cal...
Date: Thu, 17 Sep 2009 12:38:48 +1000
Message-ID: <19121.41272.564725.505554@notabene.brown>
References: <f5d1f90a0909161713s2f31e3b4t34a4ee285b83ef8e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Linux Raid Study on Wednesday September 16
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid Study <linuxraid.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday September 16, linuxraid.study@gmail.com wrote:
> Hello:
> 
> I understand that parity calculations are not done as part of Raid5
> read operation in normal running conditions.

Correct.

> 
> However, it would be done during disk failure or when a sector is bad.

Also correct.

> Is there a way (any stats) available to see if parity cal are done
> when sector is bad (since this is not as obvious as a disk fail...)
> 

Maybe you want
   /sys/block/mdX/md/dev-YYY/errors

which counts the number of sectors for which md found a read error and
had to generate correct data using parity, and then wrote that correct
data back.

NeilBrown
