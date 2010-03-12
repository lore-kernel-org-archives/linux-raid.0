From: "Majed B." <majedb@gmail.com>
Subject: Re: Reshaping the length of devices
Date: Fri, 12 Mar 2010 18:20:39 +0300
Message-ID: <70ed7c3e1003120720q6e2e9b7bxf2f66fdb8cb892e2@mail.gmail.com>
References: <4B9A5A7B.4070105@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B9A5A7B.4070105@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I think it depends on how you migrate to the new disks. The best
option would be to have one partition use all the space on the new
(larger) disks, and replace a disk in the array with the new disk &
wait for it to sync. Do the same for all disks.

You'll end up with a working array, where each disk has 1 partition
but the total size of the array is only consuming half the capacity.

After that just use --growth and it'll expand the array to the max
available capacity from the disks.

On Fri, Mar 12, 2010 at 6:15 PM, Asdo <asdo@shiftmail.org> wrote:
> I am wondering... is it possible to reshape the length of the underly=
ing
> devices with MD raid?
>
> I mean like in the case one buys larger disks: after moving the raid
> partitions to the new disks half of them is still free. So one might =
want to
> extend the raid partitions to the end of the disks instead of creatin=
g
> another array in the free space.
>
> I have searched the linux-raid mailing list history but I couldn't fi=
nd this
> topic.
>
> Thanks in advance
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
