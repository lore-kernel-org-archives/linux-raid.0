From: Rich Rauenzahn <rrauenza@gmail.com>
Subject: Re: reshape from raid5 to raid6 failed -- and backup file is gone?
Date: Thu, 22 Apr 2010 15:26:13 -0700
Message-ID: <l2k657cbef51004221526hcb002ac9pd8e464f50c5b1a70@mail.gmail.com>
References: <n2j657cbef51004221132uf2d7f5cds1268f848fee1489e@mail.gmail.com>
	 <q2u657cbef51004221446l41381e31hf26f96072b04983e@mail.gmail.com>
	 <20100423080938.5ef90287@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100423080938.5ef90287@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>
> It is very odd that the backup file disappeared. =A0What is
> =A0 /.MEDIA/tmp
> ?? Not a tmpfs filesystem I hope...

No, a persistent filesystem on another disk -- with no autodelete
scripts or anything.  Very very weird that it disappeared.   I saw it
before I went to bed... was about 50MB if I recall.  Unless the fsck
at boot removed it -- but I would imagine you make sure you fsync that
file to disk before you proceed?   I think ./.MEDIA is ext4.

> You could hack mdadm to assemble the array even without a backup file=
=2E
> Get 'Grow_restart' to always return 0.
>
> Then most of your data should be assessible, but the could be a secti=
on in
> the middle which is currupt.

As long as fsck can bring it back to a consistent state, I'm ok with
that.   But I would guess some file contents could be silently
corrupt?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
