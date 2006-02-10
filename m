From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: Question: array locking, possible?
Date: Fri, 10 Feb 2006 12:17:49 -0500
Message-ID: <43ECCABD.7040104@steeleye.com>
References: <20060207185517.7bc96486@mwdsp001.swissptt.ch>	<43E8F455.2020800@steeleye.com>	<20060208115549.2c771ecb@mwdsp001.swissptt.ch> <20060208214533.39653804.pegasus@nerv.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060208214533.39653804.pegasus@nerv.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?Q?Jure_Pe=E8ar?= <pegasus@nerv.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jure Pe=E8ar wrote:

> I too am running a jbod with md raid between two machines. So far md =
never
> caused any kind of problems, altough I did have situations where both
> machines were syncing mirrors at once.
>=20
> If there's a little tool to reserve a disk via scsi, I'd like to know=
 about
> it too. Even a piece of code would be enough.

The sg3_utils can do this, if your hardware is compatible.

--
Paul
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
