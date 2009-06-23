From: Sujit Karataparambil <sjt.kar@gmail.com>
Subject: Re: Slow raid10 resync
Date: Tue, 23 Jun 2009 18:52:52 +0530
Message-ID: <921ca19c0906230622t16b2e731yd8e158524d9c8ed7@mail.gmail.com>
References: <2A22ECE278A6604A84476172F106BFCE07AC7A5A@CORPUSMX50A.corp.emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2A22ECE278A6604A84476172F106BFCE07AC7A5A@CORPUSMX50A.corp.emc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan_MichaelS@emc.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I think this is the max performance you can get,
but that is only the software raid.

http://tldp.org/HOWTO/Software-RAID-HOWTO-9.html
http://linux-raid.osdl.org/index.php/Performance

better guide that I thought would be helpfull, but did see some
activity on the mailing list.


On Mon, Jun 22, 2009 at 11:04 PM, <Ryan_MichaelS@emc.com> wrote:
> Occasionally one of my devices with a 4 drive raid10 array resyncs ve=
ry
> slowly. =A0Typical resync speed is in the 50-60 MB/sec range. =A0When
> running slow the speed is around 7-10 MB/sec. =A0sync_speed_min is se=
t to
> 20,000, max is set to 200,000. =A0By setting sync_speed_min to 5000 I=
 can
> slow the sync further, but setting it back to 20000 doesn't fix the
> speed. =A0Other IO on the system is normal. =A0The drives and the CPU=
 are
> not maxed.
>
> I don't know what is triggering this slow sync state. =A0Once in this
> state it will continue until the build completes.
>
> Any idea what might be happening here? =A0I'm running Debian with a 2=
=2E6.22
> kernel.
>
> Thanks for your help.
> - Michael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
-- Sujit K M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
