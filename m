From: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?=
	<Sergiusz.Brzezinski@supersystem.pl>
Subject: Re: mdadm doesn't wont to grow - help please
Date: Tue, 15 May 2012 12:04:42 +0200
Message-ID: <4FB22A3A.5010003@supersystem.pl>
References: <4FB10D81.7070803@supersystem.pl> <20120515101431.786b117a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120515101431.786b117a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

W dniu 15.05.2012 02:14, NeilBrown pisze:
 > On Mon, 14 May 2012 15:49:53 +0200 Sergiusz Brzezi=C5=84ski
 > <Sergiusz.Brzezinski@supersystem.pl>  wrote:
 >
 >> Hi,
 >>
 >> I would like to grow the RAID1.
 >>
 >> - Raid1 size has about 50GB
 >> - two HD partition (sda2, sdb2) have about 80GB+ (each)
 >>
 >> I do:
 >>
 >> # mdadm --grow /dev/md0 --size=3Dmax
 >>
 >> and I get the info, that the new size is 50GB. And I wonder: why no=
t 80GB? The
 >> size doesn't change! If I try to force size (--size=3Dxxxxx), I get=
 the message
 >> that there is no space.
 >>
 >> What did I wrong?
 >
 > Probably used an ancient version of mdadm - more than a couple of mo=
nths
 > old :-)
 >
 > If you
 >    for i in /sys/block/md0/md/dev*/size
 >    do echo 0>  $i
 >    done
 > then try again it might work better.
 >
 > Newer mdadm (since May 2011) do this for you.
 >
 > If you look at the "mdadm -E /dev/sda2" output before and after you =
will
 > notice that "Avail Dev Size" changes.
 >
 > You can achieve the same effect by stopping the array, the assemblin=
g it
 > with --update=3Ddevicesize
 >
 >    mdadm --stop /dev/md0
 >    mdadm --assemble /dev/md0 --update=3Ddevicesize /dev/sd[ab]2
 >    mdadm --grow /dev/md0 --size=3Dmax
 >
 > NeilBrown
[...]

Hi,

Yes, that helped!

Bevore:

  Avail Dev Size : 104855552 (50.00 GiB 53.69 GB)
      Array Size : 104855552 (50.00 GiB 53.69 GB)



# echo 0 > /sys/block/md1/md/dev-sda2/size


After:

Avail Dev Size : 175625584 (83.74 GiB 89.92 GB)
      Array Size : 104855552 (50.00 GiB 53.69 GB)
   Used Dev Size : 104855552 (50.00 GiB 53.69 GB)


And now:
# mdadm --grow /dev/md1 --size=3Dmax
works as expected

thank's a lot

best regards

Sergiusz
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
