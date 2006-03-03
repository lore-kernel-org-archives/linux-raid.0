From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 13:03:24 +0100
Message-ID: <du9bac$7h2$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kasper Dupont <70006427576745453539@expires.04.sep.2006.kasperd.net> wrote:
>> Do you have write-cache enabled on the mirrors?
> How do I find out about that?

for 2.4 (although I belive to remember that the reporting is broken
there) and IDE:
grep -i ^wcache /proc/ide/hd*/settings

>> that this always affects areas which are "free" on the filesystem layer.
> Does the raid layer have any way to know if they are free and

No, that's why I did put the free in quotes and did desribe how the
"free" differs from "used" :)

> So far I have only seen it happen on swap. I thought that might
> be because that machine swaps a lot.

Well, if it swaps a lot, my assumption could lead to different mirrors
in that case too - supposed my assumption is true at all :)


regards
   Mario
-- 
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

