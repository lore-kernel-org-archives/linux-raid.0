From: Tom Peters <tpeters@mixcom.com>
Subject: Re: SuSE 9.2 and 3ware 8506 card
Date: Sun, 26 Feb 2006 14:55:47 -0600
Message-ID: <5.1.0.14.2.20060226143859.0baefeb8@localhost>
References: <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
 <5.1.0.14.2.20060130164019.0ce71eb8@localhost> <drn46f$tor$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <drn46f$tor$1@sea.gmane.org>
References: <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
 <5.1.0.14.2.20060130164019.0ce71eb8@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My thanks to those who responded. I have the 3ware 8506-4LP installed a=
nd=20
running with a pair of Maxtor Maxline III drives. I'm out looking for t=
he=20
SmartMonTools suite, per the advice given.

Bonnie++ gives me results like  22034 k/s seq out, char mode, 32660 blo=
ck=20
mode, 13120 rewrite. Yikes! 91 to 94% cpu utilization for character mod=
e=20
output! I suppose that's pretty inefficient though. More like 35-38% fo=
r=20
block, 27% for rewrites.

Tweaking the background task control one step left or right of center=20
towards "Faster Task" or "Faster IO" seems to make a small but measurab=
le=20
difference, but oddly, sequential reads using Bonnie++ were slightly fa=
ster=20
when tweaked towards "Faster Task."

I found out something else too, something which I supposed should have =
been=20
obvious. I started out with ext3 on this array. I wiped it and changed =
it=20
to xfs, which benchmarks faster, at least as far as Bonnie++ can tell. =
I=20
guess ext3 is a journaling fs, is it not?

Is there some particular filesystem that's any better than any other fo=
r=20
hardware mirrored arrays?

-Tom


At 08:38 AM 1/31/2006 +0100, Peter Daum wrote:
>tw_clin is the (binary only) command line tool for maintaining 3ware
>controllers. All you can do with the web frontend can be done this
>way, too.
>
>Performance of the 3ware 8506 is pretty reasonable (I got a data rate
>of ~ 80 MB/s with RAID 10 , 55-60 with RAID 1 ) and about the same
>for reading and writing.
>
>Unfortunately, after my experiences (see above), i have some serious
>concerns regarding data integrity, though ...
>
>Regards,
>                   Peter Daum
>
>
>Tom Peters wrote:
>>Hi, brand new newbie (is that redundant?) here, who soon to be the pr=
oud=20
>>owner of a 3ware 8506-4 RAID card, on its way in the mail. I'm runnin=
g an=20
>>old P3 on SuSE 9.2 and would like to know what to read to get up to s=
peed=20
>>on setting this card up and maintaining it once I do. I'm pretty new =
to=20
>>linux and get a lot of advice that is pitched just slightly above my=20
>>level of understanding, so please go slow.
>>I'm currently using a Compaq SmartArray 3200 with 8 drives and I've a=
bout=20
>>given up getting any kind of reasonable performance out of it. That, =
plus=20
>>the outrageous cost of SCSI drives, is the reason for the switch to S=
ATA.=20
>>I can borrow a pair of 300 GB drives for a while to prove the concept=
=20
>>(the 3ware card wasn't that pricey) and if I can get it to work=20
>>reasonably well, buy some drives. I think there's some voodoo in the =
BIOS=20
>>of a real Compaq server that makes it work properly; for me it's a do=
g=20
>>and writes unbelievably slow.
>>I've been reading this group for a few weeks and hear some hints and=20
>>intimations about things I should probably learn about. For example,=20
>>someone just mentioned tw_cli maint verify, is that a 3ware thing or =
a=20
>>ext3 thing? And the fact that there is a 3ware knowledgebase (e.g.=20
>>http://www.3ware.com/KB/article.aspx?id=3D13247 should help.
>>So what else do I need to know?
>>-T
>>
>>
>>
>>[Philosophy] There is nothing that somebody, somewhere, will not
>>consider immoral. --Jan.Six@uku.fi
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html


[Pop Culture] Pour me a glass of grain alcohol and rain water, and
help yourself to whatever you'd like.  --Gen. Jack Ripper, Dr.
Strangelove
--... ...--  -.. .  -. ----. --.- --.- -...
tpeters@nospam.mixcom.com   (remove "nospam") N9QQB (amateur radio)
"HEY YOU" (loud shouting)  WEB ADDRESS http//www.mixweb.com/tpeters
43=B0 7' 17.2" N by 88=B0 6' 28.9" W,  Elevation 815',  Grid Square EN5=
3wc
WAN/LAN/Telcom Analyst, Tech Writer, MCP, CCNA, Registered Linux User 3=
85531



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
