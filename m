From: NeilBrown <neilb@suse.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Tue, 21 Mar 2017 13:38:14 +1100
Message-ID: <87a88fcq21.fsf@notabene.neil.brown.name>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com> <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com> <87d1djdz8y.fsf@notabene.neil.brown.name> <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com> <CAAZLhTcoU232uBs2zcK6TFj67Jru5oeNE_F0T2fQR6Un66OPXA@mail.gmail.com> <87lgs0cy0e.fsf@notabene.neil.brown.name> <CAAZLhTcNsjzLdEZyzG+kEuDhVye8pnuf6VhWzP=G0NL_aFX-5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAZLhTcNsjzLdEZyzG+kEuDhVye8pnuf6VhWzP=G0NL_aFX-5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alfred Matthews <asm13243546@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Mar 20 2017, Alfred Matthews wrote:

>>> *** Checking Backup Volume Header:
>>> Unexpected Volume signature '  ' expected 'H+'
>>
>> Here the backup volume header, which is 2 blocks (blocks are 8K) from
>> the end of the device, looks wrong.
>> This probably means the chunk size is wrong.
>> I would suggest trying different chunksizes, starting at 4K and
>> doubling, until this message goes away.
>> That still might not be the correct chunk size, so I would continue up
>> to several megabytes and find all the chunksizes that seem to work.
>> Then look at what else hpfsck says on those.
>
> I'm not actually able to generate happy output in hpfsck using any of
> the following multiples of 4K
>
> 4
> [...]
> 8192
> 16384
> 32768
> 65536
> 131072
> 262144
> 524288
> 1048576
> 2097152
>
> Any chance it's not really an HFS system at all?

Not likely.  hpfsck finds a perfectly valid superblock (or "Volume
Header") at the start of the device.  It just cannot find the end one.

The blocksize is:
     blocksize       : 2000

which is in HEX, so 8K.
The total_blocks is:
     total_blocks    : 732482664

which are 8K blocks, so 5859861312K or 5.4TB (using 1024*1024*1024).
which matches the fact that each partition is 2.73TB.

The problem seems to be that we are not combining the two partitions
together in the correct way to create the original 5.4TB partition.

All we know is that the backup volume header should look
much like the main header, and particularly should have 'H+' in the
signature, which is the first 2 bytes.
i.e. the first two bytes of the volume headers should be
0x4A2B

The second (8K) block of the disk must look like this, and
the second last should as well.
If you can search through both devices for all 8K blocks which
start with 0x4A2B, that might give us a hint what to look for.
I would write a C program to do this.  I might take a while to run, but
you can test on the first device, as you know block 2 matches.


Hmmm... I've got a new theory.  The code is broken.
fscheck_read_wrapper() in libhfsp/src/fscheck.c should set
vol->maxblocks.
It is set to a dummy value of '3' before this is called.
In the "signature == HFS_VOLHEAD_SIG" it sets it properly,
but in the "signature == HFSP_VOLHEAD_SIG" case (which applies to you)
it doesn't.
So it tries to read the backup from block "3-2", or block 1.  And there
is nothing there.

How is your C coding?  You could
  apt-get source hfsplus
and hack the code and try to build it yourself....


NeilBrown



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljQkhYACgkQOeye3VZi
gbmnIQ//VH+NJXH8QOS9BxF90jk4O2NffwKqlNbnXsNjxALH3xs2fVn/frUhwrKB
39uAR5S4xjtQ/JrJZTUw0N8KKol2TIIjzzR6Ngu3MhBRws7AciOQBkIZjVmItEl5
FD+6Inn6H2c+TZaSNNzem8pXtaCjS3TGItGzVitIlAGj3vKF/+blMBRkZOd0Y1AJ
5vYJBWZGNX0BkK0nvulDWDZf/9UGpQuruhza3406yaPN2kGDj7M9si6qdW5qpHGJ
nCQzyumrJPXSw3XMZk5c5AVoRiwacIvh46BwHebpxPA2/+wcEq2wq580BsqjT02Y
l2Br5N1O+BEFSM/XF1fbrPrRRjGzlvu/DYnIWqQFkXC3VqhS21CQRa3X/c5VoPa0
qSpDQInSY3X1+RTybbUFHLgWL0f8rN2mzgxYTAwdD6vVmgQa9K81I4Gzgn2AjoSA
/BG2MvwXZ+fnkTTr425I4B3/YY6qqiphgFkm6SWiiykXBwusxl+s+ZxjAAfdAorq
BKCu5D/DxsHb1ts3O8T1aBPlCJ1IskQN4M0cEJhcVeJg6H8GeJ+Y9xCfbbKP7TCK
pUwREnHeDXMtrL99gqSa7fyoMCt0MELkoQ2vOLq1y66+siQ61kKk1uzQeqsx0XPG
qBgDIHjfyLAqSWhS/RdG1T6fiFsSnQAust9UQtRPYolh7eYoyDc=
=3FmX
-----END PGP SIGNATURE-----
--=-=-=--
