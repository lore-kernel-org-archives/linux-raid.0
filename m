From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Fwd: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 07:21:31 -0500
Message-ID: <7d86ddb90903130521s454b386eo1ec00eec17bdaae7@mail.gmail.com>
References: <7d86ddb90903121646q485ad12y90824a4c3fcc2dfd@mail.gmail.com>
	 <20090313004802.GB29989@mint.phcomp.co.uk>
	 <7d86ddb90903122021y5f4f0868na3f1944f87f77f4a@mail.gmail.com>
	 <20090313101707.GF29989@mint.phcomp.co.uk>
	 <7d86ddb90903130519p4268dc33vc8ad42b53aefa2e2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90903130519p4268dc33vc8ad42b53aefa2e2@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I tried rolling back the kernal and have the same issue. Here is an
example of the dstat output when writing with bonnie++ on RAID 1. As
soon as the write buffer fills up the wait climbs as it is waiting to
write to the disk.=A0The output looks the same on both systems.

usr sys idl wai hiq siq| read =A0writ| recv =A0send| =A0in =A0 out | in=
t =A0 csw
=A00 =A0 0 100 =A0 0 =A0 0 =A0 0| =A0 0 =A0 =A0 0 | 586B 1682B| =A0 0 =A0=
 =A0 0 |1015 =A0 110
=A00 =A0 0 100 =A0 0 =A0 0 =A0 0| =A0 0 =A0 =A0 0 | =A064B =A0412B| =A0=
 0 =A0 =A0 0 |1022 =A0 =A096
=A04 =A0 1 =A096 =A0 1 =A0 0 =A0 0| =A040k =A0 =A00 | 238B =A0664B| =A0=
 0 =A0 =A0 0 |1011 =A0 124
43 =A0 6 =A050 =A0 1 =A0 0 =A0 0|4096B =A0 =A00 | 375B =A0428B| =A0 0 =A0=
 =A0 0 |1026 =A0 =A090
43 =A0 7 =A050 =A0 0 =A0 0 =A0 0| =A0 0 =A0 =A0 0 | =A064B =A0412B| =A0=
 0 =A0 =A0 0 |1005 =A0 =A060
43 =A0 8 =A050 =A0 0 =A0 0 =A0 0| =A0 0 =A0 =A0 0 | =A064B =A0412B| =A0=
 0 =A0 =A0 0 |1023 =A0 =A091
43 =A0 6 =A050 =A0 0 =A0 0 =A0 0|4096B =A0 =A00 | =A064B =A0412B| =A0 0=
 =A0 =A0 0 |1006 =A0 =A077
40 =A014 =A044 =A0 0 =A0 0 =A0 1| =A0 0 =A0 =A062M| 158B =A0396B| =A0 0=
 =A0 =A0 0 |1194 =A0 160
40 =A010 =A0 0 =A046 =A0 0 =A0 3| =A0 0 =A0 145M| 158B =A0522B| =A0 0 =A0=
 =A0 0 |1297 =A0 128
38 =A0 8 =A0 0 =A052 =A0 0 =A0 3|4096B =A0127M| =A064B =A0412B| =A0 0 =A0=
 =A0 0 |1276 =A0 147
41 =A0 9 =A0 1 =A048 =A0 0 =A0 3|4096B =A0120M| 174B =A0366B| =A0 0 =A0=
 =A0 0 |1252 =A0 129
43 =A0 8 =A0 3 =A045 =A0 0 =A0 0| =A0 0 =A0 =A016k| 158B =A0412B| =A0 0=
 =A0 =A0 0 |1012 =A0 113
40 =A016 =A0 6 =A036 =A0 0 =A0 1|4096B =A0 41M| =A064B =A0318B| =A0 0 =A0=
 =A0 0 |1142 =A0 188
42 =A011 =A0 0 =A045 =A0 0 =A0 2| =A0 0 =A0 130M| =A064B =A0675B| =A0 0=
 =A0 =A0 0 |1327 =A0 276
43 =A0 9 =A0 0 =A044 =A0 0 =A0 4| =A0 0 =A0 138M| =A064B =A0412B| =A0 0=
 =A0 =A0 0 |1280 =A0 130
34 =A0 9 =A016 =A038 =A0 0 =A0 2|4096B =A0107M| =A064B =A0412B| =A0 0 =A0=
 =A0 0 |1229 =A0 120
44 =A0 9 =A0 4 =A044 =A0 0 =A0 0| =A0 0 =A08192B| =A064B =A0412B| =A0 0=
 =A0 =A0 0 |1024 =A0 175
41 =A017 =A0 0 =A041 =A0 0 =A0 0| =A0 0 =A0 =A033M| 192B =A0366B| =A0 0=
 =A0 =A0 0 |1096 =A0 193
