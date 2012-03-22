From: jlcenter@comcast.net
Subject: Fwd: grub-probe seems to be having problems
Date: Thu, 22 Mar 2012 02:27:17 +0000 (UTC)
Message-ID: <529358656.324923.1332383237382.JavaMail.root@sz0019a.westchester.pa.mail.comcast.net>
References: <4F685BC2.1030008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F685BC2.1030008@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Any takers?  -John

----- Forwarded Message -----
=46rom: "Vladimir '=CF=86-coder/phcoder' Serbinenko" <phcoder@gmail.com=
>
To: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Cc: "The development of GRUB 2" <grub-devel@gnu.org>, "Marco d'Itri" <m=
d@Linux.IT>
Sent: Tuesday, March 20, 2012 6:28:18 AM
Subject: Re: grub-probe seems to be having problems

On 19.03.2012 22:28, Lennart Sorensen wrote:
> On Fri, Mar 09, 2012 at 03:37:57PM -0500, Lennart Sorensen wrote:
>> Interestingly after poking at reading all the disks and poking mdadm
>> --examine and --detail, now grub-prob likes md1, but still dislikes =
md0.
>>
>> root@rceng03new:/tmp# /usr/sbin/grub-probe --device-map=3D --target=3D=
abstraction --device /dev/md1
>> diskfilter mdraid1x raid5rec
>> root@rceng03new:/tmp# /usr/sbin/grub-probe --device-map=3D --target=3D=
abstraction --device /dev/md0
>> /usr/sbin/grub-probe: error: Couldn't find physical volume `(null)'.=
 Check your device.map.
>>
>> md1 was failing before with the same grub code.
>>
>> I don't get it.  I wonder if there is any known issues in 2.6.32 ker=
nel
>> and/or mdadm - v3.1.4 - 31st August 2010
> Any suggestion for how to try and debug this myself, like which
> file/function to start debuging at?  I would like to put this machine
> in to production use soon, but I would also like to take this chance =
to
> fix the bug in grub first.

There is no need to debug. I know exactly why GRUB is confused: because=
=20
as far as my understanding goes the superblock makes no sense (details=20
in previous mail). What we need is that someone familiar with md tells=20
me how this sector should be interpreted.



--=20
Regards
Vladimir '=CF=86-coder/phcoder' Serbinenko


_______________________________________________
Grub-devel mailing list
Grub-devel@gnu.org
https://lists.gnu.org/mailman/listinfo/grub-devel
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
