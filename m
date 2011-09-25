From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: Green drives and RAID arrays with partity
Date: Sun, 25 Sep 2011 10:41:02 -0400
Message-ID: <4E7F3D7E.4070205@scalableinformatics.com>
References: <4E7F0A31.4070001@yazzy.org>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F0A31.4070001@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/25/2011 07:02 AM, Marcin M. Jessa wrote:
> Hi guys.
>
> I was wondering if it's safe to use so called green drives in RAID 5 =
or
> RAID 6 with md?

You might need to turn off TLER and their power spin-down features, but=
=20
in general, they *should* work ok.  Modulo any firmware issues (staring=
=20
intently at WD).  We don't use Western Digital drives anymore due to ..=
=2E=20
er ... profound high failure rates we've observed in the field.  These=20
may or may not be connected to "greenness".  They are definitely=20
connected to buggy firmware (this is on enterprise and consumer drives,=
=20
used across a fairly wide swath of use cases).

Your mileage may vary (e.g. you might have different experiences).  We=20
wouldn't recommend them.

> Drive such as Seagate Barracuda=AE Green 2TB ST2000DL003 or Western
> Digital Caviar=AE Green=99 2TB WD20EARX have TLER off and reading mis=
c
> forums I understand that it would be a good idea to buy drives with t=
hat
> option available.

TLER and the power spindown option are good things to be able to turn=20
off.  Otherwise you need to have a way for the MD device to deal with a=
=20
spun-down set of drives.  I am not sure support is there for this right=
=20
now ... I could be wrong, I've just not seen it.

This said, spinning up and down drives is actually more stressful for=20
the electronics and motor.  Better to leave them in one state whenever=20
possible.  I can't remember the study I saw on this, but about a year=20
ago I saw a quietly published correlation between drive failures and=20
number of spinup/spindown cycles.  My memory might be off on it, so fee=
l=20
free to look for yourself (and don't rely upon my likely faulty memory)=
=2E

> On the other hand some people claim that Linux/Solaris/BSD based
> software RAID may be able to work just fine with these drives.

If the drives don't try to be "smart" and do "smart things" (powerdown,=
=20
unlimited Herculean error recovery, massive sector remapping that takes=
=20
it out of service for more than 60 seconds), yeah, they should "just=20
work".  If you have a barrel full of these drives and need to use them,=
=20
by all means, just turn off the "smart" features.

OTOH, if you are buying new drives, steer clear of them.


--=20
Joseph Landman, Ph.D
=46ounder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/sicluster
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
