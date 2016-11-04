From: NeilBrown <neilb@suse.com>
Subject: Re: Panicked and deleted superblock
Date: Fri, 04 Nov 2016 15:34:24 +1100
Message-ID: <87h97nq2wf.fsf@notabene.neil.brown.name>
References: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0e68051d-1008-cf9b-1f8f-0a0736b1c58f@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Hoffmann <Hoffmann.P@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, Oct 31 2016, Peter Hoffmann wrote:

> My problem is the result of working late and not informing myself
> previously, I'm fully aware that I should have had a backup, be less
> spontaneous and more cautious.
>
> The initial situation is a RAID-5 array with three disks. I assume it to
> look follows:
>
> | Disk 1   | Disk 2   | Disk 3   |
> |----------|----------|----------|
> |    out   | Block 2  | P(1,2)   |
> |    of    | P(3,4)   | Block 4  |	degenerated but working
> |   sync   | Block 5  | Block 6  |

The default RAID5 layout (there a 4 to choose from) is
#define ALGORITHM_LEFT_SYMMETRIC	2 /* Rotating Parity N with Data Continuation */

The first data block on a stripe is always located after the parity
block.
So if data is D0 D1 D2 D3.... then

   D0   D1   P01
   D3   P23  D2
   P45  D4   D5

>
>
> Then I started the re-sync:
>
> | Disk 1   | Disk 2   | Disk 3   |
> |----------|----------|----------|
> | Block 1  | Block 2  | P(1,2)   |
> | Block 3  | P(3,4)   | Block 4  |   	already synced
> | P(5,6)   | Block 5  | Block 6  |
>                . . .
> |    out   | Block b  | P(a,b)   |
> |    of    | P(c,d)   | Block d  |	not yet synced
> |   sync   | Block e  | Block f  |
>
> But I didn't wait for it to finish as I actually wanted to add a fourth
> disk and so started a grow process. But I just changed the size of the
> array, I didn't actually add the fourth disk (don't ask why I cannot
> recall it). I assume that both processes - re-sync  and grow - raced
> through the array and did their job.

So you ran
  mdadm --grow /dev/md0 --raid-disks 4 --force

???
You would need --force or mdadm would refuse to do such a silly thing.

Also, the kernel would refuse to let a reshape start while a resync was
on-going, so the reshape attempt should have been rejected anyway.

>
> | Disk 1   | Disk 2   | Disk 3   |
> |----------|----------|----------|
> | Block 1  | Block 2  | Block 3  |
> | Block 4  | Block 5  | P(4,5,6) |	with four disks but degenerated
> | Block 7  | P(7,8,9) | Block 8  |
>                . . .
> | Block a  | Block b  | P(a,b)   |
> | Block c  | P(c,d)   | Block d  |	not yet grown but synced
> | P(e,f)   | Block e  | Block f  |
>                . . .
> |    out   | Block V  | P(U,V)   |
> |    of    | P(W,X)   | Block X  |		not yet synced
> |   sync   | Block Y  | Block Z  |
>
> And after running for a while - my NAS is very slow (partly because all
> disks are LUKS'd), mdstat showed around 1GiB of Data processed - we had
> a blackout. Water dropped in a distribution socket and *poff*. After a
> reboot I wanted to resemble everything, didn't know what I was doing so
> the RAID superblock is now lost and I failed to reassemble (this is the
> part I really can't recall, I panicked). I never wrote anything to the
> actual array so I assume, better hope that no actual data is lost.

So you deliberately erased the RAID superblock?  Presumably not.
Maybe you ran "mdadm --create ...." to try to create a new array?  That
would do it.

If the reshape hadn't actually started, then you have some chance of
recovering your data.  If it had, then recovery is virtually impossible
because you don't know how far it got.

>
> I have a plan but wanted to check with you before doing anything stupid
> again.
> My idea is to look for that magic number of the ext4-fs to find the
> beginning of Block 1 on Disk 1, then I would copy an reasonable amount
> of data and try to figure out how big Block 1 and hence chunk-size is -
> perhaps fsck.ext4 can help do that? After that I copy another reasonable
> amount of data from Disks 1-3 to figure out the border between the grown
> Stripes and the synced Stripes. And from there on I'd have my data in a
> defined state from which I can save the whole file system.
> One thing I'm wondering is if I got the layout right. And the other
> might be rather a case for the ext4-mailing list but I'd ask it anyway:
> how can I figure where the file system starts to be corrupted?

You might be able to make something like this work .. if reshape hadn't
started.  But if you can live without recovering the data, then that is
probably the more cost effective option.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYHA/QAAoJEDnsnt1WYoG59ZsQALCPnB795jvUV6D+L/Qvk5qq
jRAqrMKsnfwhGS8zUCvxXtgxZHA3k9bo78RfXLELeHc8XMXC3UxwVdezzh9MnGeI
qyHvhKkm7iYmv01RK0EiYSCVnZTuXOgV22XToCkYKhZgp33iyKJG3HWGfo3WtFCc
qoEQlN28VKgijifMzLgWEeHgcWz6vfz5rxXxUEelgJ2elvEKiMQO+y8qQP+jWER2
dwanYmfwBJXonwSclcALlqqe+zd51mwbMRL+ecMBrdMg1YWgS49FvfrXccI7JrwP
H0twFEi0oPebJJ7ZrHHINrfuTNiKWHElPB/8BYenVHMknKusXlpLU1T9AKBSYEx2
7e94MQ6fYIQIH4yHpWthcYMeKmytAGRTj35HMuDPrkhC7xH9P34RvkkDCzRoefN2
LiUX99KheUW/5lXvrOariA7iQq8zlWg99fm8Ovj6T1sUzoSnSFLPq6BqsHV4eg4E
K2aGgJHl4FFAjWzYGex6IuNsvFGVQW/SCr2CVM3ZlCNgj/c5AR3gVdjmm26vLZh8
siMjLftQB2uJo+Rg2kKoyDlk/Jv5ddXxVtaBVqrkJlkDDq05Iopw+PScBlY6Wd99
XjeyxYRKagXKR+rFaMZ3QSflKQaQaCFXZR87hIuc8vBMM+whc8rmtfG+jcS9Vzav
nyG+oZ+JL8vhRmf1tp2F
=3hZu
-----END PGP SIGNATURE-----
--=-=-=--
