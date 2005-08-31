From: "David M. Strang" <dstrang@shellpower.net>
Subject: Re: raid5: Disk failure on sdm, disabling device
Date: Wed, 31 Aug 2005 17:34:07 -0400
Message-ID: <00c901c5ae73$b80e3ca0$c100a8c0@NCNF5131FTH>
References: <003401c5ae61$d982b5d0$c100a8c0@NCNF5131FTH> <4316050B.1060805@tls.msk.ru> <005201c5ae63$ef23e6f0$c100a8c0@NCNF5131FTH> <43160DF2.6000504@tls.msk.ru>  <007401c5ae6a$7e9cd160$c100a8c0@NCNF5131FTH> <1125520778.3194.18.camel@x1-6-00-0d-60-fd-e8-4c> <008b01c5ae6c$e4db5e90$c100a8c0@NCNF5131FTH> <1125521616.3194.22.camel@x1-6-00-0d-60-fd-e8-4c> <00ab01c5ae6f$1bb27410$c100a8c0@NCNF5131FTH> <43162122.703@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


----- Original Message ----- 
From: Michael Tokarev
To: David M. Strang
Cc: Linux RAID
Sent: Wednesday, August 31, 2005 5:29 PM
Subject: Re: raid5: Disk failure on sdm, disabling device

Michael Tokarev wrote:
> David M. Strang wrote:
> []
>
> > Is there something a little deeper to this error message?
> >
> > Aug 31 04:48:15 abyss kernel: scsi2 (12:0): rejecting I/O to offline 
> > device
> > Aug 31 04:48:15 abyss kernel: raid5: Disk failure on sdm, disabling 
> > device.
>
> If you reread my message, I hope you will find a bit of clue:
>
>   echo y > /sys/block/sdm/device/delete
> (or something like that anyway.)
>
> That's needed for exactly this purpose: to remove a device which is
> marked 'offline' in the kernel somewhere - to be able to re-add it
> later - either with this script or just doing that magic add-single-device
> command manually.

I should have listened sooner; I wasn't able to follow the paths in the 
re-add command, so I didn't do the delete.

I did the delete (the above syntax is correct) -- ran the rescan script, it 
added it back - and the device is accessable again.

Thank you Michael & Forrest.

-- David 

