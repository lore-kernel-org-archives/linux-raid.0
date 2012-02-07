From: Richard Herd <2001oddity@gmail.com>
Subject: Re: Please Help! RAID5 -> 6 reshapre gone bad
Date: Tue, 7 Feb 2012 14:10:40 +1100
Message-ID: <CAOANJV8MJRLu6+BC6HdBLqhNZsMrdhZpYN_Wc+8FObMJ2++O4w@mail.gmail.com>
References: <CAOANJV-V8ZTXBvQxxMnEnv24p8A-fAas-6x65ifW5yp35ZqHnA@mail.gmail.com>
	<4F30893F.4000709@turmel.org>
	<CAOANJV955ZdLexRTjVkQzTMapAaMitq5eqxP0rUvDjjLh4Wgzw@mail.gmail.com>
	<4F309313.2070406@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F309313.2070406@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks again Phil.

To confirm:

root@raven:/# mdadm -Avv --force --backup-file=3D/usb/md0.backup
/dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1

Results in the below, so even with --force it doesn't want to accept
'non-fresh' sdc.

mdadm: looking for devices for /dev/md0
mdadm: /dev/sda1 is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdb1 is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 5.
mdadm: /dev/sdf1 is identified as a member of /dev/md0, slot 4.
mdadm:/dev/md0 has an active reshape - checking if critical section
needs to be restored
mdadm: accepting backup with timestamp 1328559119 for array with
timestamp 1328567549
mdadm: restoring critical section
mdadm: no uptodate device for slot 0 of /dev/md0
mdadm: added /dev/sda1 to /dev/md0 as 2
mdadm: added /dev/sdc1 to /dev/md0 as 3
mdadm: added /dev/sdf1 to /dev/md0 as 4
mdadm: added /dev/sdd1 to /dev/md0 as 5
mdadm: added /dev/sdb1 to /dev/md0 as 1
mdadm: failed to RUN_ARRAY /dev/md0: Input/output error

And dmesg shows:
[11595.863451] md: bind<sda1>
[11595.863972] md: bind<sdc1>
[11595.865341] md: bind<sdf1>
[11595.869893] md: bind<sdd1>
[11595.870891] md: bind<sdb1>
[11595.871357] md: kicking non-fresh sdc1 from array!
[11595.871370] md: unbind<sdc1>
[11595.880072] md: export_rdev(sdc1)
[11595.882513] raid5: reshape will continue
[11595.882538] raid5: device sdb1 operational as raid disk 1
[11595.882542] raid5: device sdf1 operational as raid disk 4
[11595.882546] raid5: device sda1 operational as raid disk 2
[11595.883544] raid5: allocated 6308kB for md0
[11595.883627] 1: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[11595.883633] 5: w=3D1 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D1 op2=3D=
0
[11595.883637] 4: w=3D2 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[11595.883642] 2: w=3D3 pa=3D18 pr=3D6 m=3D2 a=3D2 r=3D6 op1=3D0 op2=3D=
0
[11595.883645] raid5: not enough operational devices for md0 (3/6 faile=
d)
[11595.891968] RAID5 conf printout:
[11595.891971]  --- rd:6 wd:3
[11595.891976]  disk 1, o:1, dev:sdb1
[11595.891979]  disk 2, o:1, dev:sda1
[11595.891983]  disk 4, o:1, dev:sdf1
[11595.891986]  disk 5, o:1, dev:sdd1
[11595.892520] raid5: failed to run raid set md0
[11595.900726] md: pers->run() failed ...

Cheers


