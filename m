From: =?ISO-8859-1?Q?Marc_Recht=E9?= <marc3@rechte.fr>
Subject: Re: Linux tries to bring up raid before the disks are finished initializing
Date: Wed, 16 Feb 2011 09:33:34 +0100
Message-ID: <ijg24l$p2e$1@dough.gmane.org>
References: <971504.54875.qm@web30805.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <971504.54875.qm@web30805.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Mike,

I found you discussion regarding a problem you had with a PMP with an 
Adaptec 1430SA configuration with several SATA disks connected though 3 
x SII3726 port multiplier

Could you please confirm this Adpatec card support properly PMP, because 
Adpatec support tech. say this card is not tested: "The 1430SA is a SATA 
2 controller and has not been tested with expanders."

I am currently facing disk detection problem with the AMD700 SATA chip 
(cold book will either not detect any disk, or some of them, but warm 
reboot detects them all)  that's why I envisage this Adpatec controller 
alternative.

It seems the SB700 series chip has a known problem with PMP (see 
http://en.wikipedia.org/wiki/AMD_700_chipset_series#Southbridges). 
Kernel I use is 2.6.32 (RHEL6).

Many thanks

