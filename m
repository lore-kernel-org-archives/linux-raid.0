From: Liwei <xieliwei@gmail.com>
Subject: Re: RAID6: Reducing to Grow
Date: Wed, 18 Oct 2017 13:20:50 +0800
Message-ID: <9ef8359d-7da9-de5a-d939-46a3c51cc68d@gmail.com>
References: <CAPE0SYzB49Vk-QcKWGzVDCqwYjnatGYWrFVeb+jdMF-5wry9Lg@mail.gmail.com>
 <ba94e811-1ae4-a8a3-5907-bde289b44754@turmel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------A69B6D993AB0047EC8A40EAD"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ba94e811-1ae4-a8a3-5907-bde289b44754@turmel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------A69B6D993AB0047EC8A40EAD
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Phil,

On 17/10/2017 10:39 PM, Phil Turmel wrote:
> Hi Liwei,
> 
> On 10/17/2017 01:09 AM, Liwei wrote:
>> Hi list, tldr: Have a mixed-sized (2TB and 6TB) RAID6 array, realised
>> there is now more potential space (using only 6TB drives) than
>> running the array based on the 2TB "smallest-drive" size. Is there a
>> way to convert to using only the 6TB drives, without a rebuild?
> 
> It depends. /-:
> 
> Certainly not in one step.  If you are running LVM on top of your array,
> and have the space split up into various LVs, none extremely large,
> there are some possibilities.
> 
> You might need one more 6TB drive to help with the juggling.
> 
> Please use lsdrv[1] to document your running setup so we can see what
> might be possible.  Past the output into your reply in *text* mode, with
> line wrapping turned off.  (It would help if you composed your mails in
> Thunderbird or some client that handles text mode properly -- TBird
> supports gmail accounts.)
> 
> Phil
> 
> [1] https://github.com/pturmel/lsdrv

Whoops, we do run LVM on top, but currently it is one gigantic LV. (We converted to btrfs and started using subvolumes instead) My guess is you're thinking of creating another array with the unused space, and then migrating LVs over?

The lsdrv output follows, with a lot of irrelevant/empty nodes removed. Also, I realised I misread the storage size of two of the 2TB drives, so we're actually at 9x 2TB and 4x 6TB.

_However_, I do have one 6TB "hot spare" plugged in, and 3 proper 6TB SAS drives arriving next week, so there may still be a way to do this, perhaps?

Output of lsdrv is also attached, in case the formatting still gets truncated because I didn't set things up properly.

