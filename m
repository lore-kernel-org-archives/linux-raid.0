From: Andrea Gelmini <andrea.gelmini@gmail.com>
Subject: Re: Unable to assemble a multi-degraded Raid5...
Date: Thu, 25 Nov 2010 12:07:49 +0100
Message-ID: <AANLkTimJFqKuwLZhX0cp-svDXboXD6pm7dzWNf_1QiM+@mail.gmail.com>
References: <AANLkTim21s=48i6hbFfmf5RZYaRv-0KiGOkDA2NpQUKn@mail.gmail.com>
	<20101125065513.53c26154@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101125065513.53c26154@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, bluca@comedia.it
List-Id: linux-raid.ids

2010/11/24 Neil Brown <neilb@suse.de>:
Hi Neil,
   and thanks a lot for your quick answer.

> So
>
> =C2=A0mdadm --assemble --auto=3Dyes --force \
> =C2=A0 =C2=A0 =C2=A0--update=3Dsuper-minor /dev/md0 /dev/sd[abdf]

  I solved re-creating the array for the 3 disks active
  (following your clues in the mailing list archive).
  I didn't try your suggestion because I saw your mail too late.

Thanks a lot for your work,
Andrea
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
