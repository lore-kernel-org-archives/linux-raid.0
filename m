From: Eivind Sarto <eivindsarto@gmail.com>
Subject: Re: raid1 data corruption during resync
Date: Tue, 2 Sep 2014 10:04:07 -0700
Message-ID: <4A2E98D8-5ADE-4CA3-B297-4170BC450819@gmail.com>
References: <20A5228D-DD63-4A6C-B2C6-B0C38996E636@gmail.com> <E16BE56A-06CE-4614-A663-D28730671108@redhat.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E16BE56A-06CE-4614-A663-D28730671108@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: Eivind Sarto <eivindsarto@gmail.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Sep 2, 2014, at 7:10 AM, Brassow Jonathan <jbrassow@redhat.com> wrot=
e:

> There is absolutely an issue with the mentioned commit.
>=20
> We are seeing symptoms of a different sort.  Our testing group is doi=
ng device fault testing.  (They are using LVM to create the RAID device=
s, but as you know, that uses the same underlying kernel code.)  We enc=
ounter situations where the resync thread is stuck waiting for a barrie=
r to come down, but it never does.  All I/O to the RAID1 device blocks.
>=20
> There are a few different variations to how the problem manifests its=
elf, but I have bisected the kernel to this commit (79ef3a8).
>=20
> Unfortunately, it does take quite some time (hours) to reproduce the =
issue with our test scripts.  I will try testing this proposed patch wh=
ile I try to figure out what the patch is doing and what might have gon=
e wrong.
>=20
> brassow
>=20
>=20
> On Aug 29, 2014, at 2:29 PM, Eivind Sarto wrote:
>=20
>> I am seeing occasional data corruption during raid1 resync.
>> Reviewing the raid1 code, I suspect that commit 79ef3a8aa1cb1523cc23=
1c9a90a278333c21f761 introduced a bug.
>> Prior to this commit raise_barrier() used to wait for conf->nr_pendi=
ng to become zero.  It no longer does this.
>> It is not easy to reproduce the corruption, so I wanted to ask about=
 the following potential fix while I am still testing it.
>> Once I validate that the fix indeed works, I will post a proper patc=
h.
>> Do you have any feedback?
>>=20
>> =97 drivers/md/raid1.c	2014-08-22 15:19:15.000000000 -0700
>> +++ /tmp/raid1.c	2014-08-29 12:07:51.000000000 -0700
>> @@ -851,7 +851,7 @@ static void raise_barrier(struct r1conf=20
>> 	 *    handling.
>> 	 */
>> 	wait_event_lock_irq(conf->wait_barrier,
>> -			    !conf->array_frozen &&
>> +			    !conf->array_frozen && !conf->nr_pending &&
>> 			    conf->barrier < RESYNC_DEPTH &&
>> 			    (conf->start_next_window >=3D
>> 			     conf->next_resync + RESYNC_SECTORS),
>>=20
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20

Yes, you are correct.  I think above patch would just return the resync=
 to the old implementation.
No resync-window.  Just either one of resync-IO or user-IO at any given=
 time for the entire array.
As I said, the comment in the resync code no longer matches the actual =
implementation.

-eivind--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
