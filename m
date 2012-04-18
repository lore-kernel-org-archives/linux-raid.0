From: Tom Rini <tom.rini@gmail.com>
Subject: Re: Fixing broken metadata?
Date: Wed, 18 Apr 2012 10:51:34 -0700
Message-ID: <CA+M6bXmLZm4nPoDSO5=KczNuszbaqiWrsHqm+qGz6atdjBNhZg@mail.gmail.com>
References: <CA+M6bXkCQNXJ58mL0uNqu9oBgLhYq+sPWMiyqc+T9o5sVYgFmQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+M6bXkCQNXJ58mL0uNqu9oBgLhYq+sPWMiyqc+T9o5sVYgFmQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 18, 2012 at 10:22 AM, Tom Rini <tom.rini@gmail.com> wrote:
> Hey all,
>
> As part of tracking down a bug in mvsas in 3.4-rc3, my raid0 array go=
t
> trashed a bit. =A0Currently mdadm --misc /dev/.. -E gives results lik=
e
> this: http://pastebin.com/X2kWmF1A is there a backup copy of the
> metadata somewhere or some other way to force re-creating the array
> and let e2fsck decide if there's anything salvageable? =A0If not I ca=
n
> live with re-creating it. =A0Thanks!

Please disregard.  I had tried backing up the disks, passing to a VM
and re-creating the raid there, with no luck.  On the real HW (after
backing up again to be safe), this did seem to work.

--=20
Tom
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
