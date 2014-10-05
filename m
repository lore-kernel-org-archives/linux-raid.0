From: Matthijs Kooijman <matthijs@stdin.nl>
Subject: MD Raid1 hangs system on read error (3.10)
Date: Sun, 5 Oct 2014 11:27:01 +0200
Message-ID: <20141005092700.GA1452@login.tika.stderr.nl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sm4nu43k4a2Rpi4c"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sm4nu43k4a2Rpi4c
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey folks,

a few times now I've found my system being locked up after a read error
=66rom a hard disk. It looks like the MD code that handles the read error
messes up and causes a GPF.

After this happens, the system becomes completely unresponsive - it
responds to ping and opens TCP connections, but no data comes out. The
serial console also gives no response.

After rebooting, the disk in question showed a pending sector. In the
most recent occurence, I found that the array was also resyncing. I'm
not sure if this also happened in the earlier occurences (but since the
pending sector didn't disappear in the next day, I'd expect no resync
happened before). The read errors always happened during a routine check
of the array.

Over the last months, this happend three or four times now. In between,
I've also seen some read errors that did get handled properly without a
crash.

I've included the kernel output from the most recent case below. If it
helps, I could dig in my logs to find the earlier occurences too. I've
also included some details about the raid arrays. The read error
happened in sdd / md127.

Gr.

Matthijs


Oct  5 01:08:02 tika kernel: [2383614.474387] ata4.00: exception Emask 0x0 =
SAct 0x1 SErr 0x0 action 0x0
Oct  5 01:08:02 tika kernel: [2383614.481134] ata4.00: irq_stat 0x40000008
Oct  5 01:08:02 tika kernel: [2383614.485360] ata4.00: failed command: READ=
 FPDMA QUEUED
