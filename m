From: "bart@ardistech.com" <bart@ardistech.com>
Subject: How to auto rebuild array?
Date: Tue, 12 Jul 2005 15:46:00 +0200
Message-ID: <42D3C998.3F84EF1C@ardistech.com>
Reply-To: bart@ardistech.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi,

I have the problem that after a power failure I get the message:

Jul 12 15:29:17 kernel: md: created md3
Jul 12 15:29:17 kernel: md: bind<hda4>
Jul 12 15:29:17 kernel: md: bind<hdb4>
Jul 12 15:29:17 kernel: md: bind<hde4>
Jul 12 15:29:17 kernel: md: bind<hdf4>
Jul 12 15:29:17 kernel: md: running: <hdf4><hde4><hdb4><hda4>
Jul 12 15:29:17 kernel: md: kicking non-fresh hde4 from array!
Jul 12 15:29:17 kernel: md: unbind<hde4>

I understand that hde4 is not 'fresh' and the array need to be rebuild
but I only can do that with 'mdadm --add /dev/md3 /dev/hde4'. I would
like to have it turned into a hot-spare, in which case a rebuild would
start automatic.

This application runs unattended, so there is nobody there to enter
mdadm commands.... How can I make the rebuild starting automatic
(like a hardware raidcard does)?

Regards,
	Bart
