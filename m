From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Raid-5 rebuild
Date: Fri, 24 Dec 2004 12:19:52 -0500
Message-ID: <200412241720.iBOHJx921533@www.watkins-home.com>
References: <41CC1794.7050607@wasp.net.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41CC1794.7050607@wasp.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: 'Brad Campbell' <brad@wasp.net.au>, 'RAID Linux' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Since your removed the disk, then added it.  It is like a new disk.  I think
this is reasonable.  If I recall, Mdadm has an option to verify parity now.
I don't have time to find the details for you.  But I think it requires
Kernel 2.6.?.  I have 2.4, so I can't play with it yet.

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Brad Campbell
Sent: Friday, December 24, 2004 8:20 AM
To: RAID Linux
Subject: Raid-5 rebuild

G'day all,

I'm using a 2.6.10-rc1 (ish.. some BK just after that) kernel and I have a
10 drive raid-5 /dev/md0.
I noticed SMART telling me I have some pending reallocations on /dev/sdj, so
I decided to force the 
matter with a
mdadm --fail /dev/md0 /dev/sdj1
mdadm --remove /dev/md0 /dev/sdj1
mdadm --add /dev/md0 /dev/sdj1

Fine.. all going well, but I noticed using iostat that instead of doing
read-compare cycles, the 
kernel is rebuilding the drive regardless.

I thought (and I may be wrong) that adding a drive to a raid-5 triggered the
kernel to read each 
stripe, and only write out new parity info if the stripe contents are wrong.
Given this array was idle, and I failed/removed/added the drive within about
10 seconds, I would 
have thought that about 99.999% of the stripes should be consistent. The
kernel however is writing 
the whole lot out again. (Not a bad thing in this case as it will *force*
the block reallocations)

What is going on?

On another note, looks like one of my Maxtors is going south (18
reallocations and counting in the 
past week). Go on, say I told you so! I have another 15 of them sitting here
in a box waiting for 
the howswap racks to arrive. I guess I'll be testing out Maxtors RMA process
soon.


iostat 5

avg-cpu:  %user   %nice    %sys %iowait   %idle
           31.45    0.00   68.55    0.00    0.00

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
hda              33.87        29.03      1970.97         72       4888
sda             122.58     27187.10         0.00      67424          0
sdb             122.18     27187.10         0.00      67424          0
sdc             122.18     27187.10         0.00      67424          0
sdd             122.18     27187.10         0.00      67424          0
sde             122.58     27187.10         0.00      67424          0
sdf             123.39     27187.10         0.00      67424          0
sdg             123.79     27187.10         0.00      67424          0
sdh             124.60     27187.10         0.00      67424          0
sdi             122.58     27187.10         0.00      67424          0
sdj             141.53         0.00     27354.84          0      67840
sdk              25.00       416.13       335.48       1032        832
sdl              25.40       354.84       380.65        880        944
sdm              26.61       377.42       419.35        936       1040
md0               0.00         0.00         0.00          0          0
md2              79.44       829.03       600.00       2056       1488


Personalities : [raid0] [raid5] [raid6]
md2 : active raid5 sdl[0] sdm[2] sdk[1]
       488396800 blocks level 5, 128k chunk, algorithm 2 [3/3] [UUU]

md0 : active raid5 sdj1[10] sda1[0] sdi1[8] sdh1[7] sdg1[6] sdf1[5] sde1[4]
sdd1[3] sdc1[2] sdb1[1]
       2206003968 blocks level 5, 128k chunk, algorithm 0 [10/9]
[UUUUUUUUU_]
       [>....................]  recovery =  0.8% (2182696/245111552)
finish=585.3min speed=6913K/sec
unused devices: <none>

Oh, while I'm here. If you celebrate Christmas, Merry Christmas! (I have
become somewhat more 
sensitive to this living in an Arab country!)

-- 
Brad
                    /"\
Save the Forests   \ /     ASCII RIBBON CAMPAIGN
Burn a Greenie.     X      AGAINST HTML MAIL
                    / \
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

