From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: systemd kills mdmon if it was started manually
	by user
Date: Wed, 2 Nov 2011 16:21:39 +0100
Message-ID: <CAPXgP13XEsGSdrftU77-ee3k0gE=O=Odrb4YNkADUFCJ352ZBg@mail.gmail.com>
References: <20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
	<20111102151749.GE5119@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org>
In-Reply-To: <20111102151749.GE5119@tango.0pointer.de>
List-Unsubscribe: <http://lists.freedesktop.org/mailman/options/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=unsubscribe>
List-Archive: <http://lists.freedesktop.org/archives/systemd-devel>
List-Post: <mailto:systemd-devel@lists.freedesktop.org>
List-Help: <mailto:systemd-devel-request@lists.freedesktop.org?subject=help>
List-Subscribe: <http://lists.freedesktop.org/mailman/listinfo/systemd-devel>,
	<mailto:systemd-devel-request@lists.freedesktop.org?subject=subscribe>
Sender: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
Errors-To: systemd-devel-bounces+gcssd-systemd-devel=m.gmane.org@lists.freedesktop.org
To: Lennart Poettering <lennart@poettering.net>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, Nov 2, 2011 at 16:17, Lennart Poettering <lennart@poettering.net> wrote:
> Kernel threads we detect by checking whether /proc/$PID/cmdline is
> empty, hence I'd suggest we use the first char of argv[0][0] here, to
> detect whether something is a process to avoid killing. Question is
> which char to choose for that. I am tempted to use '@'.

Maybe introduce a 'initramfs' cgroup and move the pids there?

Kay
