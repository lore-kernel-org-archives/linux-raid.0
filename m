From: Ross Vandegrift <ross@willow.seitz.com>
Subject: Re: RAID1 help
Date: Sun, 8 Jun 2003 17:10:51 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030608211051.GA17000@willow.seitz.com>
References: <E15502AC-99E2-11D7-8B62-000393795060@fifreak.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <E15502AC-99E2-11D7-8B62-000393795060@fifreak.dyndns.org>
To: Jason Gordon <fifreak@fifreak.dyndns.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 08, 2003 at 02:56:15PM -0400, Jason Gordon wrote:
> I have been trying to setup software RAID 1 on a new debian based 
> system for the last day and I cant seem to get it right.
<snip>

It sounds like you're trying to use the default Debian kernels.  This is
very difficult.  I've tried pretty seriously three times and failed.
Google doesn't find anyone who ever succeeded.  A recent inquiry to
linux-raid and debian-user mailing lists yielded zero responses.

> Any help, ideas suggestions, im getting pretty frustrated here.

Give up on the Debian kernels and build your own that includes the RAID1
drivers as modules.

(OTOH, if you do stick it out with the Debian kernels and figure
something out, please report back)

-- 
Ross Vandegrift
ross@willow.seitz.com

A Pope has a Water Cannon.                               It is a Water Cannon.
He fires Holy-Water from it.                        It is a Holy-Water Cannon.
He Blesses it.                                 It is a Holy Holy-Water Cannon.
He Blesses the Hell out of it.          It is a Wholly Holy Holy-Water Cannon.
He has it pierced.                It is a Holey Wholly Holy Holy-Water Cannon.
He makes it official.       It is a Canon Holey Wholly Holy Holy-Water Cannon.
Batman and Robin arrive.                                       He shoots them.
