From: Drew Reusser <dreusser@gmail.com>
Subject: Re: Issue with Raid 10 super block failing
Date: Sun, 18 Nov 2012 19:10:00 +0000
Message-ID: <CAPAnFc_siNMWcYtYf56dYO1LgkCKPxMDhC-PuMD-18D4jNJcqw@mail.gmail.com>
References: <CAPAnFc_USC=a8S_0wcsK36Sx=HXgfVTQ4LPC=m9Y9mDFrYrepg@mail.gmail.com>
	<50A82267.9030802@turmel.org>
	<CAPAnFc_ZtiE_-6usMHZA56Vx9JOw=gT3O3ABdpb2kcqLV6hcBw@mail.gmail.com>
	<50A8F247.8060002@turmel.org>
	<CAPAnFc9_AqQCHnzpNukVJNuaAZ0k9+i0wEZn6SAX=ucF_X_k2g@mail.gmail.com>
	<50A91487.70806@turmel.org>
	<CAPAnFc9KLBDhCDt1WYiOye5wvRv=zvBDfL1=8OEYg04VBCLHBQ@mail.gmail.com>
	<50A92F53.5080100@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50A92F53.5080100@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Nov 18, 2012 at 6:56 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Drew,
>
> Please don't top-post.  Repaired again.
>
> On 11/18/2012 12:39 PM, Drew Reusser wrote:
>> On Sun, Nov 18, 2012 at 5:01 PM, Phil Turmel <philip@turmel.org> wrote:
>
> [trim /]
>
>>> This all looks like it should work.
>>>
>>> Please try "mdadm -v --assemble /dev/md0 /dev/sd[abde]1" and show the
>>> output.  If it doesn't work, also show "cat /proc/mdstat" and "dmesg".
>
>> The issue is not that I cannot get the raid to create, it is that I
>> cannot access any of the files on the system when I mount it.  It was
>> setup as an ext4 filesystem and it all was working and I rebooted and
>> it was not after that point.
>>
>>
>> mint mnt # mount -t ext4 /dev/md0 /mnt/raid
>> mount: wrong fs type, bad option, bad superblock on /dev/md0,
>>        missing codepage or helper program, or other error
>>        In some cases useful info is found in syslog - try
>>        dmesg | tail  or so
>>
>> mint dev # mdadm -v --assemble /dev/md0 /dev/sd[abde]1
>> mdadm: looking for devices for /dev/md0
>> mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 0.
>> mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
>> mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 2.
>> mdadm: /dev/sde1 is identified as a member of /dev/md0, slot 3.
>> mdadm: added /dev/sdb1 to /dev/md0 as 1
>> mdadm: added /dev/sdd1 to /dev/md0 as 2
>> mdadm: added /dev/sde1 to /dev/md0 as 3
>> mdadm: added /dev/sda1 to /dev/md0 as 0
>> mdadm: /dev/md0 has been started with 4 drives.
>> mint dev # cat /proc/mdstat
>> Personalities : [raid10]
>> md0 : active raid10 sda1[0] sde1[3] sdd1[2] sdb1[1]
>>       1952211968 blocks super 1.2 512K chunks 2 near-copies [4/4] [UUUU]
>>
>> unused devices: <none>
>
> Ok.  So it's not a raid problem.  You didn't show your dmesg.
>
> Phil

Sorry - did not know the rules about top posting.  Is there something
specific in the dmesg you are looking for?  I tried to mount it again
and copied everything in the buffer.

