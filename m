From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: raid5 lockups post ca64cae96037de16e4af92678814f5d4bf0c1c65
Date: Wed, 06 Mar 2013 10:31:55 +0100
Message-ID: <wrfj4ngog9h0.fsf@redhat.com>
References: <wrfj1ubvi88x.fsf@redhat.com>
	<20130305080010.6285b435@notabene.brown> <wrfjlia2fd6h.fsf@redhat.com>
	<20130306131804.0b39752a@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-=-="
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130306131804.0b39752a@notabene.brown> (NeilBrown's message of
	"Wed, 6 Mar 2013 13:18:04 +1100")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>, Eryu Guan <eguan@redhat.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

NeilBrown <neilb@suse.de> writes:
> On Tue, 05 Mar 2013 09:44:54 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
> wrote:
>> > Does this fix it?
>> >
>> > NeilBrown
>> 
>> Unfortunately no, I still see these crashes with this one applied :(
>> 
>
> Thanks - the symptom looked  similar, but now that I look more closely I can
> see it is quite different.
>
> How about this then?  I can't really see what is happening, but based on the
> patch that you identified it must be related to these flags.
> It seems that handle_stripe_clean_event() is being called to early, and it
> doesn't clear out the ->written bios because they are still locked or
> something.  But it does clear R5_Discard on the parity block, so
> handle_stripe_clean_event doesn't get called again.
>
> This makes the handling of the various flags somewhat more uniform, which is
> probably a good thing.

Hi Neil,

With this one applied I end up with an OOPS instead. Note I had to
modify the last test/clear bit sequence to use &sh->dev[i].flags instead
of &dev->flags to avoid a compiler warning.

I am attaching the test script I am running too. It was written by Eryu
Guan.

Cheers,
Jes




[ 2623.554780] kernel BUG at drivers/md/raid5.c:2954!
[ 2623.560126] invalid opcode: 0000 [#1] SMP 
[ 2623.564722] Modules linked in: raid456 async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx nls_utf8 lockd sunrpc bnep bluetooth rfkill sg dm_mirror dm_region_hash dm_log dm_mod raid1 coretemp kvm_intel kvm crc32c_intel iTCO_wdt ghash_clmulni_intel e1000e iTCO_vendor_support lpc_ich microcode mfd_core i2c_i801 video pcspkr uinput xfs mgag200 i2c_algo_bit drm_kms_helper ttm drm mpt2sas i2c_core raid_class scsi_transport_sas usb_storage [last unloaded: raid456]
[ 2623.612586] CPU 3 
[ 2623.614639] Pid: 20177, comm: md42_raid5 Not tainted 3.7.0-rc1+ #17 Intel Corporation S1200BTL/S1200BTL
[ 2623.625329] RIP: 0010:[<ffffffffa0438dd7>]  [<ffffffffa0438dd7>] handle_stripe+0x2297/0x2320 [raid456]
[ 2623.635732] RSP: 0018:ffff8801dd70db68  EFLAGS: 00010246
[ 2623.641660] RAX: ffff8801fc62cf18 RBX: ffff8801fc62cbf8 RCX: 0000000000000001
[ 2623.649623] RDX: 0000000000000000 RSI: 0000000000008d88 RDI: ffff8801edb63e00
[ 2623.657585] RBP: ffff8801dd70dcb8 R08: 0000000000000000 R09: ffff8801fc62cb10
[ 2623.665547] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000001
[ 2623.673509] R13: ffff8801fc62cbf8 R14: 0000000000000000 R15: 0000000000000001
[ 2623.681472] FS:  0000000000000000(0000) GS:ffff880236860000(0000) knlGS:0000000000000000
[ 2623.690503] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 2623.696915] CR2: 00007fb484fcc950 CR3: 00000000018fd000 CR4: 00000000001407e0
[ 2623.704878] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 2623.712841] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 2623.720804] Process md42_raid5 (pid: 20177, threadinfo ffff8801dd70c000, task ffff88022fadcbf0)
[ 2623.730512] Stack:
[ 2623.732757]  0000000000000000 0000000000000000 0000000000000000 0000000000000000
[ 2623.741067]  ffff880232900400 00000001002386d6 ffff880236874100 0000000000000003
[ 2623.749376]  ffff8801dd70dcb8 ffff8801fc62cc38 ffff8801edb63f78 ffff8801edb63f60
[ 2623.757686] Call Trace:
[ 2623.760419]  [<ffffffffa0439c1e>] handle_active_stripes+0x18e/0x2a0 [raid456]
[ 2623.768387]  [<ffffffffa043a79b>] raid5d+0x43b/0x5a0 [raid456]
[ 2623.774902]  [<ffffffff814a6acd>] md_thread+0x10d/0x140
[ 2623.780736]  [<ffffffff81084210>] ? wake_up_bit+0x40/0x40
[ 2623.786764]  [<ffffffff814a69c0>] ? md_rdev_init+0x140/0x140
[ 2623.793081]  [<ffffffff81083810>] kthread+0xc0/0xd0
[ 2623.798529]  [<ffffffff81083750>] ? kthread_create_on_node+0x120/0x120
[ 2623.805815]  [<ffffffff8161e6ac>] ret_from_fork+0x7c/0xb0
[ 2623.811842]  [<ffffffff81083750>] ? kthread_create_on_node+0x120/0x120
[ 2623.819126] Code: 83 be a4 00 00 00 00 74 0e e8 a6 39 07 e1 e9 21 de ff ff 0f 0b 0f 0b e8 58 ad ff ff 0f 1f 84 00 00 00 00 00 e9 0b de ff ff 0f 0b <0f> 0b 8b 43 58 44 8b 43 48 48 c7 c6 88 e1 43 a0 44 0f bf 4b 38 
[ 2623.841056] RIP  [<ffffffffa0438dd7>] handle_stripe+0x2297/0x2320 [raid456]
[ 2623.848840]  RSP <ffff8801dd70db68>

