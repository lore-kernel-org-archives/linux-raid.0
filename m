From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 16:10:51 +0100
Message-ID: <du9m9r$ddi$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <20060303144824.GA15672@hactar.lan>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kasper Dupont <87385155133026632046@expires.04.sep.2006.kasperd.net> wrote:
> On the 2.6 system where I see the differences between mirrors
> /proc/ide/hde/settings:wcache                  1

write cache enabled.
Btw... don't disable it on a production system without previously
thinking about it :) Disabling write cache leads to massive performance
decrease on heavy simultaneous I/O... On a system with (IMHO not heavy
but significant) simultaneous I/O I got 35MB/s write speed on dd with
write cache enabled and it shrunk down to 9MB/s with write cache
disabled - while load grew up from ~0 to ~8.

> On a 2.4 system where I see no differences between mirrors I
> /proc/ide/hde/settings:wcache                  0               0               1               rw
> So how should I interpret this?

As I said - on 2.4 write cache reporting through /proc is broken: it
always reports disabled write cache, while it is not necessarily
disabled. Use hdparm -I instead (big I, not small i).


regards
   Mario
-- 
"Why are we hiding from the police, daddy?"      | J. E. Guenther
"Because we use SuSE son, they use SYSVR4."      | de.alt.sysadmin.recovery

