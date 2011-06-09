From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Possible to use multiple disk to bypass I/O wait?
Date: Thu, 9 Jun 2011 11:19:39 +0100
Message-ID: <BANLkTikd-LEtAt_3n6bC7nTd2BZqZfNQLA@mail.gmail.com>
References: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimFOaJoMnwid1F+ghVwkBgJi2FymQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Emmanuel Noobadmin <centos.admin@gmail.com>
Cc: CentOS mailing list <centos@centos.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 9 June 2011 10:24, Emmanuel Noobadmin <centos.admin@gmail.com> wrote=
:
> I'm trying to resolve an I/O problem on a CentOS 5.6 server. The
> process basically scans through Maildirs, checking for space usage an=
d
> quota. Because there are hundred odd user folders and several 10s of
> thousands of small files, this sends the I/O wait % way high. The
> server hits a very high load level and stops responding to other
> requests until the crawl is done.
>
> I am wondering if I add another disk and symlink the sub-directories
> to that, would that free up the server to respond to other requests
> despite the wait on that disk?
>
> Alternatively, if I mdraid mirror the existing disk, would md be smar=
t
> enough to read using the other disk while the first's tied up with th=
e
> first process?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

The first thing that comes to my mind: Have you tried another IO schedu=
ler?

/M
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
