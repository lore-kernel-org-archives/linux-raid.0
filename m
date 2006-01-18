From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: Re: RAID 1 vs RAID 0
Date: Wed, 18 Jan 2006 11:33:22 +0100
Message-ID: <dql5hi$ald$1@sea.gmane.org>
References: <dqkie5$mf2$3@sea.gmane.org> <Pine.LNX.4.44.0601180228370.2456-100000@coffee.psychology.mcmaster.ca> <dqksi3$mf2$5@sea.gmane.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Max Waterman <davidmaxwaterman+gmane@fastmail.co.uk> wrote:
> Still, it seems like it should be a solvable problem...if you order the 
> data differently on each disk; for example, in the two disk case, 
> putting odd and even numbered 'stripes' on different platters [or sides 

Well, unfortunately for todays hard disks the OS doesn't know anything
anymore about platters, cylinders, sectors, zones etc.
Furthermore, such an attempt would break the (really nice!) ability to
use each single RAID1 mirror as a plain blockdevice with a plain
filesystem on it.


regards
   Mario
-- 
It is a capital mistake to theorize before one has data.
Insensibly one begins to twist facts to suit theories instead of theories
to suit facts.                   -- Sherlock Holmes by Arthur Conan Doyle

