From: Support <support@ggsys.net>
Subject: Re: Software RAID when it works and when it doesn't
Date: Wed, 17 Oct 2007 16:53:52 -0500
Message-ID: <1192658032.16416.407.camel@w100>
References: <14526.1192571833@mdt.ecitele.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14526.1192571833@mdt.ecitele.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2007-10-16 at 17:57 -0400, Mike Accetta wrote:

> Was the disk driver generating any low level errors or otherwise
> indicating that it might be retrying operations on the bad drive at
> the time (i.e. console diagnostics)?  As Neil mentioned later, the md layer
> is at the mercy of the low level disk driver.  We've observed abysmal
> RAID1 recovery times on failing SATA disks because all the time is
> being spent in the driver retrying operations which will never succeed.
> Also, read errors don't tend to fail the array so when the bad disk is
> again accessed for some subsequent read the whole hopeless retry process
> begins anew.

The console was full of errors like:

end_request: I/O error, dev sdb, sector 42644555

I don't know what generates those messages.

As I asked before but never got an answer, is there a way to do timeouts
within the md code so that we are not at the mercy of the lower layer
drivers?

> 
> I posted a patch about 6 weeks ago which attempts to improve this situation
> for RAID1 by telling the driver not to retry on failures and giving some
> weight to read errors for failing the array.  Hopefully, Neil is still
> mulling it over and it or something similar will eventually make it into
> the main line kernel as a solution for this problem.
> --
> Mike Accetta
> 

Thanks,

Alberto