On Tue, Feb 7, 2012 at 1:57 PM, Phil Turmel <philip@turmel.org> wrote:
> Hi Richard,
>
> [restored CC list... =A0please use reply-to-all on kernel.org lists]
>
> On 02/06/2012 09:40 PM, Richard Herd wrote:
>> Hi Phil,
>>
>> Thanks for the swift response :-) =A0Also I'm in (what I'd like to s=
ay
>> but can't - sunny) Sydney...
>>
>> OK, without slathering this thread is smart reports I can quite
>> definitely say you are exactly nail-on-the-head with regard to the
>> read errors escalating into link timeouts. =A0This is exactly what i=
s
>> happening. =A0I had thought this was actually a pretty common setup =
for
>> home users (eg mdadm and drives such as WD20EARS/ST2000s) - I have t=
he
>> luxury of budgets for Netapp kit at work - unfortunately my personal
>> finances only stretch to an ITX case and a bunch of cheap HDs!
>
> I understand the constraints, as I pinch pennies at home and at the
> office (I own my engineering firm). =A0I've made do with cheap deskto=
p
> drives that do support ERC. =A0I got burned when Seagate dropped ERC =
on
> their latest desktop drives. =A0Hitachi Deskstar is the only affordab=
le
> model on the market that still support ERC.
>
>> I understand it's the ERC causing disks to get kicked, and fully
>> understand if you can't help further.
>
> Not that I won't help, as there's no risk to me :-)
>
>> Assembling without sdg I'm not sure will do it, as what we have is 4
>> disks with the same events counter (3 active sync (sda/sdb/sdf), 1
>> spare rebuilding (sdd)), and 2 (sdg/sdc) removed with older event
>> counters. =A0Leaving out sdg leaves us with sdc which has an event
>> counter of 1848333. =A0As the 3 active sync (sda/sdb/sdf) + 1 spare
>> (sdd) have an event counter of 1848341, mdadm doesn't want to let me
>> use sdc in the array even with --force.
>
> This surprises me. =A0The purpose of "--force" with assemble is to
> ignore the event count. =A0Have you tried this with the newer mdadm
> you compiled?
>
>> As you say as it's in the middle of a reshape so a recreate is out.
>>
>> I'm considering data loss is a given at this point, but even being
>> able to bring the array online degraded and pull out whatever is sti=
ll
>> intact would help.
>>
>> If you have any further suggestions that would be great, but I do
>> understand your position on ERC and thank you for your input :-)
>
> Please do retry the --assemble --force with /dev/sdg left out?
>
> I'll leave the balance of your response untrimmed for the list to see=
=2E
>
> Phil
>
>
>> Feb =A07 01:07:16 raven kernel: [18891.989330] ata8: hard resetting =
link
>> Feb =A07 01:07:22 raven kernel: [18897.356104] ata8: link is slow to
>> respond, please be patient (ready=3D0)
>> Feb =A07 01:07:26 raven kernel: [18902.004280] ata8: hard resetting =
link
>> Feb =A07 01:07:32 raven kernel: [18907.372104] ata8: link is slow to
>> respond, please be patient (ready=3D0)
>> Feb =A07 01:07:36 raven kernel: [18912.020097] ata8: SATA link up 6.=
0
>> Gbps (SStatus 133 SControl 300)
>> Feb =A07 01:07:41 raven kernel: [18917.020093] ata8.00: qc timeout (=
cmd 0xec)
>> Feb =A07 01:07:41 raven kernel: [18917.028074] ata8.00: failed to
>> IDENTIFY (I/O error, err_mask=3D0x4)
>> Feb =A07 01:07:41 raven kernel: [18917.028310] ata8: hard resetting =
link
>> Feb =A07 01:07:47 raven kernel: [18922.396089] ata8: link is slow to
>> respond, please be patient (ready=3D0)
>> Feb =A07 01:07:51 raven kernel: [18927.044313] ata8: hard resetting =
link
>> Feb =A07 01:07:56 raven kernel: [18932.020099] ata8: SATA link up 6.=
0
>> Gbps (SStatus 133 SControl 300)
>> Feb =A07 01:08:06 raven kernel: [18942.020048] ata8.00: qc timeout (=
cmd 0xec)
>> Feb =A07 01:08:06 raven kernel: [18942.028075] ata8.00: failed to
>> IDENTIFY (I/O error, err_mask=3D0x4)
>> Feb =A07 01:08:06 raven kernel: [18942.028307] ata8: limiting SATA l=
ink
>> speed to 3.0 Gbps
>> Feb =A07 01:08:06 raven kernel: [18942.028321] ata8: hard resetting =
link
>> Feb =A07 01:08:12 raven kernel: [18947.396108] ata8: link is slow to
>> respond, please be patient (ready=3D0)
>> Feb =A07 01:08:16 raven kernel: [18951.988069] ata8: SATA link up 6.=
0
>> Gbps (SStatus 133 SControl 320)
>> Feb =A07 01:08:46 raven kernel: [18981.988104] ata8.00: qc timeout (=
cmd 0xec)
>> Feb =A07 01:08:46 raven kernel: [18981.996070] ata8.00: failed to
>> IDENTIFY (I/O error, err_mask=3D0x4)
>> Feb =A07 01:08:46 raven kernel: [18981.996302] ata8.00: disabled
>> Feb =A07 01:08:46 raven kernel: [18981.996324] ata8.00: device repor=
ted
>> invalid CHS sector 0
>> Feb =A07 01:08:46 raven kernel: [18981.996348] ata8: hard resetting =
link
>> Feb =A07 01:08:52 raven kernel: [18987.364104] ata8: link is slow to
>> respond, please be patient (ready=3D0)
>> Feb =A07 01:08:56 raven kernel: [18992.012050] ata8: SATA link up 6.=
0
>> Gbps (SStatus 133 SControl 320)
>> Feb =A07 01:08:56 raven kernel: [18992.012114] ata8: EH complete
>> Feb =A07 01:08:56 raven kernel: [18992.012158] sd 8:0:0:0: [sdg]
>> Unhandled error code
>> Feb =A07 01:08:56 raven kernel: [18992.012165] sd 8:0:0:0: [sdg] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 01:08:56 raven kernel: [18992.012176] sd 8:0:0:0: [sdg] CDB=
:
>> Write(10): 2a 00 e8 e0 74 3f 00 00 08 00
>> Feb =A07 01:08:56 raven kernel: [18992.012696] md: super_written get=
s
>> error=3D-5, uptodate=3D0
>> Feb =A07 01:08:56 raven kernel: [18992.013169] sd 8:0:0:0: [sdg]
>> Unhandled error code
>> Feb =A07 01:08:56 raven kernel: [18992.013176] sd 8:0:0:0: [sdg] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 01:08:56 raven kernel: [18992.013186] sd 8:0:0:0: [sdg] CDB=
:
>> Read(10): 28 00 04 9d bd bf 00 00 80 00
>> Feb =A07 01:08:56 raven kernel: [18992.276986] sd 8:0:0:0: [sdg]
>> Unhandled error code
>> Feb =A07 01:08:56 raven kernel: [18992.276999] sd 8:0:0:0: [sdg] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 01:08:56 raven kernel: [18992.277012] sd 8:0:0:0: [sdg] CDB=
:
>> Read(10): 28 00 04 9d be 3f 00 00 80 00
>> Feb =A07 01:08:56 raven kernel: [18992.316919] sd 8:0:0:0: [sdg]
>> Unhandled error code
>> Feb =A07 01:08:56 raven kernel: [18992.316930] sd 8:0:0:0: [sdg] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 01:08:56 raven kernel: [18992.316942] sd 8:0:0:0: [sdg] CDB=
:
>> Read(10): 28 00 04 9d be bf 00 00 80 00
>> Feb =A07 01:08:56 raven kernel: [18992.326906] sd 8:0:0:0: [sdg]
>> Unhandled error code
>> Feb =A07 01:08:56 raven kernel: [18992.326920] sd 8:0:0:0: [sdg] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 01:08:56 raven kernel: [18992.326932] sd 8:0:0:0: [sdg] CDB=
:
>> Read(10): 28 00 04 9d bf 3f 00 00 80 00
>> Feb =A07 01:08:56 raven kernel: [18992.327944] sd 8:0:0:0: [sdg]
>> Unhandled error code
>> Feb =A07 01:08:56 raven kernel: [18992.327956] sd 8:0:0:0: [sdg] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 01:08:56 raven kernel: [18992.327968] sd 8:0:0:0: [sdg] CDB=
:
>> Read(10): 28 00 04 9d bf bf 00 00 80 00
>> Feb =A07 01:08:57 raven kernel: [18992.555093] md: md0: reshape done=
=2E
>> Feb =A07 01:08:57 raven kernel: [18992.607595] md: reshape of RAID a=
rray md0
>> Feb =A07 01:08:57 raven kernel: [18992.607606] md: minimum _guarante=
ed_
>> speed: 200000 KB/sec/disk.
>> Feb =A07 01:08:57 raven kernel: [18992.607614] md: using maximum
>> available idle IO bandwidth (but not more than 200000 KB/sec) for
>> reshape.
>> Feb =A07 01:08:57 raven kernel: [18992.607628] md: using 128k window=
,
>> over a total of 1953511936 blocks.
>> Feb =A07 06:41:02 raven rsyslogd: [origin software=3D"rsyslogd"
>> swVersion=3D"4.2.0" x-pid=3D"911" x-info=3D"http://www.rsyslog.com"]
>> rsyslogd was HUPed, type 'lightweight'.
>> Feb =A07 07:12:32 raven kernel: [40807.989092] ata5: hard resetting =
link
>> Feb =A07 07:12:38 raven kernel: [40813.524074] ata5: SATA link up 6.=
0
>> Gbps (SStatus 133 SControl 300)
>> Feb =A07 07:12:43 raven kernel: [40818.524106] ata5.00: qc timeout (=
cmd 0xec)
>> Feb =A07 07:12:43 raven kernel: [40818.524126] ata5.00: failed to
>> IDENTIFY (I/O error, err_mask=3D0x4)
>> Feb =A07 07:12:43 raven kernel: [40818.532788] ata5: hard resetting =
link
>> Feb =A07 07:12:48 raven kernel: [40824.058039] ata5: SATA link up 6.=
0
>> Gbps (SStatus 133 SControl 300)
>> Feb =A07 07:12:58 raven kernel: [40834.056101] ata5.00: qc timeout (=
cmd 0xec)
>> Feb =A07 07:12:58 raven kernel: [40834.056121] ata5.00: failed to
>> IDENTIFY (I/O error, err_mask=3D0x4)
>> Feb =A07 07:12:58 raven kernel: [40834.064203] ata5: limiting SATA l=
ink
>> speed to 3.0 Gbps
>> Feb =A07 07:12:58 raven kernel: [40834.064217] ata5: hard resetting =
link
>> Feb =A07 07:13:04 raven kernel: [40839.592095] ata5: SATA link up 3.=
0
>> Gbps (SStatus 123 SControl 320)
>> Feb =A07 07:13:34 raven kernel: [40869.592088] ata5.00: qc timeout (=
cmd 0xec)
>> Feb =A07 07:13:34 raven kernel: [40869.592110] ata5.00: failed to
>> IDENTIFY (I/O error, err_mask=3D0x4)
>> Feb =A07 07:13:34 raven kernel: [40869.599676] ata5.00: disabled
>> Feb =A07 07:13:34 raven kernel: [40869.599700] ata5.00: device repor=
ted
>> invalid CHS sector 0
>> Feb =A07 07:13:34 raven kernel: [40869.599724] ata5: hard resetting =
link
>> Feb =A07 07:13:39 raven kernel: [40875.124128] ata5: SATA link up 3.=
0
>> Gbps (SStatus 123 SControl 320)
>> Feb =A07 07:13:39 raven kernel: [40875.124201] ata5: EH complete
>> Feb =A07 07:13:39 raven kernel: [40875.124243] sd 4:0:0:0: [sdd]
>> Unhandled error code
>> Feb =A07 07:13:39 raven kernel: [40875.124251] sd 4:0:0:0: [sdd] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 07:13:39 raven kernel: [40875.124262] sd 4:0:0:0: [sdd] CDB=
:
>> Write(10): 2a 00 e8 e0 74 3f 00 00 08 00
>> Feb =A07 07:13:39 raven kernel: [40875.135544] md: super_written get=
s
>> error=3D-5, uptodate=3D0
>> Feb =A07 07:13:39 raven kernel: [40875.152171] sd 4:0:0:0: [sdd]
>> Unhandled error code
>> Feb =A07 07:13:39 raven kernel: [40875.152179] sd 4:0:0:0: [sdd] Res=
ult:
>> hostbyte=3DDID_BAD_TARGET driverbyte=3DDRIVER_OK
>> Feb =A07 07:13:39 raven kernel: [40875.152189] sd 4:0:0:0: [sdd] CDB=
:
>> Read(10): 28 00 09 2b f2 3f 00 00 80 00
>> Feb =A07 07:13:41 raven kernel: [40876.734504] md: md0: reshape done=
=2E
>> Feb =A07 07:13:41 raven kernel: [40876.736298] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.743529] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.750009] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.755143] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.760126] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.765070] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.769890] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.774759] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.779456] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.784166] lost page write due t=
o
>> I/O error on md0
>> Feb =A07 07:13:41 raven kernel: [40876.788773] JBD: Detected IO erro=
rs
>> while flushing file data on md0
>> Feb =A07 07:13:41 raven kernel: [40876.796386] JBD: Detected IO erro=
rs
>> while flushing file data on md0
>>
>> On Tue, Feb 7, 2012 at 1:15 PM, Phil Turmel <philip@turmel.org> wrot=
e:
>>> Hi Richard,
>>>
>>> On 02/06/2012 08:34 PM, Richard Herd wrote:
>>>> Hey guys,
>>>>
>>>> I'm in a bit of a pickle here and if any mdadm kings could step in=
 and
