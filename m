From: Jens Benecke <jens@spamfreemail.de>
Subject: Re: Q: RAID-1 w/2x160GB, ReiserFS, Debian 'woody', homebrew 2.4.25 kernel
Date: Thu, 05 Aug 2004 14:02:12 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <cet7k4$lsn$1@sea.gmane.org>
References: <ceq7ij$vj7$1@sea.gmane.org>	<27897.194.60.85.4.1091613610.squirrel@194.60.85.4>	<cesjcm$9da$1@sea.gmane.org> <87657ycaf9.fsf@enki.rimspace.net> <4111FBF5.8000806@buttersideup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tim Small wrote:

> Daniel Pittman wrote:
=20
>>>see subject (Debian). I've looked at SuSE though, it seems with thei=
r
>>>setup RAID and ReiserFS is much easier to handle.

>>The upcoming release of Debian will feature MD and LVM device creatio=
n
>>at install time, but is not yet stable; the current stable release do=
es
>>not support either of them.
 =20
> Sarge is pretty good at the moment (at least I am running production
> systems on it, and have been for the last few months) - the disadvant=
age
> of installing a new Woody system now is that security updates for it
> will probably stop before it's reached the end of it's useful life.  =
Of

Hi Tim,

Are you sure? I thought woody will be supported for quite some time. I'=
ve
been running an updated Debian with a couple self-compiled packages sin=
ce
1999, upgraded a couple times but woody has been quite pain-less so far=
=2E
Only the current set up has been messed up a bit so far.

I'm planning to use SysCP (www.syscp.de) as a webhosting management
interface, which requires woody - for now. It'll probably switch to Sar=
ge
when it becomes stable, which is why I don't plan on doing this right n=
ow.

I was faovouring SuSE because they have more up to date packages (Postf=
ix
2.1, Apache 2.0.49, PHP 4.3.4, MySQL 4.0), and because I wouldn't have =
to
bake my own kernel (I need a couple patches that Debian doesn't supply,
most importantly the GRsecurity patch set, and ReiserFS quota and
data-logging).
But I found that I can get most of the packages via backports.org and
dotdeb.net, and that my homebrew 2.4.25 kernel with those patches just =
runs
far too painlessly to give up right now.

> course, as it's Debian, you should be able to upgrade to Sarge
> relatively painlessly, but I'd probably rather avoid the hassle, and =
go
> straight to Sarge now.  I think Debian Installer currently includes
> support for installing Sarge directly onto md mirrors (including
> handling the boot-loader stuff), but I haven't tried it yet...  Might=
 be
> worth trying one of the daily builds from:
> http://www.debian.org/devel/debian-installer/

The problem here is that I won't ever see the box. It's a rented dedica=
ted
server. And the company, they let you choose hardware and distribution =
and
partitioning but then just install the default with enabled "ssh" and l=
et
you do the rest.
=20
> The disadvantage of installing Sarge yet is that it won't go through =
the
> official security updates until it is released, but in the mean time,
> you can pull security-fixes in from unstable (using apt-pinning if yo=
u
> like) - sounds nasty but it seems to work quite well in practice.  So=
rry
> for getting distribution-centric on the list!

This sounds like too much manual intervention to me. I just want the da=
mn
thing to run. I'm past the experimenting stage where I compiled half th=
e
system myself. :-)


--=20
Jens Benecke
http://www.hitchhikers.de - Europas kostenlose Mitfahrzentrale seit 199=
8
http://www.rb-hosting.de - Webhosting mit Extras - PHP ab =A49 - SSH ab=
 =A419
http://www.spamfreemail.de - 100% saubere Postf=E4cher, garantiert!

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
