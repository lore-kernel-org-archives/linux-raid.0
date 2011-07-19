From: "Tyler J. Wagner" <tyler@tolaris.com>
Subject: Re: how to recover filesystem after clobbering array?
Date: Tue, 19 Jul 2011 13:44:41 +0100
Message-ID: <4E257C39.1090202@tolaris.com>
References: <20110719104325.16112cl7f4lrzkjh@mail.sapo.pt>	<j03lp4$h72$1@dough.gmane.org> <4E255FE1.2060006@tolaris.com> <20110719120153.1529669k4o1t6v4x@mail.sapo.pt>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719120153.1529669k4o1t6v4x@mail.sapo.pt>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Vasco_N=E9voa?= <vasco.nevoa@sapo.pt>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2011-07-19 12:01, Vasco N=E9voa wrote:
> So I firmly believe the data is all there, on both disks.
> I just need to rebuild the metadata to point to the data again someho=
w.
> Right?...

Yes. Or no. Do you want to risk losing your data? Clone one of the disk=
s
now, then experiment with trying to re-assemble the array.

Regards,
Tyler

--=20
"It is an interesting and demonstrable fact, that all children are athe=
ists
and were religion not inculcated into their minds, they would remain so=
=2E"
   -- Ernestine Rose

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
