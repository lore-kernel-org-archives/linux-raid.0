From: Emmanuel Noobadmin <centos.admin@gmail.com>
Subject: Re: Possible to use multiple disk to bypass I/O wait?
Date: Fri, 10 Jun 2011 00:15:25 +0800
Message-ID: <BANLkTint7-6ZHkOwhtM9C9gJaqootQ=hfA@mail.gmail.com>
References: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
	<BANLkTikd-LEtAt_3n6bC7nTd2BZqZfNQLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikd-LEtAt_3n6bC7nTd2BZqZfNQLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: CentOS mailing list <centos@centos.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 6/9/11, Mathias Bur=E9n <mathias.buren@gmail.com> wrote:
> The first thing that comes to my mind: Have you tried another IO sche=
duler?

and the first thing that came to this noob's mind was: Wait, you mean
there's actually more than one? AND I get to choose?

I'll probably be experimenting with deadline and anticipatory since
the i/o wait seems to be due to the disk running back and fro trying
to serve the file scan as well as legit read request so having that
small wait for reads in the same area sounds like it would help.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
