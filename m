From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Converting existing Data to RAID5
Date: Fri, 02 May 2003 19:46:13 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB2AEE5.10803@hum.auc.dk>
References: <20030502172613.GA20267@moof.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030502172613.GA20267@moof.org.uk>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giles A. Radford wrote:

> Now, Having read back on this list the stock answer to "I want to
> expand my RAID5 array" seems to be (at the moment) "Use raidreconf,
> but at your own risk, and it'll take ages". I don't have a problem wi=
th
> the "ages" bit, but I'd like to be as datasafe as possible.

> Could I start up a Raid 5 array with one or two real disks and three
> or four faulty drives which I would then activate as and when copying
> from them onto the new array has finished?

No, sorry, that wouldn't work. You can have one one drive missing. raid=
reconf=20
is probably your best bet.

> On a slightly similar note, I'm used to using ext2 and ext3, but I've
> heard a lot of people talk positively about XFS recently, so I'm
> wondering if any of you have any opinions on whether I should use ext=
3
> or XFS for this new array?

Depends on your application. I quite fond of XFS in my fileservers, but=
 it has=20
the added hassle of requiring patches to the standard kernel, unless yo=
u use a=20
distro with XFS support, but they tend to lag a bit behind.

--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
