From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Wed, 2 Nov 2011 11:16:00 -0700
Message-ID: <CABE8wwt623R1bvFuUe_HuKXevnY9vTC8e5gkCK5rFyg8UrJy7g@mail.gmail.com>
References: <20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Lennart Poettering <lennart@poettering.net>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, Nov 2, 2011 at 7:33 AM, Kay Sievers <kay.sievers@vrfy.org> wrote:
> People who like to put their rootfs on a userspace managed raid device
> just get what they asked for. :)

Proper care and feeding of mdmon and userspace managed block devices /
filesystems is a solvable problem.  To me the ":)" runs the risk of
implying we don't think we can get this right.

--
Dan
