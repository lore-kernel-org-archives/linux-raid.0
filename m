From: hank peng <pengxihan@gmail.com>
Subject: Re: how to decrease raid5 write penalty in my case?
Date: Fri, 4 Jun 2010 13:39:04 +0800
Message-ID: <AANLkTilq9StTyhL9SareB2e6e10d-8DYQKlcbvskliwW@mail.gmail.com>
References: <AANLkTin2zcAMc_grkvJ3rwz4BVtPt2Y0RE9mFyFyX6aW@mail.gmail.com>
	<alpine.DEB.1.10.1006040645230.8623@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1006040645230.8623@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2010/6/4 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Fri, 4 Jun 2010, hank peng wrote:
>
>> I created a raid5 array which consists of 4 SATA disks, then I make =
a
>> XFS on it. Now, I pre-allocate a file using posix_fallocate, its siz=
e
>> is 512MB. So I think the file space allocated by file system is
>> sequential. After that , I am filling data into this file from the
>> start position, for example, every time I write 64KB data, but there
>> are 1 seconds interval between two writes.
>>
>> As for RAID5 layer in kernel, due to the 1s interval between writes,
>> extra read operation(write penalty) maybe caused although the
>> following writes is sequential in this file's space.
>> So, in my case, is there some parameters to adjust in order to
>> decrease this kind of write penalty? Can we tell raid5 layer to dela=
y
>> the read operation for that stripe parity computation because we kno=
w
>> that the following writes start at the previous writes's end point?
>
> Please verify that the reads are actually taking place for instance b=
y using
> "iostat -x 5". I'd imagine the first write will cause reads, but afte=
r that
> the whole stripe is going to be in the block cache and thus you avoid=
 any
> other reads for that stripe (you'll of course still have to do the wr=
ites to
> disk).
yes, I have used iostat and find that there is no read on /dev/md0 but
on the member disks.

write(64K) .. 1s .. write(64K) ..1s .. write(64K) .. 1s ..
write(64K).. 1s .. write(64K) ..1s .. write(64K) .. 1s .. write(64K)

this is my usage pattern.

>
> Also, why do you worry about the read operations, unless this is comb=
ined
> with a lot of other IO, I don't see how your above usage pattern woul=
d cause
> any problems?
>
> --
> Mikael Abrahamsson =C2=A0 =C2=A0email: swmike@swm.pp.se
>



--=20
The simplest is not all best but the best is surely the simplest!
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
