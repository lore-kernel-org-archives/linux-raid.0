From: Manish Katiyar <mkatiyar@gmail.com>
Subject: [PANIC] : kernel BUG at drivers/md/raid5.c:2756!
Date: Mon, 31 Oct 2011 14:29:38 -0700
Message-ID: <CAE0An6cvpqD8oPiHr2CAb753hC=47BYErOwAxaXoeHOYPaVznA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: Manish Katiyar <mkatiyar@gmail.com>
List-Id: linux-raid.ids

I was running following script (trying to reproduce an ext4 error
reported in another thread) and the kernel dies with below error.

The place where it crashes is :-
2746 static void handle_parity_checks6(raid5_conf_t *conf, struct
stripe_head *sh,
2747                                   struct stripe_head_state *s,
2748                                   int disks)
2749 {
=2E....
2754         set_bit(STRIPE_HANDLE, &sh->state);
2755
2756         BUG_ON(s->failed > 2);   <=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D !!!!



[ 9663.343974] md/raid:md11: Disk failure on loop3, disabling device.[
9663.343976] md/raid:md11: Operation continuing on 4 devices.[
9668.547289] ------------[ cut here ]------------[ 9668.547327] kernel
BUG at drivers/md/raid5.c:2756![ 9668.547356] invalid opcode: 0000
[#1] SMP=A0[ 9668.547388] Modules linked in: parport_pc ppdev
snd_hda_codec_hdmi snd_hda_codec_conexant aesni_intel cryptd aes_i586
aes_generic nfsd exportfs btusb nfs bluetooth lockd fscache
auth_rpcgss nfs_acl sunrpc binfmt_misc joydev snd_hda_intel
snd_hda_codec fuse snd_hwdep thinkpad_acpi snd_pcm snd_seq_midi
uvcvideo snd_rawmidi snd_seq_midi_event arc4 snd_seq videodev i915
iwlagn mxm_wmi drm_kms_helper drm snd_timer psmouse snd_seq_device
serio_raw mac80211 snd tpm_tis tpm nvram tpm_bios intel_ips cfg80211
soundcore i2c_algo_bit snd_page_alloc video lp parport usbhid hid
raid10 raid456 async_raid6_recov async_pq ahci libahci firewire_ohci
firewire_core crc_itu_t sdhci_pci sdhci e1000e raid6_pq async_xor xor
async_memcpy async_tx raid1 raid0 multipath linear[ 9668.547951]=A0[
9668.547964] Pid: 6067, comm: md11_raid6 Tainted: G =A0 =A0 =A0 =A0W
3.1.0-rc3+ #0 LENOVO 2537GH6/2537GH6[ 9668.548021] EIP:
0060:[<f878d590>] EFLAGS: 00010202 CPU: 3[ 9668.548056] EIP is at
handle_stripe+0x1e60/0x1e70 [raid456][ 9668.548087] EAX: 00000005 EBX:
ea589e00 ECX: 00000000 EDX: 00000003[ 9668.548121] ESI: 00000006 EDI:
df059590 EBP: ded39f00 ESP: ded39e30[ 9668.548155] =A0DS: 007b ES: 007b
=46S: 00d8 GS: 00e0 SS: 0068[ 9668.548186] Process md11_raid6 (pid:
6067, ti=3Dded38000 task=3De364b2c0 task.ti=3Dded38000)[ 9668.548228]
Stack:[ 9668.548241] =A0ded39e38 c10167e8 00000002 c107ce85 00000001
ded39e4c 00009258 00000000[ 9668.548303] =A0df0595b8 ded39e60 ea589e00
fffffffc 00000007 ea589f28 ea589e00 df059590[ 9668.548364] =A000000000
e36b1d50 ded39e7c 00000000 00000000 00000000 00000000 00000007[
9668.548424] Call Trace:[ 9668.548447] =A0[<c10167e8>] ?
sched_clock+0x8/0x10[ 9668.548477] =A0[<c107ce85>] ?
sched_clock_cpu+0xe5/0x150[ 9668.548509] =A0[<f8787f39>] ?
__release_stripe+0x109/0x160 [raid456][ 9668.548545] =A0[<f8787fce>] ?
release_stripe+0x3e/0x50 [raid456][ 9668.548580] =A0[<f878f47a>]
raid5d+0x3aa/0x510 [raid456][ 9668.548611] =A0[<c107698d>] ?
finish_wait+0x4d/0x70[ 9668.548641] =A0[<c13fc3fd>]
md_thread+0xed/0x120[ 9668.548669] =A0[<c1076890>] ?
add_wait_queue+0x50/0x50[ 9668.548697] =A0[<c13fc310>] ?
md_rdev_init+0x120/0x120[ 9668.548725] =A0[<c107608d>]
kthread+0x6d/0x80[ 9668.548750] =A0[<c1076020>] ?
flush_kthread_worker+0x80/0x80[ 9668.548784] =A0[<c15419be>]
kernel_thread_helper+0x6/0x10[ 9668.548814] Code: 44 01 40 f0 80 88 80
00 00 00 02 f0 80 88 80 00 00 00 20 8b 45 98 e9 7a f3 ff ff 0f 0b c7
40 38 03 00 00 00 b8 03 00 00 00 eb b4 <0f> 0b 0f 0b 0f 0b 0f 0b=A0[
9668.549063] md: md11: resync done.[ 9668.549087] 90 8d b4 26 00 00 00
00 55 89 e5 57 56=A0[ 9668.549159] EIP: [<f878d590>]
handle_stripe+0x1e60/0x1e70 [raid456] SS:ESP 0068:ded39e30[
9668.935138] ---[ end trace e71016c3ebaeb3bd ]---

The script to reproduce is :

/home/mkatiyar> cat a.ksh
#!/bin/ksh

SUDO=3Dsudo

cmd() {
	sudo $*
}

device=3D/dev/md11
cd
cmd mdadm --stop $device
cmd mdadm --remove $device
cmd umount /tmp/b

for i in `seq 1 7`
do
   cmd losetup -d /dev/loop$i
done

mkdir -p /tmp/a
mkdir -p /tmp/b

cd /tmp/a

for i in `seq 1 7`
do
   cmd rm /tmp/a/raid-$i
   cmd dd if=3D/dev/zero of=3D/tmp/a/raid-$i bs=3D4k count=3D25000
   cmd losetup /dev/loop$i /tmp/a/raid-$i
done

cmd mdadm --create $device --level=3D6 --raid-devices=3D7 /dev/loop[1-7=
]
cmd cat /proc/mdstat

cmd mkfs.ext4 -b 4096 -i 4096 -m 0 $device
cmd mount $device /tmp/b

cmd mdadm --manage $device --fail /dev/loop1
cmd mdadm --manage $device --fail /dev/loop2

cmd dmesg -c > /dev/null 2>&1
cmd dd if=3D/dev/zero of=3D/tmp/b/testfile bs=3D1k count=3D1000 &
cmd mdadm --manage $device --fail /dev/loop3


PS : I'm not part of the list, so please keep me in cc in the response.

--=20
Thanks -
Manish
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
