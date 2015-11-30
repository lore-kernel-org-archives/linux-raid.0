From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 2/3] md-cluster: introduce clear_clusterinfo_from_sb
Date: Mon, 30 Nov 2015 12:08:00 +1100
Message-ID: <87h9k45m6n.fsf@notabene.neil.brown.name>
References: <1448008525-17095-1-git-send-email-gqjiang@suse.com> <1448008525-17095-2-git-send-email-gqjiang@suse.com> <87y4dk577c.fsf@notabene.neil.brown.name> <5657F227.3030202@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5657F227.3030202@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>
Cc: rgoldwyn@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Nov 27 2015, Guoqing Jiang wrote:

> Hi Neil,
>
> On 11/27/2015 01:42 PM, NeilBrown wrote:
>> On Fri, Nov 20 2015, Guoqing Jiang <gqjiang@suse.com> wrote:
>>
>>> To change the bitmap from clustered to none, we also
>>> need to clean related info about cluster from sb, such
>>> as version, nodes and cluster_name.
>> I've applied the other two (though I removed the __func__ and __LINE__
>>  From error messages - they are just noise: the source of the message can
>> easily be found with out them - I should remove all the others).
>>
>> However I haven't applied this because there doesn't seem to be any
>> point.
>> Once your told that main md superblock that there is no bitmap, it
>> doesn't really matter what data is in the superblock of that
>> non-existent bitmap - it will never be looked at.  Will it?
> mdadm could still get nodes and cluster_name after change
> bitmap to none, so some cmds like "mdadm -X /dev/sda" could
> still see clustered info, it seems a little confused for user.

In that case we should fix mdadm to not report a bitmap if
MD_FEATURE_BITMAP_OFFSET isn't set (though maybe still report it if
--force is given).

i.e. if this is an issue, it is not specific to clustered-bitmaps.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWW6FwAAoJEDnsnt1WYoG5K2AQAJKUXKWX+k3O6vsYr5VdU4bW
MubOMUeY/s4lxtlnJ09VDOSQlBmfjL234yiwrXLkboNb6lBIPkLwDq4b2Si9d+JZ
xGKM86snvvHxXrRFcSRfQuXWd7TTZPXVPceZ7b26xXGsXozbWCaxqDphha3Uvxcs
Mo0UgcZTT7NqlnGB8tdC1E2QPCD0uOVFZq3AV6FN5Cc1Z7CifjPYJZykDE8G/lm/
Yea3QBkq84MP1d4HOxPPPVIgwPAhoVhH1nH4/opieItQR+fPr43VlcOaWn9DWPYJ
J9tkIefDqGczr4jhR6YmInlYmQUtPP+fN7qi9EYhEJsPWMma2ttHKpkKr/HZXVX1
3I+q1ha9T2vfQT51Hk18ndYXdJDpOjIr//FtLWRijQNUkXdEClVvne+TXnLKv6tD
Hv+kEE2+tlC/LM1IPYa/iMBuHQK1X+EBk2M6AUiBnJdRtRsaW8uhb8+OXwPVv4s8
PjWmH8/WFYy3/iJf0WhlzEnROVbZkE6mUj4SfpOjuoUaebxZKHpYQYYkdFQe0+Mt
uxr52fIBs4dJl85CQFDjma1f2XoTWVa90TWnextGj/93M3ijgPGOq6eTvKhVN79p
mN6clkjWDjiMrPjQxq0ujLTztvaNtm7FKHEMQdzaRK/96eyV7ru6czLumAyFnsdf
K3oyvGyBSoJbYIBh5gCP
=yFGg
-----END PGP SIGNATURE-----
--=-=-=--
