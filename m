From: Mike Hardy <mhardy@h3c.com>
Subject: Re: New RAID-5 800GB array, wich fs ? wich stripe block size ?
Date: Mon, 19 Jul 2004 14:05:45 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <40FC37A9.6060006@h3c.com>
References: <40FB923D.1080903@gouny.org> <40FC30C2.5050600@dobbels.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40FC30C2.5050600@dobbels.com>
To: Bernhard Dobbels <Bernhard@Dobbels.com>
Cc: =?ISO-8859-1?Q?Aur=E9lien_Gouny?= <aurelien@gouny.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


That was a tepid review at best! No offense :-)

=46WIW - I've got a 1.7TB RAID5 array that handles exactly the files yo=
u=20
describe (we're probably doing the same thing - networked media server,=
=20
right? With some other stuff on the side). In addition, it also handles=
=20
rsync backups for all the other machines using the --link-dest argument=
=20
and a rotations so it has an unbelievable amount of symlinks in the=20
filesystem.

I also have a 1.0TB RAID5 array in a separate machine that I use as a=20
backup for the main server, where all the media stuff gets backed up,=20
but I don't backup the backups since that would be silly, or overkill a=
t=20
least.

I just chose plain vanilla ext3 ('mke2fs -j -m1 /dev/md2') on top of=20
plain ol' raid 5. The only option that's different there is the "m1"=20
since with an enormous filesystem, reserving 5% of it for root use is a=
=20
bit silly.

With regard to performance, the first thing you'll notice is that unles=
s=20
you have gigabit to everywhere, you're limited by network I/O. I am=20
anyway. I could saturate a 100Mbit network connection with the read=20
speed, and after that, who cares?

Different filesystems will clearly be better for different situations,=20
but if you're just looking to serve files over the network you're reall=
y=20
not going to need to work hard to get it set up "good enough".

I will say though, I've had hardware failures and machine failures take=
=20
the array out before - remember that MTBF is divided by the number of=20
parts and arrays usually have lots of parts. Don't forget to backup=20
early and often...

-Mike

Bernhard Dobbels wrote:
> 800 GB in one filesystem is possible, but I think it'll make life eas=
ier=20
> if you have multiple partitions which you can mount wherever you want=
=2E
>=20
> Technically speaking, I prefer the LVM2 solution on which you can mak=
e=20
> and resize partitions on the fly.
>=20
> I must admit I lost my raid5 with LVM2. The cause will probably have=20
> been my fault, although I don't know what I did wrong, so I suggest i=
f=20
> you have critical data, a backup on another medium is still advised.
>=20
> Good luck.
>=20
> Bernhard
> Aur=E9lien Gouny wrote:
>=20
>> Hi all,
>>
>> I have a Promise SX6000 card and i juste have bought 6x160 GB HDs th=
at=20
>> make a 800 GB RAID-5 array.
>> I was wondering wich filesytem I should use=20
>> (ext3/reiserfs/xfs/jfs/...), if I should make one or more partitions=
=20
>> and wich stripe block size to use knowing that:
>>
>> - it will be mainly a file-server with mp3s, divx, pictures (1 to 4M=
B=20
>> each) and some files (openoffice, ...) all shared with Samba.
>> - it will have a small postgresql database
>>
>> If someone need more information in order to determine the stripe=20
>> block size or else, just ask ;)
>>
>> Thanks a lot, (sorry for bad english)
>> Aur=E9lien
>> -
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
