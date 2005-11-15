From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: HELP 13 disk raid 5 not starting
Date: Tue, 15 Nov 2005 18:30:44 -0500
Message-ID: <20051115232816.M41786@contactbda.com>
References: <20051115214704.M9636@contactbda.com> <17274.27718.311366.545389@cse.unsw.edu.au> <1132097225.23464.351.camel@seki.nac.uci.edu>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1132097225.23464.351.camel@seki.nac.uci.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Stromberg <strombrg@dcs.nac.uci.edu>, Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The disks contain a ~2TB Postgresql database so i was unable to copy to another system.  The force worked as suggested 
by Neil.

Thanks for the reply
Jim



---------- Original Message -----------
From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
To: Neil Brown <neilb@suse.de>
Cc: jim@contactbda.com, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
Sent: Tue, 15 Nov 2005 15:27:04 -0800
Subject: Re: HELP 13 disk raid 5 not starting

> On Wed, 2005-11-16 at 10:16 +1100, Neil Brown wrote:
> > On Tuesday November 15, jim@contactbda.com wrote:
> > > all,
> > > 
> > > I have a 13 disk raid 5 set with 4 disks marks as "clean" and the
> > > rest marked as dirty.
> > 
> > And important question to answer is 'how did this happen'?
> > 
> > > When I do the following command
> > > to start the raid set (md0) I get an error.  Any ideas on how to
> > > recover?
> > 
> > Add '--force' to the 'mdadm --assemble' command.  This tells mdadm to
> > try really hard to assemble the array, modifying info in the
> > super blocks if necessary.
> > Be aware that though doing this will normally give you a working
> > array, there may be data corruption within the array (it depends
> > somewhat on the answer to that first important question).
> > I would recommend at least an 'fsck' if that is practical.
> > 
> > The array will be assembled degraded.  You will need to add in a spare
> > if you are happy that the data is sufficiently intact.
> 
> Before you do anything that might make things worse (--force is a good
> thing to try, I'm sure, but sometimes the good thing to try causes
> further problems, EG sometimes fsck goes kerflooey on ya), you might
> want to see about getting an image backup of all the drives in the RAID
> array to some other system, if you have the space.  If your array wasn't
> that full, you may be able to compress the image backups to good effect.
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

