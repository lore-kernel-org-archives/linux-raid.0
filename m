From: Nikolay Kichukov <hijacker@oldum.net>
Subject: Re: data scrubbing
Date: Fri, 29 Jul 2011 16:25:39 +0300
Message-ID: <4E32B4D3.3030905@oldum.net>
References: <4E327445.9080404@oldum.net> <alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1107291200580.22537@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi,

This is a good to know!

Just performed a check on a raid1 and got:

Jul 29 15:37:36 hanna64 mdadm[2277]: RebuildFinished event detected on md device /dev/md1, component device  mismatches
found: 128

So I presume those mismatches have now been rewritten to both disks successfully. Am I wrong there?

cat /sys/block/md1/md/mismatch_cnt
128


Cheers,
- -Nik

On 07/29/2011 01:03 PM, Mikael Abrahamsson wrote:
> On Fri, 29 Jul 2011, Nikolay Kichukov wrote:
> 
>> For example is it good for raid1 array?
> 
> Yes, it's good for all raid levels that have any kind of redundancy. You want to read the information on the drives
> regularily to make sure it can still be read, and if it can't, it can be recomputed from parity and written.
> 
> Otherwise not-often-read data might have an error on one drive, and then another drive fails and now when you try to
> rebuild you don't have this data anywhere all of a sudden (RAID1 and RAID5), and you had no idea about this.
> 
> Scrubbing is good, do it regularily (at least monthly).
> 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBAgAGBQJOMrTTAAoJEDFLYVOGGjgXVPoH/0WDSWUhR8LvuaSizBBbbN48
iAWWsiA/fJr9DIO9+E1cTFXAqUOxsEY/iAJX7IVKAbS+R3/eYITHj0r6HajG3XnE
wiqY3hoJU79aGBNOtxwAH8QeNtdGooVxL6TW0TRNFr/PFbWiBc2Aj2/aFizuqPHE
EaYd1V02/i0wugWmGAFUAE81qG40jpuwq/B/KL18TDF8aayzj9T1PWLJh2QC3qJZ
ugj708g34+X7yWY7C5gWYjHoX13IbyU+hbaM1Yrt7z0wLBFw+VxtNFDeWvOI/7zn
E1c4DSmb4mAWL/CY8QlKP8oN5EkjS8o3VOz3UckkibiVqJw3X1msYZ52SY3UXeY=
=LfWV
-----END PGP SIGNATURE-----