37 =A0 9 =A0 1 =A051 =A0 0 =A0 3|4096B =A0126M| =A064B =A0428B| =A0 0 =A0=
 =A0 0 |1288 =A0 173
44 =A0 8 =A0 0 =A044 =A0 0 =A0 3| =A0 0 =A0 142M| =A064B =A0412B| =A0 0=
 =A0 =A0 0 |1289 =A0 164


Here is the dstat output with the same bonnie command on the RAID 5
volume. This machine has two VMware guests running so the system
wasn't idle when grabbing the output.

usr sys idl wai hiq siq| read=A0 writ| recv=A0 send|=A0 in=A0=A0 out | =
int=A0=A0 csw
=A0 1=A0 14=A0 83=A0=A0 2=A0=A0 0=A0=A0 0| 120k=A0 537k|=A0=A0 0=A0=A0=A0=
=A0 0 |=A0=A0 0=A0=A0 0.2 |3084=A0=A0=A0 10k
=A018=A0 11=A0 68=A0=A0 1=A0=A0 0=A0=A0 0|=A0 40k 8192B|9180B 1192B|=A0=
=A0 0=A0=A0=A0=A0 0 |3074=A0=A0=A0 12k
=A036=A0 18=A0 43=A0=A0 2=A0=A0 0=A0=A0 0| 272k=A0=A0 24M| 123k 4865B|=A0=
=A0 0=A0=A0=A0=A0 0 |3858=A0=A0=A0 14k
=A030=A0 26=A0 42=A0=A0 1=A0=A0 1=A0=A0 2| 808k=A0=A0 67M|=A0 21k 1418B=
|=A0=A0 0=A0=A0=A0=A0 0 |5253=A0=A0=A0 18k
=A039=A0 19=A0 43=A0=A0 0=A0=A0 0=A0=A0 0|4096B=A0=A0=A0 0 |4600B=A0 69=
2B|=A0=A0 0=A0=A0=A0=A0 0 |3079=A0=A0=A0 11k
=A036=A0 19=A0 29=A0 17=A0=A0 0=A0=A0 0| 116k 1104k|3024B 2464B|=A0=A0 =
0=A0=A0=A0=A0 0 |3221=A0=A0=A0 10k
=A040=A0 17=A0 14=A0 30=A0=A0 0=A0=A0 1| 136k=A0 400k|=A0 86k 5828B|=A0=
=A0 0=A0=A0=A0=A0 0 |3189=A0=A0=A0 10k
=A037=A0 21=A0 17=A0 23=A0=A0 0=A0=A0 0| 380k=A0=A0 35M|=A0 30k 1708B|=A0=
=A0 0=A0=A0=A0=A0 0 |4223=A0=A0=A0 16k
=A030=A0 29=A0 37=A0=A0 2=A0=A0 2=A0=A0 2|1160k=A0 115M| 390B=A0 550B|=A0=
=A0 0=A0=A0=A0=A0 0 |6647=A0=A0=A0 24k
=A031=A0 29=A0 37=A0=A0 1=A0=A0 1=A0=A0 2|1112k=A0 127M| 664B=A0 314B|=A0=
=A0 0=A0=A0=A0=A0 0 |6745=A0=A0=A0 24k
=A033=A0 26=A0 28=A0 11=A0=A0 0=A0=A0 1| 728k=A0=A0 71M|3074B=A0 526B|=A0=
=A0 0=A0=A0=A0=A0 0 |4608=A0=A0=A0 16k
=A037=A0 24=A0=A0 2=A0 37=A0=A0 0=A0=A0 0|=A0=A0 0=A0=A0=A0 16k|1616B=A0=
=A0 14k|=A0=A0 0=A0=A0=A0=A0 0 |3086=A0=A0=A0 10k
=A034=A0 21=A0 11=A0 33=A0=A0 1=A0=A0 1| 388k=A0=A0 33M|=A0 26k 1280B|=A0=
=A0 0=A0=A0=A0=A0 0 |3939=A0=A0=A0 13k
=A030=A0 32=A0 36=A0=A0 1=A0=A0 1=A0=A0 1|1304k=A0 111M|=A0 60B=A0 420B=
|=A0=A0 0=A0=A0=A0=A0 0 |5083=A0=A0=A0 19k
=A031=A0 35=A0 30=A0=A0 2=A0=A0 1=A0=A0 2|1296k=A0 125M|=A0 19k 2051B|=A0=
=A0 0=A0=A0=A0=A0 0 |5987=A0=A0=A0 20k
=A038=A0 22=A0 19=A0 22=A0=A0 0=A0=A0 1| 692k=A0=A0 28M|3084B 2480B|=A0=
=A0 0=A0=A0=A0=A0 0 |3744=A0=A0=A0 11k
=A041=A0 17=A0 38=A0=A0 3=A0=A0 0=A0=A0 0| 736k 2184k| 120B=A0 298B|=A0=
=A0 0=A0=A0=A0=A0 0 |3785=A0=A0=A0 11k
=A034=A0 30=A0 21=A0 14=A0=A0 0=A0=A0 0| 360k=A0=A0 35M|=A0 48k 2862B|=A0=
=A0 0=A0=A0=A0=A0 0 |4178=A0=A0=A0 12k
=A037=A0 26=A0 35=A0=A0 1=A0=A0 1=A0=A0 1|1056k=A0 136M|=A0 13k 1394B|=A0=
=A0 0=A0=A0=A0=A0 0 |4331=A0=A0=A0 11k
=A034=A0 28=A0 33=A0=A0 2=A0=A0 0=A0=A0 1|1228k=A0 134M|=A0 30k 1658B|=A0=
=A0 0=A0=A0=A0=A0 0 |4132=A0=A0=A0 11k
=A036=A0 21=A0 28=A0 14=A0=A0 0=A0=A0 0| 332k=A0=A0 23M| 151k 5798B|=A0=
=A0 0=A0=A0=A0=A0 0 |3368=A0 9166
=A037=A0 18=A0 18=A0 28=A0=A0 0=A0=A0 0|=A0 16k=A0=A0 88k|=A0 13k=A0 99=
0B|=A0=A0 0=A0=A0=A0=A0 0 |3092=A0 8403
=A038=A0 23=A0 23=A0 16=A0=A0 1=A0=A0 0| 316k=A0=A0 39M|=A0 30k 1920B|=A0=
=A0 0=A0=A0=A0=A0 0 |3635=A0 9723
=A032=A0 33=A0 33=A0=A0 2=A0=A0 0=A0=A0 1|1180k=A0 132M| 295B=A0 404B|=A0=
=A0 0=A0=A0=A0=A0 0 |3907=A0 9935
=A031=A0 31=A0 35=A0=A0 2=A0=A0 1=A0=A0 1|1120k=A0 123M|=A0 43k 2424B|=A0=
=A0 0=A0=A0=A0=A0 0 |4746=A0=A0=A0 14k
=A032=A0 29=A0 37=A0=A0 2=A0=A0 1=A0=A0 1|1380k=A0=A0 71M|3084B 2440B|=A0=
=A0 0=A0=A0=A0=A0 0 |5341=A0=A0=A0 19k
=A037=A0 24=A0 36=A0=A0 1=A0=A0 0=A0=A0 0| 700k=A0=A0 53M| 459B=A0 496B=
|=A0=A0 0=A0=A0=A0=A0 0 |4402=A0=A0=A0 20k
=A035=A0 20=A0 29=A0 14=A0=A0 1=A0=A0 1|1808k=A0=A0 61M|4596B=A0 500B|=A0=
=A0 0=A0=A0=A0=A0 0 |5551=A0=A0=A0 19k
=A030=A0 30=A0 35=A0=A0 2=A0=A0 1=A0=A0 3|1076k=A0 107M| 246B=A0 620B|=A0=
=A0 0=A0=A0=A0=A0 0 |6769=A0=A0=A0 24k
=A036=A0 25=A0 30=A0=A0 7=A0=A0 1=A0=A0 2|1088k=A0=A0 66M| 165k=A0=A0 1=
0k|=A0=A0 0=A0=A0=A0=A0 0 |5093=A0=A0=A0 17k

