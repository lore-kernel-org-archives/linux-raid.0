From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 08:09:17 -0600
Message-ID: <bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com>
References: <1264601024.29409.19.camel@thor>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1264601024.29409.19.camel@thor>
Sender: linux-raid-owner@vger.kernel.org
To: Rick Bragg <lists@gmnet.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 8:03 AM, Rick Bragg <lists@gmnet.net> wrote:
> I have 4 identical disks on it and they show up as /dev/sda, b, c, an=
d
> d.
>
> However, sdb needs to be replaced. =A0How can I tell which drive is s=
db?
> Is there a way to identify what drive is what?

Sometimes you can infer from dmesg.  E.g., type "dmesg | less" then
scroll until you see where sdb is initialized; it might show the model
and serial number of the drive.

Another approach is to use smartctl, i.e.: "sudo smartctl -a
/dev/sdb".  This will definitely show you the model and serial number.
 You can also use hdparm for the same effect: "sudo hdparm -I
/dev/sdb".

I'm sure there's more ways, but those are the first that come to mind.

-Matt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
