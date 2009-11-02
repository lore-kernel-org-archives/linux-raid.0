From: Ben DJ <bendj095124367913213465@gmail.com>
Subject: Re: system update killed /boot RAID-1 array auto-assembly/mount. why?
Date: Mon, 2 Nov 2009 14:33:18 -0800
Message-ID: <babafd2f0911021433j340add0bu5dae2c388efadfd6@mail.gmail.com>
References: <babafd2f0911021224w6adf8453we7ba4f166102044f@mail.gmail.com>
	<f1ef83020911021325uf1be098ia4567931771f88ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f1ef83020911021325uf1be098ia4567931771f88ae@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Wheeler <jwwstpete@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jesse

On Mon, Nov 2, 2009 at 1:25 PM, Jesse Wheeler <jwwstpete@gmail.com> wro=
te:
> I've observed some similar behavior on RAID-5 w/ SuSE Enterprise
> Server 10.2 SP2 with our eDirectory boxes. =A0While this is different
> from my current issue that I posted today, I will say that I have had
> -- on average -- better luck with with RHEL based distributions than
> SuSE variants.

I can't say I've made any of those comparisons.  Given a choice, I'm
sticking with openSUSE ...

11.2's RAID behavior 'feels' a bit more fragile than it was on 11.1.
That might be simply because I'm a bit paranoid now what with the
recent FAIL.

I'm trying to figure out if using kernel-desktop, rather than
kernel-server, might have anything to do with this.  I'm guessing, but
RAID1 + RAID10 is not your usual "desktop" config, so though it might
be worth a check.  So far, I haven't found enough detail on the
differences.

BenDJ
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
