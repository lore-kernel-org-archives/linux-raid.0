From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid1 repair does not repair errors?
Date: Mon, 03 Feb 2014 21:46:48 +0400
Message-ID: <52EFD608.6020106@msgid.tls.msk.ru>
References: <52EE3910.3040205@msgid.tls.msk.ru> <20140203120431.400a8a1b@notabene.brown> <20140203153644.4c530672@notabene.brown> <52EF45A0.3010401@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EF45A0.3010401@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

03.02.2014 11:30, Michael Tokarev =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> 03.02.2014 08:36, NeilBrown wrote:
> []
>> Actually I've changed my mind.  That patch won't fix anything.
>> fix_sync_read_error() is focussed on fixing a read error on ->read_d=
isk.
>> So we only set uptodate if ->read_disk succeeded.
>>
>> So this patch should do it.
>>
>> NeilBrown
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index fd3a2a14b587..0fe5fd469e74 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1733,7 +1733,8 @@ static void end_sync_read(struct bio *bio, int=
 error)
>>  	 * or re-read if the read failed.
>>  	 * We don't do much here, just schedule handling by raid1d
>>  	 */
>> -	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
>> +	if (bio =3D=3D r1_bio->bios[r1_bio->read_disk] &&
>> +	    test_bit(BIO_UPTODATE, &bio->bi_flags))
>>  		set_bit(R1BIO_Uptodate, &r1_bio->state);
>> =20
>>  	if (atomic_dec_and_test(&r1_bio->remaining))
>>
>=20
> I changed it like this for now:
>=20
> --- ../linux-3.10/drivers/md/raid1.c	2014-02-02 16:01:55.003119836 +0=
400
> +++ drivers/md/raid1.c	2014-02-03 11:26:59.062845829 +0400
> @@ -1634,8 +1634,12 @@ static void end_sync_read(struct bio *bi
>  	 * or re-read if the read failed.
>  	 * We don't do much here, just schedule handling by raid1d
>  	 */
> -	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> -		set_bit(R1BIO_Uptodate, &r1_bio->state);
> +	if (bio =3D=3D r1_bio->bios[r1_bio->read_disk]) {
> +	    if (test_bit(BIO_UPTODATE, &bio->bi_flags))
> + 		set_bit(R1BIO_Uptodate, &r1_bio->state);
> +	    else
> +		printk("end_sync_read: our bio, but !BIO_UPTODATE\n");
> +	}
>=20
>  	if (atomic_dec_and_test(&r1_bio->remaining))
>  		reschedule_retry(r1_bio);
>=20
> and will test it later today (in about 10 hours from now) -- as I
> mentioned, this is a prod box and testing isn't possible anytime.

Hm. With this change, there's nothing interesting in dmesg at all anymo=
re:

[  100.571933] md: requested-resync of RAID array md1
[  100.572430] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[  100.573041] md: using maximum available idle IO bandwidth (but not m=
ore than 200000 KB/sec) for requested-resync.
[  100.574135] md: using 128k window, over a total of 2096064k.
[  202.616277] ata6.00: exception Emask 0x0 SAct 0x7fffffff SErr 0x0 ac=
tion 0x0
[  202.617035] ata6.00: irq_stat 0x40000008
[  202.617439] ata6.00: failed command: READ FPDMA QUEUED
[  202.617980] ata6.00: cmd 60/80:c0:00:3e:3e/00:00:00:00:00/40 tag 24 =
ncq 65536 in
[  202.617980]          res 41/40:00:23:3e:3e/00:00:00:00:00/40 Emask 0=
x409 (media error) <F>
[  202.619631] ata6.00: status: { DRDY ERR }
[  202.620077] ata6.00: error: { UNC }
[  202.622692] ata6.00: configured for UDMA/133
[  202.623182] sd 5:0:0:0: [sdd] Unhandled sense code
[  202.623693] sd 5:0:0:0: [sdd]
[  202.624011] Result: hostbyte=3DDID_OK driverbyte=3DDRIVER_SENSE
[  202.624600] sd 5:0:0:0: [sdd]
[  202.624929] Sense Key : Medium Error [current] [descriptor]
[  202.625576] Descriptor sense data with sense descriptors (in hex):
[  202.626249]         72 03 11 04 00 00 00 0c 00 0a 80 00 00 00 00 00
[  202.627276]         00 3e 3e 23
[  202.627722] sd 5:0:0:0: [sdd]
[  202.628049] Add. Sense: Unrecovered read error - auto reallocate fai=
led
[  202.628773] sd 5:0:0:0: [sdd] CDB:
[  202.629135] Read(10): 28 00 00 3e 3e 00 00 00 80 00
[  202.629907] end_request: I/O error, dev sdd, sector 4079139
[  202.630513] ata6: EH complete
[  205.219181] md: md1: requested-resync done.

So my printk is not called, and it still does not try to recover
the error.

So the first condition in that new if -- bio =3D=3D r1_bio->bios[r1_bio=
->read_disk] --
is not true.

So it is - apparently - a wrong guess... ;)

BTW, just in case, -- this is a raid1 with 4 drives (yes, 4 copies of
the same data), not a "usual" 2 disk.

I can test something in next 2..3 hours, next test will be possible
only tomorrow.

Thanks,

/mjt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