Oct  5 01:08:02 tika kernel: [2383614.490775] ata4.00: cmd 60/00:00:00:60:3=
f/04:00:04:00:00/40 tag 0 ncq 524288 in
Oct  5 01:08:02 tika kernel: [2383614.490775]          res 41/40:00:ae:60:3=
f/00:00:04:00:00/40 Emask 0x409 (media error) <F>
Oct  5 01:08:02 tika kernel: [2383614.506945] ata4.00: status: { DRDY ERR }
Oct  5 01:08:02 tika kernel: [2383614.511213] ata4.00: error: { UNC }
Oct  5 01:08:02 tika kernel: [2383614.534796] ata4.00: configured for UDMA/=
133
Oct  5 01:08:02 tika kernel: [2383614.539397] sd 3:0:0:0: [sdd] Unhandled s=
ense code
Oct  5 01:08:02 tika kernel: [2383614.544489] sd 3:0:0:0: [sdd]
Oct  5 01:08:02 tika kernel: [2383614.547885] Result: hostbyte=3DDID_OK dri=
verbyte=3DDRIVER_SENSE
Oct  5 01:08:02 tika kernel: [2383614.553790] sd 3:0:0:0: [sdd]
Oct  5 01:08:02 tika kernel: [2383614.557417] Sense Key : Medium Error [cur=
rent] [descriptor]
Oct  5 01:08:02 tika kernel: [2383614.563428] Descriptor sense data with se=
nse descriptors (in hex):
Oct  5 01:08:02 tika kernel: [2383614.569937]         72 03 11 04 00 00 00 =
0c 00 0a 80 00 00 00 00 00
Oct  5 01:08:02 tika kernel: [2383614.577640]         04 3f 60 ae
Oct  5 01:08:02 tika kernel: [2383614.581453] sd 3:0:0:0: [sdd]
Oct  5 01:08:02 tika kernel: [2383614.584856] Add. Sense: Unrecovered read =
error - auto reallocate failed
Oct  5 01:08:02 tika kernel: [2383614.591847] sd 3:0:0:0: [sdd] CDB:
Oct  5 01:08:02 tika kernel: [2383614.595727] Read(10): 28 00 04 3f 60 00 0=
0 04 00 00
Oct  5 01:08:02 tika kernel: [2383614.657093] general protection fault: 000=
0 [#1] SMP
Oct  5 01:08:02 tika kernel: [2383614.660531] Modules linked in: joydev fus=
e btrfs raid6_pq zlib_deflate xor ufs qnx4 hfsplus hfs minix ntfs vfat msdo=
s fat jfs xfs crc32c libcrc32c reiserfs ext2 efivars xt_CLASSIFY xt_helper =
xt_mac xt_mark nf_conntrack_netlink tcp_diag inet_diag xt_multiport ip6t_RE=
JECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ip6table_mangle ip6table=
_filter ip6_tables ipt_REJECT xt_nat xt_tcpudp xt_connmark xt_conntrack xt_=
NFLOG nfnetlink_log nfnetlink xt_limit ipt_rpfilter iptable_raw veth nf_nat=
_ftp nf_conntrack_ftp xt_state iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4=
 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables x_=
tables bridge stp llc ext4 crc16 jbd2 ipmi_si ipmi_devintf ipmi_msghandler =
loop hid_generic usbhid hid iTCO_wdt iTCO_vendor_support mperf coretemp snd=
_pcsp e1000e snd_pcm snd_page_alloc snd_timer lpc_ich i2c_i801 snd psmouse =
evdev ptp microcode i2c_core soundcore serio_raw mfd_core pps_core ehci_pci=
 uhci_hcd ehci_hcd usbcore processor button usb_co
Oct  5 01:08:02 tika kernel: mmon thermal_sys ext3 mbcache jbd dm_mod raid1=
 md_mod sd_mod crc_t10dif ahci libahci libata scsi_mod
Oct  5 01:08:02 tika kernel: [2383614.660531] CPU: 3 PID: 232 Comm: md127_r=
aid1 Not tainted 3.10-1-amd64 #1 Debian 3.10.3-1
Oct  5 01:08:02 tika kernel: [2383614.660531] Hardware name: Supermicro X7S=
PA-HF/X7SPA-HF, BIOS 1.2a       02/21/12
Oct  5 01:08:02 tika kernel: [2383614.660531] task: ffff880139b2e080 ti: ff=
ff8801396a0000 task.ti: ffff8801396a0000
Oct  5 01:08:02 tika kernel: [2383614.660531] RIP: 0010:[<ffffffff8112fe9b>=
]  [<ffffffff8112fe9b>] bio_copy_data+0x138/0x158
Oct  5 01:08:02 tika kernel: [2383614.660531] RSP: 0018:ffff8801396a1d20  E=
FLAGS: 00010286
Oct  5 01:08:02 tika kernel: [2383614.660531] RAX: ffff88005b451980 RBX: 00=
00000000000006 RCX: 0000000000001000
Oct  5 01:08:02 tika kernel: [2383614.660531] RDX: ffff880112510a80 RSI: db=
73880000000006 RDI: ffff88010319c000
Oct  5 01:08:02 tika kernel: [2383614.660531] RBP: 0000000000001000 R08: ff=
ff880112510a00 R09: ffff88005b451800
Oct  5 01:08:02 tika kernel: [2383614.660531] R10: ffff8801396a0000 R11: 00=
00000000000000 R12: 0000160000000000
Oct  5 01:08:02 tika kernel: [2383614.660531] R13: ffff8801396a1fd8 R14: 6d=
b6db6db6db6db7 R15: ffff880000000000
Oct  5 01:08:02 tika kernel: [2383614.660531] FS:  0000000000000000(0000) G=
S:ffff88013fd80000(0000) knlGS:0000000000000000
Oct  5 01:08:02 tika kernel: [2383614.660531] CS:  0010 DS: 0000 ES: 0000 C=
R0: 000000008005003b
Oct  5 01:08:02 tika kernel: [2383614.660531] CR2: 00007fffc589aa80 CR3: 00=
00000125a83000 CR4: 00000000000007e0
Oct  5 01:08:02 tika kernel: [2383614.660531] DR0: 0000000000000000 DR1: 00=
00000000000000 DR2: 0000000000000000
Oct  5 01:08:02 tika kernel: [2383614.868070] DR3: 0000000000000000 DR6: 00=
000000ffff0ff0 DR7: 0000000000000400
Oct  5 01:08:02 tika kernel: [2383614.868070] Stack:
Oct  5 01:08:02 tika kernel: [2383614.868070]  ffff88010319c000 ffff88011dc=
91240 ffff88011dc91278 ffff88013952e780
Oct  5 01:08:02 tika kernel: [2383614.868070]  ffff880112510a00 ffff8801394=
cb800 ffff88013952e780 ffffffffa0063785
Oct  5 01:08:02 tika kernel: [2383614.868070]  ffffffff8105eaf0 ffff88013ae=
cd040 6db6db6db6db6db7 ffff880000000000
Oct  5 01:08:02 tika kernel: [2383614.868070] Call Trace:
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffffa0063785>] ? raid1=
d+0x6cd/0xacc [raid1]
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff8105eaf0>] ? mmdro=
p+0xd/0x1c
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffffa00af0d0>] ? md_th=
read+0x114/0x132 [md_mod]
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff81057c48>] ? abort=
_exclusive_wait+0x79/0x79
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffffa00aefbc>] ? signa=
l_pending+0x10/0x10 [md_mod]
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff810572f0>] ? kthre=
ad+0x7d/0x85
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff810408ef>] ? do_ex=
it+0x901/0x918
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff81057273>] ? __kth=
read_parkme+0x59/0x59
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff8138d2bc>] ? ret_f=
rom_fork+0x7c/0xb0
Oct  5 01:08:02 tika kernel: [2383614.868070]  [<ffffffff81057273>] ? __kth=
read_parkme+0x59/0x59
Oct  5 01:08:02 tika kernel: [2383614.868070] Code: fe 03 49 0f af ce 49 0f=
 af f6 48 c1 e1 0c 4c 01 f9 48 c1 e6 0c 48 01 cf 4c 01 fe 89 e9 48 89 3c 24=
 8b 78 0c 48 01 fe 48 8b 3c 24 <f3> a4 41 ff 4a 1c 41 ff 4a 1c 01 eb 41 01 =
