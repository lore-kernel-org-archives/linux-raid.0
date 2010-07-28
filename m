From: "Stefan G. Weichinger" <lists@xunil.at>
Subject: Pending sectors in valid array - how to proceed?
Date: Wed, 28 Jul 2010 19:46:29 +0200
Message-ID: <4C506CF5.2080307@xunil.at>
Reply-To: lists@xunil.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Greets,

in a customer-server I run these arrays:

# cat /proc/mdstat
Personalities : [raid0] [raid1] [raid6] [raid5] [raid4]
md1 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]

md3 : active raid5 sdd3[3](S) sdc3[2] sdb3[1] sda3[0]
      15647104 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]

md4 : active raid5 sdd4[3](S) sdc4[2] sdb4[1] sda4[0]
      471941376 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]


So far everything OK.

--

smartctl shows for /dev/sdb:

  5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
      -       0
195 Hardware_ECC_Recovered  0x001a   058   039   000    Old_age   Always
      -       146754005
197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
      -       13
198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
Offline      -       13

(relevant lines as far as I understand ...)

So I have these 13 pending sectors ...

I assume it would be good to swap sdb for safety?

This would mean:

* fail sdb

* wait for the spare to be synced ... which I fear somehow (I once lost
an array as a second drive dropped out while resync ...)

* change sdb

* re-add sdb

correct?

I also read of a way of removing and re-adding a drive to get rid of
these sectors?

Is this a recommended thing to do?
What would you recommend me to do?

Thank you, Stefan

