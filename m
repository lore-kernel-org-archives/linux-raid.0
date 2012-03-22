From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Thu, 22 Mar 2012 12:01:48 +0200
Message-ID: <CAGRgLy4Q5FhHMAeU3egqEfFKR_h1HneReg0sD_+hCmsF3WDzQw@mail.gmail.com>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
	<20120107075526.59ed433c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120107075526.59ed433c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jan Kasprzak <kas@fi.muni.cz>, linux-raid <linux-raid@vger.kernel.org>, John Robinson <john.robinson@anonymous.org.uk>
List-Id: linux-raid.ids

Neil,

> =A0echo frozen > /sys/block/mdN/md/sync_action
> =A0mdadm --add /dev/mdN /dev......
> =A0echo recover > /sys/block/mdN/md/sync_action
>
> it should do them all at once.
>
> I should teach mdadm about this..

What is required to do that from mdadm? I don't see any other place
where MD_RECOVERY_FROZEN is set, except via sysfs. So do you suggest
that mdadm use sysfs for that?
Also, what should be done if mdadm succeeds to "freeze" the array, but
fails to "unfreeze" it for some reason?

Thanks,
Alex.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
