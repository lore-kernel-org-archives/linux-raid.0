From: Chris <email.bug@arcor.de>
Subject: Re: Bug#779412: block devices loosing state
 after resume: trigger udev rules to re-apply settings
Date: Sat, 28 Feb 2015 10:47:44 +0100
Message-ID: <20150228104744.45c8d5b0@smtp.arcor.de>
References: <20150228093023.14e30d9a@smtp.arcor.de>
	<54F17E83.5070400@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <smartmontools-support-bounces@lists.sourceforge.net>
In-Reply-To: <54F17E83.5070400@debian.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/smartmontools-support>,
	<mailto:smartmontools-support-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=smartmontools-support>
List-Post: <mailto:smartmontools-support@lists.sourceforge.net>
List-Help: <mailto:smartmontools-support-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/smartmontools-support>,
	<mailto:smartmontools-support-request@lists.sourceforge.net?subject=subscribe>
Errors-To: smartmontools-support-bounces@lists.sourceforge.net
To: Michael Biebl <biebl@debian.org>
Cc: linux-raid@vger.kernel.org, 725284@bugs.debian.org, smartmontools-support@lists.sourceforge.net, 779412@bugs.debian.org
List-Id: linux-raid.ids

Am Sat, 28 Feb 2015 09:38:27 +0100
schrieb Michael Biebl <biebl@debian.org>:

> I don't think working around this in udev/systemd is a good idea.

Idealy and in the long run, the kernel drivers should keep state, yes.
But until then, better not to make releases with default configurations
that deliver serious problems (excessive hardware wear, data loss) to
the users. 

I believe before things stadardized around systemd and udev, packages
like hdparm, laptop-mode-tools, pm-utils, acpi-support,
gnome-power-manager, and more, all tried to work around problems with
block devices loosing state. Unfortunately, accumulating a large mess
and interferences resuling in releases with many bugs in this regard.

Now the situation can improve a lot, if we can say packages are safe if
they use udev rules to initialize devices. (As the kernel keeps
state, or systemd centrally triggers a udev change event where this is
not (yet) the case.)

> most of those custom settings aren't applied via udev rules
> anyway.

Which settings were you refering to?
With current versions hdparm, mdadm, etc. all seem to ship udev rules.
And that seems to be the proper way to configure the standard
hot-pluggable systems of today. (leaving aside embedded, non-systemd,
non udev systems)



------------------------------------------------------------------------------
Dive into the World of Parallel Programming The Go Parallel Website, sponsored
by Intel and developed in partnership with Slashdot Media, is your hub for all
things parallel software development, from weekly thought leadership blogs to
news, videos, case studies, tutorials and more. Take a look and join the 
conversation now. http://goparallel.sourceforge.net/
