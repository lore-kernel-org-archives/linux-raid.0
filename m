From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] md/raid10: fix data corruption and crash during resync
Date: Wed, 16 Dec 2015 12:29:22 +1100
Message-ID: <87oadrb2q5.fsf@notabene.neil.brown.name>
References: <1446654630-24067-1-git-send-email-artur.paszkiewicz@intel.com> <20151104223353.GA99478@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20151104223353.GA99478@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 05 2015, Shaohua Li wrote:

> On Wed, Nov 04, 2015 at 05:30:30PM +0100, Artur Paszkiewicz wrote:
>> The commit c31df25f20e3 ("md/raid10: make sync_request_write() call
>> bio_copy_data()") replaced manual data copying with bio_copy_data() but
>> it doesn't work as intended. The source bio (fbio) is already processed,
>> so its bvec_iter has bi_size =3D=3D 0 and bi_idx =3D=3D bi_vcnt.  Becaus=
e of
>> this, bio_copy_data() either does not copy anything, or worse, copies
>> data from the ->bi_next bio if it is set.  This causes wrong data to be
>> written to drives during resync and sometimes lockups/crashes in
>> bio_copy_data():
>>=20
>> [  517.338478] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [md=
126_raid10:3319]
>> [  517.347324] Modules linked in: raid10 xt_CHECKSUM ipt_MASQUERADE nf_n=
at_masquerade_ipv4 tun ip6t_rpfilter ip6t_REJECT nf_reject_ipv6 ipt_REJECT =
nf_reject_ipv4 xt_conntrack ebtable_nat ebtable_broute bridge stp llc ebtab=
le_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv=
6 ip6table_mangle ip6table_security ip6table_raw ip6table_filter ip6_tables=
 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntra=
ck iptable_mangle iptable_security iptable_raw iptable_filter ip_tables x86=
_pkg_temp_thermal coretemp kvm_intel kvm crct10dif_pclmul crc32_pclmul cryp=
td shpchp pcspkr ipmi_si ipmi_msghandler tpm_crb acpi_power_meter acpi_cpuf=
req ext4 mbcache jbd2 sr_mod cdrom sd_mod e1000e ax88179_178a usbnet mii ah=
ci ata_generic crc32c_intel libahci ptp pata_acpi libata pps_core wmi sunrp=
c dm_mirror dm_region_hash dm_log dm_mod
>> [  517.440555] CPU: 0 PID: 3319 Comm: md126_raid10 Not tainted 4.3.0-rc6=
+ #1
>> [  517.448384] Hardware name: Intel Corporation PURLEY/PURLEY, BIOS PLYD=
CRB1.86B.0055.D14.1509221924 09/22/2015
>> [  517.459768] task: ffff880153773980 ti: ffff880150df8000 task.ti: ffff=
880150df8000
>> [  517.468529] RIP: 0010:[<ffffffff812e1888>]  [<ffffffff812e1888>] bio_=
copy_data+0xc8/0x3c0
>> [  517.478164] RSP: 0018:ffff880150dfbc98  EFLAGS: 00000246
>> [  517.484341] RAX: ffff880169356688 RBX: 0000000000001000 RCX: 00000000=
00000000
>> [  517.492558] RDX: 0000000000000000 RSI: ffffea0001ac2980 RDI: ffffea00=
00d835c0
>> [  517.500773] RBP: ffff880150dfbd08 R08: 0000000000000001 R09: ffff8801=
53773980
>> [  517.508987] R10: ffff880169356600 R11: 0000000000001000 R12: 00000000=
00010000
>> [  517.517199] R13: 000000000000e000 R14: 0000000000000000 R15: 00000000=
00001000
>> [  517.525412] FS:  0000000000000000(0000) GS:ffff880174a00000(0000) knl=
GS:0000000000000000
>> [  517.534844] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  517.541507] CR2: 00007f8a044d5fed CR3: 0000000169504000 CR4: 00000000=
001406f0
>> [  517.549722] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 00000000=
00000000
>> [  517.557929] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 00000000=
00000400
>> [  517.566144] Stack:
>> [  517.568626]  ffff880174a16bc0 ffff880153773980 ffff880169356600 00000=
00000000000
>> [  517.577659]  0000000000000001 0000000000000001 ffff880153773980 ffff8=
8016a61a800
>> [  517.586715]  ffff880150dfbcf8 0000000000000001 ffff88016dd209e0 00000=
00000001000
>> [  517.595773] Call Trace:
>> [  517.598747]  [<ffffffffa043ef95>] raid10d+0xfc5/0x1690 [raid10]
>> [  517.605610]  [<ffffffff816697ae>] ? __schedule+0x29e/0x8e2
>> [  517.611987]  [<ffffffff814ff206>] md_thread+0x106/0x140
>> [  517.618072]  [<ffffffff810c1d80>] ? wait_woken+0x80/0x80
>> [  517.624252]  [<ffffffff814ff100>] ? super_1_load+0x520/0x520
>> [  517.630817]  [<ffffffff8109ef89>] kthread+0xc9/0xe0
>> [  517.636506]  [<ffffffff8109eec0>] ? flush_kthread_worker+0x70/0x70
>> [  517.643653]  [<ffffffff8166d99f>] ret_from_fork+0x3f/0x70
>> [  517.649929]  [<ffffffff8109eec0>] ? flush_kthread_worker+0x70/0x70
>>=20
>> Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
>> ---
>>  drivers/md/raid10.c | 4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>=20
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 96f3659..23bbe61 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1944,6 +1944,8 @@ static void sync_request_write(struct mddev *mddev=
, struct r10bio *r10_bio)
>>=20=20
>>  	first =3D i;
>>  	fbio =3D r10_bio->devs[i].bio;
>> +	fbio->bi_iter.bi_size =3D r10_bio->sectors << 9;
>> +	fbio->bi_iter.bi_idx =3D 0;
>>=20=20
>>  	vcnt =3D (r10_bio->sectors + (PAGE_SIZE >> 9) - 1) >> (PAGE_SHIFT - 9);
>>  	/* now find blocks with errors */
>> @@ -1987,7 +1989,7 @@ static void sync_request_write(struct mddev *mddev=
, struct r10bio *r10_bio)
>>  		bio_reset(tbio);
>>=20=20
>>  		tbio->bi_vcnt =3D vcnt;
>> -		tbio->bi_iter.bi_size =3D r10_bio->sectors << 9;
>> +		tbio->bi_iter.bi_size =3D fbio->bi_iter.bi_size;
>>  		tbio->bi_rw =3D WRITE;
>>  		tbio->bi_private =3D r10_bio;
>>  		tbio->bi_iter.bi_sector =3D r10_bio->devs[i].addr;
>
> Looks good. Reviewed-by: Shaohua Li <shli@kernel.org>

