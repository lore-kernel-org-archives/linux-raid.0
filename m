Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62427ECAAD5
	for <linux-raid@archiver.kernel.org>; Fri,  2 Sep 2022 19:12:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230223AbiIBTMf convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 2 Sep 2022 15:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiIBTMf (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 2 Sep 2022 15:12:35 -0400
Received: from mail.stoffel.org (li1843-175.members.linode.com [172.104.24.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99852FC125
        for <linux-raid@vger.kernel.org>; Fri,  2 Sep 2022 12:12:33 -0700 (PDT)
Received: from quad.stoffel.org (068-116-170-226.res.spectrum.com [68.116.170.226])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 6BF5E1E766;
        Fri,  2 Sep 2022 15:12:32 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 0C6F0A7E53; Fri,  2 Sep 2022 15:12:32 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Message-ID: <25362.21920.20956.599850@quad.stoffel.home>
Date:   Fri, 2 Sep 2022 15:12:32 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Peter Sanders <plsander@gmail.com>
Cc:     John Stoffel <john@stoffel.org>,
        Wols Lists <antlists@youngman.org.uk>,
        Eyal Lebedinsky <fedora@eyal.emu.id.au>,
        linux-raid@vger.kernel.org
Subject: Re: RAID 6, 6 device array - all devices lost superblock
In-Reply-To: <CAKAPSkKpykx7wCy9Qqc4QjyXAT4MbiRuTEZf2nE0F9eWyW5F4A@mail.gmail.com>
References: <CAKAPSkJLd836Zp3xU=zSOHg3qcEmi29Y2qOwWzeAFaDp+dNTvg@mail.gmail.com>
        <70e2ae22-bbba-77a4-c9bc-4c02752f4cb7@youngman.org.uk>
        <dc24b476-2f0a-8406-f1c0-e33b5b0eb388@youngman.org.uk>
        <4a414fc6-2666-302f-8d3d-08eb7a2986fc@turmel.org>
        <CAKAPSkJAQYsec-4zzcePbkJ7Ee0=sd_QvHj4Stnyineq+T8BXw@mail.gmail.com>
        <25355.47062.897268.3355@quad.stoffel.home>
        <ee66bcbe-0a9b-57a6-439f-72cc46debe48@turmel.org>
        <25355.50871.743993.605394@quad.stoffel.home>
        <CAKAPSkLQ4K1R_aD1=iURTFQmm_DXDMr=wx+VDET7DOUy+6Zp_Q@mail.gmail.com>
        <25357.13191.843087.630097@quad.stoffel.home>
        <1d978f6c-e1cc-e928-efc5-11ff167938b1@eyal.emu.id.au>
        <CAKAPSkJhf8hWGTQiCne6BnMPYoum4hJT3diz9U1FGAfq=_N-nA@mail.gmail.com>
        <CAKAPSkK1bTf+7GOxmB-odjr2zej6XBCT_VGhfNC1KnSXZHjeRw@mail.gmail.com>
        <8e994200-146e-61ce-bb4a-f7f111f47b10@youngman.org.uk>
        <CAKAPSkKQA3cV1rcj9cNrdKorOOqyjHf_4BCLxbEx8ibusJP5nA@mail.gmail.com>
        <25359.50842.604856.467479@quad.stoffel.home>
        <CAKAPSkL45hc2kTkZyZwhuMz+Pr+rqP70tARvMz4CzEdTtB1sHw@mail.gmail.com>
        <CAKAPSkKpykx7wCy9Qqc4QjyXAT4MbiRuTEZf2nE0F9eWyW5F4A@mail.gmail.com>
X-Mailer: VM 8.2.0b under 27.1 (x86_64-pc-linux-gnu)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:

Peter, please include the output of all the commands, not just the
commands themselves.  See my comments below.


> Question on restarting from scratch...
> How to reset to the starting point?

I think you need to blow away the loop devices and re-create them.  

Or at least blow away the dmsetup devices you just created.  

It might be quickest to just reboot.  What OS are you using for the
recovery?  Is it a recent live image?  Sorry for asking so many
questions... some of this is new to me too.


> dmsetup, both for remove and create of the overlay seems to be hanging.

> On Fri, Sep 2, 2022 at 10:56 AM Peter Sanders <plsander@gmail.com> wrote:
>> 
>> contents of /proc/mdstat
>> 
>> root@superior:/mnt/backup# cat /proc/mdstat
>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>> [raid4] [raid10]
>> unused devices: <none>
>> root@superior:/mnt/backup#
>> 
>> 
>> 
>> Here are the steps I ran (minus some mounting other devices and
>> looking around for mdadm tracks on the old os disk)
>> 
>> 410  DEVICES=$(cat /proc/partitions | parallel --tagstring {5}
>> --colsep ' +' mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t'
>> echo /dev/{1})
>> 411  apt install parallel
>> 412  DEVICES=$(cat /proc/partitions | parallel --tagstring {5}
>> --colsep ' +' mdadm -E /dev/{5} |grep $UUID | parallel --colsep '\t'
>> echo /dev/{1})
>> 413  echo $DEVICES

So you found no MD RAID super blocks on any of the base devices.  You
can skip this step moving forward. 

>> 414  cat /proc/partitions
>> 415  DEVICES=/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg
>> 416  DEVICES="/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg"
>> 417  echo $DEVICES
>> 418  parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7
>> {#}' ::: $DEVICES
>> 419  ls /dev/loop*

Can you show the output of all these commands, not just the commands please?

>> 423  parallel truncate -s300G overlay-{/} ::: $DEVICES

>> 427  parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f
>> --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup
>> create {/}' ::: $DEVICES
>> 428  ls /dev/mapper/

This is some key output to view.

>> 429  OVERLAYS=$(parallel echo /dev/mapper/{/} ::: $DEVICES)
>> 430  echo $OVERLAYS

What are the overlays?  

>> 431  dmsetup status

What did this command show?

>> 432  mdadm --assemble --force /dev/md1 $OVERLAYS

And here is where I think you need to put --assume-clean when using
'create' command instead.  It's not going to assemble anything because
the info was wiped.  I *think* you really want:

   mdadm --create /dev/md1 --level=raid6 -n 6 --assume-clean $OVERLAYS

And once you do this above command and it comes back, do:

    cat /proc/mdstat

and show all the output please!  

>> 433  history
>> 434  dmsetup status
>> 435  echo $OVERLAYS
>> 436  mdadm --assemble --force /dev/md0 $OVERLAYS
>> 437  cat /proc/partitions
>> 438  mkdir /mnt/oldroot
>> << look for inird mdadm files >>
>> 484  echo $OVERLAYS
>> 485  mdadm --create /dev/md0 --level=raid6 -n 6 /dev/mapper/sdb
>> /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde /dev/mapper/sdf
>> /dev/mapper/sdg

I'm confused here, what  is the difference between the md1 you
assembled above, and the md0 you're doing here?  

>> << cancelled out of 485, review instructions... >>
>> 486  mdadm --create /dev/md0 --level=raid6 -n 6 /dev/mapper/sdb
>> /dev/mapper/sdc /dev/mapper/sdd /dev/mapper/sde /dev/mapper/sdf
>> /dev/mapper/sdg
>> 487  fsck -n /dev/md0

And what output did you get here?  Did it find a filesystem?  You might want
to try:

   blkid /dev/md0  


>> 488  mdadm --stop /dev/md0
>> 489  echo $DEVICES
>> 490   parallel 'dmsetup remove {/}; rm overlay-{/}' ::: $DEVICES
>> 491  dmsetup status

This all worked properly?  No errors?

I gave up after this because it's not clear what the results really
are.  If you don't find a filesystem that fsck's cleanly, then you
should just need to stop the array, then re-create it but shuffle the
order of the devices.  

Instead of disk in order of "sdb sdc sdd... sdN", you would try the
order "sdc sdd ... sdN sdb".   See how I moved sdb to the end of the
list of devices?  With six disks, you have I think 6 factorial options
to try.   Which is alot of options to go though, and why you need to
automate this more.  But also keep a log and show the output!

John


>> 492  ls
>> 493  rm overlay-*
>> 494  ls
>> 495  parallel losetup -d ::: /dev/loop[0-9]*
>> 496  parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b 7
>> {#}' ::: $DEVICES
>> 497  parallel truncate -s300G overlay-{/} ::: $DEVICES
>> 498  parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f
>> --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup
>> create {/}' ::: $DEVICES
>> 499  dmsetup status
>> 500  /sbin/reboot
>> 501  history
>> 502  dmsetup status
>> 503  mount
>> 504  cat /proc/partitions
>> 505  nano /etc/fstab
>> 506  mount /mnt/backup/
>> 507  ls /mnt/backup/
>> 508  rm /mnt/backup/
>> 509  rm /mnt/backup/overlay-sd*
>> 510  emacs setupOverlay &
>> 511  ps auxww | grep emacs
>> 512  kill 65017
>> 513  ls /dev/loo*
>> 514  DEVICES='/dev/sdb /dev/sdc /dev/sdd /dev/sde /dev/sdf /dev/sdg'
>> 515  echo $DEVICES
>> 516   parallel 'test -e /dev/loop{#} || mknod -m 660 /dev/loop{#} b
>> 7 {#}' ::: $DEVICES
>> 517  ls /dev/loo*
>> 518  parallel truncate -s4000G overlay-{/} ::: $DEVICES
>> 519  ls
>> 520  rm overlay-sd*
>> 521  cd /mnt/bak
>> 522  cd /mnt/backup/
>> 523  ls
>> 524  parallel truncate -s4000G overlay-{/} ::: $DEVICES
>> 525  ls -la
>> 526  blockdev --getsize /dev/sdb
>> 527  man losetup
>> 528  man losetup
>> 529  parallel 'size=$(blockdev --getsize {}); loop=$(losetup -f
>> --show -- overlay-{/}); echo 0 $size snapshot {} $loop P 8 | dmsetup
>> create {/}' ::: $DEVICES
>> 530  dmsetup status
>> 531  history | grep mdadm
>> 532  history
>> 533  dmsetup status
>> 534  history | grep dmsetup
>> 535  dmsetup status
>> 536  dmsetup remove sdg
>> 537  dmsetup ls --tree
>> 538  lsof
>> 539  dmsetup ls --tre
>> 540  dmsetup ls --tree
>> 541  lsof | grep -i sdg
>> 542  lsof | grep -i sdf
>> 543  history |grep dmsetup | less
>> 544  dmsetup status
>> 545  history > ~plsander/Documents/raidIssues/joblog
>> 
>> On Wed, Aug 31, 2022 at 4:37 PM John Stoffel <john@stoffel.org> wrote:
>> >
>> > >>>>> "Peter" == Peter Sanders <plsander@gmail.com> writes:
>> >
>> > > encountering a puzzling situation.
>> > > dmsetup is failing to return.
>> >
>> > I don't think you need to use dmsetup in your case, but can you post
>> > *all* the commands you ran before you got to this point, and the
>> > output of
>> >
>> >        cat /proc/mdstat
>> >
>> > as well?  Thinking on this some more, you might need to actually also
>> > add:
>> >
>> >         --assume-clean
>> >
>> > to the 'mdadm create ....' string, since you don't want it to zero the
>> > array or anything.
>> >
>> > Sorry for not remembering this at the time!
>> >
>> > So if you can, please just start over from scratch, showing the setup
>> > of the loop devices, the overlayfs setup, and the building the RAID6
>> > array, along with the cat /proc/mdstat after you do the initial build.
>> >
>> > John
>> >
>> > P.S.  For those who hated my email citing tool, I pulled it out for
>> > now.  Only citing with > now.  :-)
>> >
>> > > root@superior:/mnt/backup# dmsetup status
>> > > sdg: 0 5860533168 snapshot 16/8388608000 16
>> > > sdf: 0 5860533168 snapshot 16/8388608000 16
>> > > sde: 0 5860533168 snapshot 16/8388608000 16
>> > > sdd: 0 5860533168 snapshot 16/8388608000 16
>> > > sdc: 0 5860533168 snapshot 16/8388608000 16
>> > > sdb: 0 5860533168 snapshot 16/8388608000 16
>> >
>> > > dmsetup remove sdg  runs for hours.
>> > > Canceled it, ran dmsetup ls --tree and find that sdg is not present in the list.
>> >
>> > > dmsetup status shows:
>> > > sdf: 0 5860533168 snapshot 16/8388608000 16
>> > > sde: 0 5860533168 snapshot 16/8388608000 16
>> > > sdd: 0 5860533168 snapshot 16/8388608000 16
>> > > sdc: 0 5860533168 snapshot 16/8388608000 16
>> > > sdb: 0 5860533168 snapshot 16/8388608000 16
>> >
>> > > dmsetup ls --tree
>> > > root@superior:/mnt/backup# dmsetup ls --tree
>> > > sdf (253:3)
>> > >  ├─ (7:3)
>> > >  └─ (8:80)
>> > > sde (253:1)
>> > >  ├─ (7:1)
>> > >  └─ (8:64)
>> > > sdd (253:2)
>> > >  ├─ (7:2)
>> > >  └─ (8:48)
>> > > sdc (253:0)
>> > >  ├─ (7:0)
>> > >  └─ (8:32)
>> > > sdb (253:5)
>> > >  ├─ (7:5)
>> > >  └─ (8:16)
>> >
>> > > any suggestions?
>> >
>> >
>> >
>> > > On Tue, Aug 30, 2022 at 2:03 PM Wols Lists <antlists@youngman.org.uk> wrote:
>> > >>
>> > >> On 30/08/2022 14:27, Peter Sanders wrote:
>> > >> >
>> > >> > And the victory conditions would be a mountable file system that passes a fsck?
>> > >>
>> > >> Yes. Just make sure you delve through the file system a bit and satisfy
>> > >> yourself it looks good, too ...
>> > >>
>> > >> Cheers,
>> > >> Wol