On Fri, Mar 13, 2009 at 5:17 AM, Alain Williams <addw@phcomp.co.uk> wro=
te:
> On Thu, Mar 12, 2009 at 10:21:28PM -0500, Ryan Wagoner wrote:
>> I'm glad I'm not the only one experiencing the issue. Luckily the
>> issues on both my systems aren't as bad. I don't have any errors
>> showing in /var/log/messages on either system. I've been trying to
>> track down this issue for about a year now. I just recently my the
>> connection with RAID 1 and mdadm when copying data on the second
>> system.
>
> Did you have the problem straight from install, or perhaps when a new
> kernel started being used ?
>
> My system worked well for some months, there was no kernel update and
> it started to go wrong a couple of weeks ago. I also see errors
> when I run 'badblocks' -- which makes it smell of a hardware issue,
> but the disks were tested, on return, by the hardware supplier and
> they did not find any problem with them.
>
> Given that you are not seeing anything in /var/log/messages make me
> think that I do have some other problem -- perhaps in addition to
> what you have.
>
> --
> Alain Williams
> Linux/GNU Consultant - Mail systems, Web sites, Networking, Programme=
r, IT Lecturer.
> +44 (0) 787 668 0256 =A0http://www.phcomp.co.uk/
> Parliament Hill Computers Ltd. Registration Information: http://www.p=
hcomp.co.uk/contact.php
> Past chairman of UKUUG: http://www.ukuug.org/
> #include <std_disclaimer.h>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
