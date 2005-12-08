From: Neil Brown <neilb@suse.de>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Thu, 8 Dec 2005 14:48:58 +1100
Message-ID: <17303.44330.447062.271960@cse.unsw.edu.au>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
	<17302.10018.330421.986669@cse.unsw.edu.au>
	<dc164f000512062258r21ebb844w4b59238612635d7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Milo on Tuesday December 6
Sender: linux-raid-owner@vger.kernel.org
To: Milo <search.lists@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday December 6, search.lists@gmail.com wrote:
> On 12/6/05, Neil Brown <neilb@suse.de> wrote:
> > > If the raid is ok in degraded (missing 1 drive) mode, shouldn't I be
> > > able to mount it?
> >
> > Yes you should.
> > The fact that you cannot tends to suggest something wrong at a
> > hardware level, but it is hard to be sure.
> >
> > Can you get any kernel messages between assembling the array and the
> > mount hanging?
> > If you could
> >    echo t > /proc/sysrq_trigger
> >
> > and capture the output
> >    dmesg > /some/file
> >
> > that might also be helpful.
> >
> > NeilBrown
> >
> 
> Ok, I managed to capture some output, but it doesn't mean much to me. 
> If anyone can help with some type of diagnosis, I would much
> appreciate it since i'm killing myself over this one.  The dmesg
> output is at (appended with timestamp):
> http://www.lebox.org/milan/debug/

Yes, that is very helpful.

The drive is not being assembled successfully. 
When you try to mount it, a raid bug (which has since been fixed)
causes the mount processed to crash.
You should be able to assemble the array with:

  mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1

Please try that, then take a copy of 
  cat /proc/mdstat
  mdadm -D /dev/md0

and then try mounting the filesystem.
If the mount still fails, send me the output of those commands.

Thanks,
NeilBrown

