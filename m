From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: mdadm and TLER (Time Limited Error Recovery)
Date: Tue, 8 Sep 2009 21:45:14 +0200
Message-ID: <slrnhadd2a.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <299cc2790909071735x6eefd8bsc05ad76fa782cae1@mail.gmail.com>
 <slrnhacpsm.2i5.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20090908184837.GA28217@teal.hq.k1024.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Iustin Pop <iusty@k1024.org> wrote:
> I'm sorry but I disagree here. *Especially* because md is used over
> normal SATA controllers most of the time, TLER is beneficial because the
> drive doesn't go catatonic for minutes at a time trying to recover a bad
> sector, which would (because md doesn't timeout disks) cause md to hung
> up the whole device. TLER will allow md to see the error quickly and

Yes, that's right. So - as in the most cases - it's up to user's demands
if he prefers quicker recovery from errors or harder attempts to correct
them :)


regards
   Mario
-- 
Good, Fast, Cheap: Pick any two (you can't have all three).
                                            -- RFC 1925, 7a