eb e9 0b ff ff ff 58
Oct  5 01:08:02 tika kernel: [2383614.868070] RIP  [<ffffffff8112fe9b>] bio=
_copy_data+0x138/0x158
Oct  5 01:08:02 tika kernel: [2383614.868070]  RSP <ffff8801396a1d20>
Oct  5 01:08:02 tika kernel: [2383615.003013] ---[ end trace 83bab722baa22e=
03 ]---
Oct  5 01:08:02 tika kernel: [2383615.007968] BUG: scheduling while atomic:=
 md127_raid1/232/0x10000002
Oct  5 01:08:02 tika kernel: [2383615.014640] Modules linked in: joydev fus=
e btrfs raid6_pq zlib_deflate xor ufs qnx4 hfsplus hfs minix ntfs vfat msdo=
s fat jfs xfs crc32c libcrc32c reiserfs ext2 efivars xt_CLASSIFY xt_helper =
xt_mac xt_mark nf_conntrack_netlink tcp_diag inet_diag xt_multiport ip6t_RE=
JECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ip6table_mangle ip6table=
_filter ip6_tables ipt_REJECT xt_nat xt_tcpudp xt_connmark xt_conntrack xt_=
NFLOG nfnetlink_log nfnetlink xt_limit ipt_rpfilter iptable_raw veth nf_nat=
_ftp nf_conntrack_ftp xt_state iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4=
 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables x_=
tables bridge stp llc ext4 crc16 jbd2 ipmi_si ipmi_devintf ipmi_msghandler =
loop hid_generic usbhid hid iTCO_wdt iTCO_vendor_support mperf coretemp snd=
_pcsp e1000e snd_pcm snd_page_alloc snd_timer lpc_ich i2c_i801 snd psmouse =
evdev ptp microcode i2c_core soundcore serio_raw mfd_core pps_core ehci_pci=
 uhci_hcd ehci_hcd usbcore processor button usb_co
Oct  5 01:08:02 tika kernel: mmon thermal_sys ext3 mbcache jbd dm_mod raid1=
 md_mod sd_mod crc_t10dif ahci libahci libata scsi_mod
