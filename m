From: Luca Berra <bluca@comedia.it>
Subject: Re: (Re: Questions regarding startup of imsm container)
Date: Tue, 23 Mar 2010 16:56:48 +0100
Message-ID: <20100323155648.GA26779@maude.comedia.it>
References: <7db987b31003222056i46c42112s541ba949821a6759@mail.gmail.com> <20100323080419.GA9374@maude.comedia.it> <7db987b31003230558l5993817fwb283c66bbf3633e9@mail.gmail.com> <7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7db987b31003230733n127ed0e2u35bbd1de3cb57733@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 23, 2010 at 08:33:50AM -0600, Randy Terbush wrote:
>To follow-up this startup challenge... here is what I am getting.
>
>mdraid is being started with mdadm -As
>
>I have the following in mdadm.conf
>
>HOMEHOST Volume0
i dont think it matters
>#DEVICE /dev/sd[bcde]
>AUTO +imsm hifi:0 -all
>ARRAY metadata=imsm UUID=30223250:76fd248b:50280919:0836b7f0
there is no name for this array, so it will auto-allocate one, try:
ARRAY /dev/md0 metadata=imsm .....
if you dont like the dynamic minor (just a guess)
>ARRAY /dev/md/Volume0 container=30223250:76fd248b:50280919:0836b7f0
>member=0 UUID=8a4ae452:da1e7832:70ecf895:eb58229c
>
>The following devices are being created.
>
># ls -l /dev/md/
>total 0
>lrwxrwxrwx 1 root root 6 Mar 23 08:10 0 -> ../md0
>lrwxrwxrwx 1 root root 8 Mar 23 08:17 126 -> ../md126
>lrwxrwxrwx 1 root root 8 Mar 23 08:17 127 -> ../md127
>lrwxrwxrwx 1 root root 8 Mar 23 08:17 imsm0 -> ../md127
>lrwxrwxrwx 1 root root 8 Mar 23 08:17 Volume0 -> ../md126
>
>cat /proc/mdstat
>Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>md126 : active raid5 sdb[3] sdc[2] sdd[1] sde[0]
>      2930280448 blocks super external:/md127/0 level 5, 64k chunk,
>algorithm 0 [4/4] [UUUU]
>      [>....................]  resync =  1.8% (18285824/976760320)
>finish=182.6min speed=87464K/sec
>
>md127 : inactive sde[3](S) sdb[2](S) sdc[1](S) sdd[0](S)
>      9028 blocks super external:imsm
>
>unused devices: <none>
>
>So the container device is getting moved from md0 to md127. Not sure why.
>
>And would sure like to have a write-intent bitmap active to avoid this
>resync issue which seems to be happening way too frequently.
As far as i understand the code (which might be not correct):
It is impossible to have internal bitmaps on imsm arrays,
no provisioning in the imsm metadata.
For external bitmaps, kernel code checks the mddev superblock event
counter and the external bitmap superblock event counter to see if they
match before activating the bitmap (you dont' want a bitmap containing
stale information) it is an u64 number, imsm has a u32 number that is
used for similar purpose. so it might be possible.
I have no clue if it will work or not tough. this is why in the patch i
sent previously i preferred disabling bitmaps completely.

Regards,
L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
