From: Jeff Johnson <jeff.johnson@aeoncomputing.com>
Subject: Re: 20 drive raid-10, CentOS5.5, after reboot assemble fails - all
 drives "non-fresh"
Date: Sun, 07 Aug 2011 21:54:31 -0700
Message-ID: <4E3F6C07.8040106@aeoncomputing.com>
References: <4E3F4BD0.5060807@aeoncomputing.com> <20110808125608.7ceeaa02@notabene.brown> <4E3F66F2.3030300@aeoncomputing.com> <4E3F68CB.4060005@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E3F68CB.4060005@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Joe,

The raid still won't assemble via config file:

mdadm --assemble --update=summaries /dev/md3 /dev/sd[c-v]1
mdadm --add /dev/md3 /dev/sd[wxyz]1   (spares)
mdadm --examine --scan | grep md3 > /etc/mdadm.conf.mdt_new
mdadm --stop /dev/md3
mdadm -vv --assemble /dev/md3 -c /etc/mdadm.conf.mdt_new

Output:
mdadm: looking for devices for /dev/md3
mdadm: no recogniseable superblock on /dev/sdz2
mdadm: /dev/sdz2 has wrong uuid.
mdadm: /dev/sdz has wrong uuid.
mdadm: no RAID superblock on /dev/sdy2
mdadm: /dev/sdy2 has wrong uuid.
mdadm: /dev/sdy has wrong uuid.
mdadm: no RAID superblock on /dev/sdx2
mdadm: /dev/sdx2 has wrong uuid.
mdadm: /dev/sdx has wrong uuid.
mdadm: no RAID superblock on /dev/sdw2
mdadm: /dev/sdw2 has wrong uuid.
mdadm: /dev/sdw has wrong uuid.
mdadm: no RAID superblock on /dev/sdv2
mdadm: /dev/sdv2 has wrong uuid.
mdadm: /dev/sdv has wrong uuid.
mdadm: no RAID superblock on /dev/sdu2
mdadm: /dev/sdu2 has wrong uuid.
mdadm: /dev/sdu has wrong uuid.
mdadm: no RAID superblock on /dev/sdt2
mdadm: /dev/sdt2 has wrong uuid.
mdadm: /dev/sdt has wrong uuid.
mdadm: no RAID superblock on /dev/sds2
mdadm: /dev/sds2 has wrong uuid.
mdadm: /dev/sds has wrong uuid.
mdadm: no RAID superblock on /dev/sdr2
mdadm: /dev/sdr2 has wrong uuid.
mdadm: /dev/sdr has wrong uuid.
mdadm: no RAID superblock on /dev/sdq2
mdadm: /dev/sdq2 has wrong uuid.
mdadm: /dev/sdq has wrong uuid.
mdadm: no RAID superblock on /dev/sdp2
mdadm: /dev/sdp2 has wrong uuid.
mdadm: /dev/sdp has wrong uuid.
mdadm: no RAID superblock on /dev/sdo2
mdadm: /dev/sdo2 has wrong uuid.
mdadm: /dev/sdo has wrong uuid.
mdadm: no RAID superblock on /dev/sdn2
mdadm: /dev/sdn2 has wrong uuid.
mdadm: /dev/sdn has wrong uuid.
mdadm: no RAID superblock on /dev/sdm2
mdadm: /dev/sdm2 has wrong uuid.
mdadm: /dev/sdm has wrong uuid.
mdadm: no RAID superblock on /dev/sdl2
mdadm: /dev/sdl2 has wrong uuid.
mdadm: /dev/sdl has wrong uuid.
mdadm: no RAID superblock on /dev/sdk2
mdadm: /dev/sdk2 has wrong uuid.
mdadm: /dev/sdk has wrong uuid.
mdadm: no RAID superblock on /dev/sdj2
mdadm: /dev/sdj2 has wrong uuid.
mdadm: /dev/sdj has wrong uuid.
mdadm: no RAID superblock on /dev/sdi2
mdadm: /dev/sdi2 has wrong uuid.
mdadm: /dev/sdi has wrong uuid.
mdadm: no RAID superblock on /dev/sdh2
mdadm: /dev/sdh2 has wrong uuid.
mdadm: /dev/sdh has wrong uuid.
mdadm: no RAID superblock on /dev/sdg2
mdadm: /dev/sdg2 has wrong uuid.
mdadm: /dev/sdg has wrong uuid.
mdadm: no RAID superblock on /dev/sdf2
mdadm: /dev/sdf2 has wrong uuid.
mdadm: /dev/sdf has wrong uuid.
mdadm: no RAID superblock on /dev/sde2
mdadm: /dev/sde2 has wrong uuid.
mdadm: /dev/sde has wrong uuid.
mdadm: no RAID superblock on /dev/sdd2
mdadm: /dev/sdd2 has wrong uuid.
mdadm: /dev/sdd has wrong uuid.
mdadm: no RAID superblock on /dev/sdc2
mdadm: /dev/sdc2 has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: cannot open device 
/dev/disk/by-uuid/55389e74-b43e-4a6b-97c5-573fcd91a4b7: Device or 
resource busy
mdadm: /dev/disk/by-uuid/55389e74-b43e-4a6b-97c5-573fcd91a4b7 has wrong 
uuid.
mdadm: cannot open device 
/dev/disk/by-uuid/ab90577f-7c58-4e91-95e4-25025cf01790: Device or 
resource busy
mdadm: /dev/disk/by-uuid/ab90577f-7c58-4e91-95e4-25025cf01790 has wrong 
uuid.
mdadm: cannot open device /dev/root: Device or resource busy
mdadm: /dev/root has wrong uuid.
mdadm: cannot open device /dev/sdb3: Device or resource busy
mdadm: /dev/sdb3 has wrong uuid.
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: /dev/sdb2 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sdb: Device or resource busy
mdadm: /dev/sdb has wrong uuid.
mdadm: cannot open device /dev/sda3: Device or resource busy
mdadm: /dev/sda3 has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/sda: Device or resource busy
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sdz1 is identified as a member of /dev/md3, slot 20.
mdadm: /dev/sdy1 is identified as a member of /dev/md3, slot 21.
mdadm: /dev/sdx1 is identified as a member of /dev/md3, slot 22.
mdadm: /dev/sdw1 is identified as a member of /dev/md3, slot 23.
mdadm: /dev/sdv1 is identified as a member of /dev/md3, slot 19.
mdadm: /dev/sdu1 is identified as a member of /dev/md3, slot 18.
mdadm: /dev/sdt1 is identified as a member of /dev/md3, slot 17.
mdadm: /dev/sds1 is identified as a member of /dev/md3, slot 16.
mdadm: /dev/sdr1 is identified as a member of /dev/md3, slot 15.
mdadm: /dev/sdq1 is identified as a member of /dev/md3, slot 14.
mdadm: /dev/sdp1 is identified as a member of /dev/md3, slot 13.
mdadm: /dev/sdo1 is identified as a member of /dev/md3, slot 12.
mdadm: /dev/sdn1 is identified as a member of /dev/md3, slot 11.
mdadm: /dev/sdm1 is identified as a member of /dev/md3, slot 10.
mdadm: /dev/sdl1 is identified as a member of /dev/md3, slot 9.
mdadm: /dev/sdk1 is identified as a member of /dev/md3, slot 8.
mdadm: /dev/sdj1 is identified as a member of /dev/md3, slot 7.
mdadm: /dev/sdi1 is identified as a member of /dev/md3, slot 6.
mdadm: /dev/sdh1 is identified as a member of /dev/md3, slot 5.
mdadm: /dev/sdg1 is identified as a member of /dev/md3, slot 4.
mdadm: /dev/sdf1 is identified as a member of /dev/md3, slot 3.
mdadm: /dev/sde1 is identified as a member of /dev/md3, slot 2.
mdadm: /dev/sdd1 is identified as a member of /dev/md3, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md3, slot 0.
mdadm: No suitable drives found for /dev/md3


Maybe '--update=uuid' ??

--Jeff


On 8/7/11 9:40 PM, Joe Landman wrote:
> On 08/08/2011 12:32 AM, Jeff Johnson wrote:
>
>> It is good I can start the raid manually but it isn't supposed to work
>> like that. Any idea why assembling from a config file would fail? Here
>> is the latest version of the config file line (made with mdadm --examine
>> --scan):
>
> Jeff,
>
>   You might need to update the raid superblocks during the manual 
> assemble.
>
>   mdadm --assemble --update=summaries /dev/md3 /dev/sd[c-v]1
>
>   Also, you can simplify the below a bit to the following:
>
>>
>> ARRAY /dev/md3 level=raid10 num-devices=20 metadata=0.90 spares=4
>> UUID=e17a29e8:ec6bce5c:f13d343c:cfba4dc4
>
> ARRAY /dev/md3 UUID=e17a29e8:ec6bce5c:f13d343c:cfba4dc4
>

-- 
------------------------------
Jeff Johnson
Manager
Aeon Computing

jeff.johnson "at" aeoncomputing.com
www.aeoncomputing.com
t: 858-412-3810 x101   f: 858-412-3845


4905 Morena Boulevard, Suite 1313 - San Diego, CA 92117

