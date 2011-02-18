From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm / force parity checking of blocks on all reads?
Date: Fri, 18 Feb 2011 14:25:36 +1100
Message-ID: <20110218142536.04d35fe5@notabene.brown>
References: <4D5DD3C0.3020804@chaven.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5DD3C0.3020804@chaven.com>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Costaras <stevecs@chaven.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 17 Feb 2011 20:04:48 -0600 Steve Costaras <stevecs@chaven.com> wrote:

> 
> 
> I'm looking at alternatives to ZFS since it still has some time to go 
> for large scale deployment as a kernel-level file system (and brtfs has 
> years to go).   I am running into problems with silent data corruption 
> with large deployments of disks.    Currently no hardware raid vendor 
> supports T10 DIF (which even if supported would only work w/ SAS/FC 
> drives anyway) nor does read parity checking.

Maybe I'm just naive,  but find it impossible to believe that "silent data
corruption" is ever acceptable.   You should fix or replace your hardware.

Yes, I know silent data corruption is theoretically possible at a very low
probability and that as you add more and more storage, that probability gets
higher and higher.

But my point is that the probability of unfixable but detectable corruption
will ALWAYS be much (much much) higher than the probability of silent data
corruption (on a correctly working system).

So if you are getting unfixable errors reported on some component, replace
that component.  And if you aren't then ask your vender to replace the
system, because it is broken.


> 
> I am hoping that either there is a way that I don't know of to enable 
> mdadm to read the data plus p+q parity blocks for every request and 
> compare them for accuracy (simlar to what you need to do for a scrub but 
> /ALWAYS/) or have the functionality added as an option.

No, it is not currently possible to do this, nor have I plan to implement
it.  I guess it would be possible in theory though.

NeilBrown


> 
> With the current large capacity drives we have today getting bit errors 
> is quite common (I have some scripts that I do complete file checks 
> every two weeks across 50TB arrays and come up with errros every 
> month).   I'm looking at expanding to 200-300TB volumes shortly so the 
> problem will only get that much more frequent.     Being able to check 
> the data against parity will be able to find/notify and correct errors 
> at read time before they get to user space.   This fixes bit rot as well 
> as torn/wild reads/writes and mitigates transmission issues.
> 
> I searched the list but couldn't find this benig discussed before, is 
> this possible?
> 
> Steve Costaras
> stevecs@chaven.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

