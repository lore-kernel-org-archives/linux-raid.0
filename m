From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: Care and feeding of RAID?
Date: Wed, 06 Sep 2006 08:17:26 +1200
Message-ID: <44FDDB56.3030304@sauce.co.nz>
References: <44FD722C.7050608@waldoware.com> <Pine.LNX.4.56.0609051414310.17570@lion.drogon.net> <44FD91D1.7090501@maine.edu> <44FDAF3E.1090209@waldoware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44FDAF3E.1090209@waldoware.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a timely thread for me, as I am about to setup a software RAID 
10 (a striped pair of mirrors), on 4 x 500GB SATA.

Anything to watch for by not partitioning the drives at all? Or is it 
safer to make one partition, slightly smaller (suggestions of how much 
welcome), than the full drive, to allow for possible size discrepencies 
with replacemnets.

Also I am wondering as this is RAID0 on top of RAID1, if there are any 
special steps that need to be taken when maintaining the array (adding, 
removing, rebuilding etc), compared with a "single layer" RAID?

Regards,

Richard
