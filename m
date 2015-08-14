From: "Wilson, Jonathan" <i400s@hotmail.com>
Subject: Re: How will mdadm handle a wrongly added drive, when the original
 comes back on line?
Date: Fri, 14 Aug 2015 09:04:13 +0100
Message-ID: <BLU437-SMTP103F503282DDF045B2A7F2EE17C0@phx.gbl>
References: <BLU437-SMTP91911FDCDB54E9FBB43E5BE1770@phx.gbl>
	 <55BFFC6A.6030006@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55BFFC6A.6030006@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2015-08-04 at 09:42 +1000, Adam Goryachev wrote:
> On 03/08/15 23:14, Wilson, Jonathan wrote:
> > Due to a bug in the driver for a Marvel chipset 4 port SATA card I think
> > I may have added an empty drive partition into a raid6 array and when I
> > get a new card I it will end up seeing not only the new drive, but also
> > the "missing" drive.
> >
> > Events:
> > Upgraded jessie with latest updates (quite some time since I last did
> > it) and re-booted.
> >
> > A 6 drive raid6 assembled, but all the drives were spare. Stopped the
> > array and did a mdadm --assemble /dev/md6.
> >
> > It assembled with 5 drives, one missing.
> >
> > Tried re-add, which failed, and then -add which completed ok.
> At this point the array should have done a resync to add the 6th drive.
> > Some time later I re-booted and the same problem happened.
> >
> > All drives spare, stopped, assembled, added missing.
> At this point the array should have done a resync to add the 6th drive. 
> Whether this is the same "6th" drive or not doesn't matter.
> > Its now working and I have a new card on order due to something going
> > badly wrong with the driver and/or card and/or chipset (Marvel 9230).
> >
> > After some time passed after the second boot, I realised that one of my
> > drives was physically missing. I had a drive ready to go as a genuine
> > spare but not yet added as a spare to mdadm, so in theory it should have
> > been totally empty apart from a partition.
> >
> > Now my problem is that firstly I can not be sure that when I looked
> > at /proc/mdstat/ and saw "all" the drives as spare there might have been
> > a missing one. (On either or both occasions.)
> >
> > In my mdadm.config I don't specify the number of drives in the array,
> > just its name and the UUID.
> >
> > Now my question is: if we call the drives in the array A,B,C,D,E,F and
> > the empty one G.
> >
> > After the first boot I may have added G, so the array would be
> > A,B,C,D,E,G. (F missing from system)
> >
> > After the second boot I may have added F back, so the array would be
> > A,B,C,D,E,F (G missing from system)
> >
> > If after changing the card the system sees A,B,C,D,E,F,G how will mdadm
> > work? Will it fail to assemble as one of the drives is "extra" to the
> > metadata count (I assume even though I don't specify a count in the
> > conf, that internally on the partitions of the disks in the array it
> > knows there should be "6" disks.
> It should reject the "older" 6th drive because the event count will be 
> older, and should auto-assemble with all the other drives. The older 
> "6th" drive will either be spare, or not added to the array at all, and 
> you would need to add it to the array for it to become a spare.

I wanted to thank you for your help with this post some days ago.

The drives had indeed swapped so I had 7 disks in a 6 disk array. After
swapping the 4 port Marvel chipset card for two 2 port ASM1062's
(Interestingly enough these happened to be exactly the same chips as the
additional on board extra satas) the system booted with a nice clean
dmesg log. (No "red line" errors)

The older, original, drive of the array was kicked:

 
> [    3.269932] md: bind<sdb4>
> [    3.272343] md: bind<sda4>
> [    3.274762] md: raid10 personality registered for level 10
> [    3.275748] md/raid10:md4: active with 2 out of 2 devices
> [    3.276617] md4: detected capacity change from 0 to 64390955008
> [    3.277958]  md4: unknown partition table
> [    3.346450] md: bind<sdn6>
> [    3.370188] md: bind<sdg6>
> [    3.372120] md: kicking non-fresh sdh6 from array! <<<<<<<<<<<<<<<<<<<<<
> [    3.372956] md: unbind<sdh6>
> [    3.383684] md: export_rdev(sdh6)
> [    3.452610] raid6: sse2x1   13949 MB/s
> [    3.520586] raid6: sse2x2   17910 MB/s
> [    3.588568] raid6: sse2x4   20617 MB/s
> [    3.656547] raid6: avx2x1   27298 MB/s
> [    3.724527] raid6: avx2x2   32586 MB/s
> [    3.792508] raid6: avx2x4   36498 MB/s
> [    3.793243] raid6: using algorithm avx2x4 (36498 MB/s)
> [    3.793973] raid6: using avx2x2 recovery algorithm
> [    3.794829] xor: automatically using best checksumming function:
> [    3.832495]    avx       : 43866.000 MB/sec
> [    3.833351] async_tx: api initialized (async)
> [    3.834559] md: raid6 personality registered for level 6
> [    3.835255] md: raid5 personality registered for level 5
> [    3.835945] md: raid4 personality registered for level 4
> [    3.836716] md/raid:md6: device sdg6 operational as raid disk 0
> [    3.837391] md/raid:md6: device sdn6 operational as raid disk 5
> [    3.838043] md/raid:md6: device sdl6 operational as raid disk 1
> [    3.838688] md/raid:md6: device sdm6 operational as raid disk 4
> [    3.839315] md/raid:md6: device sdj6 operational as raid disk 2
> [    3.839916] md/raid:md6: device sdi6 operational as raid disk 3
> [    3.840715] md/raid:md6: allocated 0kB
> [    3.841341] md/raid:md6: raid level 6 active with 6 out of 6 devices, algorithm 2
> [    3.841963] RAID conf printout:
> [    3.841963]  --- level:6 rd:6 wd:6
> [    3.841964]  disk 0, o:1, dev:sdg6
> [    3.841965]  disk 1, o:1, dev:sdl6
> [    3.841965]  disk 2, o:1, dev:sdj6
> [    3.841966]  disk 3, o:1, dev:sdi6
> [    3.841966]  disk 4, o:1, dev:sdm6
> [    3.841967]  disk 5, o:1, dev:sdn6
> [    3.842047] created bitmap (22 pages) for device md6
> [    3.842997] md6: bitmap initialized from disk: read 2 pages, set 0 of 43172 bits
> [    3.855294] md6: detected capacity change from 0 to 11588669014016
> 

The booted drive is now sitting as "inactive" so when I get time I will
clear it and add it as a hot spare.

Thanks again, and thanks to Neil and others for all their hard work in
developing mdadm.


