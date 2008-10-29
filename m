From: "Joe Landman" <joe.landman@gmail.com>
Subject: Re: question on how to (correctly) build an initrd for a root disk on a RAID1
Date: Tue, 28 Oct 2008 22:03:25 -0400
Message-ID: <9f5edc120810281903y67c0b56eia869d76cfa048ce3@mail.gmail.com>
References: <9f5edc120810261937w339f2919p4f7ce82fbcaf2149@mail.gmail.com>
	 <20081027071613.GA8197@maude.comedia.it>
	 <9f5edc120810270534j3d969d2s18c1017755990c30@mail.gmail.com>
	 <20081028064354.GD7764@percy.comedia.it>
	 <9f5edc120810280520i3ff4855fne765069beeca27e9@mail.gmail.com>
	 <9f5edc120810281842q7421ea92of6c466693f8f5b7f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <9f5edc120810281842q7421ea92of6c466693f8f5b7f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 28, 2008 at 9:42 PM, Joe Landman <joe.landman@gmail.com> wrote:
> Update:

capture is at http://pastebin.com/f57b6ba19  .  I think I see part of
the problem

From the trace:

Scanning and configuring dmraid supported devices
raidautorun: RAID_AUTORUN failed: No such device
raidautorun: RAID_AUTORUN failed: No such device

Seeing some of the other notes from here
[http://www.centos.org/modules/newbb/viewtopic.php?topic_id=15305]
someone noted that to make this work correctly, they had to rebuild
with the raid drivers built in.  I am ok with this if we have to do
it, but it seems strange ...  is RAID built as a module or as a built
in for the default distro kernel?

It is also interesting to note that in Fedora, the mkinitrd was
patched to use mdadm
(http://cvs.fedoraproject.org/viewvc/rpms/mkinitrd/F-7/mkinitrd.spec}.
 This is for mkinitrd-6.x.  This machine (Centos 5.2) uses
mkinitrd-5.1.19.6-28

[root@jackrabbitm ~]# rpm -qf /sbin/mkinitrd
mkinitrd-5.1.19.6-28
mkinitrd-5.1.19.6-28

It is starting to look like we need to switch to a later model
mkinitrd.  I'll try this, but are there any patches running around for
this for this mkinitrd?  Conversely, does anyone else with MD raid on
their root/boot drive see mdadm or mdadm.conf in their initrd with a
similar mkinitrd on their system?

Thanks!