Oct  5 01:08:02 tika kernel: [2383615.119035] CPU: 3 PID: 232 Comm: md127_r=
aid1 Tainted: G      D      3.10-1-amd64 #1 Debian 3.10.3-1
Oct  5 01:08:02 tika kernel: [2383615.128462] Hardware name: Supermicro X7S=
PA-HF/X7SPA-HF, BIOS 1.2a       02/21/12
Oct  5 01:08:02 tika kernel: [2383615.136470]  0000000000000000 ffffffff813=
82c1d ffffffff81386f6e 0000000000000046
Oct  5 01:08:02 tika kernel: [2383615.144420]  0000000000014040 ffff8801396=
a1fd8 ffff8801396a1fd8 ffff880139b2e080
Oct  5 01:08:02 tika kernel: [2383615.152521]  ffff8801396a0000 00000000000=
0000b 0000000000000246 ffff8801396a1fd8
Oct  5 01:08:02 tika kernel: [2383615.160479] Call Trace:
Oct  5 01:08:02 tika kernel: [2383615.163228]  [<ffffffff81382c1d>] ? __sch=
edule_bug+0x42/0x4f
Oct  5 01:08:02 tika kernel: [2383615.169195]  [<ffffffff81386f6e>] ? __sch=
edule+0x85/0x532
Oct  5 01:08:02 tika kernel: [2383615.174893]  [<ffffffff810606fc>] ? __con=
d_resched+0x1d/0x26
Oct  5 01:08:02 tika kernel: [2383615.180883]  [<ffffffff81387464>] ? _cond=
_resched+0x10/0x18
Oct  5 01:08:02 tika kernel: [2383615.186732]  [<ffffffff81386bd2>] ? down_=
read+0x9/0x19
Oct  5 01:08:02 tika kernel: [2383615.192207]  [<ffffffff8104b6f4>] ? exit_=
signals+0x1a/0x110
Oct  5 01:08:02 tika kernel: [2383615.198080]  [<ffffffff810400fb>] ? do_ex=
it+0x10d/0x918
Oct  5 01:08:02 tika kernel: [2383615.203594]  [<ffffffff81382641>] ? print=
k+0x4f/0x51
Oct  5 01:08:02 tika kernel: [2383615.208859]  [<ffffffff81388f91>] ? oops_=
end+0xa9/0xae
Oct  5 01:08:02 tika kernel: [2383615.214327]  [<ffffffff81388568>] ? gener=
al_protection+0x28/0x30
Oct  5 01:08:02 tika kernel: [2383615.220824]  [<ffffffff8112fe9b>] ? bio_c=
opy_data+0x138/0x158
Oct  5 01:08:02 tika kernel: [2383615.226937]  [<ffffffffa0063785>] ? raid1=
d+0x6cd/0xacc [raid1]
Oct  5 01:08:02 tika kernel: [2383615.233105]  [<ffffffff8105eaf0>] ? mmdro=
p+0xd/0x1c
Oct  5 01:08:02 tika kernel: [2383615.238324]  [<ffffffffa00af0d0>] ? md_th=
read+0x114/0x132 [md_mod]
Oct  5 01:08:02 tika kernel: [2383615.244801]  [<ffffffff81057c48>] ? abort=
_exclusive_wait+0x79/0x79
Oct  5 01:08:02 tika kernel: [2383615.251334]  [<ffffffffa00aefbc>] ? signa=
l_pending+0x10/0x10 [md_mod]
Oct  5 01:08:02 tika kernel: [2383615.258046]  [<ffffffff810572f0>] ? kthre=
ad+0x7d/0x85
Oct  5 01:08:02 tika kernel: [2383615.263448]  [<ffffffff810408ef>] ? do_ex=
it+0x901/0x918
Oct  5 01:08:02 tika kernel: [2383615.269032]  [<ffffffff81057273>] ? __kth=
read_parkme+0x59/0x59
Oct  5 01:08:02 tika kernel: [2383615.275217]  [<ffffffff8138d2bc>] ? ret_f=
rom_fork+0x7c/0xb0
Oct  5 01:08:02 tika kernel: [2383615.281102]  [<ffffffff81057273>] ? __kth=
read_parkme+0x59/0x59
Oct  5 01:08:02 tika kernel: [2383615.287286] note: md127_raid1[232] exited=
 with preempt_count 2
Oct  5 01:08:02 tika kernel: [2383615.293427] BUG: scheduling while atomic:=
 md127_raid1/232/0x10000002
Oct  5 01:08:03 tika kernel: [2383615.300072] Modules linked in: joydev fus=
e btrfs raid6_pq zlib_deflate xor ufs qnx4 hfsplus hfs minix ntfs vfat msdo=
s fat jfs xfs crc32c libcrc32c reiserfs ext2 efivars xt_CLASSIFY xt_helper =
xt_mac xt_mark nf_conntrack_netlink tcp_diag inet_diag xt_multiport ip6t_RE=
JECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_raw ip6table_mangle ip6table=
_filter ip6_tables ipt_REJECT xt_nat xt_tcpudp xt_connmark xt_conntrack xt_=
NFLOG nfnetlink_log nfnetlink xt_limit ipt_rpfilter iptable_raw veth nf_nat=
_ftp nf_conntrack_ftp xt_state iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4=
 nf_nat_ipv4 nf_nat nf_conntrack iptable_mangle iptable_filter ip_tables x_=
