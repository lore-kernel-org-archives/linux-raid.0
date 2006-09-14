From: Turbo Fredriksson <turbo@bayour.com>
Subject: Re: libata hotplug and md raid?
Date: Thu, 14 Sep 2006 13:44:46 +0200
Message-ID: <874pvawu35.fsf@pumba.bayour.com>
References: <c384c5ea0609130311t4005e5aam153251fc6bbbdfb8@mail.gmail.com>
	<4507E2A9.7070306@emc.com> <4507E641.7090508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4507E641.7090508@gmail.com> (Tejun Heo's message of "Wed, 13
 Sep 2006 20:06:41 +0900")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>>>>> "Tejun" == Tejun Heo <htejun@gmail.com> writes:

    Tejun> Would it be better for md to listen to
    Tejun> hotplug events and auto-remove dead devices or is it
    Tejun> something which belongs to userland?

From my perspective (User+Admin), I'd _very much_ like to have
(physically) removed disks be removed by md.

This would greatly help me when a disk fails on any of my systems.
They are all SPARC's (with a few x86). None of which have any
monitor attached. The x86's have, but that monitor is a couple of
hundred meters away...

So when I change drive, I first have to telnet into the terminal
switch port for that machine, do the mdadm commands. Then physically
change the drive. Then back to a machine and telnet back in to the
machine and hot-add the disk....

Granted, it don't take that much time, but it's a couple of extra
steps (literally :) that I'd prefer not to do/take...
-- 
supercomputer toluene Mossad Semtex assassination Noriega Rule Psix
cryptographic critical NORAD terrorist killed fissionable Marxist
genetic
[See http://www.aclu.org/echelonwatch/index.html for more about this]
[Or http://www.europarl.eu.int/tempcom/echelon/pdf/rapport_echelon_en.pdf]
If neither of these works, try http://www.aclu.org and search for echelon.
Note. This is a real, not fiction.
http://www.theregister.co.uk/2001/09/06/eu_releases_echelon_spying_report/
http://www.aclu.org/safefree/nsaspying/23989res20060131.html#echelon
