From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 10:48:01 -0600
Message-ID: <20091111164813467.BVCE15440@cdptpa-omta01.mail.rr.com>
References: <20091111151946.GA29346@boogie.lpds.sztaki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111151946.GA29346@boogie.lpds.sztaki.hu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gabor Gombas' <gombasg@sztaki.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > RAID-Server:/etc# ll rcS.d/*md*
> > lrwxrwxrwx 1 root root 20 2008-11-21 22:35 rcS.d/S25mdadm-raid ->
> > ../init.d/mdadm-raid
> > lrwxrwxrwx 1 root root 20 2008-12-27 18:35 rcS.d/S99mdadm_monitor ->
> > ../init.d/mdadm-raid
> > RAID-Server:/etc# ll rc2.d/*md*
> > lrwxrwxrwx 1 root root 15 2008-11-21 22:35 rc2.d/S25mdadm ->
> ../init.d/mdadm
> > lrwxrwxrwx 1 root root 20 2008-12-27 18:36 rc2.d/S99mdadm_monitor ->
> > ../init.d/mdadm-raid
> 
> What Debian version do you have? There are no mdadm_monitor links in
> lenny, and I do not have etch systems anymore to check.

	Lenny.  I'm not sure where they came from.  It might even have been
me playing around at some point, and I just forgot to delete them.  I did a
lot of fiddling with mdadm about a year ago.

> > 	Getting back to my dilema, however, I suppose I could simply create
> > an /etc/rcS.d/S24mounthda4 script that explicitly mounts /dev/hda4 to
> > /etc/mdadm/bitmap, or I could modify the init.d/mdadm-raid script to
> > explicitly mount the /dev/hda partition if it is not already mounted.
> > Editing the init.d/mdadm-raid script is a bit cleaner and perhaps
> clearer,
> > but any update to mdadm is liable to wipe out the modifications to the
> > startup script.
> 
> In Debian, modifications to init scripts are preserved during upgrade
> unless you explicitely request them to be overwritten.

	I didn't know that, but even so, it's probably at least somewhat
better not to modify a script unless it's necessary, because the new package
might have some important differences in the script.