tables bridge stp llc ext4 crc16 jbd2 ipmi_si ipmi_devintf ipmi_msghandler =
loop hid_generic usbhid hid iTCO_wdt iTCO_vendor_support mperf coretemp snd=
_pcsp e1000e snd_pcm snd_page_alloc snd_timer lpc_ich i2c_i801 snd psmouse =
evdev ptp microcode i2c_core soundcore serio_raw mfd_core pps_core ehci_pci=
 uhci_hcd ehci_hcd usbcore processor button usb_co
Oct  5 01:08:03 tika kernel: mmon thermal_sys ext3 mbcache jbd dm_mod raid1=
 md_mod sd_mod crc_t10dif ahci libahci libata scsi_mod
Oct  5 01:08:03 tika kernel: [2383615.404198] CPU: 1 PID: 232 Comm: md127_r=
aid1 Tainted: G      D W    3.10-1-amd64 #1 Debian 3.10.3-1
Oct  5 01:08:03 tika kernel: [2383615.413670] Hardware name: Supermicro X7S=
PA-HF/X7SPA-HF, BIOS 1.2a       02/21/12
(This is where the log ends, probably things went FUBAR at this point)

matthijs@tika:~$ sudo mdadm --misc -D /dev/md126
/dev/md126:
        Version : 1.2
  Creation Time : Thu Apr 10 19:04:30 2014
     Raid Level : raid1
     Array Size : 104791936 (99.94 GiB 107.31 GB)
  Used Dev Size : 104791936 (99.94 GiB 107.31 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun Oct  5 11:17:35 2014
          State : clean=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

           Name : tika:ssd  (local to host tika)
           UUID : 16e28bb4:db7d5c69:81cb1b64:ae4f760d
         Events : 125

    Number   Major   Minor   RaidDevice State
       0       8        1        0      active sync   /dev/sda1
       1       8       17        1      active sync   /dev/sdb1
matthijs@tika:~$ sudo mdadm --misc -D /dev/md127
/dev/md127:
        Version : 1.2
  Creation Time : Tue Sep 21 12:30:00 2010
     Raid Level : raid1
     Array Size : 488384536 (465.76 GiB 500.11 GB)
  Used Dev Size : 488384536 (465.76 GiB 500.11 GB)
   Raid Devices : 2
  Total Devices : 2
    Persistence : Superblock is persistent

    Update Time : Sun Oct  5 11:12:55 2014
          State : active, resyncing=20
 Active Devices : 2
Working Devices : 2
 Failed Devices : 0
  Spare Devices : 0

  Resync Status : 16% complete

           Name : tika:hdd  (local to host tika)
           UUID : f201f80b:8c1e6f0b:ccc25f2e:98fdccc6
         Events : 922

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1


--sm4nu43k4a2Rpi4c
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJUMQ7jAAoJEDeYrxWhVlZYtncP/RPntFSBHKQeK8/pDOFozO9Z
qppewuVRpRaIkqCn9PCk32Osc6+bKwRvP8DwVI2WaZSOuIt6xcVD1MzY4KuhAh4A
PC9DoKFGrO6J3gZAzG9GQveaH6dm5LQzuST/BH3iMJuIqhcD3SwMCnQ3czuKY/NV
rIIl3hVBFj2SFSQ25XDocps/Scpf0xlGmZv4RfirBO3N1fVI5/h8gPLepSmx0u9A
gJQiBcq9LvGxdoJ1lrzvq5WEENokhml/baPfXXKgp/t0md6VgNeemjPZHRF3f657
3Nk5hB+EbbIUdJC3v+ElNwDVtDl5yZWho3HhCpesC0hjZyQ6XoA0HcLRfpl8AXZh
kNMBtzJYKoMs9wE8mIza6uXsLQDvQWVCDyKhREypP+OyxS0Cm6d1RBnJfjeSFFW6
J+2eDiIp4+UDlepxibBuu9THCL9jkhb+SaBbY6wEtrl1QbLY79fkJoZrHMkpan+R
5wfNdqlbCm90MGkza/DmoZechyMHooArdpjC/uz6Ihy76VqH6NRw9mJtjH68MVoY
WHIkPGNrwVWCEIbcDcPZWY3rBMqE9VJpQo89qK29IgLODUog4dnvFOecFzT7kwrj
c6YESKw35Bcp2l+I4zu8L0bS8nLe0S1ESQ1yEwme8Bd5dWecuH/dsUGdEPFSVJ67
KveTBGwZ79wXdq4Vvpli
=KtB6
-----END PGP SIGNATURE-----

--sm4nu43k4a2Rpi4c--
