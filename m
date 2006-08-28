From: Ferenc Wagner <wferi@niif.hu>
Subject: Re: RAID6 fallen apart
Date: Mon, 28 Aug 2006 17:36:09 +0200
Message-ID: <87ejv027py.fsf@tac.ki.iif.hu>
References: <87y7tcxu71.fsf@szonett.ki.iif.hu>
	<17650.20238.346014.292009@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17650.20238.346014.292009@cse.unsw.edu.au> (Neil Brown's
 message of "Mon, 28 Aug 2006 12:03:58 +1000")
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown <neilb@suse.de> writes:

> On Saturday August 26, wferi@niif.hu wrote:
>
>> after an intermittent network failure, our RAID6 array of AoE devices
>> can't run anymore.  Looks like the system dropped each of the disks one
>> after the other, and at the third the array failed as expected.
>> Trying to assemble the array results in all disks going into spare
>> status, nothing useful.  The disks really must have been cut
>> simultaneously, but their superblocks were probably altered since then
>> by the recovery attempts.
>
> You say some of the drives are 'spare'.  How did that happen?  Did you
> try to add them back to the array after it has failed?  That is a
> mistake.

Surely it was, although not mine.

> The thing to do at that point is 
>   - stop the array
>   - make sure the network is back and the individual drives are
>     working
>   - use mdadm to assemble with --force.  This should 'just work'. 

Probably it should have...

> But if you used --add, then you will have destroyed info in the
> superblock.  That isn't the end of the world, but makes it a little
> harder.
>
> The easiest thing to do is simply recreate the array, making sure to
> have the drives in the correct order, and any options (like chunk
> size) the same.  This will not hurt the data (if done correctly).

Thanks, that did it!  Strangely (for me) mdadm -E doesn't report the
chunk size, only mdadm -D does, which is not available prior assembly.
Looks like it was left at the default 64k.  I recreated the array with
two drives missing to avoid triggering a resync, and added them
afterwards.  I wonder whether it makes any difference.

Anyway, thanks a lot!
-- 
Feri.
