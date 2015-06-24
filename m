From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm/Software RAID problems - another update
Date: Thu, 25 Jun 2015 09:26:26 +1000
Message-ID: <20150625092626.1ac30dfe@noble>
References: <1434739736.4161728.300185905.45F829A7@webmail.messagingengine.com>
	<1434779786.1648537.300522273.678785B2@webmail.messagingengine.com>
	<1434896517.3660124.303759113.0AE76093@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1434896517.3660124.303759113.0AE76093@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gareth Evans <donotspam@fastmail.fm>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 21 Jun 2015 15:21:57 +0100 Gareth Evans <donotspam@fastmail.fm>
wrote:

> After a number of tests with VirtualBox this weekend, it seems things work as they should with Fedora 22 but openSUSE 13.2, Debian 8.1 and Ubuntu 14.04.2 all appear to hang on boot when one vdisk is removed and another is attached, even if formatted with a "Linux RAID autodetect"-type partition.  CentOS 7 doesn't hang but doesn't have mdadm in its emergency console (I gave up with CentOS after that as not sure how to add commands, if that's possible...) and neither Fedora nor CentOS emergency consoles seem to include fdisk, which isn't too helpful.  
> 

I cannot comment on the other distros, but I believe that openSUSE
13.2, with all updates installed, handles boot on degraded md arrays
correctly.  As I *am* the mdadm maintainer for that distro, I can put
effort there.

If you have specifics of a configuration on openSUSE-13.2 with latest
updates for mdadm and dracut installed, where it doesn't boot correctly,
then I would definitely like to know about them, either here or at
bugzilla.opensuse.org - whichever suits you.

Thanks,
NeilBrown

