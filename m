From: Stefan Borggraefe <stefan@spybot.info>
Subject: Re: Help with recovering a RAID5 array
Date: Mon, 06 May 2013 10:12:42 +0200
Message-ID: <4918514.Nmbo5VakCk@chablis>
References: <34199580.p6EyCyMeIZ@chablis> <1838659.cc600uVROo@rattle> <20130506163102.066b9264@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130506163102.066b9264@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am Montag, 6. Mai 2013, 16:31:02 schrieb NeilBrown:
> On Sat, 04 May 2013 13:13:27 +0200 Stefan Borggraefe <stefan@spybot.info>
> 
> wrote:
> > Am Freitag, 3. Mai 2013, 10:38:52 schrieben Sie:
> > > On Thu, May 2, 2013 at 2:24 PM, Stefan Borggraefe <stefan@spybot.info>
> > 
> > wrote:
> > > > I am using a RAID5 software RAID on Ubuntu 12.04
> > > > 
> > > > It consits of 6 Hitachi drives with 4 TB and contains an ext 4 file
> > > > system.
> > > > 
> > > > When I returned to this server this morning, the array was in the
> > > > following
> > > > state:
> > > > 
> > > > md126 : active raid5 sdc1[7](S) sdh1[4] sdd1[3](F) sde1[0] sdg1[6]
> > > > sdf1[2]
> > > > 
> > > >       19535086080 blocks super 1.2 level 5, 512k chunk, algorithm 2
> > > >       [6/4]
> > > > 
> > > > [U_U_UU]
> > > > 
> > > > sdc is the newly added hard disk, but now also sdd failed. :( It would
> > > > be
> > > > great if there was a way to have the this RAID5 working again. Perhaps
> > > > sdc1
> > > > can then be fully added to the array and after this drive sdd also
> > > > exchanged.
> > > 
> > > I have had a few raid6 fail in a similar fashion: the 3rd drive
> > > faliing during rebuild (Also 4 TB Hitachi by the way).
> > > 
> > > I tested if the drives were fine:
> > >   parallel dd if={} of=/dev/null bs=1000k ::: /dev/sd?
> > > 
> > > And they were all fine.
> > 
> > Same for me.
> > 
> > > With only a few failing sectors (if any) I figured that very little
> > > would be lost by forcing the failing drive online. Remove the spare
> > > 
> > > drive, and force the remaining online:
> > >   mdadm -A --scan --force
> > 
> > I removed the spare /dev/sdc1 from /dev/md126
> > 
> > with
> > 
> > mdadm /dev/md126 --remove /dev/sdc1
> > 
> > After mdadm -A --scan --force the array is now in this state
> > 
> > md126 : active raid5 sdh1[4] sdd1[3](F) sde1[0] sdg1[6] sdf1[2]
> > 
> >       19535086080 blocks super 1.2 level 5, 512k chunk, algorithm 2 [6/4]
> > 
> > [U_U_UU]
> 
> Did you stop the array first?
>   i.e.
>     mdadm --stop /dev/md126
>     mdadm -Asfvv
> 
> NeilBrown

Thank you Neil, yes this was my mistake. I realised it in the meantime and am 
currently checking the file system using overlay files as suggested in

https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Force_assembly
-- 
Best regards,
Stefan Borggraefe
