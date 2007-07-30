From: Neil Brown <neilb@suse.de>
Subject: Re: Is it possible to grow a RAID-10 array with mdadm?
Date: Mon, 30 Jul 2007 18:48:52 +1000
Message-ID: <18093.42484.733479.935581@notabene.brown>
References: <loom.20070727T225545-192@post.gmane.org>
	<46ABAC5A.2000103@ziu.info>
	<46ABB830.1000204@ziu.info>
	<0dc901c7d20b$be23d100$332317ac@Cortex>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tomas France on Sunday July 29
Sender: linux-raid-owner@vger.kernel.org
To: Tomas France <tomfra@centrum.cz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 29, tomfra@centrum.cz wrote:
> Hi everyone,
> 
> Is it possible to add drives to an active RAID-10 array, using the "grow" 
> switch with mdadm, just like it is possible with a RAID-5 array? Or perhaps 
> there is another way?
> 
> I have been looking for this information for a long time but have been 
> unable to find it anywhere. The man page for mdadm does not mention RAID-10 
> at all so that didn't help either. Has anyone tried it?

The man page for mdadm does not mention it because it is not
supported.

There are several reshape options that I would like to implement
including
  - raid5 -> raid6
  - shrinking raid4/5/6
  - raid0 -> raid5
  - changing chunksize/layout of raid4/5/6
  - raid10 growing and layout change

unfortunately I haven't yet found/made the time.

Patches are always welcome :-)

NeilBrown
