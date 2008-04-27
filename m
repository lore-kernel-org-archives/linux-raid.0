From: Michal Soltys <soltys@ziu.info>
Subject: Re: Can't create partitions on raid, --auto=mdp not possible
Date: Sun, 27 Apr 2008 09:43:23 +0200
Message-ID: <48142E9B.1050708@ziu.info>
References: <200804261346.03511.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200804261346.03511.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Dexter Filmore <Dexter.Filmore@gmx.de>
List-Id: linux-raid.ids

Dexter Filmore wrote:
> 
> And lo and behold: in /dev no trace of md1p1 or md1/p1 or whatever. Only md1.
> 

Either /dev/md_d1p1 or /dev/md/d1p1. Check DEVICE NAMES section and 
--auto options explanation in mdadm(8)

How nodes are created, depends on command line options explicitly 
provided, mdadm.conf (globally in CREATE and per-device in ARRAY) as 
well as udev rules (currently default rules ignore partitionable raids, 
so just kernel-name device node is created under /dev).

