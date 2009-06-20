From: Wil Reichert <wil.reichert@gmail.com>
Subject: Re: filesystem stripe parameters
Date: Fri, 19 Jun 2009 17:26:35 -0700
Message-ID: <7a329d910906191726k7acde13ye5f3b3c2e76c6692@mail.gmail.com>
References: <7a329d910906181208t2f95d94bsc4eac2c5f20355f5@mail.gmail.com>
	 <4A3B573D.5020206@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A3B573D.5020206@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jun 19, 2009 at 2:15 AM, Michael Tokarev<mjt@tls.msk.ru> wrote:
> Wil Reichert wrote:
>>
>> When using LVM on top of RAID 5, is it still worthwhile to pass RAID
>> stripe information to the filesystem on creation? =C2=A0Or do the PE=
's in
>> LVM blur the specific stripe sizes & I'd want to use some multiple o=
f
>> those instead?
>
> It's a very good question, especially in context of RAID5.
>
> Yes it is still a good idea to pass that info because it is still a
> RAID5 which requires proper treatment wrt unaligned writes and keepin=
g
> redundancy.
>
> But the thing is that RAID5 and LVM are not good to each other UNLESS
> RAID5 consists of 3, 5 or 9 (or 17 etc) drives -- i.e. 2^N+1, so that
> there's 2^N data drives.
>
> This is because LVM can only have blocksize as a power of two and in
> order to be useful that blocksize should be a multiple of RAID5 data
> row size (stripe size etc).
>
> This is only possible when RAID5 has 2^N data drives or 2^N+1 total
> drives. =C2=A0The same is for RAID4, and for RAID6 it's 2^N+2 since R=
AID6
> has 2 parity drives.
>
> But if you can't match LVM blocksize and RAID strip size, there's
> *almost* no point at telling raid parameters to the filesystem: no
> matter how hard you'll try, LVM will make the whole thing non-optimal=
=2E
>
> Ok, depending on the number of drives, *some* logical volumes will
> be properly aligned, but definitely not all of them. =C2=A0For exampl=
e
> on a 4-drive RAID5 array, only every 3rd volume will be ok, --
> provided the volumes are allocated in full one after another,
> without holes and fragmentation.
>
> When everything is properly aligned, it's still worth the effort
> IMHO to tell the filesystem about true raid properties.

Several questions answered, more questions arise =3D)

I'm using 3 1T discs, so it seems I'm in luck.  My chunk size is 128k,
my PE size is the default 4M.  Using mkfs.ext4 as an example, it takes
stride (chunk) and stripe-width ( chunk * (N-1) ) parameters.  So
which would be optimal - using the RAID values (i.e. 128k, 256k) or
the LVM values (i.e. 4M, 8M) when creating the filesystem or is there
no right answer and it just depends on the usage pattern?

Wil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
