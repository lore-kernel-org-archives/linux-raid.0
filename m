From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 16:19:46 +0100
Message-ID: <20091111151946.GA29346@boogie.lpds.sztaki.hu>
References: <4AF9ABAA.1020407@redhat.com>
 <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20091111033418841.IRLD6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 10, 2009 at 09:34:09PM -0600, Leslie Rhorer wrote:

> RAID-Server:/etc# ll rcS.d/*md*
> lrwxrwxrwx 1 root root 20 2008-11-21 22:35 rcS.d/S25mdadm-raid ->
> ../init.d/mdadm-raid
> lrwxrwxrwx 1 root root 20 2008-12-27 18:35 rcS.d/S99mdadm_monitor ->
> ../init.d/mdadm-raid
> RAID-Server:/etc# ll rc2.d/*md*
> lrwxrwxrwx 1 root root 15 2008-11-21 22:35 rc2.d/S25mdadm -> ../init.d/mdadm
> lrwxrwxrwx 1 root root 20 2008-12-27 18:36 rc2.d/S99mdadm_monitor ->
> ../init.d/mdadm-raid

What Debian version do you have? There are no mdadm_monitor links in
lenny, and I do not have etch systems anymore to check.

> 	Getting back to my dilema, however, I suppose I could simply create
> an /etc/rcS.d/S24mounthda4 script that explicitly mounts /dev/hda4 to
> /etc/mdadm/bitmap, or I could modify the init.d/mdadm-raid script to
> explicitly mount the /dev/hda partition if it is not already mounted.
> Editing the init.d/mdadm-raid script is a bit cleaner and perhaps clearer,
> but any update to mdadm is liable to wipe out the modifications to the
> startup script.

In Debian, modifications to init scripts are preserved during upgrade
unless you explicitely request them to be overwritten.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
