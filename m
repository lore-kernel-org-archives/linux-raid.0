From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: raid/device failure
Date: Sun, 10 Feb 2013 18:27:35 -0700
Message-ID: <201302101827.36116.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've re-configured my NAS box (still haven't put it into "production") to be a 
raid5 over 7 2TB consumer seagate barracuda drives, and with some tweaking, 
performance was looking stellar.

Unfortunately I started seeing some messages in dmesg that worried me:

mpt2sas0: log_info(0x31110d01): originator(PL), code(0x11), sub_code(0x0d01)

Now, nothing actually seemed amis other than those messages at that point. But 
much later down the line I got the following: http://pastebin.com/a5uTs5fT

sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 3a 3e 30 08 00 02 98 00
end_request: I/O error, dev sdh, sector 977154056
md/raid:md0: read error corrected (8 sectors at 977154056 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154064 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154072 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154080 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154088 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154096 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154104 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154112 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154120 on sdh)
md/raid:md0: read error corrected (8 sectors at 977154128 on sdh)
mpt2sas0: log_info(0x31110d01): originator(PL), code(0x11), sub_code(0x0d01)
mpt2sas0: log_info(0x31110d01): originator(PL), code(0x11), sub_code(0x0d01)
mpt2sas0: log_info(0x31110d01): originator(PL), code(0x11), sub_code(0x0d01)
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 c4 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587659776
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 d4 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587663872
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 e0 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587666944
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 e4 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587667968
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 ec 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587670016
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 f0 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587671040
raid5_end_read_request: 73 callbacks suppressed
md/raid:md0: read error corrected (8 sectors at 1587660768 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587660776 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587660784 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587660792 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587663872 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587663880 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587663888 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587663896 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587663904 on sdh)
md/raid:md0: read error corrected (8 sectors at 1587663912 on sdh)
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a1 e4 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587667968
md/raid:md0: read error NOT corrected!! (sector 1587667968 on sdh).
md/raid:md0: Disk failure on sdh, disabling device.
md/raid:md0: Operation continuing on 6 devices.
md/raid:md0: read error not correctable (sector 1587667976 on sdh).
md/raid:md0: read error not correctable (sector 1587667984 on sdh).
md/raid:md0: read error not correctable (sector 1587667992 on sdh).
md/raid:md0: read error not correctable (sector 1587668000 on sdh).
md/raid:md0: read error not correctable (sector 1587668008 on sdh).
md/raid:md0: read error not correctable (sector 1587668016 on sdh).
md/raid:md0: read error not correctable (sector 1587668024 on sdh).
md/raid:md0: read error not correctable (sector 1587668032 on sdh).
md/raid:md0: read error not correctable (sector 1587668040 on sdh).
md/raid:md0: read error not correctable (sector 1587668048 on sdh).
sd 0:0:7:0: [sdh]  Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
sd 0:0:7:0: [sdh]  Sense Key : Aborted Command [current] 
sd 0:0:7:0: [sdh]  Add. Sense: Information unit iuCRC error detected
sd 0:0:7:0: [sdh] CDB: Read(10): 28 00 5e a2 08 00 00 04 00 00
end_request: I/O error, dev sdh, sector 1587677184
RAID conf printout:
 --- level:5 rd:7 wd:6
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
 disk 3, o:1, dev:sde
 disk 4, o:1, dev:sdf
 disk 5, o:1, dev:sdg
 disk 6, o:0, dev:sdh
RAID conf printout:
 --- level:5 rd:7 wd:6
 disk 0, o:1, dev:sda
 disk 1, o:1, dev:sdb
 disk 2, o:1, dev:sdc
 disk 3, o:1, dev:sde
 disk 4, o:1, dev:sdf
 disk 5, o:1, dev:sdg

I've run full S.M.A.R.T. tests (except the conveyance test, probably run that 
tonight and see what happens) on all drives in the array, and there are no 
obvious warnings or errors in the S.M.A.R.T. restults at all. Including 
reallocated (pending or not) sectors.

I've seen references while searching for possible causes, where people had 
this error occur with faulty cables, or SAS backplanes. Is this a likely 
senario? The cables are brand new, but anything is possible.

The card is a IBM M1015 8 port HBA flashed with the LSI 9211-8i IT firmware, 
and no BIOS.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
