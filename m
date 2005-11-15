From: "Jim Buttafuoco" <jim@contactbda.com>
Subject: Re: HELP 13 disk raid 5 not starting
Date: Tue, 15 Nov 2005 18:27:45 -0500
Message-ID: <20051115232628.M46167@contactbda.com>
References: <20051115214704.M9636@contactbda.com> <17274.27718.311366.545389@cse.unsw.edu.au>
Reply-To: jim@contactbda.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17274.27718.311366.545389@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

Thanks for the reply, the --force worked great,  md0 is syncing now, I will run testing against my database once the 
sync completes in 400 minutes.

Jim



---------- Original Message -----------
From: Neil Brown <neilb@suse.de>
To: jim@contactbda.com
Cc: linux-raid@vger.kernel.org
Sent: Wed, 16 Nov 2005 10:16:22 +1100
Subject: Re: HELP 13 disk raid 5 not starting

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
> 
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
------- End of Original Message -------

