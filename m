From: NeilBrown <neilb@suse.de>
Subject: Re: md road-map: 2011
Date: Thu, 17 Feb 2011 08:36:43 +1100
Message-ID: <20110217083643.16404187@notabene.brown>
References: <20110216212751.51a294aa@notabene.brown>
	<4D5C0760.4090304@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C0760.4090304@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Landman <joe.landman@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 16 Feb 2011 12:20:32 -0500 Joe Landman <joe.landman@gmail.com> wrote:

> On 02/16/2011 05:27 AM, NeilBrown wrote:
> >
> > I all,
> >   I wrote this today and posted it at
> > http://neil.brown.name/blog/20110216044002
> >
> > I thought it might be worth posting it here too...
> 
> Another request would be an incremental on-demand build of the RAID. 
> That is, when we set up a RAID6, that it only computes the blocks as 
> they are allocated and used.  This helps with things like thin 
> provisioning on remote target devices (among other nice things).
> 

That is exactly what the non-sync bitmap is supposed to do.  On the first
write to a region that is marked as not-in-sync, a resync for just that
region is triggered.

Thanks,
NeilBrown