--=-=-=
Content-Type: application/x-sh
Content-Disposition: attachment; filename=md-2.sh
Content-Transfer-Encoding: base64

IyEvYmluL2Jhc2gKCkZTVFlQPWV4dDQKVEVTVF9ERVZfMT0vZGV2L2xvb3AwClRFU1RfREVWXzI9
L2Rldi9sb29wMQpURVNUX0RFVl8zPS9kZXYvbG9vcDIKVEVTVF9ERVZfND0vZGV2L2xvb3AzCgpt
a2ZzX3N0cmlwZV9zdHJpZGVfdGVzdCgpCnsKCWxvY2FsIHJldD0wCglsb2NhbCBzdHJpZGU9MAoJ
bG9jYWwgc3RyaXBlX3dpZHRoPTAKCWxvY2FsIE1EX0RFVj0vZGV2L21kNDIKCgllY2hvICIgKiBU
ZXN0IHdpdGggZGlmZmVyZW50IGNodWNrIHNpemUoNjRLIDEyOEsgMjU2SyksIGRpZmZlcmVudCBu
dW1iZXIgb2YgZGV2aWNlcygzIDQpIGFuZCBkaWZmZXJlbnQgYmxvY2sgc2l6ZSIKCWZvciBjaHVu
a19zaXplIGluIDY0IDEyOCAyNTY7ZG8KCQlmb3IgbnJfZGV2IGluIDMgNDtkbwoJCQkjIENsZWFy
IGRldmljZSBtZXRhZGF0YQoJCQltZGFkbSAtLXplcm8tc3VwZXJibG9jayAkVEVTVF9ERVZfMSA+
L2Rldi9udWxsIDI+JjEKCQkJbWRhZG0gLS16ZXJvLXN1cGVyYmxvY2sgJFRFU1RfREVWXzIgPi9k
ZXYvbnVsbCAyPiYxCgkJCW1kYWRtIC0temVyby1zdXBlcmJsb2NrICRURVNUX0RFVl8zID4vZGV2
L251bGwgMj4mMQoJCQltZGFkbSAtLXplcm8tc3VwZXJibG9jayAkVEVTVF9ERVZfNCA+L2Rldi9u
dWxsIDI+JjEKCgkJCWVjaG8gIiAgKiBTZXR1cCBSQUlENSB3aXRoICRucl9kZXYgZGV2aWNlcywg
Y2h1bmsgc2l6ZSAkY2h1bmtfc2l6ZSBLQiIKCQkJaWYgWyAkbnJfZGV2IC1lcSAzIF07dGhlbgoJ
CQkJREVWX0xJU1Q9IiRURVNUX0RFVl8xICRURVNUX0RFVl8yICRURVNUX0RFVl8zIgoJCQllbHNl
CgkJCQlERVZfTElTVD0iJFRFU1RfREVWXzEgJFRFU1RfREVWXzIgJFRFU1RfREVWXzMgJFRFU1Rf
REVWXzQiCgkJCWZpCgkJCW1kYWRtIC0tY3JlYXRlICRNRF9ERVYgLS1sZXZlbD01IC0tY2h1bms9
JGNodW5rX3NpemUgLS1yYWlkLWRldmljZXM9JG5yX2RldiAkREVWX0xJU1QKCQkJaWYgWyAkPyAt
bmUgMCBdO3RoZW4KCQkJCWVjaG8gIiAgLSBGYWlsZWQgdG8gY3JlYXRlIFJBSUQ1IHdpdGggJG5y
X2RldiBkZXZpY2VzIGNodW5rIHNpemUgJGNodW5rX3NpemUiCgkJCQkoKHJldCsrKSkKCQkJCXJl
dHVybiAkcmV0CgkJCWZpCgoJCQllY2hvICIgICAqIG1rZnMgb24gUkFJRDUsIHN0cmlkZSBzaG91
bGQgYmUgJGNodW5rX3NpemUvXCRibG9ja3NpemUsIHN0cmlwZS13aWR0aCBzaG91bGQgYmUgXCRz
dHJpZGUgKiAoJG5yX2RldiAtIDEpIgoJCQlmb3IgYmxrIGluIDEgMiA0O2RvCgkJCQlta2ZzIC10
ICRGU1RZUCAtYiAkKCgkYmxrICogMTAyNCkpICRNRF9ERVYgPm1rZnMubG9nIDI+JjEKCQkJCXN0
cmlkZT1gZ3JlcCBTdHJpZGUgbWtmcy5sb2cgfCBhd2sgLUYgIiB8PSIgJ3twcmludCAkMn0nYAoJ
CQkJc3RyaXBlX3dpZHRoPWBncmVwICJTdHJpcGUgd2lkdGgiIG1rZnMubG9nIHwgYXdrIC1GICIg
fD0iICd7cHJpbnQgJChORi0xKX0nYAoJCQkJaWYgWyAkKCgkc3RyaWRlICogJGJsaykpIC1uZSAk
Y2h1bmtfc2l6ZSBdO3RoZW4KCQkJCQllY2hvICIgICAtIFdyb25nIHN0cmlkZSwgZXhwZWN0ICQo
KCRjaHVua19zaXplIC8gJGJsaykpLCBnb3QgJHN0cmlkZSIKCQkJCQkoKHJldCsrKSkKCQkJCWZp
CgkJCQlpZiBbICRzdHJpcGVfd2lkdGggLW5lICQoKCRzdHJpZGUgKiAkKCgkbnJfZGV2IC0gMSkp
KSkgXTt0aGVuCgkJCQkJZWNobyAiICAgLSBXcm9uZyBzdHJpcGUtd2lkdGgsIGV4cGVjdCAkKCgk
c3RyaWRlICogJCgoJG5yX2RldiAtIDEpKSkpLCBnb3QgJHN0cmlwZV93aWR0aCIKCQkJCQkoKHJl
dCsrKSkKCQkJCWZpCgkJCWRvbmUKCQkJZWNobyAiICAgKiBTdG9wIFJBSUQ1IgoJCQlpZiAhIG1k
YWRtIC0tc3RvcCAkTURfREVWO3RoZW4KCQkJCWVjaG8gIiAgIC0gRmFpbGVkIHRvIHN0b3AgJE1E
X0RFViIKCQkJCSgocmV0KyspKQoJCQkJcmV0dXJuICRyZXQKCQkJZmkKCQlkb25lCglkb25lCgoJ
cmV0dXJuICRyZXQKfQoKI2ZvciBpIGluIHsxLi4xMDB9O2RvCiMJZWNobyAiPT09IFJvdW5kICRp
ID09PSIKCWlmICEgbWtmc19zdHJpcGVfc3RyaWRlX3Rlc3Q7dGhlbgoJCWVjaG8gIioqKiBFcnJv
ciAqKioiCgkJZXhpdCAxCglmaQojZG9uZQplY2hvICI9PT0gVGVzdCBQYXNzID09PSIK
--=-=-=--
