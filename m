From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: change from raid 5 to raid 6 interrupted
Date: Fri, 22 Apr 2011 16:05:01 +0100
Message-ID: <4DB1991D.1090902@anonymous.org.uk>
References: <BANLkTikntFUK5rX1oTynY849=o-GuDL2Yg@mail.gmail.com> <BANLkTikBscshav-eDHHAGWh=6iuDMj=b0w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikBscshav-eDHHAGWh=6iuDMj=b0w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Raphael_M=FCller?= <rapmue@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/04/2011 15:49, Raphael M=FCller wrote:
> last week i tried to grow my raid 5 with 4 disks to a raid 6 with 5
> disks. accidentialy i dropped the powersource and the resync process
> stopped.
>
> i could start the nas with a rescue stick, but i still wasnt' able to
> complete the resync. there are some output from different commands
> (examine and assemble tries)
>
> i'm very confused, because there stands active sync, but raid 6 and i
> think since it was very at the beginning, there was no data changed o=
n
> the 4 raid 5 disks.
>
> what should i do? and is it possible to rebuild this array? luckily i
> have somewhere around 90% of the data backed up on another nas.

The end of the assemble output has the answer:
> mdadm:/dev/md1 has an active reshape - checking if critical section n=
eeds to be restored
> mdadm: Failed to find backup of critical section
> mdadm: Failed to restore critical section for reshape, sorry.
>       Possibly you needed to specify the --backup-file

You need to manually re-issue the assemble command, and specify the=20
--backup-file you gave when you started the --grow. That should get the=
=20
array assembled and the reshape running again.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
