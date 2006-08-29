From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 fallen apart
Date: Tue, 29 Aug 2006 12:01:27 +1000
Message-ID: <17651.40951.849657.876173@cse.unsw.edu.au>
References: <87y7tcxu71.fsf@szonett.ki.iif.hu>
	<17650.20238.346014.292009@cse.unsw.edu.au>
	<87ejv027py.fsf@tac.ki.iif.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ferenc Wagner on Monday August 28
Sender: linux-raid-owner@vger.kernel.org
To: Ferenc Wagner <wferi@niif.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 28, wferi@niif.hu wrote:
> Neil Brown <neilb@suse.de> writes:
> >
> > You say some of the drives are 'spare'.  How did that happen?  Did you
> > try to add them back to the array after it has failed?  That is a
> > mistake.
> 
> Surely it was, although not mine.
> 

;-)

> > The easiest thing to do is simply recreate the array, making sure to
> > have the drives in the correct order, and any options (like chunk
> > size) the same.  This will not hurt the data (if done correctly).
> 
> Thanks, that did it!  Strangely (for me) mdadm -E doesn't report the
> chunk size, only mdadm -D does, which is not available prior assembly.
> Looks like it was left at the default 64k.  I recreated the array with
> two drives missing to avoid triggering a resync, and added them
> afterwards.  I wonder whether it makes any difference.

Great!
mdadm -E does report chunk size .. for raid0, raid4, raid5. :-(
It will be fixed for raid6 and raid10 in the next release.  Thanks.

Possibly safer to recreate with two missing if you aren't sure of the
order.  That way you can look in the array to see if it looks right,
or if you have to try a different order.

NeilBrown