[140792.819843]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.819845]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.819847]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.819849]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.819850]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.819852]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.819854]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853846] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[140792.853851] Raw EDID:
[140792.853854]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[140792.853856]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853858]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853860]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853862]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853864]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853866]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.853868]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.854743] i2c i2c-0: >sendbytes: NAK bailout.
[140792.855321] i2c i2c-0: >sendbytes: NAK bailout.
[140792.889289] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[140792.889292] Raw EDID:
[140792.889294]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[140792.889296]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.889298]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.889300]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.889302]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.889304]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.889306]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.889308]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[140792.890180] i2c i2c-0: >sendbytes: NAK bailout.
[140792.890759] i2c i2c-0: >sendbytes: NAK bailout.
[140792.891336] i2c i2c-0: >sendbytes: NAK bailout.
[140792.891913] i2c i2c-0: >sendbytes: NAK bailout.
[140792.892504] i2c i2c-0: >sendbytes: NAK bailout.
[179179.297240] sd 6:0:0:0: >[sdc] Device not ready
[179179.297246] sd 6:0:0:0: >[sdc]
[179179.297249] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[179179.297252] sd 6:0:0:0: >[sdc]
[179179.297254] Sense Key : Not Ready [current]
[179179.297259] Info fld=0x0
[179179.297262] sd 6:0:0:0: >[sdc]
[179179.297266] <<vendor>> ASC=0xff ASCQ=0xffASC=0xff <<vendor>> ASCQ=0xff
[179179.297271] sd 6:0:0:0: >[sdc] CDB:
[179179.297273] Read(10): 28 00 00 33 a3 08 00 00 f0 00
[179179.297284] end_request: I/O error, dev sdc, sector 3384072
[179179.434863] sd 6:0:0:0: >[sdc] Media Changed
[179179.434867] sd 6:0:0:0: >[sdc]
[179179.434869] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[179179.434872] sd 6:0:0:0: >[sdc]
[179179.434874] Sense Key : Unit Attention [current]
[179179.434878] Info fld=0x0
[179179.434881] sd 6:0:0:0: >[sdc]
[179179.434884] Add. Sense: Not ready to ready change, medium may have changed
[179179.434888] sd 6:0:0:0: >[sdc] CDB:
[179179.434889] Read(10): 28 00 00 33 a3 f8 00 00 10 00
[179179.434900] end_request: I/O error, dev sdc, sector 3384312
[179179.438065] SQUASHFS error: squashfs_read_data failed to read
block 0x24ef05f1
[179179.438071] SQUASHFS error: Unable to read data cache entry [24ef05f1]
[179179.438073] SQUASHFS error: Unable to read page, block 24ef05f1, size 3144
[179179.438079] SQUASHFS error: Unable to read data cache entry [24ef05f1]
[179179.438081] SQUASHFS error: Unable to read page, block 24ef05f1, size 3144
[179179.438084] SQUASHFS error: Unable to read data cache entry [24ef05f1]
[179179.438085] SQUASHFS error: Unable to read page, block 24ef05f1, size 3144
[179179.438088] SQUASHFS error: Unable to read data cache entry [24ef05f1]
[179179.438089] SQUASHFS error: Unable to read page, block 24ef05f1, size 3144
[179179.438092] SQUASHFS error: Unable to read data cache entry [24ef05f1]
[179179.438094] SQUASHFS error: Unable to read page, block 24ef05f1, size 3144
[179179.438149] SQUASHFS error: squashfs_read_data failed to read
block 0x24ef3735
[179179.438151] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438152] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438156] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438157] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438160] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438162] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438165] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438166] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438169] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438170] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438173] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438175] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438180] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438181] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438185] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438186] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438189] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438191] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438194] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438195] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438199] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438200] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438203] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438204] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438207] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438209] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438212] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438213] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438216] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438218] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438221] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438222] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438225] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438226] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438229] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438231] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438234] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438235] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438238] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438239] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438244] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438245] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438248] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438250] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438253] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438254] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438257] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438258] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438261] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438263] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438266] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438267] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438270] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438271] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.438275] SQUASHFS error: Unable to read data cache entry [24ef3735]
[179179.438276] SQUASHFS error: Unable to read page, block 24ef3735, size 866c
[179179.450001] SQUASHFS error: squashfs_read_data failed to read
block 0xa891c85
[179179.450005] SQUASHFS error: Unable to read data cache entry [a891c85]
[179179.450007] SQUASHFS error: Unable to read page, block a891c85, size ef60
[179180.524251] sd 6:0:0:0: >[sdc] No Caching mode page present
[179180.524257] sd 6:0:0:0: >[sdc] Assuming drive cache: write through
[180820.792916] i2c i2c-0: >sendbytes: NAK bailout.
[181674.692186] i2c i2c-0: >sendbytes: NAK bailout.
[181674.692774] i2c i2c-0: >sendbytes: NAK bailout.
[181674.693347] i2c i2c-0: >sendbytes: NAK bailout.
[181674.694236] i2c i2c-0: >sendbytes: NAK bailout.
[181674.695125] i2c i2c-0: >sendbytes: NAK bailout.
[181674.695163] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[181674.695702] i2c i2c-0: >sendbytes: NAK bailout.
[181675.052592] i2c i2c-0: >sendbytes: NAK bailout.
[181675.065502] i2c i2c-0: >sendbytes: NAK bailout.
[181675.066081] i2c i2c-0: >sendbytes: NAK bailout.
[181675.068120] i2c i2c-0: >sendbytes: NAK bailout.
[181675.069016] i2c i2c-0: >sendbytes: NAK bailout.
[181675.069592] i2c i2c-0: >sendbytes: NAK bailout.
[181675.070168] i2c i2c-0: >sendbytes: NAK bailout.
[181675.070746] i2c i2c-0: >sendbytes: NAK bailout.
[212440.583072] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.583077] Raw EDID:
[212440.583079]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.583081]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.583082]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.583083]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.583084]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.583086]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.583087]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.583088]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.584381] i2c i2c-0: >sendbytes: NAK bailout.
[212440.584959] i2c i2c-0: >sendbytes: NAK bailout.
[212440.619195] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.619197] Raw EDID:
[212440.619199]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.619201]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.619203]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.619205]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.619207]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.619209]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.619211]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.619212]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653501] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.653503] Raw EDID:
[212440.653505]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.653507]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653509]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653511]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653513]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653514]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653516]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.653518]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688377] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.688380] Raw EDID:
[212440.688382]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.688384]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688385]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688387]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688389]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688391]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688393]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688394]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.688400] radeon 0000:01:00.0: >VGA-1: EDID block 0 invalid.
[212440.688403] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[212440.887526] i2c i2c-0: >sendbytes: NAK bailout.
[212440.890532] i2c i2c-0: >sendbytes: NAK bailout.
[212440.891109] i2c i2c-0: >sendbytes: NAK bailout.
[212440.891688] i2c i2c-0: >sendbytes: NAK bailout.
[212440.925590] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.925592] Raw EDID:
[212440.925594]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.925596]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.925597]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.925598]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.925599]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.925601]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.925602]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.925603]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.926475] i2c i2c-0: >sendbytes: NAK bailout.
[212440.960341] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.960343] Raw EDID:
[212440.960344]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.960345]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960347]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960348]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960349]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960350]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960352]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960353]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.960904] i2c i2c-0: >sendbytes: NAK bailout.
[212440.961483] i2c i2c-0: >sendbytes: NAK bailout.
[212440.995346] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212440.995348] Raw EDID:
[212440.995350]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212440.995351]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.995352]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.995354]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.995355]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.995356]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.995357]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212440.995359]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029325] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[212441.029330] Raw EDID:
[212441.029333]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[212441.029335]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029338]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029339]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029341]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029343]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029345]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029347]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[212441.029352] radeon 0000:01:00.0: >VGA-1: EDID block 0 invalid.
[212441.029356] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[212441.030236] i2c i2c-0: >sendbytes: NAK bailout.
[212441.030813] i2c i2c-0: >sendbytes: NAK bailout.
[212441.031390] i2c i2c-0: >sendbytes: NAK bailout.
[212441.033756] i2c i2c-0: >sendbytes: NAK bailout.
[212441.034336] i2c i2c-0: >sendbytes: NAK bailout.
[212441.034913] i2c i2c-0: >sendbytes: NAK bailout.
[212441.035490] i2c i2c-0: >sendbytes: NAK bailout.
[212441.036074] i2c i2c-0: >sendbytes: NAK bailout.
[212441.038086] i2c i2c-0: >sendbytes: NAK bailout.
[212441.180577] i2c i2c-0: >sendbytes: NAK bailout.
[212441.193195] i2c i2c-0: >sendbytes: NAK bailout.
[212441.193773] i2c i2c-0: >sendbytes: NAK bailout.
[212441.194669] i2c i2c-0: >sendbytes: NAK bailout.
[212441.195246] i2c i2c-0: >sendbytes: NAK bailout.
[212441.195823] i2c i2c-0: >sendbytes: NAK bailout.
[221931.264569] i2c i2c-0: >sendbytes: NAK bailout.
[221941.280572] i2c i2c-0: >sendbytes: NAK bailout.
[221951.297203] i2c i2c-0: >sendbytes: NAK bailout.
[221961.312571] i2c i2c-0: >sendbytes: NAK bailout.
[240720.501705] sd 6:0:0:0: >[sdc] No Caching mode page present
[240720.501711] sd 6:0:0:0: >[sdc] Assuming drive cache: write through
[261706.688568] i2c i2c-0: >sendbytes: NAK bailout.
[261716.708153] i2c i2c-0: >sendbytes: NAK bailout.
[261716.709052] i2c i2c-0: >sendbytes: NAK bailout.
[261716.709628] i2c i2c-0: >sendbytes: NAK bailout.
[261716.710205] i2c i2c-0: >sendbytes: NAK bailout.
[261716.710782] i2c i2c-0: >sendbytes: NAK bailout.
[261716.710821] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[261716.843829] i2c i2c-0: >sendbytes: NAK bailout.
[261716.845552] i2c i2c-0: >sendbytes: NAK bailout.
[261716.846129] i2c i2c-0: >sendbytes: NAK bailout.
[261716.847342] i2c i2c-0: >sendbytes: NAK bailout.
[261716.847919] i2c i2c-0: >sendbytes: NAK bailout.
[261716.848504] i2c i2c-0: >sendbytes: NAK bailout.
[261716.848541] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[261716.912904] i2c i2c-0: >sendbytes: NAK bailout.
[261716.924873] i2c i2c-0: >sendbytes: NAK bailout.
[261716.926893] i2c i2c-0: >sendbytes: NAK bailout.
[261716.961179] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[261716.961182] Raw EDID:
[261716.961184]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[261716.961187]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.961188]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.961190]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.961192]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.961194]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.961196]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.961198]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996245] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[261716.996247] Raw EDID:
[261716.996248]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[261716.996250]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996251]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996252]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996254]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996255]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996256]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.996257]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[261716.997124] i2c i2c-0: >sendbytes: NAK bailout.
[261716.997701] i2c i2c-0: >sendbytes: NAK bailout.
[261716.998275] i2c i2c-0: >sendbytes: NAK bailout.
[261716.998851] i2c i2c-0: >sendbytes: NAK bailout.
[261716.999428] i2c i2c-0: >sendbytes: NAK bailout.
[261717.132591] i2c i2c-0: >sendbytes: NAK bailout.
[261717.145501] i2c i2c-0: >sendbytes: NAK bailout.
[261717.146079] i2c i2c-0: >sendbytes: NAK bailout.
[261717.146655] i2c i2c-0: >sendbytes: NAK bailout.
[261717.147230] i2c i2c-0: >sendbytes: NAK bailout.
[261717.147808] i2c i2c-0: >sendbytes: NAK bailout.
[264676.128886] i2c i2c-0: >sendbytes: NAK bailout.
[264686.144889] i2c i2c-0: >sendbytes: NAK bailout.
[264696.160889] i2c i2c-0: >sendbytes: NAK bailout.
[264706.176578] i2c i2c-0: >sendbytes: NAK bailout.
[264707.291137] md: md0 stopped.
[264707.295646] md: bind<sdb1>
[264707.297420] md: bind<sdd1>
[264707.297691] md: bind<sde1>
[264707.301861] md: bind<sda1>
[264707.357646] bio: create slab <bio-1> at 1
[264707.357731] md/raid10:md0: active with 4 out of 4 devices
[264707.357760] md0: detected capacity change from 0 to 1999065055232
[264707.366388]  md0: unknown partition table
[264716.192566] i2c i2c-0: >sendbytes: NAK bailout.
[264726.211504] i2c i2c-0: >sendbytes: NAK bailout.
[264726.214184] i2c i2c-0: >sendbytes: NAK bailout.
[264726.214763] i2c i2c-0: >sendbytes: NAK bailout.
[264726.215339] i2c i2c-0: >sendbytes: NAK bailout.
[264726.215916] i2c i2c-0: >sendbytes: NAK bailout.
[264726.216502] i2c i2c-0: >sendbytes: NAK bailout.
[264726.216542] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[264726.344571] i2c i2c-0: >sendbytes: NAK bailout.
[264726.420906] i2c i2c-0: >sendbytes: NAK bailout.
[264726.433191] i2c i2c-0: >sendbytes: NAK bailout.
[264726.433767] i2c i2c-0: >sendbytes: NAK bailout.
[264726.435793] i2c i2c-0: >sendbytes: NAK bailout.
[264726.469742] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[264726.469744] Raw EDID:
[264726.469748]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[264726.469750]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.469752]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.469754]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.469755]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.469757]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.469759]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.469761]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504018] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[264726.504021] Raw EDID:
[264726.504023]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[264726.504026]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504028]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504030]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504031]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504033]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504035]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504037]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.504911] i2c i2c-0: >sendbytes: NAK bailout.
[264726.505813] i2c i2c-0: >sendbytes: NAK bailout.
[264726.506709] i2c i2c-0: >sendbytes: NAK bailout.
[264726.507285] i2c i2c-0: >sendbytes: NAK bailout.
[264726.541571] [drm:drm_edid_block_valid] *ERROR* EDID checksum is
invalid, remainder is 130
[264726.541574] Raw EDID:
[264726.541577]  	00 ff ff ff ff ff ff 00 ff ff ff ff ff ff ff ff
[264726.541579]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.541581]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.541583]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.541585]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.541586]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.541588]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.541590]  	ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
[264726.542153] i2c i2c-0: >sendbytes: NAK bailout.
[264726.542729] i2c i2c-0: >sendbytes: NAK bailout.
[264726.543305] i2c i2c-0: >sendbytes: NAK bailout.
[264726.543881] i2c i2c-0: >sendbytes: NAK bailout.
[264726.544481] i2c i2c-0: >sendbytes: NAK bailout.
[264726.680578] i2c i2c-0: >sendbytes: NAK bailout.
[264726.692875] i2c i2c-0: >sendbytes: NAK bailout.
[264726.693451] i2c i2c-0: >sendbytes: NAK bailout.
[264726.694027] i2c i2c-0: >sendbytes: NAK bailout.
[264726.694603] i2c i2c-0: >sendbytes: NAK bailout.
[264726.695178] i2c i2c-0: >sendbytes: NAK bailout.
[264788.678322] md0: detected capacity change from 1999065055232 to 0
[264788.678330] md: md0 stopped.
[264788.678339] md: unbind<sda1>
[264788.680063] md: export_rdev(sda1)
[264788.680108] md: unbind<sde1>
[264788.684033] md: export_rdev(sde1)
[264788.684055] md: unbind<sdd1>
[264788.688534] md: export_rdev(sdd1)
[264788.688556] md: unbind<sdb1>
[264788.696025] md: export_rdev(sdb1)
[264800.331630] md: md0 stopped.
[264800.333015] md: bind<sdb1>
[264800.334507] md: bind<sdd1>
[264800.334790] md: bind<sde1>
[264800.334977] md: bind<sda1>
[264800.338578] bio: create slab <bio-1> at 1
[264800.341261] md/raid10:md0: active with 4 out of 4 devices
[264800.341293] md0: detected capacity change from 0 to 1999065055232
[264800.343496]  md0: unknown partition table
[264906.870361] EXT4-fs (md0): VFS: Can't find ext4 filesystem
[270145.600580] i2c i2c-0: >sendbytes: NAK bailout.
[270155.620473] i2c i2c-0: >sendbytes: NAK bailout.
[270155.621372] i2c i2c-0: >sendbytes: NAK bailout.
[270155.621948] i2c i2c-0: >sendbytes: NAK bailout.
[270155.622523] i2c i2c-0: >sendbytes: NAK bailout.
[270155.623099] i2c i2c-0: >sendbytes: NAK bailout.
[270155.623138] [drm:radeon_vga_detect] *ERROR* VGA-1: probed a
monitor but no|invalid EDID
[270155.817233] i2c i2c-0: >sendbytes: NAK bailout.
[270155.829516] i2c i2c-0: >sendbytes: NAK bailout.
[270155.841186] i2c i2c-0: >sendbytes: NAK bailout.
[270155.841766] i2c i2c-0: >sendbytes: NAK bailout.
[270155.842342] i2c i2c-0: >sendbytes: NAK bailout.
[270155.842918] i2c i2c-0: >sendbytes: NAK bailout.
[270155.843493] i2c i2c-0: >sendbytes: NAK bailout.
[270155.977230] i2c i2c-0: >sendbytes: NAK bailout.
[270155.989185] i2c i2c-0: >sendbytes: NAK bailout.
[270155.989762] i2c i2c-0: >sendbytes: NAK bailout.
[270155.991786] i2c i2c-0: >sendbytes: NAK bailout.
[270155.992386] i2c i2c-0: >sendbytes: NAK bailout.
[270155.993288] i2c i2c-0: >sendbytes: NAK bailout.
[270155.993864] i2c i2c-0: >sendbytes: NAK bailout.
[270155.994440] i2c i2c-0: >sendbytes: NAK bailout.
[270303.640240] EXT4-fs (md0): VFS: Can't find ext4 filesystem
