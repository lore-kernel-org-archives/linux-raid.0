From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Re: [BUG] Raid5 trouble
Date: Wed, 17 Oct 2007 18:44:41 +0200
Message-ID: <47163BF9.304@systella.fr>
References: <4714BB92.7040701@systella.fr> <47161CE3.80909@systella.fr>	 <e9c3a7c20710170758p4046ca44labe370e94bca6e93@mail.gmail.com> <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20710170840u2ed8d6a9x26523eec6700ad11@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, sparclinux@vger.kernel.org
List-Id: linux-raid.ids

Dan Williams wrote:
> On 10/17/07, Dan Williams <dan.j.williams@intel.com> wrote:
>> On 10/17/07, BERTRAND Jo=EBl <joel.bertrand@systella.fr> wrote:
>>> BERTRAND Jo=EBl wrote:
>>>>     Hello,
>>>>
>>>>     I run 2.6.23 linux kernel on two T1000 (sparc64) servers. Each
>>>> server has a partitionable raid5 array (/dev/md/d0) and I have to
>>>> synchronize both raid5 volumes by raid1. Thus, I have tried to bui=
ld a
>>>> raid1 volume between /dev/md/d0p1 and /dev/sdi1 (exported by iscsi=
 from
>>>> the second server) and I obtain a BUG :
>>>>
>>>> Root gershwin:[/usr/scripts] > mdadm -C /dev/md7 -l1 -n2 /dev/md/d=
0p1
>>>> /dev/sdi1
>>>> ...
>>>         Hello,
>>>
>>>         I have fixed iscsi-target, and I have tested it. It works n=
ow without
>>> any trouble. Patches were posted on iscsi-target mailing list. When=
 I
>>> use iSCSI to access to foreign raid5 volume, it works fine. I can f=
ormat
>>> foreign volume, copy large files on it... But when I tried to creat=
e a
>>> new raid1 volume with a local raid5 volume and a foreign raid5 volu=
me, I
>>> receive my well known Oops. You can find my dmesg after Oops :
>>>
>> Can you send your .config and your bootup dmesg?
>>
>=20
> I found a problem which may lead to the operations count dropping
> below zero.  If ops_complete_biofill() gets preempted in between the
> following calls:
>=20
> raid5.c:554> clear_bit(STRIPE_OP_BIOFILL, &sh->ops.ack);
> raid5.c:555> clear_bit(STRIPE_OP_BIOFILL, &sh->ops.pending);
>=20
> ...then get_stripe_work() can recount/re-acknowledge STRIPE_OP_BIOFIL=
L
> causing the assertion.  In fact, the 'pending' bit should always be
> cleared first, but the other cases are protected by
> spin_lock(&sh->lock).  Patch attached.

	Dan,

	I have modified get_stripe_work like this :

static unsigned long get_stripe_work(struct stripe_head *sh)
{
         unsigned long pending;
         int ack =3D 0;
         int a,b,c,d,e,f,g;

         pending =3D sh->ops.pending;

         test_and_ack_op(STRIPE_OP_BIOFILL, pending);
         a=3Dack;
         test_and_ack_op(STRIPE_OP_COMPUTE_BLK, pending);
         b=3Dack;
         test_and_ack_op(STRIPE_OP_PREXOR, pending);
         c=3Dack;
         test_and_ack_op(STRIPE_OP_BIODRAIN, pending);
         d=3Dack;
         test_and_ack_op(STRIPE_OP_POSTXOR, pending);
         e=3Dack;
         test_and_ack_op(STRIPE_OP_CHECK, pending);
         f=3Dack;
         if (test_and_clear_bit(STRIPE_OP_IO, &sh->ops.pending))
                 ack++;
         g=3Dack;

         sh->ops.count -=3D ack;

         if (sh->ops.count<0) printk("%d %d %d %d %d %d %d\n",=20
a,b,c,d,e,f,g);
         BUG_ON(sh->ops.count < 0);

         return pending;
}

and I obtain on console :

  1 1 1 1 1 2
kernel BUG at drivers/md/raid5.c:390!
               \|/ ____ \|/
               "@'/ .. \`@"
               /_| \__/ |_\
                  \__U_/
md7_resync(5409): Kernel bad sw trap 5 [#1]

	If that can help you...

	JKB
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
