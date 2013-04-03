From: Martin Wilck <mwilck@arcor.de>
Subject: Re: RAID 5 doesn't scale
Date: Wed, 03 Apr 2013 20:34:38 +0200
Message-ID: <515C763E.6030402@arcor.de>
References: <loom.20130403T122905-373@post.gmane.org> <515C10BF.7060503@mpstor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515C10BF.7060503@mpstor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Benjamin ESTRABAUD <be@mpstor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/03/2013 01:21 PM, Benjamin ESTRABAUD wrote:

> It seems that you are running random 4K writes on this array (unless you 
> are running the test on the SSD directly here?). If so, you are writing 
> lots of 4K sectors on independant 192KB stripes. This means that the 
> whole 192KB of stripe needs to be first read, copied to memory, modified 
> with the new 4K of data, have its parity calculated and the new stripe 
> rewritten to the underlying disks.

That's not strictly necessary. For each 4k block to be written, it's
sufficient to read the data block and the corresponding parity block
(2x4k), calculate the changes in the parity block from the difference
between the old and new data block, and write both data and parity
(2x4k). Thus for every write IOP, 4 RAID IOPS are needed (2x read, 2x
write).

Doesn't MD do it this way?

Martin