PCI [mpt3sas] 02:00.0 Serial Attached SCSI controller: LSI Logic / Symbios Logic SAS3224 PCI-Express Fusion-MPT SAS-3 (rev 01)
├scsi 0:0:0:0 ATA      WDC WD2001FASS-0 {WD-WMAY01416344}
│└sda 1.82t [8:0] Partitioned (gpt)
│ └sda1 1.82t [8:1] MD raid6 (7/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│   │                    PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
│   └VG Carroll 20.01t 0 free {9fcFdE-g501-tLfQ-Lg5k-zCYS-fhw3-vEJI1Y}
│    └dm-12 20.01t [253:12] LV Wonderland btrfs 'Wonderland' {f710ec85-b277-45a4-a526-e970f74e2781}
│     └Mounted as /dev/mapper/Carroll-Wonderland @ /mnt/Wonderland
├scsi 0:0:1:0 ATA      WDC WD20EARS-00J {WD-WCAWZ1869671}
│└sdb 1.82t [8:16] Partitioned (gpt)
│ └sdb1 1.82t [8:17] MD raid6 (2/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:2:0 ATA      WDC WD20EFRX-68E {WD-WCC4M6VTHJRR}
│└sdc 1.82t [8:32] Partitioned (gpt)
│ └sdc1 1.82t [8:33] MD raid6 (5/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:3:0 ATA      HGST HDN726060AL {NCGGBM7S}
│└sdd 5.46t [8:48] Empty/Unknown
├scsi 0:0:4:0 ATA      WDC WD20EFRX-68E {WD-WCC4M6YJN0SD}
│└sde 1.82t [8:64] Partitioned (gpt)
│ └sde1 1.82t [8:65] MD raid6 (0/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:5:0 ATA      WDC WD20EFRX-68E {WD-WCC4M6YJNEP7}
│└sdf 1.82t [8:80] Partitioned (gpt)
│ └sdf1 1.82t [8:81] MD raid6 (3/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:6:0 ATA      WDC WD6002FFWX-6 {K1GLBHMD}
│└sdg 5.46t [8:96] Partitioned (gpt)
│ └sdg1 5.46t [8:97] MD raid6 (12/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:7:0 ATA      WDC WD20EZRX-00D {WD-WMC4N2764539}
│└sdh 1.82t [8:112] Partitioned (gpt)
│ └sdh1 1.82t [8:113] MD raid6 (6/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdi1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:8:0 ATA      WDC WD20EZRX-00D {WD-WCC300583284}
│└sdi 1.82t [8:128] Partitioned (gpt)
│ └sdi1 1.82t [8:129] MD raid6 (8/13) (w/ sdo1,sdm1,sdl1,sdk1,sdj1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:9:0 ATA      WDC WD20EARS-00M {WD-WCAZA5414083}
│└sdj 1.82t [8:144] Partitioned (gpt)
│ └sdj1 1.82t [8:145] MD raid6 (9/13) (w/ sdo1,sdm1,sdl1,sdk1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:10:0 ATA      HGST HDN726060AL {NCGSUEPS}
│└sdk 5.46t [8:160] Partitioned (gpt)
│ └sdk1 5.46t [8:161] MD raid6 (11/13) (w/ sdo1,sdm1,sdl1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:11:0 ATA      WDC WD20EARS-00J {WD-WCAYY0201907}
│└sdl 1.82t [8:176] Partitioned (gpt)
│ └sdl1 1.82t [8:177] MD raid6 (1/13) (w/ sdo1,sdm1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:0:12:0 ATA      HGST HDN726060AL {NCGD6PVS}
│└sdm 5.46t [8:192] Partitioned (gpt)
│ └sdm1 5.46t [8:193] MD raid6 (4/13) (w/ sdo1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
├scsi 0:x:x:x [Empty]
├scsi 0:0:14:0 ATA      HGST HDN726060AL {NAHUM8DY}
│└sdo 5.46t [8:224] Partitioned (gpt)
│ └sdo1 5.46t [8:225] MD raid6 (10/13) (w/ sdm1,sdl1,sdk1,sdj1,sdi1,sdh1,sdg1,sdf1,sde1,sdc1,sdb1,sda1) in_sync 'NLEStore:Alice' {394b9087-268a-a957-f7f1-d4c4ccefb191}
│  └md126 20.01t [9:126] MD v1.2 raid6 (13) clean, 512k Chunk {394b9087:268aa957:f7f1d4c4:ccefb191}
│                        PV LVM2_member 20.01t used, 0 free {8PhZ2b-wiZ1-ok9L-ClLw-OQUy-GrfE-eTo0Hw}
└scsi 0:x:x:x [Empty]


Liwei

(Also, sorry about the html crud in the previous email, turns out my antivirus just gained the ability to inject stuff into emails composed from Gmail within a browser. Very sketchy behaviour.)
(Resend because I did mess up the plain-text setting, sorry that you're receiving this twice!)

--------------A69B6D993AB0047EC8A40EAD
Content-Type: text/plain; charset=UTF-8;
 name="lsdrv.out"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="lsdrv.out"

UENJIFttcHQzc2FzXSAwMjowMC4wIFNlcmlhbCBBdHRhY2hlZCBTQ1NJIGNvbnRyb2xsZXI6
IExTSSBMb2dpYyAvIFN5bWJpb3MgTG9naWMgU0FTMzIyNCBQQ0ktRXhwcmVzcyBGdXNpb24t
TVBUIFNBUy0zIChyZXYgMDEpCuKUnHNjc2kgMDowOjA6MCBBVEEgICAgICBXREMgV0QyMDAx
RkFTUy0wIHtXRC1XTUFZMDE0MTYzNDR9CuKUguKUlHNkYSAxLjgydCBbODowXSBQYXJ0aXRp
b25lZCAoZ3B0KQrilIIg4pSUc2RhMSAxLjgydCBbODoxXSBNRCByYWlkNiAoNy8xMykgKHcv
IHNkbzEsc2RtMSxzZGwxLHNkazEsc2RqMSxzZGkxLHNkaDEsc2RnMSxzZGYxLHNkZTEsc2Rj
MSxzZGIxKSBpbl9zeW5jICdOTEVTdG9yZTpBbGljZScgezM5NGI5MDg3LTI2OGEtYTk1Ny1m
N2YxLWQ0YzRjY2VmYjE5MX0K4pSCICDilJRtZDEyNiAyMC4wMXQgWzk6MTI2XSBNRCB2MS4y
IHJhaWQ2ICgxMykgY2xlYW4sIDUxMmsgQ2h1bmsgezM5NGI5MDg3OjI2OGFhOTU3OmY3ZjFk
NGM0OmNjZWZiMTkxfQrilIIgICDilIIgICAgICAgICAgICAgICAgICAgIFBWIExWTTJfbWVt
YmVyIDIwLjAxdCB1c2VkLCAwIGZyZWUgezhQaFoyYi13aVoxLW9rOUwtQ2xMdy1PUVV5LUdy
ZkUtZVRvMEh3fQrilIIgICDilJRWRyBDYXJyb2xsIDIwLjAxdCAwIGZyZWUgezlmY0ZkRS1n
NTAxLXRMZlEtTGc1ay16Q1lTLWZodzMtdkVKSTFZfQrilIIgICAg4pSUZG0tMTIgMjAuMDF0
IFsyNTM6MTJdIExWIFdvbmRlcmxhbmQgYnRyZnMgJ1dvbmRlcmxhbmQnIHtmNzEwZWM4NS1i
Mjc3LTQ1YTQtYTUyNi1lOTcwZjc0ZTI3ODF9CuKUgiAgICAg4pSUTW91bnRlZCBhcyAvZGV2
L21hcHBlci9DYXJyb2xsLVdvbmRlcmxhbmQgQCAvbW50L1dvbmRlcmxhbmQK4pScc2NzaSAw
OjA6MTowIEFUQSAgICAgIFdEQyBXRDIwRUFSUy0wMEoge1dELVdDQVdaMTg2OTY3MX0K4pSC
4pSUc2RiIDEuODJ0IFs4OjE2XSBQYXJ0aXRpb25lZCAoZ3B0KQrilIIg4pSUc2RiMSAxLjgy
dCBbODoxN10gTUQgcmFpZDYgKDIvMTMpICh3LyBzZG8xLHNkbTEsc2RsMSxzZGsxLHNkajEs
c2RpMSxzZGgxLHNkZzEsc2RmMSxzZGUxLHNkYzEsc2RhMSkgaW5fc3luYyAnTkxFU3RvcmU6
QWxpY2UnIHszOTRiOTA4Ny0yNjhhLWE5NTctZjdmMS1kNGM0Y2NlZmIxOTF9CuKUgiAg4pSU
bWQxMjYgMjAuMDF0IFs5OjEyNl0gTUQgdjEuMiByYWlkNiAoMTMpIGNsZWFuLCA1MTJrIENo
dW5rIHszOTRiOTA4NzoyNjhhYTk1NzpmN2YxZDRjNDpjY2VmYjE5MX0K4pSCICAgICAgICAg
ICAgICAgICAgICAgICAgUFYgTFZNMl9tZW1iZXIgMjAuMDF0IHVzZWQsIDAgZnJlZSB7OFBo
WjJiLXdpWjEtb2s5TC1DbEx3LU9RVXktR3JmRS1lVG8wSHd9CuKUnHNjc2kgMDowOjI6MCBB
VEEgICAgICBXREMgV0QyMEVGUlgtNjhFIHtXRC1XQ0M0TTZWVEhKUlJ9CuKUguKUlHNkYyAx
LjgydCBbODozMl0gUGFydGl0aW9uZWQgKGdwdCkK4pSCIOKUlHNkYzEgMS44MnQgWzg6MzNd
IE1EIHJhaWQ2ICg1LzEzKSAody8gc2RvMSxzZG0xLHNkbDEsc2RrMSxzZGoxLHNkaTEsc2Ro
MSxzZGcxLHNkZjEsc2RlMSxzZGIxLHNkYTEpIGluX3N5bmMgJ05MRVN0b3JlOkFsaWNlJyB7
Mzk0YjkwODctMjY4YS1hOTU3LWY3ZjEtZDRjNGNjZWZiMTkxfQrilIIgIOKUlG1kMTI2IDIw
LjAxdCBbOToxMjZdIE1EIHYxLjIgcmFpZDYgKDEzKSBjbGVhbiwgNTEyayBDaHVuayB7Mzk0
YjkwODc6MjY4YWE5NTc6ZjdmMWQ0YzQ6Y2NlZmIxOTF9CuKUgiAgICAgICAgICAgICAgICAg
ICAgICAgIFBWIExWTTJfbWVtYmVyIDIwLjAxdCB1c2VkLCAwIGZyZWUgezhQaFoyYi13aVox
LW9rOUwtQ2xMdy1PUVV5LUdyZkUtZVRvMEh3fQrilJxzY3NpIDA6MDozOjAgQVRBICAgICAg
SEdTVCBIRE43MjYwNjBBTCB7TkNHR0JNN1N9CuKUguKUlHNkZCA1LjQ2dCBbODo0OF0gRW1w
dHkvVW5rbm93bgrilJxzY3NpIDA6MDo0OjAgQVRBICAgICAgV0RDIFdEMjBFRlJYLTY4RSB7
V0QtV0NDNE02WUpOMFNEfQrilILilJRzZGUgMS44MnQgWzg6NjRdIFBhcnRpdGlvbmVkIChn
cHQpCuKUgiDilJRzZGUxIDEuODJ0IFs4OjY1XSBNRCByYWlkNiAoMC8xMykgKHcvIHNkbzEs
c2RtMSxzZGwxLHNkazEsc2RqMSxzZGkxLHNkaDEsc2RnMSxzZGYxLHNkYzEsc2RiMSxzZGEx
KSBpbl9zeW5jICdOTEVTdG9yZTpBbGljZScgezM5NGI5MDg3LTI2OGEtYTk1Ny1mN2YxLWQ0
YzRjY2VmYjE5MX0K4pSCICDilJRtZDEyNiAyMC4wMXQgWzk6MTI2XSBNRCB2MS4yIHJhaWQ2
ICgxMykgY2xlYW4sIDUxMmsgQ2h1bmsgezM5NGI5MDg3OjI2OGFhOTU3OmY3ZjFkNGM0OmNj
ZWZiMTkxfQrilIIgICAgICAgICAgICAgICAgICAgICAgICBQViBMVk0yX21lbWJlciAyMC4w
MXQgdXNlZCwgMCBmcmVlIHs4UGhaMmItd2laMS1vazlMLUNsTHctT1FVeS1HcmZFLWVUbzBI
d30K4pScc2NzaSAwOjA6NTowIEFUQSAgICAgIFdEQyBXRDIwRUZSWC02OEUge1dELVdDQzRN
NllKTkVQN30K4pSC4pSUc2RmIDEuODJ0IFs4OjgwXSBQYXJ0aXRpb25lZCAoZ3B0KQrilIIg
4pSUc2RmMSAxLjgydCBbODo4MV0gTUQgcmFpZDYgKDMvMTMpICh3LyBzZG8xLHNkbTEsc2Rs
MSxzZGsxLHNkajEsc2RpMSxzZGgxLHNkZzEsc2RlMSxzZGMxLHNkYjEsc2RhMSkgaW5fc3lu
YyAnTkxFU3RvcmU6QWxpY2UnIHszOTRiOTA4Ny0yNjhhLWE5NTctZjdmMS1kNGM0Y2NlZmIx
OTF9CuKUgiAg4pSUbWQxMjYgMjAuMDF0IFs5OjEyNl0gTUQgdjEuMiByYWlkNiAoMTMpIGNs
ZWFuLCA1MTJrIENodW5rIHszOTRiOTA4NzoyNjhhYTk1NzpmN2YxZDRjNDpjY2VmYjE5MX0K
4pSCICAgICAgICAgICAgICAgICAgICAgICAgUFYgTFZNMl9tZW1iZXIgMjAuMDF0IHVzZWQs
IDAgZnJlZSB7OFBoWjJiLXdpWjEtb2s5TC1DbEx3LU9RVXktR3JmRS1lVG8wSHd9CuKUnHNj
c2kgMDowOjY6MCBBVEEgICAgICBXREMgV0Q2MDAyRkZXWC02IHtLMUdMQkhNRH0K4pSC4pSU
c2RnIDUuNDZ0IFs4Ojk2XSBQYXJ0aXRpb25lZCAoZ3B0KQrilIIg4pSUc2RnMSA1LjQ2dCBb
ODo5N10gTUQgcmFpZDYgKDEyLzEzKSAody8gc2RvMSxzZG0xLHNkbDEsc2RrMSxzZGoxLHNk
aTEsc2RoMSxzZGYxLHNkZTEsc2RjMSxzZGIxLHNkYTEpIGluX3N5bmMgJ05MRVN0b3JlOkFs
aWNlJyB7Mzk0YjkwODctMjY4YS1hOTU3LWY3ZjEtZDRjNGNjZWZiMTkxfQrilIIgIOKUlG1k
MTI2IDIwLjAxdCBbOToxMjZdIE1EIHYxLjIgcmFpZDYgKDEzKSBjbGVhbiwgNTEyayBDaHVu
ayB7Mzk0YjkwODc6MjY4YWE5NTc6ZjdmMWQ0YzQ6Y2NlZmIxOTF9CuKUgiAgICAgICAgICAg
ICAgICAgICAgICAgIFBWIExWTTJfbWVtYmVyIDIwLjAxdCB1c2VkLCAwIGZyZWUgezhQaFoy
Yi13aVoxLW9rOUwtQ2xMdy1PUVV5LUdyZkUtZVRvMEh3fQrilJxzY3NpIDA6MDo3OjAgQVRB
ICAgICAgV0RDIFdEMjBFWlJYLTAwRCB7V0QtV01DNE4yNzY0NTM5fQrilILilJRzZGggMS44
MnQgWzg6MTEyXSBQYXJ0aXRpb25lZCAoZ3B0KQrilIIg4pSUc2RoMSAxLjgydCBbODoxMTNd
IE1EIHJhaWQ2ICg2LzEzKSAody8gc2RvMSxzZG0xLHNkbDEsc2RrMSxzZGoxLHNkaTEsc2Rn
MSxzZGYxLHNkZTEsc2RjMSxzZGIxLHNkYTEpIGluX3N5bmMgJ05MRVN0b3JlOkFsaWNlJyB7
Mzk0YjkwODctMjY4YS1hOTU3LWY3ZjEtZDRjNGNjZWZiMTkxfQrilIIgIOKUlG1kMTI2IDIw
LjAxdCBbOToxMjZdIE1EIHYxLjIgcmFpZDYgKDEzKSBjbGVhbiwgNTEyayBDaHVuayB7Mzk0
YjkwODc6MjY4YWE5NTc6ZjdmMWQ0YzQ6Y2NlZmIxOTF9CuKUgiAgICAgICAgICAgICAgICAg
ICAgICAgIFBWIExWTTJfbWVtYmVyIDIwLjAxdCB1c2VkLCAwIGZyZWUgezhQaFoyYi13aVox
LW9rOUwtQ2xMdy1PUVV5LUdyZkUtZVRvMEh3fQrilJxzY3NpIDA6MDo4OjAgQVRBICAgICAg
V0RDIFdEMjBFWlJYLTAwRCB7V0QtV0NDMzAwNTgzMjg0fQrilILilJRzZGkgMS44MnQgWzg6
MTI4XSBQYXJ0aXRpb25lZCAoZ3B0KQrilIIg4pSUc2RpMSAxLjgydCBbODoxMjldIE1EIHJh
aWQ2ICg4LzEzKSAody8gc2RvMSxzZG0xLHNkbDEsc2RrMSxzZGoxLHNkaDEsc2RnMSxzZGYx
LHNkZTEsc2RjMSxzZGIxLHNkYTEpIGluX3N5bmMgJ05MRVN0b3JlOkFsaWNlJyB7Mzk0Yjkw
ODctMjY4YS1hOTU3LWY3ZjEtZDRjNGNjZWZiMTkxfQrilIIgIOKUlG1kMTI2IDIwLjAxdCBb
OToxMjZdIE1EIHYxLjIgcmFpZDYgKDEzKSBjbGVhbiwgNTEyayBDaHVuayB7Mzk0YjkwODc6
MjY4YWE5NTc6ZjdmMWQ0YzQ6Y2NlZmIxOTF9CuKUgiAgICAgICAgICAgICAgICAgICAgICAg
IFBWIExWTTJfbWVtYmVyIDIwLjAxdCB1c2VkLCAwIGZyZWUgezhQaFoyYi13aVoxLW9rOUwt
Q2xMdy1PUVV5LUdyZkUtZVRvMEh3fQrilJxzY3NpIDA6MDo5OjAgQVRBICAgICAgV0RDIFdE
MjBFQVJTLTAwTSB7V0QtV0NBWkE1NDE0MDgzfQrilILilJRzZGogMS44MnQgWzg6MTQ0XSBQ
YXJ0aXRpb25lZCAoZ3B0KQrilIIg4pSUc2RqMSAxLjgydCBbODoxNDVdIE1EIHJhaWQ2ICg5
LzEzKSAody8gc2RvMSxzZG0xLHNkbDEsc2RrMSxzZGkxLHNkaDEsc2RnMSxzZGYxLHNkZTEs
c2RjMSxzZGIxLHNkYTEpIGluX3N5bmMgJ05MRVN0b3JlOkFsaWNlJyB7Mzk0YjkwODctMjY4
YS1hOTU3LWY3ZjEtZDRjNGNjZWZiMTkxfQrilIIgIOKUlG1kMTI2IDIwLjAxdCBbOToxMjZd
IE1EIHYxLjIgcmFpZDYgKDEzKSBjbGVhbiwgNTEyayBDaHVuayB7Mzk0YjkwODc6MjY4YWE5
NTc6ZjdmMWQ0YzQ6Y2NlZmIxOTF9CuKUgiAgICAgICAgICAgICAgICAgICAgICAgIFBWIExW
TTJfbWVtYmVyIDIwLjAxdCB1c2VkLCAwIGZyZWUgezhQaFoyYi13aVoxLW9rOUwtQ2xMdy1P
UVV5LUdyZkUtZVRvMEh3fQrilJxzY3NpIDA6MDoxMDowIEFUQSAgICAgIEhHU1QgSERONzI2
MDYwQUwge05DR1NVRVBTfQrilILilJRzZGsgNS40NnQgWzg6MTYwXSBQYXJ0aXRpb25lZCAo
Z3B0KQrilIIg4pSUc2RrMSA1LjQ2dCBbODoxNjFdIE1EIHJhaWQ2ICgxMS8xMykgKHcvIHNk
bzEsc2RtMSxzZGwxLHNkajEsc2RpMSxzZGgxLHNkZzEsc2RmMSxzZGUxLHNkYzEsc2RiMSxz
ZGExKSBpbl9zeW5jICdOTEVTdG9yZTpBbGljZScgezM5NGI5MDg3LTI2OGEtYTk1Ny1mN2Yx
LWQ0YzRjY2VmYjE5MX0K4pSCICDilJRtZDEyNiAyMC4wMXQgWzk6MTI2XSBNRCB2MS4yIHJh
aWQ2ICgxMykgY2xlYW4sIDUxMmsgQ2h1bmsgezM5NGI5MDg3OjI2OGFhOTU3OmY3ZjFkNGM0
OmNjZWZiMTkxfQrilIIgICAgICAgICAgICAgICAgICAgICAgICBQViBMVk0yX21lbWJlciAy
MC4wMXQgdXNlZCwgMCBmcmVlIHs4UGhaMmItd2laMS1vazlMLUNsTHctT1FVeS1HcmZFLWVU
bzBId30K4pScc2NzaSAwOjA6MTE6MCBBVEEgICAgICBXREMgV0QyMEVBUlMtMDBKIHtXRC1X
Q0FZWTAyMDE5MDd9CuKUguKUlHNkbCAxLjgydCBbODoxNzZdIFBhcnRpdGlvbmVkIChncHQp
CuKUgiDilJRzZGwxIDEuODJ0IFs4OjE3N10gTUQgcmFpZDYgKDEvMTMpICh3LyBzZG8xLHNk
bTEsc2RrMSxzZGoxLHNkaTEsc2RoMSxzZGcxLHNkZjEsc2RlMSxzZGMxLHNkYjEsc2RhMSkg
aW5fc3luYyAnTkxFU3RvcmU6QWxpY2UnIHszOTRiOTA4Ny0yNjhhLWE5NTctZjdmMS1kNGM0
Y2NlZmIxOTF9CuKUgiAg4pSUbWQxMjYgMjAuMDF0IFs5OjEyNl0gTUQgdjEuMiByYWlkNiAo
MTMpIGNsZWFuLCA1MTJrIENodW5rIHszOTRiOTA4NzoyNjhhYTk1NzpmN2YxZDRjNDpjY2Vm
YjE5MX0K4pSCICAgICAgICAgICAgICAgICAgICAgICAgUFYgTFZNMl9tZW1iZXIgMjAuMDF0
IHVzZWQsIDAgZnJlZSB7OFBoWjJiLXdpWjEtb2s5TC1DbEx3LU9RVXktR3JmRS1lVG8wSHd9
CuKUnHNjc2kgMDowOjEyOjAgQVRBICAgICAgSEdTVCBIRE43MjYwNjBBTCB7TkNHRDZQVlN9
CuKUguKUlHNkbSA1LjQ2dCBbODoxOTJdIFBhcnRpdGlvbmVkIChncHQpCuKUgiDilJRzZG0x
IDUuNDZ0IFs4OjE5M10gTUQgcmFpZDYgKDQvMTMpICh3LyBzZG8xLHNkbDEsc2RrMSxzZGox
LHNkaTEsc2RoMSxzZGcxLHNkZjEsc2RlMSxzZGMxLHNkYjEsc2RhMSkgaW5fc3luYyAnTkxF
U3RvcmU6QWxpY2UnIHszOTRiOTA4Ny0yNjhhLWE5NTctZjdmMS1kNGM0Y2NlZmIxOTF9CuKU
giAg4pSUbWQxMjYgMjAuMDF0IFs5OjEyNl0gTUQgdjEuMiByYWlkNiAoMTMpIGNsZWFuLCA1
MTJrIENodW5rIHszOTRiOTA4NzoyNjhhYTk1NzpmN2YxZDRjNDpjY2VmYjE5MX0K4pSCICAg
ICAgICAgICAgICAgICAgICAgICAgUFYgTFZNMl9tZW1iZXIgMjAuMDF0IHVzZWQsIDAgZnJl
ZSB7OFBoWjJiLXdpWjEtb2s5TC1DbEx3LU9RVXktR3JmRS1lVG8wSHd9CuKUnHNjc2kgMDp4
Ong6eCBbRW1wdHldCuKUnHNjc2kgMDowOjE0OjAgQVRBICAgICAgSEdTVCBIRE43MjYwNjBB
TCB7TkFIVU04RFl9CuKUguKUlHNkbyA1LjQ2dCBbODoyMjRdIFBhcnRpdGlvbmVkIChncHQp
CuKUgiDilJRzZG8xIDUuNDZ0IFs4OjIyNV0gTUQgcmFpZDYgKDEwLzEzKSAody8gc2RtMSxz
ZGwxLHNkazEsc2RqMSxzZGkxLHNkaDEsc2RnMSxzZGYxLHNkZTEsc2RjMSxzZGIxLHNkYTEp
IGluX3N5bmMgJ05MRVN0b3JlOkFsaWNlJyB7Mzk0YjkwODctMjY4YS1hOTU3LWY3ZjEtZDRj
NGNjZWZiMTkxfQrilIIgIOKUlG1kMTI2IDIwLjAxdCBbOToxMjZdIE1EIHYxLjIgcmFpZDYg
KDEzKSBjbGVhbiwgNTEyayBDaHVuayB7Mzk0YjkwODc6MjY4YWE5NTc6ZjdmMWQ0YzQ6Y2Nl
ZmIxOTF9CuKUgiAgICAgICAgICAgICAgICAgICAgICAgIFBWIExWTTJfbWVtYmVyIDIwLjAx
dCB1c2VkLCAwIGZyZWUgezhQaFoyYi13aVoxLW9rOUwtQ2xMdy1PUVV5LUdyZkUtZVRvMEh3
fQrilJRzY3NpIDA6eDp4OnggW0VtcHR5XQo=
--------------A69B6D993AB0047EC8A40EAD--
