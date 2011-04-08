From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: What the heck happened to my array?
Date: Fri, 08 Apr 2011 09:19:01 +0800
Message-ID: <4D9E6285.8000006@fnarfbargle.com>
References: <4D9876E4.6080501@fnarfbargle.com>	<AANLkTi=2GNYdySbCDXmaDC8-8vF8GU9V3Uoy1qByNq58@mail.gmail.com>	<4D995E27.3060800@fnarfbargle.com>	<BANLkTi=prv_vzfJr2JJt3LLhdB0GFSMy4w@mail.gmail.com>	<4D9A6694.4040606@fnarfbargle.com> <20110405161043.00d54901@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110405161043.00d54901@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/04/11 14:10, NeilBrown wrote:

> I would suggest:
>    copy anything that you need off, just in case - if you can.
>
>    Kill the mdadm that is running in the back ground.  This will mean that
>    if the machine crashes your array will be corrupted, but you are thinking
>    of rebuilding it any, so that isn't the end of the world.
>    In /sys/block/md0/md
>       cat suspend_hi>  suspend_lo
>       cat component_size>  sync_max
>

root@srv:/sys/block/md0/md# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdc[0] sdd[6](S) sdl[1](S) sdh[9] sda[8] sde[7] 
sdg[5] sdb[4] sdf[3] sdm[2]
       7814078464 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[10/8] [U_UUUU_UUU]
       [=================>...]  reshape = 88.2% (861696000/976759808) 
finish=3713.3min speed=516K/sec

md2 : active raid5 sdi[0] sdk[3] sdj[1]
       1465146368 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] 
[UUU]

md6 : active raid1 sdp6[0] sdo6[1]
       821539904 blocks [2/2] [UU]

md5 : active raid1 sdp5[0] sdo5[1]
       104864192 blocks [2/2] [UU]

md4 : active raid1 sdp3[0] sdo3[1]
       20980800 blocks [2/2] [UU]

md3 : active raid1 sdp2[0] sdo2[1]
       8393856 blocks [2/2] [UU]

md1 : active raid1 sdp1[0] sdo1[1]
       20980736 blocks [2/2] [UU]

unused devices: <none>
root@srv:/sys/block/md0/md# cat component_size > sync_max
cat: write error: Device or resource busy

root@srv:/sys/block/md0/md# cat suspend_hi suspend_lo
13788774400
13788774400

root@srv:/sys/block/md0/md# grep . sync_*
sync_action:reshape
sync_completed:1723392000 / 1953519616
sync_force_parallel:0
sync_max:1723392000
sync_min:0
sync_speed:281
sync_speed_max:200000 (system)
sync_speed_min:200000 (local)

So I killed mdadm, then did the cat suspend_hi > suspend_lo.. but as you 
can see it won't let me change sync_max. The array above reports 
516K/sec, but that was just on its way down to 0 on a time based 
average. It was not moving at all.

I then tried stopping the array, restarting it with mdadm 3.1.4 which 
immediately segfaulted and left the array in state resync=DELAYED.

I issued the above commands again, which succeeded this time but while 
the array looked good, it was not resyncing :
root@srv:/sys/block/md0/md# cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
md0 : active raid6 sdc[0] sdd[6](S) sdl[1](S) sdh[9] sda[8] sde[7] 
sdg[5] sdb[4] sdf[3] sdm[2]
       7814078464 blocks super 1.2 level 6, 512k chunk, algorithm 2 
[10/8] [U_UUUU_UUU]
       [=================>...]  reshape = 88.2% (861698048/976759808) 
finish=30203712.0min speed=0K/sec

md2 : active raid5 sdi[0] sdk[3] sdj[1]
       1465146368 blocks super 1.2 level 5, 64k chunk, algorithm 2 [3/3] 
[UUU]

md6 : active raid1 sdp6[0] sdo6[1]
       821539904 blocks [2/2] [UU]

md5 : active raid1 sdp5[0] sdo5[1]
       104864192 blocks [2/2] [UU]

md4 : active raid1 sdp3[0] sdo3[1]
       20980800 blocks [2/2] [UU]

md3 : active raid1 sdp2[0] sdo2[1]
       8393856 blocks [2/2] [UU]

md1 : active raid1 sdp1[0] sdo1[1]
       20980736 blocks [2/2] [UU]

unused devices: <none>

root@srv:/sys/block/md0/md# grep . sync*
sync_action:reshape
sync_completed:1723396096 / 1953519616
sync_force_parallel:0
sync_max:976759808
sync_min:0
sync_speed:0
sync_speed_max:200000 (system)
sync_speed_min:200000 (local)

I stopped the array and restarted it with mdadm 3.2.1 and it continued 
along its merry way.

Not an issue, and I don't much care if it blew something up, but I 
thought it worthy of a follow up.

If there is anything you need tested while it's in this state I've got ~ 
1000 minutes of resync time left and I'm happy to damage it if requested.

Regards,
Brad
