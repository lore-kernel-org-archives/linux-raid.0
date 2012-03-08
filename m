From: Kai Stian Olstad <kai.stian.olstad@gmail.com>
Subject: Re: invalid bitmap file superblock: bad magic
Date: Thu, 8 Mar 2012 17:41:38 +0100
Message-ID: <CAOPY+weSBif2Lqwnu5wKMOCPqAf2ZApu1-sLxmuP5JU-M0GZsQ@mail.gmail.com>
References: <201203081711.17836.a.miskiewicz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201203081711.17836.a.miskiewicz@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?Q?Arkadiusz_Mi=B6kiewicz?= <a.miskiewicz@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Mar 8, 2012 at 5:11 PM, Arkadiusz Mi=C5=9Bkiewicz
<a.miskiewicz@gmail.com> wrote:
> I'm trying to create internal bitmap on freshly created
> raid1 array on 3.2.6 kernel.
>
> What's going on and how to fix this problem?
>
> [root@setebos ~]# mdadm /dev/md3 --grow --bitmap=3Dinternal

Wrong syntax, try:
mdadm --grow /dev/md3 --bitmap=3Dinternal

--=20
Kai Stian Olstad
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
