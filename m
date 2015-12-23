From: NeilBrown <neilb@suse.com>
Subject: Re: raid5 async_xor: sleep in atomic
Date: Wed, 23 Dec 2015 13:34:32 +1100
Message-ID: <87twn928qv.fsf@notabene.neil.brown.name>
References: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFskJNhmU-N5_odOZV54x10Ku=7SSDnaMz5EtCbKddye+AGReg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stanislav Samsonov <slava@annapurnalabs.com>, linux-raid@vger.kernel.org
Cc: dan.j.williams@intel.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Dec 22 2015, Stanislav Samsonov wrote:

> Hi,
>
> Kernel 4.1.3 : there is some troubling kernel message that shows up
> after enabling CONFIG_DEBUG_ATOMIC_SLEEP and testing DMA XOR
> acceleration for raid5:
>
> BUG: sleeping function called from invalid context at mm/mempool.c:320
> in_atomic(): 1, irqs_disabled(): 0, pid: 1048, name: md127_raid5
> INFO: lockdep is turned off.
> CPU: 1 PID: 1048 Comm: md127_raid5 Not tainted 4.1.15.alpine.1-dirty #1
> Hardware name: Annapurna Labs Alpine
> [<c00169d8>] (unwind_backtrace) from [<c0012a78>] (show_stack+0x10/0x14)
> [<c0012a78>] (show_stack) from [<c07462ec>] (dump_stack+0x80/0xb4)
> [<c07462ec>] (dump_stack) from [<c00bf2f0>] (mempool_alloc+0x68/0x13c)
> [<c00bf2f0>] (mempool_alloc) from [<c041c9b4>]
> (dmaengine_get_unmap_data+0x24/0x4c)
> [<c041c9b4>] (dmaengine_get_unmap_data) from [<c03a8084>]
> (async_xor_val+0x60/0x3a0)
> [<c03a8084>] (async_xor_val) from [<c058e4c0>] (raid_run_ops+0xb70/0x1248)
> [<c058e4c0>] (raid_run_ops) from [<c05915d4>] (handle_stripe+0x1068/0x22a8)
> [<c05915d4>] (handle_stripe) from [<c0592ae4>]
> (handle_active_stripes+0x2d0/0x3dc)
> [<c0592ae4>] (handle_active_stripes) from [<c059300c>] (raid5d+0x384/0x5b0)
> [<c059300c>] (raid5d) from [<c059db6c>] (md_thread+0x114/0x138)
> [<c059db6c>] (md_thread) from [<c0042d54>] (kthread+0xe4/0x104)
> [<c0042d54>] (kthread) from [<c000f658>] (ret_from_fork+0x14/0x3c)
>
> The reason is that async_xor_val() in crypto/async_tx/async_xor.c is
> called in atomic context (preemption disabled) by raid_run_ops(). Then
> it calls dmaengine_get_unmap_data() an then mempool_alloc() with
> GFP_NOIO flag - this allocation type might sleep under some condition.
>
> Checked latest kernel 4.3 and it has exactly same flow.
>
> Any advice regarding this issue?

Changing the GFP_NOIO to GFP_ATOMIC in all the calls to
dmaengine_get_unmap_data() in crypto/async_tx/ would probably fix the
issue... or make it crash even worse :-)

Dan: do you have any wisdom here?  The xor is using the percpu data in
raid5, so it cannot be sleep, but GFP_NOIO allows sleep.
Does the code handle failure to get_unmap_data() safely?  It looks like
it probably does.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWegg4AAoJEDnsnt1WYoG5vCgP/05XvzS9kKY2iBC4pZzMc3Vh
PTiSVGSDbZc12j7WBjcWIiyvBwYlEEi3ZY1RYG3/3CavQTqBh7pEAt64fJaNT1RV
aTk8B62kogs+VS1Fb+7gRurMZZJzIyVlxkVnFqDbGngvo1acat6Xz/3U/hVeJtRf
KL6SHwQe0Ou+vp/fs+DoDbxMUmT201Xmh3kM9+g5O2CI7p0cdM0gRIJTqB6DUi1b
pYeGb6GJbusDNiASGZY38OIRelc/YG2JY7ISkKYsqApiYI1l21PSFOZn9cXRH3TM
bz2nqeF9waWodv5I2VXIFgVtPdviLKAYT8lq9soqFldUgWhjb2Ga3j9p1zls/ep/
HKVpPYx0oggEwA/8yuQtYNbmdoy6jVIXeevuhUhdT/7uSYA7ZWtqWyaWfqWlCSEh
asl7g2KJWubVOTFj8v7MVNHlBKpFwlpCTWLF4cESRF+IoQ6kltZRJ0xT2S5xYRAz
lCilwmMQJqDNuPonluxqu84KDakOCoimfS/PeDhU2ElVMaGi3MqEVfHFUgZDOuzC
CSOrtSvFVS4sjrHIYR6FdVvuMMTsQwtUj6tQ8gg960/frxw8CE7hRpgp6BsZ8zxi
XknRx4jvci5+yEXX54ekwrG0bg0GN8L4fBKkYC+coZ1JptWOTQj+tyGp+xIY1eUH
YxzFFrP2pJ4GsY/yMYqQ
=hD/W
-----END PGP SIGNATURE-----
--=-=-=--
