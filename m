From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: New raid level suggestion.
Date: Thu, 30 Dec 2010 11:58:12 +0000
Message-ID: <4D1C73D4.6050600@anonymous.org.uk>
References: <20101230082356.GC2986@bitwizard.nl> <4D1C470E.4080406@crc.id.au> <20101230094230.GE2986@bitwizard.nl> <4D1C616D.8030904@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D1C616D.8030904@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 30/12/2010 10:39, Stan Hoeppner wrote:
[...]
> Any RAID scheme that uses parity is less than optimal, and up to
> horrible, for heavy random IO loads.  As always, this depends on "how
> heavy" the load is.  For up to a few hundred constant IOPS you can get
> away with parity RAID schemes.  If you need a few thousand or many
> thousand IOPS, better stay away from parity RAID.

Sorry, I have to disagree with this, in this situation. RAID-6 over 4 
discs will be just as fast for reading multiple small files as RAID-10 
over 4 discs, and a web server is a read-mostly environment, while at 
the same time I can't imagine any RAID schema ever giving thousands of 
IOPS over 4 discs, parity or no.

Cheers,

John.

