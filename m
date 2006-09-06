From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: checking md device parity (forced resync) - is it necessary?
Date: Wed, 6 Sep 2006 09:19:52 +0200
Message-ID: <edlsqo$jo4$2@sea.gmane.org>
References: <44FD3C65.8040000@wpkg.org> <17661.19907.140798.943518@cse.unsw.edu.au> <44FD66C3.6040609@wpkg.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tomasz Chmielewski <mangoo@wpkg.org> wrote:
> # by default, run at 01:06 on the first Sunday of each month.
> 6 1 1-7 * 7 root [ -x /usr/share/mdadm/checkarray ] && 

You have a quite old version of mdadm. This issue has been fixed in
mdadm (2.5.2-8) unstable from 27 Jul 2006. Current version is mdadm
(2.5.3.git200608202239-2) unstable from 23 Aug 2006.

Since the feature did just appear in mdadm (2.5.2-3) UNRELEASED from
7 Jul 2006 (and even just went to unstable with mdadm (2.5.2-7) unstable
from 20 Jul 2006), it seems you were simply in quite bad luck :)


regards
   Mario
-- 
It is practically impossible to teach good programming style to students
that have had prior exposure to BASIC: as potential programmers they are
mentally mutilated beyond hope of regeneration.  -- Dijkstra

