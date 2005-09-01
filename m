From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Thu, 1 Sep 2005 03:38:01 -0400
Message-ID: <00e001c5aec8$151f1d20$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH> <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c> <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH> <1125521616.3194.22.camel@x1-6-00-0d-60-fd-e8-4c> <00ab01c5ae6f$1bb27410$c100a8c0@NCNF5131FTH> <43162122.703@tls.msk.ru> <00c901c5ae73$b80e3ca0$c100a8c0@NCNF5131FTH> <1125526791.3194.32.camel@x1-6-00-0d-60-fd-e8-4c>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Forrest Taylor <ftaylor@redhat.com>
Cc: Michael Tokarev <mjt@tls.msk.ru>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Forrest Taylor wrote:
> > Michael Tokarev wrote:
> > > David M. Strang wrote:
> > > []
> > >
> > > > Is there something a little deeper to this error message?
> > > >
> > > > Aug 31 04:48:15 abyss kernel: scsi2 (12:0): rejecting I/O to offline
> > > > device
> > > > Aug 31 04:48:15 abyss kernel: raid5: Disk failure on sdm, disabling
> > > > device.
> > >
> > > If you reread my message, I hope you will find a bit of clue:
> > >
> > >   echo y > /sys/block/sdm/device/delete
> > > (or something like that anyway.)
> > >
> > > That's needed for exactly this purpose: to remove a device which is
> > > marked 'offline' in the kernel somewhere - to be able to re-add it
> > > later - either with this script or just doing that magic 
> > > add-single-device
> > > command manually.
> >
> > I should have listened sooner; I wasn't able to follow the paths in the
> > re-add command, so I didn't do the delete.
> >
> > I did the delete (the above syntax is correct) -- ran the rescan script, 
> > it
> > added it back - and the device is accessable again.
> >
> > Thank you Michael & Forrest.
>
> I just noticed that in /sys/block/sda/device/, along with the delete
> file, there is a rescan file.  I think that this is what I was thinking
> of with the 2.6 kernel.

Well, my worst fear was realized. My raid array barfed during rebuild. It 
errorenously kicked a few devices from the array. I/O was not rejected to 
any of the drives as was before; so I stopped the array. (mdadm --stop 
/dev/md0) -- and re-assembled it;

mdadm -A /dev/md0 /dev/sda /dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf 
/dev/sdg /dev/sdh /dev/sdi /dev/sdj /dev/sdk /dev/sdl /dev/sdm /dev/sdn 
/dev/sdo /dev/sdp /dev/sdq /dev/sdr /dev/sds /dev/sdt /dev/sdu /dev/sdv 
/dev/sdw /dev/sdx /dev/sdy /dev/sdz /dev/sdaa /dev/sdab -f

Just as before;

mdadm: forcing event count in /dev/sda(0) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdb(1) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdc(2) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdd(3) from 337384 upto 2645518
mdadm: forcing event count in /dev/sde(4) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdf(5) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdg(6) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdh(7) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdi(8) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdj(9) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdk(10) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdl(11) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdn(13) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdo(14) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdp(15) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdq(16) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdr(17) from 337384 upto 2645518
mdadm: forcing event count in /dev/sds(18) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdt(19) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdu(20) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdv(21) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdw(22) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdx(23) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdy(24) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdz(25) from 337384 upto 2645518
mdadm: forcing event count in /dev/sdab(27) from 337384 upto 2645518
mdadm: /dev/md0 assembled from 26 drives - not enough to start the array.

The 2 drives, one of which was sync'd -- and one that was rebuilding; won't 
join the array.



