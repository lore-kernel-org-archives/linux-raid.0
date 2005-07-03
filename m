From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: RAID1: What happens when one half of a mirror fails?
Date: Sun, 03 Jul 2005 17:43:48 +0200
Message-ID: <42C807B4.4080701@weisshuhn.de>
References: <200506301024.13126.eric@pretorious.net>	 <42C44210.7010204@gw.unix-scripts.info>	 <200506301215.39271.eric@pretorious.net>  <42C44DD6.5060901@weisshuhn.de> <1120372864.3368.1.camel@raz-laptop>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig84AB6D31D45FB363C1587E9B"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1120372864.3368.1.camel@raz-laptop>
Sender: linux-raid-owner@vger.kernel.org
To: raz ben jehuda <razb@bitband.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig84AB6D31D45FB363C1587E9B
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

with current version 2.6 kernels there are no problems known to me not
to have swap and system raid partitions built out of partitions of the
same physical disks.
i didn't catch what you mean by "the kernel that removes the bad disk
from the operating system". if it means that it will trigger a swapoff
for the partition on the failed disk it is near to useless since at that
time already a irreversible data loss has happened which causes the
system to crash.
the only possibility to prevent a system crash during failure of a
harddisk is swapping to raid partitions.

raz ben jehuda wrote:
> i had a "system hanging" when both swap and root file system were on the
> raid. for that i added line in the kernel that removes the bad disk from
> the operating system. 
> On Thu, 2005-06-30 at 22:53, Frank Wittig wrote:
> 
>>Eric Pretorious wrote:
>>
>>>On Thursday 30 June 2005 12:03 pm, Laurent CARON wrote:
>>>
>>>
>>>>is the swap partition on raid?
>>>
>>>
>>>No. swap both swap partitions are formatted as standard swap partitions and mounted via /etc/fstab.
>>>
>>
>>That's no good idea. If a disk fails which contains a swap partition to
>>which data has been swapped the system will crash.
>>Therefor it is important to use mirrored partitions for swap.


--------------enig84AB6D31D45FB363C1587E9B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFCyAe4x6tzaD9P7mkRAuwHAJ0Wo4RpRO/4As9XQ6k/B8pYIZivyQCfdD+/
wiii0em0/h00DKd8znBMrbg=
=lICk
-----END PGP SIGNATURE-----

--------------enig84AB6D31D45FB363C1587E9B--
