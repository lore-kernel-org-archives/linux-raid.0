From: Robert Long <boblong@k9heritage.com>
Subject: Mirroring seek optimization
Date: Sat, 23 Aug 2014 17:51:09 -0700
Message-ID: <4CE5B469-1F8B-4F66-8993-8A752CE08420@k9heritage.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I don=92t know who to talk to, so I thought I would start here. A while=
 back I developed a further optimization for speeding up read access in=
 mirrored disk arrays. Testing reveals that it achieves about a 7% adva=
ntage over the current implementation. I had considered patenting it, b=
ut I found that there is an existing US patent (7,330,930) that is broa=
d enough to cover the existing Linux mirror implementation as well as m=
y improvement.

Any ideas regarding who to contact regarding further discussion of appl=
ying the improvement would be appreciated.

Bob Long


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
