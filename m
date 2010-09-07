From: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Subject: =?iso-8859-1?B?cmVidWlsZGluZyBhIFJBSUQ2IGFycmF5LCBhbmQgaWdub3JpbmcgYmFkIHNlY3RvcnM/?=
Date: Tue, 07 Sep 2010 05:18:22 +0000
Message-ID: <20100907051822.9554.qmail@s217.sureserver.com>
Reply-To: "=?iso-8859-1?Q?Michael=20Sallaway?=" <michael@sallaway.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a 12-device RAID-6 array, that appears to have 3 drives that are going bad -- occasionally throwing bad sectors, etc. So I've got replacement drives, and figured I would swap them out one at a time -- swap out the first bad drive, rebuild to it from the rest of the array, the repeat the procedure for the other 2 drives.

However, during the rebuild process, the other 2 drives that have a few bad sectors end up dropping out of the array (as shown below, extracted from logs). Even though the bad sectors are at entirely different locations, it first drops one drive (leaving me with no redundancy, but still continuing the rebuild), then later on dropping the 2nd drive, leaving me with 9/12 working drives, so stops the rebuild and abadons all hope. (fortunately, I was careful to make sure the array isn't used at all during the process, so can forcibly create it again with all the devices, and assume it to be clean to get it working again.)

However, I figured there must be some way for the md driver to recover from the read error, and recover the data from parity for that particular section? Then, later on (for the 2nd drive that has a few bad sectors), do the same thing, but use the parity on the first bad drive (which is perfectly fine at that location). Is there any way to do something like that, or tell mdadm (or the md device) to keep going, and use parity to correct those errors at that location instead of dropping the drive from the array?

One solution I considered was just to take the faulty drives out, and dd them individually directly to a fresh drive, skipping over the few bad sectors. However, I thought this would not work as intended either -- the small amount of data that couldn't be read at that location would be incorrect, and the md device wouldn't automatically correct it when reading it later on, would it? (from what I can tell, it would just flag that there was a parity mismatch, but still use the incorrect data from the new drive).

Alternatively, is there any way to restart a recovery/resync from a specified location? ie. if I noticed in the logs that when the first drive dropped out (bringing it down to 10 working devices, rebuilding to 1 spare) it actually stopped and restarted recovery:

Sep  7 09:31:40 lechuck kernel: [51927.142926] md: md10: recovery done.
<snip>
Sep  7 09:31:40 lechuck kernel: [51927.400138] md: recovery of RAID array md10
Sep  7 09:31:40 lechuck kernel: [51927.400159] md: resuming recovery of md10 from checkpoint.
Sep  7 09:31:40 lechuck mdadm[3840]: RebuildFinished event detected on md device /dev/md10
Sep  7 09:31:40 lechuck mdadm[3840]: RebuildStarted event detected on md device /dev/md10

Is there any way to forcibly tell it to restart recovery from a certain location when I hot-add a drive to an array? (the idea is something like an assume-semi-clean -- I can tell it that the first 60% of the drive has been recovered and resynced, so only do recovery from there.)

Thanks in advance for any help or info anyone can give!

Cheers,
Michael



Sep  7 09:31:40 lechuck kernel: [51927.096442] end_request: I/O error, dev sdm, sector 1574510755
Sep  7 09:31:40 lechuck kernel: [51927.104975] raid5:md10: read error not correctable (sector 1574510752 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.104985] raid5: Disk failure on sdm, disabling device.
Sep  7 09:31:40 lechuck kernel: [51927.104989] raid5: Operation continuing on 10 devices.
Sep  7 09:31:40 lechuck kernel: [51927.122210] raid5:md10: read error not correctable (sector 1574510760 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122214] raid5:md10: read error not correctable (sector 1574510768 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122218] raid5:md10: read error not correctable (sector 1574510776 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122222] raid5:md10: read error not correctable (sector 1574510784 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122225] raid5:md10: read error not correctable (sector 1574510792 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122229] raid5:md10: read error not correctable (sector 1574510800 on sdm).
Sep  7 09:31:40 lechuck kernel: [51927.122242] ata13: EH complete
Sep  7 09:31:40 lechuck kernel: [51927.142926] md: md10: recovery done.
Sep  7 09:31:40 lechuck mdadm[3840]: Fail event detected on md device /dev/md10, component device /dev/sdm
Sep  7 09:31:40 lechuck kernel: [51927.344026] RAID5 conf printout:
Sep  7 09:31:40 lechuck kernel: [51927.344031]  --- rd:12 wd:10
Sep  7 09:31:40 lechuck kernel: [51927.344034]  disk 0, o:1, dev:sdf
Sep  7 09:31:40 lechuck kernel: [51927.344037]  disk 1, o:1, dev:sdb
Sep  7 09:31:40 lechuck kernel: [51927.344039]  disk 2, o:1, dev:sda
Sep  7 09:31:40 lechuck kernel: [51927.344042]  disk 3, o:1, dev:sdc
Sep  7 09:31:40 lechuck kernel: [51927.344044]  disk 4, o:1, dev:sdj
Sep  7 09:31:40 lechuck kernel: [51927.344047]  disk 5, o:1, dev:sdi
Sep  7 09:31:40 lechuck kernel: [51927.344049]  disk 6, o:1, dev:sdp
Sep  7 09:31:40 lechuck kernel: [51927.344052]  disk 7, o:1, dev:sdn
Sep  7 09:31:40 lechuck kernel: [51927.344054]  disk 8, o:1, dev:sdo
Sep  7 09:31:40 lechuck kernel: [51927.344057]  disk 9, o:0, dev:sdm
Sep  7 09:31:40 lechuck kernel: [51927.344059]  disk 10, o:1, dev:sdk
Sep  7 09:31:40 lechuck kernel: [51927.344062]  disk 11, o:1, dev:sdl




Sep  7 10:52:15 lechuck kernel: [56762.966469] end_request: I/O error, dev sdf, sector 1673429073
Sep  7 10:52:15 lechuck kernel: [56762.974937] raid5:md10: read error not correctable (sector 1673429072 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.974943] raid5: Disk failure on sdf, disabling device.
Sep  7 10:52:15 lechuck kernel: [56762.974944] raid5: Operation continuing on 9 devices.
Sep  7 10:52:15 lechuck kernel: [56762.991856] raid5:md10: read error not correctable (sector 1673429080 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991860] raid5:md10: read error not correctable (sector 1673429088 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991864] raid5:md10: read error not correctable (sector 1673429096 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991867] raid5:md10: read error not correctable (sector 1673429104 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991871] raid5:md10: read error not correctable (sector 1673429112 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991875] raid5:md10: read error not correctable (sector 1673429120 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991878] raid5:md10: read error not correctable (sector 1673429128 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991882] raid5:md10: read error not correctable (sector 1673429136 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991885] raid5:md10: read error not correctable (sector 1673429144 on sdf).
Sep  7 10:52:15 lechuck kernel: [56762.991903] ata4: EH complete
Sep  7 10:52:15 lechuck mdadm[3840]: Fail event detected on md device /dev/md10, component device /dev/sdf
Sep  7 10:52:16 lechuck kernel: [56763.120170] md: md10: recovery done.
Sep  7 10:52:16 lechuck kernel: [56763.146105] RAID5 conf printout:
Sep  7 10:52:16 lechuck kernel: [56763.146110]  --- rd:12 wd:9
Sep  7 10:52:16 lechuck kernel: [56763.146113]  disk 0, o:0, dev:sdf
Sep  7 10:52:16 lechuck kernel: [56763.146116]  disk 1, o:1, dev:sdb
Sep  7 10:52:16 lechuck kernel: [56763.146118]  disk 2, o:1, dev:sda
Sep  7 10:52:16 lechuck kernel: [56763.146121]  disk 3, o:1, dev:sdc
Sep  7 10:52:16 lechuck kernel: [56763.146123]  disk 4, o:1, dev:sdj
Sep  7 10:52:16 lechuck kernel: [56763.146125]  disk 5, o:1, dev:sdi
Sep  7 10:52:16 lechuck kernel: [56763.146127]  disk 6, o:1, dev:sdp
Sep  7 10:52:16 lechuck kernel: [56763.146130]  disk 7, o:1, dev:sdn
Sep  7 10:52:16 lechuck kernel: [56763.146132]  disk 8, o:1, dev:sdo
Sep  7 10:52:16 lechuck kernel: [56763.146134]  disk 10, o:1, dev:sdk
Sep  7 10:52:16 lechuck kernel: [56763.146137]  disk 11, o:1, dev:sdl

