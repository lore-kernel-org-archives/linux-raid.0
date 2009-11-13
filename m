From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: OOPS on MPC8548 board when writing RAID5 array
Date: Thu, 12 Nov 2009 18:36:58 -0700
Message-ID: <e9c3a7c20911121736ma9f8d72waa377c4b61b2f480@mail.gmail.com>
References: <389deec70911100344j5969e834nc80a9fd330935ef3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org>
In-Reply-To: <389deec70911100344j5969e834nc80a9fd330935ef3@mail.gmail.com>
List-Unsubscribe: <https://lists.ozlabs.org/options/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=unsubscribe>
List-Archive: <http://lists.ozlabs.org/pipermail/linuxppc-dev>
List-Post: <mailto:linuxppc-dev@lists.ozlabs.org>
List-Help: <mailto:linuxppc-dev-request@lists.ozlabs.org?subject=help>
List-Subscribe: <https://lists.ozlabs.org/listinfo/linuxppc-dev>,
	<mailto:linuxppc-dev-request@lists.ozlabs.org?subject=subscribe>
Sender: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
Errors-To: linuxppc-dev-bounces+glppd-linuxppc64-dev=m.gmane.org@lists.ozlabs.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, linuxppc-dev@ozlabs.org, Suresh Vishnu <Vishnu@freescale.com>
List-Id: linux-raid.ids

Hi Hank,

Thanks for testing.

On Tue, Nov 10, 2009 at 4:44 AM, hank peng <pengxihan@gmail.com> wrote:
> CPU is MPC8548, kernel version is 2.6.31.5,CONFIG_FSL_DMA and
> CONFIG_ASYNC_TX_DMA options are all enabled.
> #mdadm -C /dev/md0 --assume-clean -l5 -n3 /dev/sd{a,b,c}
> #dd if=3D/dev/zero of=3D/dev/md0 bs=3D1M count=3D1000
> Oops: Exception in kernel mode, sig: 5 [#1]
> MPC85xx CDS
> Modules linked in:
> NIP: c01c45d8 LR: c01c4d48 CTR: 00000000
> REGS: c2dd5c80 TRAP: 0700 =A0 Not tainted =A0(2.6.31.5)
> MSR: 00029000 <EE,ME,CE> =A0CR: 22004028 =A0XER: 00000000
> TASK =3D e820a580[3804] 'md0_raid5' THREAD: c2dd4000
> GPR00: 00000001 c2dd5d30 e820a580 c2fb1088 00000001 00000000 00000002 000=
01000
> GPR08: 00000001 c0485a20 00000000 ef8092f8 22002024 55555555 c2d67870 c02=
82d2c
> GPR16: 00001000 e8355c00 c2eff964 00000000 00000000 00000019 01000040 c2d=
d5e00
> GPR24: c2dd5dfc 00000001 c2dd5dc0 c099c420 00000000 c2d67838 00000002 c2d=
d5d58
> NIP [c01c45d8] async_tx_quiesce+0x28/0x74
[..]
> I checked the kernel source code, and find that this OOPS was caused
> by the following BUG_ON code:
> It is in crypto/async_tx/async_tx.c:
> void async_tx_quiesce(struct dma_async_tx_descriptor **tx)
> {
> =A0 =A0 =A0 =A0if (*tx) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* if ack is already set then we cannot be=
 sure
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * we are referring to the correct operati=
on
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0BUG_ON(async_tx_test_ack(*tx));
> =A0 /* OOPS occured */

Yes, this looks like a manifestation of the issue I brought up in my
review of the driver [1].  The talitos_prep_dma_xor routine is always
acknowledging its descriptors, which it should not because that is the
responsibility of the client of the api.  When the raid code tries to
attach a memcpy that depends on the xor it sees that it needs to
switch to from talitos to fsldma (or software if fsldma is turned
off).  Since talitos does not have the DMA_INTERRUPT capability to
trigger the channel switch we need to perform a synchronous wait for
the xor to complete before submitting the memcpy.  When the ack bit is
not set the xor descriptor might be recycled by the dma device driver
while we are waiting for it, hence the BUG_ON().

--
Dan

See the final comment:
[1]: http://marc.info/?l=3Dlinux-raid&m=3D125685641412112&w=3D2
