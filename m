From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Performance difference between two raid0 arrays on same drives?
Date: Sat, 12 Jul 2003 17:49:32 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F102E0C.1000108@hum.auc.dk>
References: <200307121537.33889.michel@ket.kth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200307121537.33889.michel@ket.kth.se>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Michel Bellais wrote:

> You're right, I thought about it too, but the fastest array is built =
with=20
> partitions closer to the centre of the disk, so it should be the slow=
est=20
> indeed.
> The disks are big (180 Gb), the partitions represent less than 10% of=
 it and=20
> follow each others.  It cannot explain 30% difference in performance.

You can test the performance across your drives with the program zcav=20
(which should come with bonnie++ - if not, take a look at=20
http://www.coker.com.au/bonnie++/)

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
