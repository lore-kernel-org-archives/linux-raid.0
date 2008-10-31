From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Debian and udev (was: RFC - device names and mdadm with some
	reference to udev.)
Date: Sat, 1 Nov 2008 00:08:05 +0100
Message-ID: <20081031230805.GA13203@lanczos.q-leap.de>
References: <18692.62860.863118.727187@notabene.brown> <ac3eb2510810270541g2ac57bd1p5576f15959e849e@mail.gmail.com> <18694.19834.523955.697048@notabene.brown> <ac3eb2510810271703k7d9c97caob0f1d2eee28b8b7@mail.gmail.com> <20081031205434.GB9554@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20081031205434.GB9554@piper.oerlikon.madduck.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 31, 2008 at 09:54:34PM +0100, martin f krafft wrote:
> also sprach Kay Sievers <kay.sievers@vrfy.org> [2008.10.28.0103 +0100]:
> > All stuff in /lib/udev/rules.d/ is not marked as "config" in the
> > package and will be overwritten with a udev update, regardless if the
> > content has been edited or not. We moved the "default" rules there
> > because people edited the files in /etc and wondered why stuff broke
> > in weird ways on updates. /etc/udev/rules.d/ is for "user rules" or
> > on-the-fly created system specific ones, like persistent net names and
> > cdrom rules. In an ideal setup you would be able to do rm -rf
> > /etc/udev/rules.d/*, reboot, and start device configuration from
> > scratch.
> > 
> > Debian didn't catch up the last months, they use an older version of
> > udev, and have always had thier very own idea of rules, that didn't
> > match the udev default.
> 
> Debian is nearing a release, we have other things to worry about.
> 
> But to clarify Kay's statement:
> yes, we cannot follow the udev default if we accept that users might
> want to edit udev rules, even if they risk breaking stuff. We very
> specifically discourage the administrator to write to anywhere but
> /usr/local and /etc for good reasons. Thus, the rules have to go to
> /etc/udev.

Rules written by the adminstrator have to go to /etc/udev, but system 
default rules certainly not. And IMHO it is plain wrong when
Debian maintainers think they know better than the rest of the world.
(And yes, I'm a debian user myself and also a package maintainer).

Cheers,
Bernd
