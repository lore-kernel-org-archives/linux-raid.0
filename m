From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: HELP 13 disk raid 5 not starting
Date: Tue, 15 Nov 2005 15:27:04 -0800
Message-ID: <1132097225.23464.351.camel@seki.nac.uci.edu>
References: <20051115214704.M9636@contactbda.com>
	 <17274.27718.311366.545389@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17274.27718.311366.545389@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: jim@contactbda.com, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids

On Wed, 2005-11-16 at 10:16 +1100, Neil Brown wrote:
> On Tuesday November 15, jim@contactbda.com wrote:
> > all,
> > 
> > I have a 13 disk raid 5 set with 4 disks marks as "clean" and the
> > rest marked as dirty.
> 
> And important question to answer is 'how did this happen'?
> 
> > When I do the following command
> > to start the raid set (md0) I get an error.  Any ideas on how to
> > recover?
> 
> Add '--force' to the 'mdadm --assemble' command.  This tells mdadm to
> try really hard to assemble the array, modifying info in the
> super blocks if necessary.
> Be aware that though doing this will normally give you a working
> array, there may be data corruption within the array (it depends
> somewhat on the answer to that first important question).
> I would recommend at least an 'fsck' if that is practical.
> 
> The array will be assembled degraded.  You will need to add in a spare
> if you are happy that the data is sufficiently intact.

Before you do anything that might make things worse (--force is a good
thing to try, I'm sure, but sometimes the good thing to try causes
further problems, EG sometimes fsck goes kerflooey on ya), you might
want to see about getting an image backup of all the drives in the RAID
array to some other system, if you have the space.  If your array wasn't
that full, you may be able to compress the image backups to good effect.




