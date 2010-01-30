From: Asdo <asdo@shiftmail.org>
Subject: Re: feature suggestion to handle read errors during re-sync of raid5
Date: Sat, 30 Jan 2010 22:09:41 +0100
Message-ID: <4B64A015.6080904@shiftmail.org>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se>
 <4B6471A1.2070407@texsoft.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B6471A1.2070407@texsoft.it>
Sender: linux-raid-owner@vger.kernel.org
To: Giovanni Tessore <giotex@texsoft.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Giovanni Tessore wrote:
> I supposed that modern hard drives' firmware would recover and 
> relocate dying sectors by its own (using smart and other techs), and 
> that the OS gets read errors only when the drive is actually in very 
> bad shape and can't cope with the problem, and it's time to trash it.
The disk must find the dying sector somehow.

It will certainly find it if you scrub the array often, and at that time 
relocate it (by itself or by MD means). If the disk is very smart (I'm 
not sure how many disks really do this) it can relocate during read, if 
it finds that the sector has a partial read error which is still 
correctable with the internal reed-solomon algorithm. Otherwise it will 
report the read error to Linux and MD will regenerate parity and write 
over the sector. At that point the sector will be relocated.

I'm not sure SMART test performs a surface scan so I would rely on MD 
scrubs for that.

> Having the OS recover and rewrite the sectors makes me feel back in 
> the past, when under DOS we used PCTools and other utilities to do 
> this recovery stuff on ST-506 drives .... and this works well on raid, 
> but in sinlge disk configuration, shouldn't these be data loss?
The OS rewrites the sector ONLY if the disk is in a raid setup. 
Otherwise how could it guess the data that should be in that sector, if 
the disk itself cannot?

