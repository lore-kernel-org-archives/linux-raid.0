From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: RAID5 broke during reshape...
Date: Sat, 2 Jan 2010 23:00:11 +0100
Message-ID: <20100102220010.GB6428@boogie.lpds.sztaki.hu>
References: <1262451347.10047.14.camel@michal-laptop.sawicz.net>
 <70ed7c3e1001020933x7ac028a5n42af404eb5e23e30@mail.gmail.com>
 <1262454630.10047.23.camel@michal-laptop.sawicz.net>
 <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <70ed7c3e1001021001g7e7a17b6ufb431ddfd563eae6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: =?iso-8859-2?Q?Micha=B3?= Sawicz <michal@sawicz.net>, LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Jan 02, 2010 at 09:01:49PM +0300, Majed B. wrote:

> All your disks report a lot of ECC errors: 195 Hardware_ECC_Recovered
> 0x001a   100   100   000    Old_age   Always       -       139150990

All of them are Samsungs, so that's normal. The raw value here does not
have much meaning; for some disk vendors/models, a huge number here is
perfectly OK.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
