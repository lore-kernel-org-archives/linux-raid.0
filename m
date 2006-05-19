From: Per Lindstrand <mail@perlindstrand.com>
Subject: Re: Raid5 resize "testing opportunity"
Date: Fri, 19 May 2006 22:11:44 +0200
Message-ID: <446E2680.9070905@perlindstrand.com>
References: <20060501152229.18367.patches@notabene>	<200605021938.45254.a1426z@gawab.com>	<17495.62433.136481.543828@cse.unsw.edu.au>	<200605030700.23515.a1426z@gawab.com>	<17502.61577.874881.753541@cse.unsw.edu.au>	<446B968B.6050606@ucolick.org>	<17515.46721.340413.205804@cse.unsw.edu.au>	<446D13E5.2050107@ucolick.org> <17517.5342.472654.391841@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17517.5342.472654.391841@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Patrik Jonsson <patrik@ucolick.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I'm currently running an active raid5 array of 12 x 300GB SATA devices.
During the last couple of months I have grown my raid two times (from 4
to 8 to 12). I was using a 2.6.16-rc1 kernel with the (at that time)
latest md-patch.

I'm happy to say that both times the growing procedure completed
successfully!

This is how I did:

At first I had 4 devices ( /dev/sd{a,b,c,d} ) running in an active raid=
5
array (chunk-size 256). When I bought 4 more I thought I=92d try to gro=
w
them instead of running another array. I assembled my array with 4
drives and made sure that the array started without problems (cat:ed
/proc/mdstat). After that I cfdisk:ed the 4 new devices to one huge
partition with the type FD (Linux raid autodetect) and added them as
spares with the command:

# mdadm --add /dev/md0 /dev/sd{e,f,g,h}1

After that I checked the /proc/mdstat to confirm that they had been
successfully added and then executed the grow command:

# mdadm -Gv /dev/md0 -n8

which started the whole growing procedure. After that I waited (it took
about 6 times rebuilding from 4 to 8 and almost 11 hours from 8 to 12).


The following information might not belong in the raid-list but I
thought it might be useful someone:
---------------------------------------------------------------------
The raid is encrypted with LUKS aes-cbc-essiv:sha256 and has an ext3
filesystem formatted with '-T Largefile', -m0 and '-R stride=3D64'. Aft=
er
I successfully had grown the raid5 array I managed to resize the LUKS
and the ext3 partition with the following commands:

(After decrypting the raid using standard luksOpen procedure)

# cryptsetup resize cmd0
(no I didn't forget the <size> information)

# resize2fs -p /dev/mapper/cmd0
seemed to do the trick with the ext3 filesystem.
---------------------------------------------------------------------

This is how I did it both times and I must say, even though it was scar=
y
as hell growing a raid of 2.1TB with need-to-have data, it was really
interesting and boy am I glad it worked! =3D)

I just thought I=92d tribute to the raid-list with my grow-story. It ca=
n
be nice to hear of those who succeed too and not only when people have
accidents. =3D)

Thanks for a great work with the growing code!

Best regards
Per Lindstrand, Sweden

Neil Brown wrote:
> On Thursday May 18, patrik@ucolick.org wrote:
>> Hi Neil,
>>
>> The raid5 reshape seems to have gone smoothly (nice job!), though it
>> took 11 hours! Are there any pieces of info you would like about the=
 array?
>=20
> Excellent!
>=20
> No, no other information would be useful. =20
> This is the first real-life example that I know of of adding 2 device=
s
> at once.  That should be no more difficult, but it is good to know
> that it works in fact as well as in theory.
>=20
> Thanks,
> NeilBrown
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
