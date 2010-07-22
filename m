From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: Why is sb->size set to 0 with raid0?
Date: Thu, 22 Jul 2010 15:04:40 +0200
Message-ID: <slrni4ggf9.jpi.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <slrni4e7bi.ced.Mario.Holbe@darkside.dyn.samba-tng.org>
 <20100722153456.04f751e7@notabene> <20100722185054.51930d15@natsu>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov <roman@rm.pp.ru> wrote:
> That sounds a bit surprising, excuse my ignorance, but how a RAID0 of
> differently-sized devices is laid out? Is the "tail" of the larger device

rtfm :)

md(4):
   RAID0
...
       If  devices  in  the array are not all the same size, then once
       the smallest device has been exhausted, the RAID0 driver starts
       collecting  chunks  into  smaller  stripes  that  only span the
       drives which still have remaining space.


regards
   Mario
-- 
Und wie jede Sprache, so hat auch PHP ein Anwendungsgebiet, fuer das es
besonders gut geeignet ist. Soweit ich sehen kann, handelt es sich dabei
um das sogenannte "ins Knie schiessen".
                              -- Volker Birk in de.alt.sysadmin.recovery

