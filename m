From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: Is mdadm.conf needed?
Date: Fri, 7 Mar 2014 19:00:02 +0000
Message-ID: <21274.5938.39330.873959@tree.ty.sabi.co.uk>
References: <CAJx5YvG5sA9GcPEd2D59ekg+QrRj7YGTKW=a8MMmLUWwkMo8fA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvG5sA9GcPEd2D59ekg+QrRj7YGTKW=a8MMmLUWwkMo8fA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> while most of the Linux software-RAID related tutorials
> suggest to have the mdadm.conf file up to date, then is it
> actually needed or used any more? [ ... ]

It has never been "needed". It is just very convenient for:

* Setting site-specific defaults for creating MD RAID sets
  and for messaging and recovery.

* Starting up specific MD RAID sets, because as 'man 5
  mdadm.conf' says in recent versions the default is such that
  most block devices that look like array membersare started:
  =ABIf no DEVICE line is present, then "DEVICE partitions
  containers" is assumed.=BB

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
