From: Jure Pe__ar <pegasus@nerv.eu.org>
Subject: Re: raid on shared storage
Date: Fri, 25 Mar 2005 22:05:27 +0100
Message-ID: <20050325220527.27a92278.pegasus@nerv.eu.org>
References: <423ADD02.4020008@netuse.de>
	<20050318135637.GT18819@marowsky-bree.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
In-Reply-To: <20050318135637.GT18819@marowsky-bree.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 18 Mar 2005 14:56:37 +0100
Lars Marowsky-Bree <lmb@suse.de> wrote:

> Activating the same md raid on more than one node will destroy your
> data, is the gist of it.

No. Happened to me multiple times and I still have all the data.

It's not much of a problem if two machines are syncing the same mirror =
as
long as it is not mounted on any. Once you have the mirror mounted on o=
ne of
them, who knows what happens to the write you've just commited.

I don't know what happens on raid5 tho ...

--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
