From: Neil Brown <neilb@suse.de>
Subject: Re: what does md do if it finds an inconsistency?
Date: Mon, 7 May 2007 14:08:53 +1000
Message-ID: <17982.42581.742226.970559@notabene.brown>
References: <20070506004539.GA17736@lapse.madduck.net>
	<20070506090642.GA22083@lapse.madduck.net>
	<463DB709.8010900@eyal.emu.id.au>
	<3655.195.137.231.42.1178458574.squirrel@albatross.madduck.net>
	<20070506155954.GB27948@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Gavin McCullagh on Sunday May 6
Sender: linux-raid-owner@vger.kernel.org
To: Gavin McCullagh <gmccullagh@gmail.com>
Cc: martin f krafft <madduck@madduck.net>, linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday May 6, gmccullagh@gmail.com wrote:
> On Sun, 06 May 2007, martin f krafft wrote:
> 
> > Maybe the ideal way would be to have mdadm --monitor send an email on
> > mismatch_count>0 or a cronjob that regularly sends reminders, until the
> > admin logs in and runs e.g. /usr/share/mdadm/repairarray.

You could certainly do that.  If you configure mdadm to run a program
for each 'monitor' event, you can detect the mismatch count from
argv[3] when argv[1] ==  RebuildFinished.

Though I suspect many people would be happy with running the 'repair'
every month rather than just a 'check'.  Maybe that should be a config
option.

> > 
> > Also, if a mismatch is found on a RAID1, how does md decide which copy is
> > mismatched and which is correct? What about RAID 5/6/10?
> 
> I think it just picks one at random.  After all, how could you reliably
> know which is right in a raid1 array?  With raid5, I understand it just
> updates the parity.

I prefer to say "arbitrary" rather than "random".
I think the current implementation uses the first readable device as
the 'correct' one.
Otherwise, this is correct.

> 
> I had an idea to write an interactive userspace program which ran through
> each block on each disk device to figure out which ones didn't match up and
> then figure out whether it's within allocated filesystem space and if so,
> which file or filesystem data was affected.  This would hopefully enable a
> user to figure out which block is wrong and correct things.
> 

That would be awfully difficult as doing a reverse mapping (block ->
file) is no-trivial in almost any filesystem, and you would want to
(ultimately) do it for every filesystem...

Might be educational though :-)

NeilBrown
