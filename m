From: Milo <search.lists@gmail.com>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Wed, 7 Dec 2005 22:01:03 -0800
Message-ID: <dc164f000512072201w1779863bw1ac1d7b14a5a52ac@mail.gmail.com>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
	 <17302.10018.330421.986669@cse.unsw.edu.au>
	 <dc164f000512062258r21ebb844w4b59238612635d7f@mail.gmail.com>
	 <17303.44330.447062.271960@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17303.44330.447062.271960@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/7/05, Neil Brown <neilb@suse.de> wrote:
> On Tuesday December 6, search.lists@gmail.com wrote:
> > On 12/6/05, Neil Brown <neilb@suse.de> wrote:
> > > > If the raid is ok in degraded (missing 1 drive) mode, shouldn't I be
> > > > able to mount it?
> > >
> > > Yes you should.
> > > The fact that you cannot tends to suggest something wrong at a
> > > hardware level, but it is hard to be sure.
> > >
> > > Can you get any kernel messages between assembling the array and the
> > > mount hanging?
> > > If you could
> > >    echo t > /proc/sysrq_trigger
> > >
> > > and capture the output
> > >    dmesg > /some/file
> > >
> > > that might also be helpful.
> > >
> > > NeilBrown
> > >
> >
> > Ok, I managed to capture some output, but it doesn't mean much to me.
> > If anyone can help with some type of diagnosis, I would much
> > appreciate it since i'm killing myself over this one.  The dmesg
> > output is at (appended with timestamp):
> > http://www.lebox.org/milan/debug/
>
> Yes, that is very helpful.
>
> The drive is not being assembled successfully.
> When you try to mount it, a raid bug (which has since been fixed)
> causes the mount processed to crash.
> You should be able to assemble the array with:
>
>   mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1
>
> Please try that, then take a copy of
>   cat /proc/mdstat
>   mdadm -D /dev/md0

# mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1
mdadm: /dev/md0 has been started with 2 drives (out of 3).
# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sdb1[1] sdc1[2]
      490191104 blocks level 5, 128k chunk, algorithm 2 [3/2] [_UU]

unused devices: <none>

then mdadm -D /dev/md0 hangs, then i make another trace ...
http://www.lebox.org/milan/debug/dmesg.1134020701

>
> and then try mounting the filesystem.
> If the mount still fails, send me the output of those commands.
>
> Thanks,
> NeilBrown
>
>
