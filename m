From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: monitoring multipath arrays plus inconsistent /proc/mdstat?
Date: Fri, 22 Oct 2004 23:25:31 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041022212531.GE7205@marowsky-bree.de>
References: <20041021165119.GU3911@marowsky-bree.de> <Pine.LNX.4.44.0410220739480.13142-100000@lajli.gau.hu> <20041022091719.GF3911@marowsky-bree.de> <41797136.2050209@bms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41797136.2050209@bms.com>
To: Anu Matthew <anu.matthew@bms.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-10-22T16:44:38, Anu Matthew <anu.matthew@bms.com> wrote:

> May I ask, why? We are to evaluate Power Path also for 2.4, and am ju=
st=20
> curious why it is not going to run on 2.6? That could be a very impor=
tant=20
> factor in decision making if it won't make it on 2.6.x

Because EMC is very forthcoming about supporting the proper way of doin=
g
multipathing on Linux in 2.6 (based on the Open Source Device-Mapper
multipath functionality + the multipath-tools package) and actively
supporting me developing that feature by providing technical specs and
hardware, I don't really see a need for using Power Path any longer on
2.6 platforms.

I could understand that they may want to provide it for legacy
installations who want to slowly transition though, but they've not
mentioned it yet; personally I'd think it would be kind of pointless
;-)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
