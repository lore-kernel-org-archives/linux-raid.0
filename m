From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be
 needed.
Date: Tue, 26 Sep 2017 20:12:46 +0100
Message-ID: <59CAA6AE.9060908@youngman.org.uk>
References: <87y3p372b0.fsf@notabene.neil.brown.name>
 <22985.8214.251962.72926@quad.stoffel.home>
 <87poae72z5.fsf@notabene.neil.brown.name>
 <250d2eff-ce7e-df72-1e6c-b4a8a2c43537@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <250d2eff-ce7e-df72-1e6c-b4a8a2c43537@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, NeilBrown <neilb@suse.com>, John Stoffel <john@stoffel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 26/09/17 16:11, Jes Sorensen wrote:
> I completely agree, I also think we shouldn't hardcode imposed layouts
> unless there are very strong reasons for it. Someone may want to put
> this into an initramfs or somewhere else and want to put it in a
> different location.

Plus isn't /sbin deprecated?

Iirc (very debatable :-) the end goal of the FHS is to have a read-only
/ with all executables in /bin. Okay it's going to take a looonngg time
to get there, but if I'm right hard-coding already-deprecated standards
isn't the best move.

(Again, iirc :-) sbin stood for *static* binaries needed for system
recovery, so its original purpose has long been abused ... :-)

Cheers,
Wol
