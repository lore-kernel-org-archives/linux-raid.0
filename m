From: bert hubert <bert.hubert@netherlabs.nl>
Subject: Re: [PATCH 004 of 11] md: Increase the delay before marking metadata clean, and make it configurable.
Date: Tue, 2 May 2006 07:56:21 +0200
Message-ID: <20060502055621.GA552@outpost.ds9a.nl>
References: <20060501152229.18367.patches@notabene> <1060501053019.22949@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1060501053019.22949@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 01, 2006 at 03:30:19PM +1000, NeilBrown wrote:
> When a md array has been idle (no writes) for 20msecs it is marked as
> 'clean'.  This delay turns out to be too short for some real
> workloads.  So increase it to 200msec (the time to update the metadata
> should be a tiny fraction of that) and make it sysfs-configurable.

What does this mean, 'too short'? What happens in that case, backing block
devices are still busy writing? When making this configurable, the help text
better explain what the trade offs are.

Thanks.

-- 
http://www.PowerDNS.com      Open source, database driven DNS Software 
http://netherlabs.nl              Open and Closed source services
