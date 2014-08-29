From: Robert Long <boblong@k9heritage.com>
Subject: Mirroring seek optimization
Date: Thu, 28 Aug 2014 22:39:57 -0700
Message-ID: <2020F0B3-0B1E-4512-9E75-0D0DE7F0FB61@k9heritage.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Again,

=46irst, the code base that I was working from is now 2 years old. Whil=
e I doubt that the raid1.c code has changed significantly I could be ve=
ry wrong. At that time the load balancing algorithm was simply to attem=
pt to split the actively seeked area of the disk into two parts, and ha=
ve one disk take the low half and one take the high half. The effect of=
 that, in read intensive applications, is to cut in half the overall se=
ek length for each disk in the mirror, resulting in considerable seek t=
ime savings and overall higher throughput. A moving average of sector a=
ddresses needs to be maintained to make this work, but this is quite ea=
sily done. The more writing happens, the more this advantage is lost. T=
he problem with this approach, though not a large one, is that is that =
a numerical average is not actually representative of the middle of the=
 work area due to outliers, clusters of reads, etc.

A solution to this is to maintain a running median of the sector addres=
s. When this is done you get a measurable increase in throughput, at th=
e cost of greater computational overhead. The method that I used to mai=
ntain a moving median involves the creation of an equal sized min heap =
and max heap connected together at the head of each. This connection po=
int represents the current median sector of access requests to the mirr=
or.

Today I fired up the machine that I used to develop and test this modif=
ication. It took some time just to locate the modified raid1.c file :) =
The machine, in addition to the boot drive, is equipped with a couple o=
f 1 TB Hitachi disk drives that were used for test purposes. To be hone=
st I don=92t remember the name of the test software that I used, but it=
 seems that it was a pretty performance standard utility, not something=
 I put together myself. Perhaps you could jog my memory. As I mentioned=
 previously the improvement was around 7% with read only testing of ran=
dom seeks.

If this is of interest I will gladly post the NOT PRODUCTION READY code=
=2E (I took some shortcuts in the code for testing purposes, primarily =
in the assignment of drives to the array so that I didn=92t have to fig=
ure out how the existing code does such a nice job of drive allocation.=
)

On the other hand, if the improvement is deemed to be insufficient then=
 I will chuck the code into the dust bin of history. Given the continue=
d rise in the use of SSDs, seek optimization becomes less relevant ever=
y day.

Bob Long

PS
This is all the =93documentation=94 that exists other than a few commen=
ts sprinkled throughout the code.--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
