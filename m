From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Sat, 4 Mar 2006 14:38:43 +0100
Message-ID: <duc593$uan$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <20060303144824.GA15672@hactar.lan> <20060304131609.GA4064@erwin.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kasper Dupont <10616252720827252562@expires.05.sep.2006.kasperd.net> wrote:
> And by that you mean that raid5 and raid6 must copy the page
> contents before writing it to disk?

They must not :) But if they don't, they risk inconsistent parity
information to be calculated.
However, since "inconsistent parity information in raid[456] is equal
to "different mirrors" in raid1, there is no real difference. So I
doubt they will copy :)


regards
   Mario
-- 
<jv> Oh well, config
<jv> one actually wonders what force in the universe is holding it
<jv> and makes it working
<Beeth> chances and accidents :)

