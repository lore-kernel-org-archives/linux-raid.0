From: Frank Blendinger <fb@intoxicatedmind.net>
Subject: Re: Failed RAID-5 with 4 disks
Date: Fri, 16 Sep 2005 13:36:22 +0200
Message-ID: <20050916113622.GI21856@intoxicatedmind.net>
References: <20050726170329.GA30354@intoxicatedmind.net> <42E6B213.8020108@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <42E6B213.8020108@dtbb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 26, 2005 at 02:58:43PM -0700, Tyler wrote:
> My suggestion would be to buy two new drives, and DD (or dd rescue) the 
> two bad drives onto the new drives, and then plug the new drive that has 
> the most recent failure on it (HDG?) in, and try running a forced 
> assemble including the HDG drive, then, in readonly mode, run an fsck to 
> check the file system, and see if it thinks most things are okay.  *IF* 
> it checks out okay (for the most part.. you will probably lose some 
> data), then plug the second new disk in, and add it to the array as a 
> spare, and it would then start a resync of the array.  Otherwise, if the 
> fsck found that the entire filesystem was fubar... then I would try the 
> above steps, but force the assemble with the original failed disk.. but 
> depending on how long in between the two failures its been, and if any 
> data was written to the array after the first failure, this is probably 
> not going to be a good thing.. but could still be useful if you were 
> trying to recover specific files that were not touched in between the 
> two failures.

Thanks for your suggestions.

This is what I did so far: I got one of the two bad drives (the one that
failed first) replaced with a new one. I copied the other bad drive to
the new one with dd. I guess that not everything could be copied
alright, I got 10 "Buffer I/O error on device hdg, logical sector
..." and about 35 "end_request: I/O error, hdg, sector ..." error
messages in my syslog.

Now I'm stuck re-activating the array with the dd'ed hde and the working
hdi and hdk. I tried "mdadm --assemble --scan /dev/md0", which told me
"mdadm: /dev/md0 assembled from 2 drives - not enough to start the array."

I then tried hot-adding hde with "mdadm --add /dev/hde [--force] /dev/md0"
but that only got me "mdadm: /dev/hde does not appear to be an md
device".

Any suggestions?


Greets,
Frank
