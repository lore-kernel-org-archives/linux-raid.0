From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: potentially lost largeish raid5 array..
Date: Fri, 23 Sep 2011 02:09:36 -0600
Message-ID: <201109230209.36209.thomas@fjellstrom.ca>
References: <201109221950.36910.tfjellstrom@shaw.ca> <20110923151108.08c1199f@notabene.brown> <201109222322.57040.tfjellstrom@shaw.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201109222322.57040.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 22, 2011, Thomas Fjellstrom wrote:
> On September 22, 2011, NeilBrown wrote:
> > On Thu, 22 Sep 2011 22:49:12 -0600 Thomas Fjellstrom
> > <tfjellstrom@shaw.ca>
> > 
> > wrote:
> > > On September 22, 2011, NeilBrown wrote:
> > > > On Thu, 22 Sep 2011 19:50:36 -0600 Thomas Fjellstrom
> > > > <tfjellstrom@shaw.ca>
> > > > 
> > > > wrote:
> > > > > Hi,
> > > > > 
> > > > > I've been struggling with a SAS card recently that has had poor
> > > > > driver support for a long time, and tonight its decided to kick
> > > > > every drive in the array one after the other. Now mdstat shows:
> > > > > 
> > > > > md1 : active raid5 sdf[0](F) sdh[7](F) sdi[6](F) sdj[5](F)
> > > > > sde[3](F) sdd[2](F) sdg[1](F)
> > > > > 
> > > > >       5860574208 blocks super 1.1 level 5, 512k chunk, algorithm 2
> > > > >       [7/0]
> > > > > 
> > > > > [_______]
> > > > > 
> > > > >       bitmap: 3/8 pages [12KB], 65536KB chunk
> > > > > 
> > > > > Does the fact that I'm using a bitmap save my rear here? Or am I
> > > > > hosed? If I'm not hosed, is there a way I can recover the array
> > > > > without rebooting? maybe just a --stop and a --assemble ? If that
> > > > > won't work, will a reboot be ok?
> > > > > 
> > > > > I'd really prefer not to have lost all of my data. Please tell me
> > > > > (please) that it is possible to recover the array. All but sdi are
> > > > > still visible in /dev (I may be able to get it back via hotplug
> > > > > maybe, but it'd get sdk or something).
> > > > 
> > > > mdadm --stop /dev/md1
> > > > 
> > > > mdadm --examine /dev/sd[fhijedg]
> > > > mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]
> > > > 
> > > > Report all output.
> > > > 
> > > > NeilBrown
> > > 
> > > Hi, thanks for the help. Seems the SAS card/driver is in a funky state
> > > at the moment. the --stop worked*. but --examine just gives "no md
> > > superblock detected", and dmesg reports io errors for all drives.
> > 
> > > I've just reloaded the driver, and things seem to have come back:
> > That's good!!
> > 
> > > root@boris:~# mdadm --examine /dev/sd[fhijedg]
> > 
> > ....
> > 
> > sd1 has a slightly older event count than the others - Update time is
> > 1:13 older.  So it presumably died first.
> > 
> > > root@boris:~# mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]
> > > mdadm: looking for devices for /dev/md1
> > > mdadm: /dev/sdd is identified as a member of /dev/md1, slot 2.
> > > mdadm: /dev/sde is identified as a member of /dev/md1, slot 3.
> > > mdadm: /dev/sdf is identified as a member of /dev/md1, slot 0.
> > > mdadm: /dev/sdg is identified as a member of /dev/md1, slot 1.
> > > mdadm: /dev/sdh is identified as a member of /dev/md1, slot 6.
> > > mdadm: /dev/sdi is identified as a member of /dev/md1, slot 5.
> > > mdadm: /dev/sdj is identified as a member of /dev/md1, slot 4.
> > > mdadm: added /dev/sdg to /dev/md1 as 1
> > > mdadm: added /dev/sdd to /dev/md1 as 2
> > > mdadm: added /dev/sde to /dev/md1 as 3
> > > mdadm: added /dev/sdj to /dev/md1 as 4
> > > mdadm: added /dev/sdi to /dev/md1 as 5
> > > mdadm: added /dev/sdh to /dev/md1 as 6
> > > mdadm: added /dev/sdf to /dev/md1 as 0
> > > mdadm: /dev/md1 has been started with 6 drives (out of 7).
> > > 
> > > 
> > > Now I guess the question is, how to get that last drive back in? would:
> > > 
> > > mdadm --re-add /dev/md1 /dev/sdi
> > > 
> > > work?
> > 
> > re-add should work, yes.  It will use the bitmap info to only update the
> > blocks that need updating - presumably not many.
> > It might be interesting to run
> > 
> >   mdadm -X /dev/sdf
> > 
> > first to see what the bitmap looks like - how many dirty bits and what
> > the event counts are.
> 
> root@boris:~# mdadm -X /dev/sdf
>         Filename : /dev/sdf
>            Magic : 6d746962
>          Version : 4
>             UUID : 7d0e9847:ec3a4a46:32b60a80:06d0ee1c
>           Events : 1241766
>   Events Cleared : 1241740
>            State : OK
>        Chunksize : 64 MB
>           Daemon : 5s flush period
>       Write Mode : Normal
>        Sync Size : 976762368 (931.51 GiB 1000.20 GB)
>           Bitmap : 14905 bits (chunks), 18 dirty (0.1%)
> 
> > But yes: --re-add should make it all happy.
> 
> Very nice. I was quite upset there for a bit. Had to take a walk ;D

I forgot to say, but: Thank you very much :) for the help, and your tireless 
work on md.

> > NeilBrown


-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
