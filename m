From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: Reduce Timeout on Disk Failure
Date: Tue, 29 Apr 2003 16:18:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030429141819.GA25744@marowsky-bree.de>
References: <20030429132329.20854.qmail@rome.rubylane.com> <3EAE86D6.D4DC56B2@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3EAE86D6.D4DC56B2@SteelEye.com>
To: Paul Clements <Paul.Clements@SteelEye.com>, jim@rubylane.com
Cc: Andreas Kahnt <aka@aka.coware.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2003-04-29T10:06:14,
   Paul Clements <Paul.Clements@SteelEye.com> said:

> Well, this particular retry problem does not exist in 2.4. And in
> general, as far as software RAID is concerned, 2.4 is a lot better...=
I
> know, at least with raid1, you can fail a device just about anytime y=
ou
> want (with lots of write activity, during a resync, etc.) and as ofte=
n
> as you want, and it doesn't hang...

This depends on the lower level device. qlaxxxx takes about 30s to
report the unplugging of a cable as an IO error; so access to the md
device blocks for 30s...


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
SuSE Labs - Research & Development, SuSE Linux AG
 =20
"If anything can go wrong, it will." "Chance favors the prepared (mind)=
=2E"
  -- Capt. Edward A. Murphy            -- Louis Pasteur
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
