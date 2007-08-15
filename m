From: Neil Brown <neilb@suse.de>
Subject: Re: detecting read errors after RAID1 check operation
Date: Thu, 16 Aug 2007 08:55:14 +1000
Message-ID: <18115.33874.732489.977468@notabene.brown>
References: <11774.1187215383@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Accetta on Wednesday August 15
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 15, maccetta@laurelnetworks.com wrote:
> 
> There are already files like /sys/block/md_d0/md/dev-sdb/errors in /sys
> which would be very convenient to consult but according to the kernel
> driver implementation the error counts reported there are apparently
> for corrected errors and not relevant for read errors during a "check"
> operation.
> 

When 'check' hits a read error, an attempt is made to 'correct' it by
over-writing with correct data.  This will either increase the
'errors' count or fail the drive completely.

What 'check' doesn't do (and 'repair' does) it react when it find that
successful reads of all drives (in a raid1) do not match.

So just use the 'errors' number - it is exactly what you want.

NeilBrown
