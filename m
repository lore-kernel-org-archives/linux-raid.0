From: Eric Rumer <eric.rumer@level3.com>
Subject: RAID recovery question
Date: Tue, 26 Aug 2003 21:31:27 -0600 (MDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.50.0308262115130.6333-100000@scrappy.it.l3.com>
Reply-To: Eric Rumer <eric.rumer@level3.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I got you email address from the mkraid --force output.  It seems I have a
problem that I need help with.

A server that I admin lost connectivity to its disk array.  It was momentary,
but several 'disks' were marked failed by the RAID software.  I have one
volume that I'm having trouble getting to work again.  It's a bit of a strange
configuration -

/dev/md3 = RAID5, /dev/sde1 + /dev/sdf1 + /dev/sdg1 + /dev/sdh1
/dev/md4 = RAID5, /dev/sdi1 + /dev/sdj1 + /dev/sdk1 + /dev/sdl1
/dev/md5 = RAID0, /dev/md3 + /dev/md4

I did this instead of an 8 disk RAID5 so that I could add to /dev/md5 in 4
disk chunks if/when we needed more space.  Looking at it now, I'm not sure
that's even possible in Linux, but in any case that's what I have (we usually
use Solaris and Veritas Volume Manager, which allows you to grow volumes, but
you need to keep the layout consistant when concatenating space).

When I try to run raidstart /dev/md3 I get -

Aug 26 20:37:15 davis kernel:  [events: 0000000f]
Aug 26 20:37:15 davis kernel:  [events: 0000000f]
Aug 26 20:37:15 davis kernel:  [events: 0000000d]
Aug 26 20:37:15 davis kernel: md: autorun ...
Aug 26 20:37:15 davis kernel: md: considering sdg1 ...
Aug 26 20:37:15 davis kernel: md:  adding sdg1 ...
Aug 26 20:37:15 davis kernel: md:  adding sdf1 ...
Aug 26 20:37:15 davis kernel: md:  adding sde1 ...
Aug 26 20:37:15 davis kernel: md: created md3
Aug 26 20:37:15 davis kernel: md: bind<sde1,1>
Aug 26 20:37:15 davis kernel: md: bind<sdf1,2>
Aug 26 20:37:15 davis kernel: md: bind<sdg1,3>
Aug 26 20:37:15 davis kernel: md: running: <sdg1><sdf1><sde1>
Aug 26 20:37:15 davis kernel: md: sdg1's event counter: 0000000d
Aug 26 20:37:15 davis kernel: md: sdf1's event counter: 0000000f
Aug 26 20:37:15 davis kernel: md: sde1's event counter: 0000000f
Aug 26 20:37:15 davis kernel: md: freshest: sdf1
Aug 26 20:37:15 davis kernel: md: kicking non-fresh sdg1 from array!
Aug 26 20:37:15 davis kernel: md: unbind<sdg1,2>
Aug 26 20:37:15 davis kernel: md: export_rdev(sdg1)
Aug 26 20:37:15 davis kernel: md3: removing former faulty sdg1!
Aug 26 20:37:15 davis kernel: md3: max total readahead window set to 768k
Aug 26 20:37:15 davis kernel: md3: 3 data-disks, max readahead per data-disk:
256k
Aug 26 20:37:15 davis kernel: raid5: device sdf1 operational as raid disk 1
Aug 26 20:37:15 davis kernel: raid5: device sde1 operational as raid disk 0
Aug 26 20:37:15 davis kernel: RAID5 conf printout:
Aug 26 20:37:15 davis kernel:  --- rd:4 wd:2 fd:2
Aug 26 20:37:15 davis kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sde1
Aug 26 20:37:15 davis kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdf1
Aug 26 20:37:15 davis kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
Aug 26 20:37:15 davis kernel:  disk 3, s:0, o:0, n:3 rd:3 us:1 dev:[dev 00:00]
Aug 26 20:37:15 davis kernel: md :do_md_run() returned -22
Aug 26 20:37:15 davis kernel: md: md3 stopped.
Aug 26 20:37:15 davis kernel: md: unbind<sdf1,1>
Aug 26 20:37:15 davis kernel: md: export_rdev(sdf1)
Aug 26 20:37:15 davis kernel: md: unbind<sde1,0>
Aug 26 20:37:15 davis kernel: md: export_rdev(sde1)
Aug 26 20:37:15 davis kernel: md: ... autorun DONE.

So, basically, I need to let the RAID software know that sdg1 and sdh1 are
back now, and are in good shape.  Can this be done without losing all my data?
The HOWTO at

<http://www.infodrom.org/Linux/HOWTO/Software-RAID/Software-RAID-HOWTO-6.html#ss6.1>

Made me think that mkraid --force was the key, but the output from the command
makes me think I'm going to lose all my data.  I think I can get /dev/md4 and
/dev/md5 back, once I know how to get /dev/md3 working.

Can you help?

Thanks,

-- Eric
