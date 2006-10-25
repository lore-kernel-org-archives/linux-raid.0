From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Bug with RAID1 hot spares?
Date: Wed, 25 Oct 2006 12:41:59 +0200
Message-ID: <ehnf1n$a1m$1@sea.gmane.org>
References: <200610202046.43033.chase.venters@clientec.com> <453EC0C4.2040006@tmr.com> <200610242344.13576.chase.venters@clientec.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chase Venters <chase.venters@clientec.com> wrote:
> The main idea is to not exercise the spare as much as the other disks. All 

Btw. you can also keep the spare-disk spinned down most of the time.
You should probably just make sure to spin it up from time to time to
see if it's still okay - I spin up my spares one hour per night when
smartd issues short selftests and a few more hours when smartd issues
long selftests.


regards
   Mario
-- 
<jv> Oh well, config
<jv> one actually wonders what force in the universe is holding it
<jv> and makes it working
<Beeth> chances and accidents :)

