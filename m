From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Rotating RAID 1
Date: Tue, 23 Aug 2011 22:28:31 -0400
Message-ID: <CALJXSJpt59U1Y+Pf4CRZ+Byg7Bb1KNYaofatUDXB4ZBQN0wGvQ@mail.gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
 <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
 <4E49849E.4030604@ivitera.com> <20110816084251.2d8e7831@notabene.brown>
 <CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com>
 <20110816095517.757afc07@notabene.brown> <CALJXSJqYXmvfoperm10XCLnGNA4WgMt_y7UoUSgPv3xjqScNcg@mail.gmail.com>
 <20110823135812.62c56cee@notabene.brown> <CALJXSJq52HG_50810mS-F1sfnCKgKsCBpqus9NZ_Le_Rc70JTw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CALJXSJq52HG_50810mS-F1sfnCKgKsCBpqus9NZ_Le_Rc70JTw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 23, 2011 at 12:05 AM, J=C3=A9r=C3=B4me Poulin <jeromepoulin=
@gmail.com> wrote:
> On Mon, Aug 22, 2011 at 11:58 PM, NeilBrown <neilb@suse.de> wrote:
>> So you have 8 MD RAID1s each with one missing device and the other d=
evice is
>> the next RAID1 down in the stack, except that last RAID1 where the o=
ne device
>> is a real device.
>

More tests revealed nothing very consistent... however, there is a
consistent performance degradation on our backups when using multiple
RAID devices, backup is every 2 hours and it is really slower.

Here are the results of bonnie++ which only show degradation of per
char even if I know it is not really significant.
Rewrite was going down more and more until it went back up for no
reason, really weird unexplainable results.
=46irst line is from raw device, sdb2, then from md device, then
incrementally more md devices in series.

                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- -=
-Seeks--
GANAS0202      300M  5547  93 76052  54 26862  34  5948  99 80050  49 1=
75.6   2
GANAS0202      300M  5455  92 72428  52 26787  35  5847  97 75833  49 1=
66.3   2
GANAS0202      300M  5401  91 71860  52 27100  35  5820  97 79219  53 1=
56.2   2
GANAS0202      300M  5315  90 71488  51 22472  30  5673  94 73707  51 1=
62.5   2
GANAS0202      300M  5159  87 67984  50 22860  31  5642  94 78829  54 1=
38.6   2
GANAS0202      300M  5033  85 67091  48 22189  30  5458  91 76586  55 1=
49.3   2
GANAS0202      300M  4904  83 65626  47 24602  34  5425  91 72349  52 1=
12.9   2
GANAS0202      300M  4854  82 66664  48 24937  35  5120  85 75008  56 1=
49.1   2
GANAS0202      300M  4732  80 66429  48 25646  37  5296  88 75137  57 1=
45.7   2
GANAS0202      300M  4246  71 69589  51 25112  36  5031  84 78260  61 1=
36.2   2
GANAS0202      300M  4253  72 70190  52 27121  40  5194  87 77648  61 1=
07.5   2
GANAS0202      300M  4112  69 76360  55 23852  35  4827  81 74005  59 1=
18.9   2
GANAS0202      300M  3987  67 62689  47 22475  33  4971  83 74315  61  =
97.6   2
GANAS0202      300M  3912  66 69769  51 22221  33  4979  83 74631  62 1=
14.9   2
GANAS0202      300M  3602  61 52773  38 25944  40  4953  83 77794  65 1=
25.4   2
GANAS0202      300M  3580  60 58728  43 22855  35  4680  79 74244  64 1=
55.2   3
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
