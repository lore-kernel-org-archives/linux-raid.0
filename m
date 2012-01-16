From: Steve Carlson <stevengcarlson@gmail.com>
Subject: Re: RAID0 partition set to spare
Date: Mon, 16 Jan 2012 02:04:09 -0600
Message-ID: <CA+q4O7Ou5DRyy5dYyrbGnWovQtwQj7+cLj7vKpeKeNwEGNMJdQ@mail.gmail.com>
References: <CA+q4O7N5D7c-dDYtW_BH3tUPK2NdAnq0agMAczTXQKji=QH3dw@mail.gmail.com>
	<4EFD9956.5050703@redhat.com>
	<CA+q4O7NS-2_1MxtXx5U4Qk66QHdXncUhm816utjuWVx8EJoGKQ@mail.gmail.com>
	<4EFEDF2A.5060408@redhat.com>
	<CA+q4O7NhcEhYLre45+u6V8nnmCg1EYi=3Lbn4_5AS6Ei5J1mTQ@mail.gmail.com>
	<CA+q4O7NjK6Aj3Djs2g+qPu69=knOKvu9=wFy-YLdmw4Fi3k2Gw@mail.gmail.com>
	<20120115161831.6e46f413@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120115161831.6e46f413@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I don't know how the array could have got in this state. =A0IO errors=
 on a
> RAID0 don't mark the devices as faulty.
> You would have to explicitly
> =A0 mdadm /dev/md2 --fail /dev/sdb3
> or something like that - and I doubt you did that.
>
> Anyway:
> =A0mdadm -S /dev/md2
> =A0mdadm -C /dev/md2 -e 0.90 -c 64 -l 0 -n 2 /dev/sda3 /dev/sdb3
>
> should get you going again. =A0All the data should be there except fo=
r anything
> that the hard drive has decided to keep for itself.
>
> NeilBrown

This fixed it.  Thanks a bunch Neil and Jes!

-Steve
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
