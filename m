From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: how to assemble an array with journal??
Date: Fri, 21 Oct 2016 18:10:04 -0200
Message-ID: <20161021201004.ovrx6nuu5k5lrt6k@fisica.ufpr.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've created an array with journal but after stopping it I'm stuck to assemble
it back, mdadm refuses to assemble it because of stale journal device:

First create journal device, it's a 2-disk raid0:

foobar# mdadm -C /dev/md0 -l 0 -n 2 -e 1.1 /dev/sd[fg]
mdadm: array /dev/md0 started.
foobar# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] 
md0 : active raid0 sdg[1] sdf[0]
      312318976 blocks super 1.1 512k chunks

Now create the raid6 array with journal:

foobar# mdadm -C /dev/md1 -l 6 -n 20 -e 1.1 --assume-clean --write-journal=/dev/md0 /dev/sd[de] /dev/sd[h-y]
mdadm: array /dev/md1 started.

foobar# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4] 
md1 : active raid6 sdy[20] sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14] sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5] sdi[4] sdh[3] sde[2] sdd[1] md0[0](J)
      105487045632 blocks super 1.1 level 6, 512k chunk, algorithm 2 [20/20] [UUUUUUUUUUUUUUUUUUUU]
      bitmap: 0/44 pages [0KB], 65536KB chunk

md0 : active raid0 sdg[1] sdf[0]
      312318976 blocks super 1.1 512k chunks

Now stop it:
foobar#~[17:56]  mdadm -S /dev/md1
mdadm: stopped /dev/md1

I put the uuid in /etc/mdadm/mdadm.conf to make it easier to assemble, then

foobar#~[17:58]  mdadm -vv -A /dev/md1 
mdadm: /dev/md0 is identified as a member of /dev/md1, slot 65533.
mdadm: /dev/sdk is identified as a member of /dev/md1, slot 5.
mdadm: /dev/sdt is identified as a member of /dev/md1, slot 14.
mdadm: /dev/sdj is identified as a member of /dev/md1, slot 4.
mdadm: /dev/sdu is identified as a member of /dev/md1, slot 15.
mdadm: /dev/sdo is identified as a member of /dev/md1, slot 9.
mdadm: /dev/sdm is identified as a member of /dev/md1, slot 7.
mdadm: /dev/sdl is identified as a member of /dev/md1, slot 6.
mdadm: /dev/sdx is identified as a member of /dev/md1, slot 18.
mdadm: /dev/sdw is identified as a member of /dev/md1, slot 17.
mdadm: /dev/sdy is identified as a member of /dev/md1, slot 19.
mdadm: /dev/sdn is identified as a member of /dev/md1, slot 8.
mdadm: /dev/sds is identified as a member of /dev/md1, slot 13.
mdadm: /dev/sdv is identified as a member of /dev/md1, slot 16.
mdadm: /dev/sdq is identified as a member of /dev/md1, slot 11.
mdadm: /dev/sdd is identified as a member of /dev/md1, slot 0.
mdadm: /dev/sdp is identified as a member of /dev/md1, slot 10.
mdadm: /dev/sdr is identified as a member of /dev/md1, slot 12.
mdadm: /dev/sdi is identified as a member of /dev/md1, slot 3.
mdadm: /dev/sdh is identified as a member of /dev/md1, slot 2.
mdadm: /dev/sde is identified as a member of /dev/md1, slot 1.
mdadm: Not safe to assemble with missing or stale journal device, consider --force.

Note that all slots were found, including the journal one. Why does it complain
it's stale??

Trying to assemble listing the devices directly gives the same result:
foobar#~[17:58]  mdadm -A /dev/md1 /dev/sd[de] /dev/sd[h-y]                     mdadm: Not safe to assemble with missing or stale journal device, consider --force.

This is with 4.7.9. How can I reassemble it?
