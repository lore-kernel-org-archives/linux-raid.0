From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Fri, 3 Mar 2006 13:38:00 +0100
Message-ID: <du9db8$dmk$1@sea.gmane.org>
References: <20060301124432.GA3591@hactar.lan> <20060301215641.GA27042@hactar.lan> <20060303073016.GA662@hactar.lan> <du9bac$7h2$1@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE> wrote:
> grep -i ^wcache /proc/ide/hd*/settings

Ah, hdparm -I reports a Feature "Write cache" (* - enabled, no asterisk,
not enabled :))


regards
   Mario
-- 
Sex is not the answer.
Sex is the question.
Yes is the answer.

