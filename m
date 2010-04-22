From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Suggestion needed for fixing RAID6
Date: Thu, 22 Apr 2010 12:09:08 +0200
Message-ID: <626601cae203$dae35030$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-2";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil, list,

I am trying to fix one RAID6 array wich have 12x1.5TB (samsung) drives.
Actually the array have 1 missing drive, and 3 wich have some bad sectors!
Genearlly because it is RAID6 there is no data lost, because the bad sectors 
are not in one address line, but i can't rebuild the missing drive, because 
the kernel drops out the bad sector-drives one by one during the rebuild 
process.

My question is, there is any way, to force the array to keep the members in 
even if have some reading errors?
Or is there a way to re-add the bad sector drives after the kernel dropped 
out without stopping the rebuild process?
In normal way after 18 hour sync, @ 97.9% the 3rd drive is always dropped 
out and the rebuild stops.

Thanks,
Janos Haar 

