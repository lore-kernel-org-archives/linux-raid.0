From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: SuSE Linux cluster using MC/ServiceGuard --- shared storage
Date: Mon, 20 Sep 2004 20:33:18 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040920183318.GP3592@marowsky-bree.de>
References: <20040920132846.29970.qmail@web61108.mail.yahoo.com> <20040920135549.GA8201@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040920135549.GA8201@percy.comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-09-20T15:55:51,
   Luca Berra <bluca@comedia.it> said:

> >Do I still need to use the Driver Patch for EVA
> >Controller Failover?=20
> i believe using the qlogic driver failover is a viable solutio,

The DM multipath in 2.6 should handle the EVA just fine.

The qlogic internal failover is being depreciated and AFAIK isn't
included in 2.6 mainline even...

> another is purchasing securepath from HP. but i believe there were
> issues using securepath and lvm together.

Proprietary multipathing solutions are a thing of the past on Linux, on=
e
hopes.


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
