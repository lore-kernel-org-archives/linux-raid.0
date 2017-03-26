From: NeilBrown <neilb@suse.com>
Subject: Re: constant array_state active after specific jobs
Date: Mon, 27 Mar 2017 09:42:29 +1100
Message-ID: <87lgrr8xt6.fsf@notabene.neil.brown.name>
References: <20170323104643.6cca7986@hal9.pdi.lan> <8737e39rg0.fsf@notabene.neil.brown.name> <20170324090442.3d01347b@hal9.pdi.lan>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170324090442.3d01347b@hal9.pdi.lan>
Sender: linux-raid-owner@vger.kernel.org
To: pdi <pdi@otenet.gr>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Mar 24 2017, pdi wrote:

> On Fri, 24 Mar 2017 16:25:35 +1100
> NeilBrown <neilb@suse.com> wrote:
>
>> On Thu, Mar 23 2017, pdi wrote:
>>=20
>> > Greetings all,
>> >
>> > The problem in a nutshell is that an array is clean after boot,
>> > until some specific jobs switch it to active where it remains until
>> > reboot.
>> >
>> > A similar problem was discussed, and solved, in=20
>> > https://www.spinics.net/lists/raid/msg46450.html. However, AFAICT,
>> > it is not the same issue.
>> >
>> > I would be grateful for any insights as to why this happens and/or
>> > how to prevent it.
>> >
>> > The relevant info follows, please let me know if anything further
>> > might help.
>> >
>> > Many thanks in advance.
>> >
>> > - uname -a
>> >   Linux hostname 4.4.38 #1 SMP Sun Dec 11 16:03:41 CST 2016 x86_64
>> >   Intel(R) Core(TM)2 Duo CPU E8400 @ 3.00GHz GenuineIntel GNU/Linux
>> > - mdadm -V
>> >   mdadm - v3.3.4 - 3rd August 2015
>> > - Desktop drives without sct/erc,
>> >   with timeout mismatch correction as per
>> >   https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>> > - /dev/md9 is a raid10 array, 4 devices, far=3D2,
>> >   with various dirs used as samba and nfs shares
>> > - The array is in *constant* array_state active
>> > - mdadm -D /dev/md9 | grep 'State :'
>> >   State : active
>> > - cat /sys/block/md9/md/array_state
>> >   active
>> > - watch -d 'grep md9 /proc/diskstats'
>> >   remain unchanged
>> > - uptime
>> >   load average: 0.00, 0.00, 0.00
>> > - cat /sys/block/md9/md/safe_mode_delay
>> >   0.201
>> > - echo 0.1 > /sys/block/md9/md/safe_mode_delay
>> >   array_state remains active
>> > - echo clean > /sys/block/md9/md/array_state
>> >   echo: write error: Device or resource busy
>> > - reboot (with or without prior check)
>> >   array_state clean
>> > - After reboot, array remains clean until some specific
>> >   jobs put it in constant active state. Such jobs so far
>> >   identified:
>> >   - echo check > /sys/block/md9/md/sync_action
>> >   - run an rsnapshot job
>> >   - start a qemu/kvm vm
>> > - Other jobs, like text/doc editing, multimedia playback,
>> >   etc retain array_state clean=20=20
>>=20
>> This bug was introduced by
>> Commit: 20d0189b1012 ("block: Introduce new bio_split()")
>> in 3.14, and fixed by
>> Commit: 9b622e2bbcf0 ("raid10: increment write counter after bio is
>> split") in 4.8.
>>=20
>> Maybe the latter patch should be sent to -stable ??
>>=20
>> NeilBrown
>
> NeilBrown, thank you for your swift and concise answer.
>
> I gather you are referring to kernel version numbers. The described
> behaviour was first noticed many months ago with kernel 2.6.37.6, and
> persisted after a system upgrade and kernel 4.4.38. However, after the
> upgrade two things were corrected, the timeout mismatch, and a
> Current_Pending_Sector in one of the drives; which may, or may not,
> explain the occurrence with the older kernel.
>
> Is this constant active state in the data array something to worry about
> and try kernel >=3D 4.8, or shall I let be?

The only important consequence of the constant active state is that if
your machine crashes at a moment when the array would otherwise have
been idle, then a resync will be needed after reboot.  Without the
constant active state, that resync would not have been needed.

If you have a write-intent bitmap, this is not particularly relevant.

I cannot say how important it is to you to avoid a resync after a crash,
so I don't know if you should just let it be or not.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljYQ9UACgkQOeye3VZi
gbnvJQ/+OQATNDEG6m4hK8EIPXuRQxjBlcH4oHjO2q6HhPNDChObTFF6FSOnOpny
HR9S4BNVUgObzhqcYL2/iag3vrqvV6kQ82EQ8snkyUY2Y70zLolt0Vcdzqw1dBc8
TqVdj43z7wCIr6dTLhTvi9OiYsMuJvPTCd3J5zRAHPghZzP6xeRrliAsZOcUcp2x
h5ho0eCk9TCADrgObdA5XP6SGy8suQPEdAeowy44u1Exbw7tQguXb6aWrTORYi1Z
xtF8jt4idO6O3sYUWM5otQz95bR4UXpt3Gr0uKyzQWLBT9iE1etuMCs3QIvezFjd
FqZZ0KBxwcjVttIywFqHhSV0cr5Mp1cHhZHvObX20gIo32rGxur4ti0gV7swV7HL
lhIPo2pjrPDIBC5gxaCxPHtjlqY3brPzdxpjqCcsZKi4GnltWPoRWOFGULH9Jgcm
gMupfhVy9shpRSZIiRgqAAFBLdpZr/2tKh5WYPNDBB5SWSjE7WGNMni+8scVtdf7
j/zZ+2uzobFWDnWPCQDJ5C8H/JuitR009nV6S35j07HZyepI8jDXBW0IOtz8ZbAq
8NwyVQS8GsEenmLLf22XaH4mjnHXgjmTqaoz/9uSFO5jQBlDF6q+aeQiNM6ATbz4
7gEtIYktjfDjUTn2OE5jAL9JP+ysk0ZiMjo9RBuzjHJEXZLH4Jw=
=YsYC
-----END PGP SIGNATURE-----
--=-=-=--
