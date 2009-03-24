From: Dylan Distasio <interzone@gmail.com>
Subject: Question on RAID 10 setup
Date: Tue, 24 Mar 2009 18:15:13 -0400
Message-ID: <3513de790903241515m2eeff929x855322a51117c45b@mail.gmail.com>
References: <1183FAF84E86E244938C2174EE436BAC030FBE29@NYKPCMEU306VEUA.INTRANET.BARCAPINT.COM>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1183FAF84E86E244938C2174EE436BAC030FBE29@NYKPCMEU306VEUA.INTRANET.BARCAPINT.COM>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all-

I would like to put together a RAID10 array utilizing 2x1TB drives and
2x500 gig drives I have in my home Linux server. =A0Is the best way to =
do
this to create 2 separate RAID1 arrays, one for each set of drives, and
then a RAID0 array made up of the RAID1 ones? =A0 I just wanted to veri=
fy
that I am going about this correctly, and also get input on whether
there are any disadvantages to this setup. =A0I would prefer not to spl=
it
these up into two separate RAID10 arrays because I want the combined
space available under one. =A0 Thanks for any comments.

-Dylan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
