From: Corey McGuire <coreyfro@coreyfro.com>
Subject: Re: RAID 5 lost two disks
Date: Fri, 5 Mar 2004 12:25:30 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403051225.30661.coreyfro@coreyfro.com>
References: <200403050926.42047.coreyfro@coreyfro.com> <200403051005.20830.coreyfro@coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403051005.20830.coreyfro@coreyfro.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org, bugzilla@watkins-home.com
List-Id: linux-raid.ids

That kinda worked!!!!!! I need to FSCK it, but i'm still afraid of fscking it 
up...

Does anyone in San Jose/San Francisco/Anywhere-in-frag'n-California have a 
free TB I can use for a DD?  I will offer you my first child!

If I need to sweeten the deal, I have LOTS to share... I have a TB of goodies 
just looking to be backed up!

On Friday 05 March 2004 10:14 am, you wrote:
> I had a 2 disk failure; I will explain what I did.
> 1 disk was bad; it affected all disks on that SCSI buss.
> The RAID software got into a bad state, I think I needed to reboot, or
> power cycle.
> After the reboot, it said 2 disks were non fresh or whatever.
> My array had 14 disks, 7 on the buss with the 2 non fresh disks.
> I could not do a dd read test with much success on most of the disks, maybe
> 2 or 3 seemed ok, but not if I did 2 dd's at the same time.
> So I unplugged all disks but 1, tested the 1.  If success repeat with the
> next disk.  I found 1 disk that did not work.  So I connected the 6 good
> disks.  Did 6 dd's at the same time, all was well.
>
> So, now I have 13 of 14 disks and 1 of the 13 is non fresh.  I issued this
> command.
>
> mdadm -A --force /dev/md2 --scan
> For some reason my filesystem was corrupt.  I noticed that the spare disk
> was in the list.  I knew the rebuild to the spare never finished.  It may
> not have been synced at all since so many disks were not working.  So, I
> knew the spare should not be part of the array, yet!
>
> I had trouble stopping the array, so reboot.
>
> This time I listed the disks excluding the spare and the failed disk.
>
> mdadm -A --force /dev/md2 /dev/sdk1 /dev/sdd1 /dev/sdl1 /dev/sde1 /dev/sdm1
> /dev/sdf1 /dev/sdn1 /dev/sdg1 /dev/sdh1 /dev/sdo1 /dev/sdi1 /dev/sdp1
> /dev/sdj1
>
> I did not include the missing disk, but I did include the non fresh disk.
> Now my filesystem is fine.
>
> I added the spare, it re-built, a good day!  I bet if this had happened to
> a hardware RAID it could not have been saved.
>
> I replaced the bad disk and added it as a spare.
> That was about 1 month ago, everything is still fine.
>
> You will need to install mdadm if you don't have it.  mdadm does not use
> raidtab, it uses /etc/mdadm.conf
>
> Man mdadm for details!
>
> Good luck!
>
> Guy
>
> ===========================================================================
>= Tips:
>
> This will give details of each disk.
> mdadm -E /dev/hda3
> repeat for hdc3, hde3, hdg3, hdi3, hdk3.
>
> dd test...  To test a disk to determine if the surface is good.
> This is just a read test!
> dd if=/dev/hda of=/dev/null bs=64k
> repeat for hdc, hde, hdg, hdi, hdk.
>
> My mdadm.conf:
> MAILADDR bugzilla@watkins-home.com
> PROGRAM /root/bin/handle-mdadm-events
>
> DEVICE /dev/sd[abcdefghijklmnopqrstuvwxyz][12]
>
> ARRAY /dev/md0 level=raid1 num-devices=2
> UUID=1fb2890c:2c9c47bf:db12e1e3:16cd7ffe
>
> ARRAY /dev/md1 level=raid1 num-devices=2
> UUID=8f183b62:ea93fe30:a842431c:4b93c7bb
>
> ARRAY /dev/md2 level=raid5 num-devices=14
> UUID=8357a389:8853c2d1:f160d155:6b4e1b99
