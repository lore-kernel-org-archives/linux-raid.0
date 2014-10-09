From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: Extremely High mismatch_cnt on RAID1 system
Date: Wed, 8 Oct 2014 22:17:25 -0500
Message-ID: <2F88B774-DFB1-4D5A-9424-190573BDA1C9@redhat.com>
References: <CAOWcSW5+8ZkWAyXL7VTk9JO+yrozFJS8RwroKqtudkiKD-fvXA@mail.gmail.com> <5433E72E.60805@shiftmail.org>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5433E72E.60805@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Oct 7, 2014, at 8:14 AM, Ethan Wilson <ethan.wilson@shiftmail.org> w=
rote:

> On 04/10/2014 15:46, Dennis Grant wrote:
>> Hello all.
>>=20
>> ...
>>=20
>> Even after multiple checks, repairs, and rebuilds, the arrays on the
>> bigger drives (/ and /home) are showing insanely high mismatch_cnt
>> values. This has me concerned.
>>=20
>=20
> Dennis,
> since nobody more knowledgeable replied, I will try.
>=20
> Some mismatches on raid1 have been there since always, and nobody eve=
r deeply investigated what they were caused by, nor if they happen on u=
nallocated filesystem space or on real live data. It seems that if LVM =
is between raid1 and the filesystem then they don't happen anymore, but=
 again nobody is really sure of why.
>=20
> Recently some changes in the raid1 resync algorithm introduced some b=
ugs that could possibly generate additional mismatches, but if you have=
n't had resyncs then I am not so sure if such bugs and their fixes are =
relevant. However the fixes are here:
> https://www.kernel.org/pub/linux/kernel/v3.x/ChangeLog-3.14.20
> search for "raid".
>=20
> You might want to upgrade to kernel 3.14.20, which is probably not wh=
at your Ubuntu LTS has currently, then repair the arrays, then see if t=
hey grow again.
> Note that you need to do repair and not check:
> echo repair > /sys/block/md0/md/sync_action
> at the next "check" the mismatch_cnt should be 0 (not just after "rep=
air", because that would count the number of mismatches that have been =
repaired).
>=20
> I'd say that mismatches in general are pretty worrisome, they shouldn=
't happen, they are likely to indicate corruption, so if what I said do=
esn't work, e.g. mismatches grow again, try to report it again on the l=
ist and somebody might be able to help further to track down this probl=
em.

The mismatches count can be incremented during operations other than ch=
eck and repair.  I believe its behavior also varies between RAID person=
alities.  However, if you check the =91last_sync_action=92 and see that=
 it was a =93check=94 operation, you are probably safe to assume that t=
he mismatch count has been computed correctly.

Note the following commit:
commit c4a39551451666229b4ea5e8aae8ca0131d00665
Author: Jonathan Brassow <jbrassow@redhat.com>
Date:   Tue Jun 25 01:23:59 2013 -0500

    MD: Remember the last sync operation that was performed

    MD:  Remember the last sync operation that was performed

    This patch adds a field to the mddev structure to track the last
    sync operation that was performed.  This is especially useful when
    it comes to what is recorded in mismatch_cnt in sysfs.  If the
    last operation was "data-check", then it reports the number of
    descrepancies found by the user-initiated check.  If it was a
    "repair" operation, then it is reporting the number of
    descrepancies repaired.  etc.

    Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
    Signed-off-by: NeilBrown <neilb@suse.de>

Relatedly, LVM makes use of the MD RAID personalities to provide its RA=
ID capabilities.  It does this by accessing MD through a thin device-ma=
pper target called "dm-raid=94 - not to be confused with the similarly =
named userspace application.  The above mentioned commit contains a cha=
nge to the dm-raid module as well, which causes it to report =910=92 mi=
smatches unless the =91last_sync_action=92 was a =93check=94.  So, for =
dm-raid (and by extension LVM) the ambiguity in mismatch_count is gone,=
 but the user must be careful when looking at the number for MD.

 brassow--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
