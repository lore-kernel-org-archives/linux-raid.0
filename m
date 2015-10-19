From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 5/6] Check write journal in incremental
Date: Mon, 19 Oct 2015 13:32:34 +1100
Message-ID: <87io63lha5.fsf@notabene.neil.brown.name>
References: <1440804426-1461372-1-git-send-email-songliubraving@fb.com> <1440804426-1461372-6-git-send-email-songliubraving@fb.com> <CAPcyv4iYxLm1uoHM1Rrz7jyecrf+8Luby8CjmQwdK0Pvs6Ya+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPcyv4iYxLm1uoHM1Rrz7jyecrf+8Luby8CjmQwdK0Pvs6Ya+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>, Song Liu <songliubraving@fb.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Dan Williams <dan.j.williams@intel.com> writes:

> On Fri, Aug 28, 2015 at 4:27 PM, Song Liu <songliubraving@fb.com> wrote:
>> If journal device is missing, do not start the array, and shows:
>>
>> ./mdadm -I /dev/sdf
>> mdadm: journal device is missing, not safe to start yet.
>>
>> The array will be started when the journal device is attached with -I
>>
>> ./mdadm -I /dev/sdb1
>> mdadm: /dev/sdb1 attached to /dev/md/0_0, which has been started.
>>
>> To force start without journal device:
>>
>> ./mdadm -I /dev/sdf --run
>> mdadm: Trying to run with missing journal device
>> mdadm: /dev/sdf attached to /dev/md/0_0, which has been started.
>>
>> Signed-off-by: Shaohua Li <shli@fb.com>
>> Signed-off-by: Song Liu <songliubraving@fb.com>
>> ---
>>  Incremental.c | 31 +++++++++++++++++++++++++++----
>>  1 file changed, 27 insertions(+), 4 deletions(-)
>>
>> diff --git a/Incremental.c b/Incremental.c
>> index 304cc6d..74905e3 100644
>> --- a/Incremental.c
>> +++ b/Incremental.c
>> @@ -35,7 +35,7 @@
>>
>>  static int count_active(struct supertype *st, struct mdinfo *sra,
>>                         int mdfd, char **availp,
>> -                       struct mdinfo *info);
>> +                       struct mdinfo *info, int *journal_device_missing);
>>  static void find_reject(int mdfd, struct supertype *st, struct mdinfo *sra,
>>                         int number, __u64 events, int verbose,
>>                         char *array_name);
>> @@ -104,6 +104,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>>         struct map_ent target_array;
>>         int have_target;
>>         char *devname = devlist->devname;
>> +       int journal_device_missing = 0;
>>
>>         struct createinfo *ci = conf_get_create_info();
>>
>> @@ -518,7 +519,7 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>>         sysfs_free(sra);
>>         sra = sysfs_read(mdfd, NULL, (GET_DEVS | GET_STATE |
>>                                     GET_OFFSET | GET_SIZE));
>> -       active_disks = count_active(st, sra, mdfd, &avail, &info);
>> +       active_disks = count_active(st, sra, mdfd, &avail, &info, &journal_device_missing);
>>         if (enough(info.array.level, info.array.raid_disks,
>>                    info.array.layout, info.array.state & 1,
>>                    avail) == 0) {
>> @@ -548,10 +549,12 @@ int Incremental(struct mddev_dev *devlist, struct context *c,
>>         }
>>
>>         map_unlock(&map);
>> -       if (c->runstop > 0 || active_disks >= info.array.working_disks) {
>> +       if (c->runstop > 0 || (!journal_device_missing && active_disks >= info.array.working_disks)) {
>
> A minor comment, and I'd defer to Neil's opinion, but I think this is
> asking for mdu_array_info_t to grow a "journal_disks" attribute.

We definitely don't want to change mdu_array_info_t - that is part of
the kernel api.
But adding a 'journal_disks' field to 'struct mdinfo' might make sense.

Similarly, now that I look at it, the 'require_journal' method doesn't
look like such a good idea.
->getinfo_super should set some flag in 'struct mdinfo' if a journal is
required.

The Incremental() function might still have a local var called
journal_device_missing, but it wouldn't pass it to count_active().
count_active would just set ->journal_disks and then Incrmental would do
something like:

journal_device_missing = info.journal_needed && info.journal_disks == 0;

Song: can you see if making some changes like that works out?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWJFZCAAoJEDnsnt1WYoG5KPoQAI1RsP/5M9EAmcs7DQAzqNAw
V2+1FGmdoopYoMPbEXtgSnhHqch4f9Ji5F6Ck2W1cMNbmOzjDuioiVuUVC6CxOmQ
BBhFDT68zxxPRfDH7kT1uRJait8nIL504zP3s4Wrlodq7m3ZjME1WDSBcuwSp/T5
pHnAvZ/pbudFx8tqoWz8oMc5TF01kBhD4tvvjs7o82nyGJW1T+y1CXObX30HMuiF
iG95KLEPhLOeIURi+98Mi5xWXDx3aoqFO2GQfqoCK1aN8Gs9YdZ/XdcUx9QgxTUE
eysFvNOseq2kskEjU+6hv1K11ODaAZMsp1PnbwrQ7xg4Pfh/681GzjHaupq2RU4O
Wyr19TX7OYgO7AH+t+pw47nWsVBhlot4hCTFKzuDX02BJziDYBx2xRtsD1P4Phbf
bQ31c6JqaFcnP0EtJ3RV8XB9sDCov/wSlWBP71JkT4khUE1E6fpPZo7dJhBIwfoW
fkSPUpkTL4SCHRcuzZR8fAro0YqpxLcSgrjHKGeNEEx39ai0wnwgUdfU88shZEmn
Nxk74ZM92aB1aZIcfMlcXC1Ult3pijdidN1GgtCpDqy2mI5D3QBNBT0/P7CnYVqF
BMmav0huCAVToDqHuVKVTWD59KqzDOJ6MJGascOAYvyxdJo7je5EeXoTdsbWpoM4
yLVBapTE/FlR4PlhgvIE
=rSQj
-----END PGP SIGNATURE-----
--=-=-=--
