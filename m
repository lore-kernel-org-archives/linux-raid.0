From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: lots of "md: export_rdev(sde)" printed after create IMSM RAID10
 with missing
Date: Fri, 9 Sep 2016 14:56:12 +0200
Message-ID: <7910bc85-f9c4-1ea3-76a6-40b819738537@intel.com>
References: <338941973.7699634.1473230038475.JavaMail.zimbra@redhat.com>
 <1648084319.7702644.1473230621059.JavaMail.zimbra@redhat.com>
 <20160908225607.GA66921@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160908225607.GA66921@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Yi Zhang <yizhan@redhat.com>
Cc: linux-raid@vger.kernel.org, Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

On 09/09/2016 12:56 AM, Shaohua Li wrote:
> On Wed, Sep 07, 2016 at 02:43:41AM -0400, Yi Zhang wrote:
>> Hello
>>
>> I tried create one IMSM RAID10 with missing, found lots of "md: export_rdev(sde)" printed, anyone could help check it?
>>
>> Steps I used:
>> mdadm -CR /dev/md0 /dev/sd[b-f] -n5 -e imsm
>> mdadm -CR /dev/md/Volume0 -l10 -n4 /dev/sd[b-d] missing
>>
>> Version:
>> 4.8.0-rc5
>> mdadm - v3.4-84-gbd1fd72 - 25th August 2016
> 
> can't reproduce with old mdadm but can with upstream mdadm. Looks mdadm is
> keeping write the new_dev sysfs entry.
> 
> Jes, any idea?
> 
> Thanks,
> Shaohua 
>> Log: 
>> http://pastebin.com/FJJwvgg6
>>
>> <6>[  301.102007] md: bind<sdb>
>> <6>[  301.102095] md: bind<sdc>
>> <6>[  301.102159] md: bind<sdd>
>> <6>[  301.102215] md: bind<sde>
>> <6>[  301.102291] md: bind<sdf>
>> <6>[  301.103010] ata3.00: Enabling discard_zeroes_data
>> <6>[  311.714344] ata3.00: Enabling discard_zeroes_data
>> <6>[  311.721866] md: bind<sdb>
>> <6>[  311.721965] md: bind<sdc>
>> <6>[  311.722029] md: bind<sdd>
>> <5>[  311.733165] md/raid10:md127: not clean -- starting background reconstruction
>> <6>[  311.733167] md/raid10:md127: active with 3 out of 4 devices
>> <6>[  311.733186] md127: detected capacity change from 0 to 240060989440
>> <6>[  311.774027] md: bind<sde>
>> <6>[  311.810664] md: md127 switched to read-write mode.
>> <6>[  311.819885] md: resync of RAID array md127
>> <6>[  311.819886] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> <6>[  311.819887] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for resync.
>> <6>[  311.819891] md: using 128k window, over a total of 234435328k.
>> <6>[  316.606073] ata3.00: Enabling discard_zeroes_data
>> <6>[  343.949845] capability: warning: `turbostat' uses 32-bit capabilities (legacy support in use)
>> <6>[ 1482.314944] md: md127: resync done.
>> <7>[ 1482.315086] RAID10 conf printout:
>> <7>[ 1482.315087]  --- wd:3 rd:4
>> <7>[ 1482.315089]  disk 0, wo:0, o:1, dev:sdb
>> <7>[ 1482.315089]  disk 1, wo:0, o:1, dev:sdc
>> <7>[ 1482.315090]  disk 2, wo:0, o:1, dev:sdd
>> <7>[ 1482.315099] RAID10 conf printout:
>> <7>[ 1482.315099]  --- wd:3 rd:4
>> <7>[ 1482.315100]  disk 0, wo:0, o:1, dev:sdb
>> <7>[ 1482.315100]  disk 1, wo:0, o:1, dev:sdc
>> <7>[ 1482.315101]  disk 2, wo:0, o:1, dev:sdd
>> <7>[ 1482.315101]  disk 3, wo:1, o:1, dev:sde
>> <6>[ 1482.315220] md: recovery of RAID array md127
>> <6>[ 1482.315221] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
>> <6>[ 1482.315222] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
>> <6>[ 1482.315227] md: using 128k window, over a total of 117217664k.
>> <6>[ 2697.184217] md: md127: recovery done.
>> <7>[ 2697.524143] RAID10 conf printout:
>> <7>[ 2697.524144]  --- wd:4 rd:4
>> <7>[ 2697.524146]  disk 0, wo:0, o:1, dev:sdb
>> <7>[ 2697.524146]  disk 1, wo:0, o:1, dev:sdc
>> <7>[ 2697.524147]  disk 2, wo:0, o:1, dev:sdd
>> <7>[ 2697.524148]  disk 3, wo:0, o:1, dev:sde
>> <6>[ 2697.524632] md: export_rdev(sde)
>> <6>[ 2697.549452] md: export_rdev(sde)
>> <6>[ 2697.568763] md: export_rdev(sde)
>> <6>[ 2697.587938] md: export_rdev(sde)
>> <6>[ 2697.607271] md: export_rdev(sde)
>> <6>[ 2697.626321] md: export_rdev(sde)
>> <6>[ 2697.645676] md: export_rdev(sde)
>> <6>[ 2697.663211] md: export_rdev(sde)
>> <6>[ 2697.681603] md: export_rdev(sde)
>> <6>[ 2697.699117] md: export_rdev(sde)
>> <6>[ 2697.716510] md: export_rdev(sde)
>>
>> Best Regards,
>>   Yi Zhang

Can you check if this fix works for you? If it does I'll send a proper
patch for this.

Thanks,
Artur

diff --git a/super-intel.c b/super-intel.c
index 92817e9..ffa71f6 100644
--- a/super-intel.c
+++ b/super-intel.c
@@ -7789,6 +7789,9 @@ static struct mdinfo *imsm_activate_spare(struct active_array *a,
 			IMSM_T_STATE_DEGRADED)
 		return NULL;
 
+	if (get_imsm_map(dev, MAP_0)->map_state == IMSM_T_STATE_UNINITIALIZED)
+		return NULL;
+
 	/*
 	 * If there are any failed disks check state of the other volume.
 	 * Block rebuild if the another one is failed until failed disks
