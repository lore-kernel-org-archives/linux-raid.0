From: Matt Domsch <Matt_Domsch@dell.com>
Subject: Re: Proposed Enhancements to MD
Date: Tue, 13 Jan 2004 14:35:59 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040113143559.B7646@lists.us.dell.com>
References: <40036902.8080403@adaptec.com> <20040113081932.A721@lists.us.dell.com> <400436CC.7020007@pobox.com> <40045539.9040709@nortelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <40045539.9040709@nortelnetworks.com>; from cfriesen@nortelnetworks.com on Tue, Jan 13, 2004 at 03:29:45PM -0500
To: Chris Friesen <cfriesen@nortelnetworks.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, Scott Long <scott_long@adaptec.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 13, 2004 at 03:29:45PM -0500, Chris Friesen wrote:
> How is this different than the 20GB RAID0 and 6 15BB RAID1s that I've 
> got on two 100GB spindles right now?

Indeed, md does this with partitions on the disks today, so it is
analogous; DDF does this with disk extents, which has the same
functionality as partitions, but without an MSDOS partition table to
define the partitions, but an on-disk metadata format (yes, partition
tables are metadata too...). 

The solution needs partitions/extents in two places.
1) below the logical drive, from which logical drives are created.
2) above the logical drive, on which multiple file systems are
created.

md provides 1) today, and as discussed today patches exist to do 2)
that have not yet been merged.


-- 
Matt Domsch
Sr. Software Engineer, Lead Engineer
Dell Linux Solutions www.dell.com/linux
Linux on Dell mailing lists @ http://lists.us.dell.com
