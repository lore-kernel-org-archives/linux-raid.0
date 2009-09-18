From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID 5 array recovery - two drives errors in external enclosure
Date: Sat, 19 Sep 2009 02:37:59 +0300
Message-ID: <70ed7c3e0909181637g35b31926ref7e4a16beaab73c@mail.gmail.com>
References: <2267211f0909171342g6ebf68a2y393daa587e59c714@mail.gmail.com>
	<2267211f0909172119w6de04e46m5fcfc5e6d35c0382@mail.gmail.com>
	<20090918080706.GB22909@cthulhu.home.robinhill.me.uk> <2267211f0909180827jbfa57acqadd308b4b889058c@mail.gmail.com>
	<6b696870909180910q67d8166ay7796321b8cd35809@mail.gmail.com>
	<2267211f0909180912p745e4ea0idb5659cb54a6adce@mail.gmail.com>
	<6b696870909180923m35f29fa2l857b6f6402eb20be@mail.gmail.com>
	<2267211f0909181041o29d6f5eft1e260696c6ab9c57@mail.gmail.com>
	<6b696870909181317x777e3c5dsdcf0e7709f9c4979@mail.gmail.com>
	<2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2267211f0909181630r33fcdbe5hb0d158b9bf12924b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tim Bostrom <tbostrom@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

If you're going to take all your data out, I would suggest you do a
clean start and zero out all the disks to force the remapping of bad
sectors, then run smartctl -t offline on all disks and after it's done
(it will take A LONG time), create your filesystem on an array and put
back your data.

On Sat, Sep 19, 2009 at 2:30 AM, Tim Bostrom <tbostrom@gmail.com> wrote=
:
> THANK YOU!
>
> To all of you who helped with advice. =C2=A0I finally waded through 7=
0MB of
> log files from the last 6 months on my server and finally figured out
> a way to get the correct order. =C2=A0I had a few logs of 'fdisk -l" =
which
> contained the Disk Identifier. =C2=A0I matched that up against where =
I had
> the drives in the enclosure and the ata.#'s. =C2=A0 I came up with a =
short
> list of drive letter ordering and just kept trying them with four
> drives at a time moving the _missing_ drive around. =C2=A0Finally, it=
 came
> up.
>
> I'm now up with four drives and RO filesystem. =C2=A0I'm going to try=
 and
> backup as much as possible off-disk. =C2=A0Then I'm thinking that I n=
eed to
> add the "missing" drive back in and re-build.
>
> Correct?
>
> Thank you again.
>
> Tim
--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
