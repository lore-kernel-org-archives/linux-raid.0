From: "James R Bamford" <jim@jimtreats.com>
Subject: RE: Software Raid 1 data corruptions..
Date: Mon, 17 Nov 2003 23:15:34 -0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <PPEOJEIEFLAONFNHJPOOGEGMGOAA.jim@jimtreats.com>
References: <16312.15921.440148.830272@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16312.15921.440148.830272@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: david.anderson@calixo.net, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Neil Brown
> Sent: 17 November 2003 03:19
> To: James R Bamford
> Cc: david.anderson@calixo.net; linux-raid@vger.kernel.org
> Subject: RE: Software Raid 1 data corruptions..
>
>
> On Saturday November 15, jim@jimtreats.com wrote:
>
> > raiddev /dev/md0
> >         raid-level      1
> >         nr-raid-disks   2
> >         nr-spare-disks  0
> >         chunk-size      4
> >         persistent-superblock   1
> >         device          /dev/hde1
> >         raid-disk       0
> >         device          /dev/hdh1
> >         raid-disk       1
>
> Would I be right in guessing that hde1 is a master, but hdh1 is a
> slave (though on different busses)?  That's kind of an odd
> configuration.
>
> You could try turning of DMA on the drives (hdparm ...) and see if you
> still get corruption.  If you don't, the finger point very much at the
> IDE controller...

Ok i managed to get corruptions (always only on the 2nd disk) according to
md5sum on the same file, when they were mounted seperately and i performed
the test on both drives simultaneously.. that at least made sense..

I will try the hdparm if it happens again but i just nuked the array,
repartitioned to 15gig, rebuilt the array (sorry i followed the howto again
as i tried dmadm to rebuild but it asked for a personality.. where do i
specify this i couldn't see it in the conf file... anyways this just
completed

Performed the test and its fine.. the md5sum results are constant on the
file... hopefully this has fixed it.. its unlikely this was a localised
problem on the disk (as in using a higher point on the disk that currently
isn't available) but i will rebuild the full array tomorrow and retest
again..

it stood up with md5sum occuring on the raid array as well as on my / drive
on the MB's standard ide controller... good signs indeed.. perhaps i wont
need to buy that hardware raid card just yet :)

I will look up on how to use mdadm to create the array but if you have any
advice on this then that'd be good..

Finally i've been hearing these conversations on how to rebuild the array as
well.. i guess this is the final test... i will simulate it with these mini
partitions as it'll be quicker... i am right that the sync time will take as
long when adding new devices as it did when adding it in the first place.. 3
hours or more for these 160gig drives..

Thanks.. hopefully i'm getting a break and this will all work from now on :)

Cheers

Jim


>
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

