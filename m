From: Milo <search.lists@gmail.com>
Subject: Re: raid5 in degraded mode; trying to revive
Date: Thu, 15 Dec 2005 01:50:48 -0800
Message-ID: <dc164f000512150150k7eaedf29y2bf23d1a69acde44@mail.gmail.com>
References: <dc164f000512060015v2e211817gefb9005fd9b26f08@mail.gmail.com>
	 <17302.10018.330421.986669@cse.unsw.edu.au>
	 <dc164f000512062258r21ebb844w4b59238612635d7f@mail.gmail.com>
	 <17303.44330.447062.271960@cse.unsw.edu.au>
	 <dc164f000512072201w1779863bw1ac1d7b14a5a52ac@mail.gmail.com>
	 <17304.50731.507934.131132@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17304.50731.507934.131132@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/8/05, Neil Brown <neilb@suse.de> wrote:
> On Wednesday December 7, search.lists@gmail.com wrote:
> > >
> > > Yes, that is very helpful.
> > >
> > > The drive is not being assembled successfully.
> > > When you try to mount it, a raid bug (which has since been fixed)
> > > causes the mount processed to crash.
> > > You should be able to assemble the array with:
> > >
> > >   mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1
> > >
> > > Please try that, then take a copy of
> > >   cat /proc/mdstat
> > >   mdadm -D /dev/md0
> >
> > # mdadm -A /dev/md0 -f /dev/sdb1 /dev/sdc1
> > mdadm: /dev/md0 has been started with 2 drives (out of 3).
> > # cat /proc/mdstat
> > Personalities : [raid5]
> > md0 : active raid5 sdb1[1] sdc1[2]
> >       490191104 blocks level 5, 128k chunk, algorithm 2 [3/2] [_UU]
> >
> > unused devices: <none>
> >
> > then mdadm -D /dev/md0 hangs, then i make another trace ...
> > http://www.lebox.org/milan/debug/dmesg.1134020701
> >
>
> It looks like the computer was already quite sick.  It probably tried
> to assemble the array at boot, failed, and left things in an
> unfortunate state.
> Can you boot with
>    raid=noautodetect
>
> And then try the 'mdadm ..' command again?
>

raid=noautodetect for linux 2.6.11.4-21.9-default bootparam doesn't
seem to stop md from loading, still get all the md0 messages in dmesg.
 I also edited /etc/fstab to not try to mount /dev/md0, also did mv
/etc/raidtab /etc/raidtab.off ...

I was going to try booting a live "kubuntu" dvd and try to mdadm -D
command from there ... since i can't seem to get suse 9.3 to not load
it on boot.

I posted some more dmesg with traces, but i think it just looks like
same thing as before.
see
http://www.lebox.org/milan/debug/dmesg.1134108554
http://www.lebox.org/milan/debug/dmesg.1134348723
or http://www.lebox.org/milan/debug/

Any more ideas?
--
Milan
