From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Adding Reed-Solomon Personality to MD, need help/advice
Date: Mon, 21 Nov 2005 14:11:40 +0100
Message-ID: <dlsh2c$2h0$1@sea.gmane.org>
References: <6.0.1.1.2.20040130235924.03f39710@mail.athenet.net>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Nathan Lewis <nathapl@cs.okstate.edu> wrote:
> As part of my Master's thesis, I am working on adding a Reed-Solomon 
> personality to the existing linux RAID structure and I would like some 

Is there any progress in implementing a generic Reed-Solomon personality
in MD since this mail from 31 Jan 2004?
Regarding the intention-question... for me, personally, it would be the
logical step inbetween raid5 resp. raid6 with survival of 1 resp. 2
simultaneous disk failures and raid10 with survival of n/2 simultaneous
disk failures. RaidRS would give users the chance to configure
redundancy and thus survivability exactly on their demands.
This would especially make sense when I see the raid5 configurations
with 14 and more devices which some users refer to on this list.
To be honest, I was thinking about such a personality myself, too, and
then was crawling the list's archive.


regards
   Mario
-- 
*axiom* welcher sensorische input bewirkte die output-aktion,
        den irc-chatter mit dem nick "dus" des irc-servers
        mittels eines kills zu verweisen?

