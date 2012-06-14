From: Ed W <lists@wildgooses.com>
Subject: BBU + Writeback Controller suggestions please?
Date: Thu, 14 Jun 2012 17:10:59 +0100
Message-ID: <4FDA0D13.9030702@wildgooses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, repeat of an older question I asked some months back.  Looking to 
add BBU writeback "HBA" to run software raid over the top.  So ideally I 
want either a raid controller which can pretend to be an HBA with 4 
individual drives each with writeback cache (and a battery).  Or at a 
pinch I would accept a controller which can offer 2 pairs of RAID-1 with 
writeback cache and I would run linux raid-0 (or XFS storage groups) 
over the top - caveat that I would very much desire that if the hardware 
controller fails I can pull the individual raid-1 drives out and access 
them from a vanilla motherboard controller?

The goal is to be able to safely enable writeback caching on a 4 drive 
RAID10 (or XFS over raid-1), but if the controller should fail (or even 
just an urgent need to access the data from a second machine) then I can 
access the arrays from another machine which doesn't have such a 
controller. Operating system is a recent linux 3 kernel

Can anyone comment on whether such a hardware card exists (seems it's 
hard to get writeback caching on drives *and* have those drives readable 
without the same controller present). Currently eyeing up the Areca 1882 
8 port unit - thoughts?

Thanks for any advice

Ed W
