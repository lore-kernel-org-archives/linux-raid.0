From: Jon Hardcastle <jonathan.hardcastle@gmail.com>
Subject: Re: argh!
Date: Sun, 31 Oct 2010 18:52:10 +0000
Message-ID: <AANLkTimEbwohTEzaPA3VpL0mBwyQisgP99L1870k9q0d@mail.gmail.com>
References: <AANLkTikWcSYEAiqh_Adwg-h71h5y6hmEbLFttg2vRoHG@mail.gmail.com>
	<BA.FF.19545.163BCCC4@cdptpa-omtalb.mail.rr.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BA.FF.19545.163BCCC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31 October 2010 01:07, Leslie Rhorer <lrhorer@satx.rr.com> wrote:
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Jon Hardcastle
>> Sent: Saturday, October 30, 2010 5:01 PM
>> To: Leslie Rhorer
>> Cc: Phil Turmel; linux-raid@vger.kernel.org
>> Subject: Re: argh!
>>
>> Sorry to spam.. if i run
>>
>> 'mdadm --assemble --scan -R'
>>
>> the array assemles in an inactive state but it is suggesting i use
>> force.. but I am worried about doing damage?
>>
>> Also, perhaps some extra commands for thick people would be cool? i.=
e.
>> force for things that are ideal.. like mounting an incomplete array
>> but having to specifiy it twice i.e. '-F -F' for things that can do
>> damage?
>
> Assembly using --force won't do damage. =A0It simply will either pass=
 or fail.
> If it passes, proceed to mounting the array read-only. =A0If it fails=
, you'll
> have to do more work.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

Thanks for your help! mdadm --assemble /dev/md4 --run --force

did it.

I don't have backups as this is 4TB's of data and have never beeen
able to afford having a whole second machine, but the price of drives
has come down alot now so think I may build a noddy machine for weekly
backups.

Thanks for listing what commands are desrustive. Am running a 'check'
before mounting the arrays, I will then kick off a FS check on all
partitions.

I have been combing my log files, I think it was my controller that
failed not the drive (not confirmed as the drive is yet to be
reconnected) but I noticed that the mdadm booted the drive but then I
think it crashed due to a bug and hence the drive was still part of
the array.. i.e. it was still 'checking' when i checked and even after
a --fail the drive was still in the array and 'checking'

I have this from messages

Oct 30 05:02:08 localhost mdadm[13271]: Fail event detected on md
device /dev/md/4, component device /dev/sdc1
Oct 30 05:02:08 localhost kernel: ------------[ cut here ]------------
Oct 30 05:02:08 localhost kernel: kernel BUG at drivers/md/raid5.c:2768=
!
Oct 30 05:02:08 localhost kernel: invalid opcode: 0000 [#1] SMP
Oct 30 05:02:08 localhost kernel: last sysfs file:
/sys/devices/virtual/block/md4/md/metadata_version
Oct 30 05:02:08 localhost kernel: Modules linked in: ipv6 snd_seq_midi
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss
snd_hda_codec_analog snd_cs4236 snd_wavefront snd_wss_lib snd_opl3_lib
snd_hda_intel snd_hda_codec snd_mpu401 snd_hwdep snd_mpu401_uart
snd_pcm snd_rawmidi snd_seq_device i2c_nforce2 ppdev pcspkr snd_timer
k8temp snd_page_alloc forcedeth i2c_core fan rtc_cmos ns558 snd
gameport processor rtc_core thermal rtc_lib button thermal_sys
parport_pc tg3 libphy e1000 fuse xfs exportfs nfs auth_rpcgss nfs_acl
lockd sunrpc jfs raid10 dm_bbr dm_snapshot dm_crypt dm_mirror
dm_region_hash dm_log dm_mod scsi_wait_scan sbp2 ohci1394 ieee1394
sl811_hcd usbhid ohci_hcd ssb uhci_hcd usb_storage ehci_hcd usbcore
aic94xx libsas lpfc qla2xxx megaraid_sas megaraid_mbox megaraid_mm
megaraid aacraid sx8 DAC960 cciss 3w_9xxx 3w_xxxx mptsas
scsi_transport_sas mptfc scsi_transport_fc scsi_tgt mptspi mptscsih
mptbase atp870u dc395x qla1280 imm parport dmx3191d sym53c8xx
qlogicfas408 gdth advansys initio BusLogic arcmsr aic7xxx aic79xx
scsi_transport_spi sg pdc_adma sata_inic162x sata_mv ata_piix ahci
sata_qstor sata_vsc sata_uli sata_sis sata_sx4 sata_nv sata_via
sata_svw sata_sil24 sata_sil sata_promise pata_pcmcia pcmcia
pcmcia_core
Oct 30 05:02:08 localhost kernel:
Oct 30 05:02:08 localhost kernel: Pid: 9967, comm: md4_raid6 Not
tainted (2.6.32-gentoo-r1 #1) System Product Name
Oct 30 05:02:08 localhost kernel: EIP: 0060:[<c0363658>] EFLAGS: 000102=
97 CPU: 0
Oct 30 05:02:08 localhost kernel: EIP is at handle_stripe+0x819/0x1617
Oct 30 05:02:08 localhost kernel: EAX: 00000006 EBX: dd19d1ac ECX:
00000003 EDX: 00000001
Oct 30 05:02:08 localhost kernel: ESI: dd19d1d4 EDI: 00000002 EBP:
dc843f1c ESP: dc843e50
Oct 30 05:02:08 localhost kernel: DS: 007b ES: 007b FS: 00d8 GS: 0000 S=
S: 0068
Oct 30 05:02:08 localhost kernel: Process md4_raid6 (pid: 9967,
ti=3Ddc843000 task=3Dde5e8510 task.ti=3Ddc843000)
Oct 30 05:02:08 localhost kernel: Stack:
Oct 30 05:02:08 localhost kernel: de5e8510 97ac2223 00000007 dd0a8400
de4b91dc 00000007 c13a1360 00020003
Oct 30 05:02:08 localhost kernel: <0> dc89b7c0 00000008 00000003
00000246 dc843eb4 c04017c8 00000010 dd19d524
Oct 30 05:02:08 localhost kernel: <0> 00000006 fffffffc dd025534
dc843eb8 00000000 00000000 00000246 dd025534
Oct 30 05:02:08 localhost kernel: Call Trace:
Oct 30 05:02:08 localhost kernel: [<c04017c8>] ?
__mutex_lock_slowpath+0x1f4/0x1fc
Oct 30 05:02:08 localhost kernel: [<c0364796>] ? raid5d+0x340/0x37e

=2E..... alot more
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