Thanks for the patch and the review.
I've added:
    Cc: stable@vger.kernel.org (v4.2+)
    Fixes: c31df25f20e3 ("md/raid10: make sync_request_write() call bio_cop=
y_data()")
    Signed-off-by: NeilBrown <neilb@suse.com>

and will hopefully submit to Linus in a day or so.

>
> A nitpick, I'm wondering if we should do a full reset like raid1 does to =
make this more clear.

Might make sense.  I'm happy with the code as it is, but if doing a full
reset makes the code cleared I'd accept that too.

Thanks,
NeilBrown


> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWcL5yAAoJEDnsnt1WYoG5WjIQAKtSLPvDrrPgsvFDxV4iiBK+
oeJxDPBpJvy+unp8LKRBon8+YbZAN5PrBV0/d7Eb86ytv1W+JhkMSnukTYcAbTpk
PixlKcZYoSwnbo7aCg355xjixMC5CXNq+SML+9LYGO+O6xrco20N1bFCfeB/kTFo
mLTIXQQ9eOfI4FAUuqvZ+tcLw2JtLc2d7L85lDP4rzrNuiluTQnNO+xSEJVwoS7E
SJAjRMa07god6ox3z28fPBVzS/R/A10HEcwsYM0cpztr4FwQ6L1bo5/S4OExQ0rC
gxzeaWWcHBFZW8fqK2OyGvyYHd+fGc9/bP8kLhjh2OHQFaxnsml2FkR9bRxrSAcr
F3NPaysp780VLfGxVWI30/9zMCgp9Ww/H73LnTfFMILaiD6VDzz/XnYhXsi3LrVE
vivl16XT7Ytr/kLdpwpjhGRNsPAZvK9J7wvisXBkn0ZJfl5WOjOFhvNex/MoPTeH
z4142/AunQUNxHZ/oxn/eO5+W2tNXmLJwf+YrFGUFWQ6g8rcNFs+CdsxjfHsnGYJ
Wl+7BQOtMqUDHNQQ/mC8rS8IeRlG35Nd+X9DonatU+zS47jQOBiOYecgaf7QurUN
2gRqdCNuKZfFruxfZF6tjX7l23yDta5ldZAPmTJ+1m/ZrX0F4+ApzOkVYpeRusG5
j/gP3WKNT3C96ZeBzy8i
=iuyD
-----END PGP SIGNATURE-----
--=-=-=--