>>>> throw some advice my way I'd be very grateful :-)
>>>>
>>>> Quick bit of background - little NAS based on an AMD E350 running
>>>> Ubuntu 10.04. Running a software RAID 5 from 5x2TB disks. =A0Every=
 few
>>>> months one of the drives would fail a request and get kicked from =
the
>>>> array (as is becoming common for these larger multi TB drives they
>>>> tolerate the occasional bad sector by reallocating from a pool of
>>>> spares (but that's a whole other story)). =A0This happened across =
a
>>>> variety of brands and two different controllers. I'd simply add th=
e
>>>> disk that got popped back in and let it re-sync. =A0SMART tests al=
ways
>>>> in good health.
>>>
>>> Some more detail on the actual devices would help, especially the
>>> output of lsdrv [1] to document what device serial numbers are whic=
h,
>>> for future reference.
>>>
>>> I also suspect you have problems with your drive's error recovery
>>> control, also known as time-limited error recovery. =A0Simple secto=
r
>>> errors should *not* be kicking out your drives. =A0Mdadm knows to
>>> reconstruct from parity and rewrite when a read error is encountere=
d.
>>> That either succeeds directly, or causes the drive to remap.
>>>
>>> You say that the SMART tests are good, so read errors are probably
>>> escalating into link timeouts, and the drive ignores the attempt to
>>> reconstruct. =A0*That* kicks the drive out.
>>>
>>> "smartctl -x" reports for all of your drives would help identify if
>>> you have this problem. =A0You *cannot* safely run raid arrays with =
drives
>>> that don't (or won't) report errors in a timely fashion (a few seco=
nds).
>>>
>>>> It did make me nervous though. =A0So I decided I'd add a second di=
sk for
>>>> a bit of extra redundancy, making the array a RAID 6 - the thinkin=
g
>>>> was the occasional disk getting kicked and re-added from a RAID 6
>>>> array wouldn't present as much risk as a single disk getting kicke=
d
>>>> from a RAID 5.
>>>>
>>>> So first off, I added the 6th disk as a hotspare to the RAID5 arra=
y.
>>>> So I now had my 5 disk RAID 5 + hotspare.
>>>>
>>>> I then found that mdadm 2.6.7 (in the repositories) isn't actually
>>>> capable of a 5->6 reshape. =A0So I pulled the latest 3.2.3 sources=
 and
>>>> compiled myself a new version of mdadm.
>>>>
>>>> With the newer version of mdadm, it was happy to do the reshape - =
so I
>>>> set it off on it's merry way, using an esata HD (mounted at /usb :=
-P)
>>>> for the backupfile:
>>>>
>>>> root@raven:/# mdadm --grow /dev/md0 --level=3D6 --raid-devices=3D6
>>>> --backup-file=3D/usb/md0.backup
>>>>
>>>> It would take a week to reshape, but it was ona UPS & happily tick=
ing
>>>> along. =A0The array would be online the whole time so I was in no =
rush.
>>>> Content, I went to get some shut-eye.
>>>>
>>>> I got up this morning and took a quick look in /proc/mdstat to see=
 how
