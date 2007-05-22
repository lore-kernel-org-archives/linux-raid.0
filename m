From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm on huge raid sets
Date: Wed, 23 May 2007 08:12:09 +1000
Message-ID: <18003.27321.583707.520299@notabene.brown>
References: <465349B9.3030702@soe.ucsc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Erich Weiler on Tuesday May 22
Sender: linux-raid-owner@vger.kernel.org
To: Erich Weiler <weiler@soe.ucsc.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 22, weiler@soe.ucsc.edu wrote:
> Greetings all-
> 
> Quick question.  We've got one of these new Sun x4500's, it is basically 
> a machine with 48 disks in it, no hardware RAID controller, so you have 
> to use software RAID, in our case mdadm because we're running RHEL 4.4.
> 
> When we try to create the raid set (RAID6), we're getting an error: 
> "Invalid number of devices" (47 devices).  We tried lowering the number, 
> and eventually it worked when we brought the number down to 27.  But 
> looking at the source code, it looks like it supports up to 256 devices 
> for RAID6... ?  Any insight would be much appreciated!!

Use "--metadata=1" to mdadm.  The 0.90 superblock has a limit of 27
devices. version 1 has no fixed limit, but the code might not support
more than 384 very well.

> 
> Thanks a million,

That would be a megathank :-?

NeilBrown
