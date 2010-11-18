From: Mike Viau <viaum@sheridanc.on.ca>
Subject: RE: How to recreate a dmraid RAID array with mdadm
Date: Thu, 18 Nov 2010 00:10:50 -0500
Message-ID: <BAY148-w508672292A737E86BE8332EF390@phx.gbl>
References: <BAY148-w65577551281F75C185BEBEF380@phx.gbl>,<20101117141514.759d9eea@notabene.brown>,<BAY148-w18A88E7D84CE0213B44F26EF380@phx.gbl>,<20101118111149.7b5004a2@notabene.brown>,<BAY148-w607755AA342EF4ACCCC9A5EF390@phx.gbl>,<20101118122847.1530d86c@notabene.brown>,<BAY148-w149179108DC6D340247236EF390@phx.gbl>,<20101118133247.7ffa99d1@notabene.brown>,<BAY148-w494B0F5EB60CC742DFC817EF390@phx.gbl>,<20101118141718.44c1837f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101118141718.44c1837f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids


> On Thu, 18 Nov 2010 14:17:18 +1100 <neilb@suse.de> wrote:
> >
> > > On Thu, 18 Nov 2010 13:32:47 +1100  wrote:
> > > > ./mdadm -Ss
> > > >
> > > > mdadm: stopped /dev/md127
> > > >
> > > >
> > > > ./mdadm -Asvvv
> > > >
> > > > mdadm: looking for devices for further assembly
> > > > mdadm: no RAID superblock on /dev/dm-3
> > > > mdadm: /dev/dm-3 has wrong uuid.
> > > > want UUID-084b969a:0808f5b8:6c784fb7:62659383
> > > > Segmentation fault
> > >
> > > Try this patch instead please.
> >
> > Applied new patch and got:
> >
> > ./mdadm -Ss
> >
> > mdadm: stopped /dev/md127
> >
> >
> > ./mdadm -Asvvv
> > mdadm: looking for devices for further assembly
> > mdadm: no RAID superblock on /dev/dm-3
> > mdadm: /dev/dm-3 has wrong uuid.
> >  want UUID-084b969a:0808f5b8:6c784fb7:62659383
> >  tst=0x10dd010 sb=(nil)
> > Segmentation fault
>
> Sorry... I guess I should have tested it myself..
>
> The
> if (tst) {
>
> Should be
>
> if (tst && content) {
>

Apply update and got:

mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot -1.
mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot -1.
mdadm: added /dev/sda to /dev/md/imsm0 as -1
mdadm: added /dev/sdb to /dev/md/imsm0 as -1
mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
mdadm: looking for devices for /dev/md/OneTB-RAID1-PV


Full output at: http://paste.debian.net/100103/
expires: 

2010-11-21 06:07:30
-M


 		 	   		  