>>>> things were going and saw things had failed spectacularly. =A0At l=
east
>>>> two disks had been kicked from the array and the whole thing had
>>>> crumbled.
>>>
>>> Do you still have the dmesg for this?
>>>
>>>> Ouch.
>>>>
>>>> I tried to assembe the array, to see if it would continue the resh=
ape:
>>>>
>>>> root@raven:/# mdadm -Avv --backup-file=3D/usb/md0.backup /dev/md0
>>>> /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/sdd1 /dev/sdf1 /dev/sdg1
>>>>
>>>> Unfortunately mdadm had decided that the backup-file was out of da=
te
>>>> (timestamps didn't match) and was erroring with: Failed to restore
>>>> critical section for reshape, sorry..
>>>>
>>>> Chances are things were in such a mess that backup file wasn't goi=
ng
>>>> to be used anyway, so I blocked the timestamp check with: export
>>>> MDADM_GROW_ALLOW_OLD=3D1
>>>>
>>>> That allowed me to assemble the array, but not run it as there wer=
e
>>>> not enough disks to start it.
>>>>
>>>> This is the current state of the array:
>>>>
>>>> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid=
5]
>>>> [raid4] [raid10]
>>>> md0 : inactive sdb1[1] sdd1[5] sdf1[4] sda1[2]
>>>> =A0 =A0 =A0 7814047744 blocks super 0.91
>>>>
>>>> unused devices: <none>
>>>>
>>>> root@raven:/# mdadm --detail /dev/md0
>>>> /dev/md0:
>>>> =A0 =A0 =A0 =A0 Version : 0.91
>>>> =A0 Creation Time : Tue Jul 12 23:05:01 2011
>>>> =A0 =A0 =A0Raid Level : raid6
>>>> =A0 Used Dev Size : 1953511936 (1863.01 GiB 2000.40 GB)
>>>> =A0 =A0Raid Devices : 6
>>>> =A0 Total Devices : 4
>>>> Preferred Minor : 0
>>>> =A0 =A0 Persistence : Superblock is persistent
>>>>
>>>> =A0 =A0 Update Time : Tue Feb =A07 09:32:29 2012
>>>> =A0 =A0 =A0 =A0 =A0 State : active, FAILED, Not Started
>>>> =A0Active Devices : 3
>>>> Working Devices : 4
>>>> =A0Failed Devices : 0
>>>> =A0 Spare Devices : 1
>>>>
>>>> =A0 =A0 =A0 =A0 =A0Layout : left-symmetric-6
>>>> =A0 =A0 =A0Chunk Size : 64K
>>>>
>>>> =A0 =A0 =A0New Layout : left-symmetric
>>>>
>>>> =A0 =A0 =A0 =A0 =A0 =A0UUID : 9a76d1bd:2aabd685:1fc5fe0e:7751cfd7 =
(local to host raven)
>>>> =A0 =A0 =A0 =A0 =A0Events : 0.1848341
>>>>
>>>> =A0 =A0 Number =A0 Major =A0 Minor =A0 RaidDevice State
>>>> =A0 =A0 =A0 =A00 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A00 =A0=
 =A0 =A0removed
