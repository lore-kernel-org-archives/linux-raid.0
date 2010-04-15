From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: grow fails with 2.6.34 git
Date: Wed, 14 Apr 2010 19:22:48 -0700
Message-ID: <r2x4877c76c1004141922y7f8ef8d6h3ae35ce261a45735@mail.gmail.com>
References: <hq5efu$mqb$1@dough.gmane.org>
	 <20100415110401.22c7a6bf@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415110401.22c7a6bf@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 14, 2010 at 6:04 PM, Neil Brown <neilb@suse.de> wrote:
> What is happening here is that the spare (sdh) is getting the Q block=
s
> written to it. =A0When this completes you will have full 2-disk redun=
dancy but
> the layout will not be optimal and the array wont be any bigger.
> To fix this you would:
>
> =A0mdadm --grow --backup-file=3D/root/backup.md4 --raid-devices=3D6 \
> =A0 =A0 =A0--layout=3Dnormalise /dev/md4
>

Is there some way of telling if the layout is proper, or is that what
'level 6' indicates?

Also is it safe to run something like...

mdadm --grow --back-file=3D/some/never/used/file --layout=3Dnormalize /=
dev/mdX

on any raid 5/6 device that isn't undergoing an active reshape? (would
it be a null-op if not required)
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
