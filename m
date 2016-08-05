From: "Jens-U. Mozdzen" <jmozdzen@nde.ag>
Subject: RAID 6 "Bad block number requested"
Date: Fri, 05 Aug 2016 17:37:01 +0200
Message-ID: <20160805173701.Horde.ShX_bZ6WY2UKHOO1Leh-sZy@www3.nde.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed; DelSp=Yes
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello list,

one of my server started getting many messages in dmesg, reporting  
"Bad block number requested", like

--- cut here ---
[7749965.585075] sd 10:0:0:0: [sda] Bad block number requested
[7750561.279143] sd 10:0:2:0: [sdc] Bad block number requested
[7751481.566408] sd 10:0:2:0: [sdc] Bad block number requested
[7752774.458062] sd 10:0:2:0: [sdc] Bad block number requested
[7754296.938131] sd 10:0:5:0: [sdf] Bad block number requested
[7755557.728901] sd 10:0:4:0: [sde] Bad block number requested
[7756230.809538] sd 10:0:5:0: [sdf] Bad block number requested
--- cut here ---

I've had about 10k of those messages during the past 10 hours alone.

These messages appear only for those devices that run a MD-RAID 6 and  
seem to be almost evenly distributed across all related devices

--- cut here ---
    1680 [sda]
    1790 [sdb]
    1755 [sdc]
    1855 [sdd]
    1695 [sde]
    1700 [sdf]
--- cut here ---

But interestingly. the incidents are not spread evenly across the day,  
here's what I have for the last few hours:

--- cut here ---
   9029 05
    1224 06
      59 07
      33 09
      31 10
      29 11
      53 12
       5 13
       2 14
       7 15
--- cut here ---

So the majority of these occurred from 5:00 to 5:59 AM. There's no  
rate increase while I run RAID checks.

Neither "mdadm --examine" for the devices nor "mdadm --detail" for the  
RAID device show anything out of place. I'll add these infos once  
somebody mentions that MD-RAID might be the source of the messages.

I had check runs on this RAID6 (echo check >  
/sys/block/md126/md/sync_action), no problems were returned. No other  
evident problems can be seen, either - no failing writes, no file  
system corruption, nothing.

What baffles me: As it is a RAID6, MD should control all writes,  
shouldn't it? Or can it be that some upper layer tries to write beyond  
the end of the RAID device, resulting in the reported syslog messages?

Some words about the stack this server runs:

- sda1-sdf1 assemble to /dev/md126, RAID6 from 6 Seagate ST1000NX0323  
(SAS HDDs)
- sdg1,sdh1 assemble to /dev/md127, RAID1 from two Toshiba PX02SMF020  
(SAS SSDs)
- md126,127 joined as a bcache'd device (/dev/bcache0)
- /dev/bcache0 is the only PV in an LVM
- some LVs are used directly (OS partitions, Ceph OSDs)
- some LVs are local storage for a DRBD setup (this node being primary)

We have a second server with identical hardware and software stack,  
just different LVs - I see none of these problems there.

Can someone confirm/deny that MD tests against writes beyond the end  
of the /dev/md* devices? Or do I have to check the upper layers to see  
if someone tries to write outside the available space?

Regards,
Jens

