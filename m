From: David Brown <david.brown@hesbynett.no>
Subject: Re: mdadm --monitor: need extra feature?
Date: Tue, 21 Aug 2012 12:44:49 +0200
Message-ID: <503366A1.9030307@hesbynett.no>
References: <503365EB.6000006@supersystem.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <503365EB.6000006@supersystem.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?U2VyZ2l1c3ogQnJ6ZXppxYRza2k=?= <Sergiusz.Brzezinski@supersystem.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21/08/2012 12:41, Sergiusz Brzezi=C5=84ski wrote:
> Hi,
>
> I use Raid1 to make backup of the whole system.

Raid is not a backup system.  It is to improve uptimes, minimise=20
downtimes due to disk failures, and possibly to improve disk speed=20
and/or capacity.

I would recommend you first think about what you are trying to achieve=20
here - what are you trying to back up, how do you see restores being=20
used, how efficiently are you using your hardware, your bandwidth, your=
=20
time and effort?

You would probably be better off with a normal fixed 2-disk raid1 to=20
minimise the problems caused by a single disk failure, combined with an=
=20
rsync snapshot style backup that can be fully automated and give quick=20
and easy recovery of multiple old versions of files in the face of the=20
most common cause of data loss - human error.

> I remove hot-swap one
> drive from the array, and insert another drive. The goal is, that the
> only activity of a man is remove and insert the drive. The rest has t=
o
> be automated.
>
> Every drive, I use for this, has prepared Raid partition and was once
> added to array, so the zero block exists and UUID is equal to the
> working array.
>
> After changing drives, the rebuilding must be initialized (mdadm -add=
)
>
> But first, it must be discovered, that the device with consistent UUI=
D
> appeared in the system with degraded array and is available for us.
> After such discover, I can add the device to the degraded array and
> start rebuilding.
>
> "mdadm --monitor" can recognize that a drive disappeared, but it can'=
t
> recognize, thant a drive with consistent UUID appeared!
>
> Or maybye I am wrong and I didn't understand something from mdadm and
> mdadm.conf?
>
> Now I use for this my own script in crontab and i don't use "mdadm
> --monitor" at all because it only partially do what I want.
>
> My question is: Is it possibe to recognize with "mdadm --monitor" tha=
t
> the new device with consistent UUID appeared? Or if no, do You mean,
> this feature is worth to implement?
>
> Sergiusz
>
> ps.
>
> sorry for my english :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
