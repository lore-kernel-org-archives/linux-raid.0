From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mdadm and automatic re-add / incremental mode with usb-disk
Date: Mon, 1 Dec 2008 16:21:47 +0100
Message-ID: <slrngj808b.6ov.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <200811301231.58180.wilhelm.meier@fh-kl.de>
 <alpine.DEB.1.10.0811300646440.29266@p34.internal.lan>
 <200811301403.29920.wilhelm.meier@fh-kl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wilhelm Meier <wilhelm.meier@fh-kl.de> wrote:
> That might be, but what is the difference between doing the re-add and 
> re-sync on boot (that's what happens!)

Nope, that's not what happens. What happens is a re-sync, not a re-add.
Drives are never automagically re-added to an array. Once arrays are so
far out of sync that a re-add is needed, you always have to do it
manually, reboot or not.

> or if the drive comes back on a running system.

The drive could be buggy, could have a buggy connection, whatever. The
reason for a drive disappearing and re-appearing is not always a user
plugging it out and in.

> So, my thought was to do this as part of a udev-rule. 

Of course, you can do this yourself via some scripting. And if you think
it is safe for you, move on. But then you have no reason to cry once
those automatisms broke your system :)


regards
   Mario
-- 
The problem in the world today is communication. Too much communication.
                                                     -- Homer J. Simpson

