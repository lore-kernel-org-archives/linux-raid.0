From: Neil Brown <neilb@suse.de>
Subject: Re: removed disk && md-device
Date: Fri, 11 May 2007 16:16:56 +1000
Message-ID: <17988.2648.848008.141952@notabene.brown>
References: <200705091417.09033.bs@q-leap.de>
	<20070509131450.GA31985@lapse.madduck.net>
	<200705091539.53863.bs@q-leap.de>
	<17986.50678.340484.891578@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Neil Brown on Thursday May 10
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bs@q-leap.de>, linux-raid@vger.kernel.org, linux-hotplug-devel@lists.sourceforge.net, 416512@bugs.debian.org
List-Id: linux-raid.ids

On Thursday May 10, neilb@suse.de wrote:
> 
> No, I haven't, but it is getting near the top of my list.

I have just committed a change to the mdadm .git so that
   mdadm /dev/md4 --fail detached

will fail any components of /dev/md4 that appear to be detached (open
returns -ENXIO). and
   mdadm /dev/md4 --remove detached
will remove any such devices (that are failed or spare).
so

   mdadm /dev/md4 --fail detached --remove detached

will get rid of any detached devices completely, as will

   mdadm /dev/md4 --fail detached --remove failed

though that will also remove any failed devices that don't happen to
be detached.

NeilBrown
