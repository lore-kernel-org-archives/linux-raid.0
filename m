From: Ole Tange <tange@binf.ku.dk>
Subject: SpareMissing event, but spare not missing
Date: Wed, 15 May 2013 15:51:37 +0200
Message-ID: <CANU9nTm_TpyomQVSHNtQHVNMwRNKrZjs=YUv5PYmKoTV61Gvsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The last couple of days I have received a warning about a missing
spare for a device that has several spares.

  A SparesMissing event had been detected on md device /dev/md1.
  :
  md1 : active raid6 sdas[12](S) sdx[0] sdaq[11](S) sdau[13](S)
sdah[9] sdaf[8] sdae[7] sdad[6] sdac[5] sdab[4] sdaa[3] sdz[2] sdy[1]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]
      bitmap: 0/2 pages [0KB], 1048576KB chunk

I have tried removing one of the spares and adding it again. Same error.

$ mdadm --version
mdadm - v3.1.4 - 31st August 2010
$ uname -a
Linux orsted 3.2.0-0.bpo.1-amd64 #1 SMP Sat Feb 11 08:41:32 UTC 2012
x86_64 GNU/Linux

/Ole


The automated mail:

This is an automatically generated mail message from mdadm
running on orsted

A SparesMissing event had been detected on md device /dev/md1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid6] [raid5] [raid4] [raid0]
md3 : active raid0 md1[0] md2[1]
      62512275456 blocks super 1.2 512k chunks

md2 : active raid6 sdat[10] sdaj[0] sdao[8] sdag[7] sdap[6] sdan[5]
sdai[4] sdam[3] sdal[2] sdak[1]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]
      bitmap: 0/2 pages [0KB], 1048576KB chunk

md1 : active raid6 sdas[12](S) sdx[0] sdaq[11](S) sdau[13](S) sdah[9]
sdaf[8] sdae[7] sdad[6] sdac[5] sdab[4] sdaa[3] sdz[2] sdy[1]
      31256138752 blocks super 1.2 level 6, 128k chunk, algorithm 2
[10/10] [UUUUUUUUUU]
      bitmap: 0/2 pages [0KB], 1048576KB chunk

md0 : active raid6 sdw[28](S) sdd[25] sdu[19] sdv[22] sdp[26] sds[16]
sdr[15] sdq[14] sdo[23] sdn[12] sdm[11] sdl[10] sdk[9] sdj[8] sdi[7]
sdh[6] sdc[20] sdf[4] sde[3] sdb[21] sdt[24]
      52744776192 blocks super 1.2 level 6, 256k chunk, algorithm 2
[20/20] [UUUUUUUUUUUUUUUUUUUU]
      bitmap: 1/2 pages [4KB], 1048576KB chunk

unused devices: <none>