>>>> =A0 =A0 =A0 =A01 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A01 =A0=
 =A0 =A0active sync =A0 /dev/sdb1
>>>> =A0 =A0 =A0 =A02 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A02 =A0=
 =A0 =A0active sync =A0 /dev/sda1
>>>> =A0 =A0 =A0 =A03 =A0 =A0 =A0 0 =A0 =A0 =A0 =A00 =A0 =A0 =A0 =A03 =A0=
 =A0 =A0removed
>>>> =A0 =A0 =A0 =A04 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A04 =A0=
 =A0 =A0active sync =A0 /dev/sdf1
>>>> =A0 =A0 =A0 =A05 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A05 =A0=
 =A0 =A0spare rebuilding =A0 /dev/sdd1
>>>>
>>>> The two removed disks:
>>>> [ 3020.998529] md: kicking non-fresh sdc1 from array!
>>>> [ 3021.012672] md: kicking non-fresh sdg1 from array!
>>>>
>>>> Attempted to re-add the disks (same for both):
>>>> root@raven:/# mdadm /dev/md0 --add /dev/sdg1
>>>> mdadm: /dev/sdg1 reports being an active member for /dev/md0, but =
a
>>>> --re-add fails.
>>>> mdadm: not performing --add as that would convert /dev/sdg1 in to =
a spare.
>>>> mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdg=
1" first.
>>>>
>>>> With a failed array the last thing we want to do is add spares and
>>>> trigger a resync so obviously I haven't zeroed the superblocks and
>>>> added yet.
>>>
>>> That would be catastrophic.
>>>
>>>> Checked and two disks really are out of sync:
>>>> root@raven:/# mdadm --examine /dev/sd[a-h]1 | grep Event
>>>> =A0 =A0 =A0 =A0 =A0Events : 1848341
>>>> =A0 =A0 =A0 =A0 =A0Events : 1848341
>>>> =A0 =A0 =A0 =A0 =A0Events : 1848333
>>>> =A0 =A0 =A0 =A0 =A0Events : 1848341
>>>> =A0 =A0 =A0 =A0 =A0Events : 1848341
>>>> =A0 =A0 =A0 =A0 =A0Events : 1772921
>>>
>>> So /dev/sdg1 dropped out first, and /dev/sdc1 followed and killed t=
he
>>> array.
>>>
>>>> I'll post the output of --examine on all the disks below - if anyo=
ne
>>>> has any advice I'd really appreciate it (Neil Brown doesn't read t=
hese
>>>> forums does he?!?). =A0I would usually move next to recreating the=
 array
