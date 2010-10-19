From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: booting into /dev/md0 after an upgrade to squeeze - SOLVED
Date: Tue, 19 Oct 2010 08:53:53 +0200
Message-ID: <20101019085353.37ebb5a1@atak.bl.pg.gda.pl>
References: <20101018201448.62a76ba6@atak.bl.pg.gda.pl>
	<4CBCA4AE.5020504@seoss.co.uk>
	<20101018231850.46d1375c@atak.bl.pg.gda.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101018231850.46d1375c@atak.bl.pg.gda.pl>
Sender: linux-raid-owner@vger.kernel.org
Cc: Tim Small <tim@seoss.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki said:     (by the date of Mon, 18 Oct 2010 23:18:50 +0200)

> I was trying to change the name from 'backup':0 to backup:0, but I
> must be doing something wrong, or it's not possible. ... or do I have
> to do this while assembling, and cannot do that on "live" array?


While inside initrd shell I brought up /dev/md0 while renaming it
at the same time, then booted into debian, like this:

# hostname backup
# mdadm -A -U name -U hostname /dev/md0 /dev/sda1 /dev/sdf1 /dev/sdg1 /dev/sdh1
# <Ctrl-D>

This caused change of Array Name from 'backup':0 to backup:0

When booted, I reinstalled linux-image package (with aptitude) and
this forced regeneration of initrd. Now it reboots just fine.

thank you for your help!
-- 
Janek Kozicki                               http://janek.kozicki.pl/  |
