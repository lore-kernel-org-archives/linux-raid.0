From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Know about chunk size
Date: Tue, 27 Nov 2012 19:36:40 +0100
Message-ID: <20121127183640.GA4109@lazy.lzy>
References: <186704.2.1353915309639.JavaMail.root@zimbra>
 <50B3E916.90205@hardwarefreak.com>
 <1354001957.48019.YahooMailNeo@web190602.mail.sg3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1354001957.48019.YahooMailNeo@web190602.mail.sg3.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kks Kbase <kks.kbase@yahoo.in>
Cc: "stan@hardwarefreak.com" <stan@hardwarefreak.com>, Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Nov 27, 2012 at 03:39:17PM +0800, Kks Kbase wrote:
[...]
> >> Also is it possible to change the chunk size for an existing array=
?
>=20
> No.=A0 You must destroy and recreate it with the new chunk size.=A0 I=
f one

It seems to me it is possible.

Should be one option of "Grow", as far as I can remember.

The issue is, it is not possible to increase the size,
unless it will fit the current number of chunks.

So, for example, if the size is doubled, there should
be an even number of chunks.

=46urthermore, LVM will not be happy if the alignment is
lost due to this. It will complain, but it will work.

bye,

--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
