From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: RAID5 - RAID6
Date: Mon, 8 Mar 2010 01:09:45 -0800
Message-ID: <4877c76c1003080109mf1d65e7l3fabb6f675215808@mail.gmail.com>
References: <4877c76c1003071931q4ede50c6p754e5478b07f2533@mail.gmail.com>
	 <B8.32.23425.F5CB49B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B8.32.23425.F5CB49B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 8, 2010 at 12:59 AM, Leslie Rhorer <lrhorer@satx.rr.com> wr=
ote:
>> Yes, it is for Squeeze, if you want the latest bugfixes and security
>> updates you should seriously consider running debian-testing instead
>> of stable.
>
> =A0 =A0 =A0 =A0No, thanks. =A0I loaded "Squeeze" on another non-RAID =
workstation in
> order to alleviate a kernel bug causing problems with a 3G wireless m=
odem.
> It was quite unstable, and caused a number of issues, most problemati=
cally
> with the fact the distro assumes the system is not headless and would=
 lock
> up tight on boot if no monitor is present. =A0All of the RAID systems=
 are
> headless. =A0More importantly, stability is far and away the absolute=
ly most
> important requirement for these servers. =A0New features I can live w=
ithout.
> Bug fixes I don't need unless they directly affect the functioning of=
 the
> system, which is highly focussed. =A0These systems have a handful of =
very
> basic, very mature apps. =A0They run NTP, FTP, SSH, rsync, NUT, SMART=
, SAMBA,
> NFS, and KDE. =A0One of them also runs Galleon, pyTivo, TyTool under =
wine, and
> openvpn server. =A0That's it.
>
>> Stable is reserved for 'mature' features. =A0Testing, as far
>> as I'm aware, will almost never (and should never if you are paying
>> attention) cause data-loss, but might occasionally get in to a
>> situation where something breaks; mostly just during upgrades (but
>> then that's true of any upgrade).
>
> =A0 =A0 =A0 =A0It's true no data was lost, but then it's a little dif=
ficult to lose
> data if the system hangs hard on boot. =A0I had to yank most of the g=
uts out
> of the system to get it stable. =A0That, plus the new version of KDE =
really
> sucks badly, and I could not get Kpackage to work properly at all. =A0=
It also
> did something really goofy to pppd, but I was able to work around it =
by
> re-trying the pppd launch repeatedly on boot until it works.
>
>

Oh, is THAT where Ubuntu got 10.04's silly framebuffer required to
boot issue from...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
