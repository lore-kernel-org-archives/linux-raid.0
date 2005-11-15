From: Neil Brown <neilb@suse.de>
Subject: Re: HELP 13 disk raid 5 not starting
Date: Wed, 16 Nov 2005 10:16:22 +1100
Message-ID: <17274.27718.311366.545389@cse.unsw.edu.au>
References: <20051115214704.M9636@contactbda.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jim Buttafuoco on Tuesday November 15
Sender: linux-raid-owner@vger.kernel.org
To: jim@contactbda.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 15, jim@contactbda.com wrote:
> all,
> 
> I have a 13 disk raid 5 set with 4 disks marks as "clean" and the
> rest marked as dirty.

And important question to answer is 'how did this happen'?

> When I do the following command
> to start the raid set (md0) I get an error.  Any ideas on how to
> recover?

Add '--force' to the 'mdadm --assemble' command.  This tells mdadm to
try really hard to assemble the array, modifying info in the
super blocks if necessary.
Be aware that though doing this will normally give you a working
array, there may be data corruption within the array (it depends
somewhat on the answer to that first important question).
I would recommend at least an 'fsck' if that is practical.

The array will be assembled degraded.  You will need to add in a spare
if you are happy that the data is sufficiently intact.

NeilBrown