>>>> and using assume-clean but since it's right in the middle of a res=
hape
>>>> I'm not inclined to try.
>>>
>>> Neil absolutely reads this mailing list, and is likely to pitch in =
if
>>> I don't offer precisely correct advice :-)
>>>
>>> He's in an Australian time zone though, so latency might vary. =A0I=
'm on the
>>> U.S. east coast, fwiw.
>>>
>>> In any case, with a re-shape in progress, "--create --assume-clean"=
 is
>>> not an option.
>>>
>>>> Critical stuff is of course backed up, but there is some user data=
 not
>>>> covered by backups that I'd like to try and restore if at all
>>>> possible.
>>>
>>> Hope is not all lost. =A0If we can get your ERC adjusted, the next =
step
>>> would be to disconnect /dev/sdg from the system, and assemble with
>>> --force and MDADM_GROW_ALLOW_OLD=3D1
>>>
>>> That'll let the reshape finish, leaving you with a single-degraded
>>> raid6. =A0Then you fsck and make critical backups. =A0Then you --ze=
ro- and
>>> --add /dev/sdg.
>>>
>>> If your drives don't support ERC, I can't recommend you continue un=
til
>>> you've ddrescue'd your drives onto new ones that do support ERC.
>>>
>>> HTH,
>>>
>>> Phil
>>>
>>> [1] http://github.com/pturmel/lsdrv
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
