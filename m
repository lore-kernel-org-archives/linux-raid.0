From: Milo <search.lists@gmail.com>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Tue, 6 Dec 2005 22:58:51 -0800
Message-ID: <dc164f000512062258r21ebb844w4b59238612635d7f@mail.gmail.com>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
	 <17302.10018.330421.986669@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17302.10018.330421.986669@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/6/05, Neil Brown <neilb@suse.de> wrote:
> On Tuesday December 6, search.lists@gmail.com wrote:
> > Hello, I have been trying to figure out how to fix my raid system,
> > SUSE 9.3, linux 2.6.11.4-21.9-default. A hard reset put my raid in
> > unstable state, almost same errors as
> > http://sumo.genetics.ucla.edu/pipermail/nelsonlab-dev/2004-August/000150.html
> > except, sda1 seems to be the problem.
> > md: kicking non-fresh sda1 from array!
> >
> > I did
> > mdadm -A -f /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1
> > and then /proc/mdstat shows the 2 disk raid active, but I could not
> > mount it, mounting /dev/md0 hangs.  Later I tried
> > mdadm --assemble /dev/md0 --force /dev/sda1 /dev/sdb1 /dev/sdc1
> > same thing.
> >
> > If the raid is ok in degraded (missing 1 drive) mode, shouldn't I be
> > able to mount it?
>
> Yes you should.
> The fact that you cannot tends to suggest something wrong at a
> hardware level, but it is hard to be sure.
>
> Can you get any kernel messages between assembling the array and the
> mount hanging?
> If you could
>    echo t > /proc/sysrq_trigger
>
> and capture the output
>    dmesg > /some/file
>
> that might also be helpful.
>
> NeilBrown
>

Ok, I managed to capture some output, but it doesn't mean much to me. 
If anyone can help with some type of diagnosis, I would much
appreciate it since i'm killing myself over this one.  The dmesg
output is at (appended with timestamp):
http://www.lebox.org/milan/debug/

The first dmesg snapshot right after a boot, 2nd after mdadm -A
/dev/md0 -f /dev/sda1 ... command and final two while mount /dev/md0
/mnt/tmp hangs; same as described above.

Thanks for any advice!

--
Milan
