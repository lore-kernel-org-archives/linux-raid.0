From: Michel Bellais <michel@ket.kth.se>
Subject: Re: Performance difference between two raid0 arrays on same drives?
Date: Sat, 12 Jul 2003 20:59:35 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200307122059.35252.michel@ket.kth.se>
References: <200307121537.33889.michel@ket.kth.se> <3F102E0C.1000108@hum.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3F102E0C.1000108@hum.auc.dk>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have done it with zcat!
The transfer rate decreases steadily from the beginning of the disk to =
the=20
end. It doesn't look linear, but more like a square root..
The loss is about 50% at the end of the disk compared to the beginning.

The test shows that the decrease in performance is negligible in the fi=
rst 10%=20
of the disk, where the raid arrrays are.
So i have really no clue about this performance loss.

Thanks for the tip! It was interesting to test this drive.
Michel Bellais

>
> You can test the performance across your drives with the program zcav
> (which should come with bonnie++ - if not, take a look at
> http://www.coker.com.au/bonnie++/)
>
>--
>Mads Peter Bach
>Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
>Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
># whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
