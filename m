From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 22 Apr 2010 18:32:17 +0200
Message-ID: <4BD07A11.5040300@rabbit.us>
References: <626601cae203$dae35030$0400a8c0@dcccs> <alpine.DEB.1.10.1004221658040.6768@uplift.swm.pp.se> <64bd01cae22e$456461e0$0400a8c0@dcccs> <alpine.DEB.1.10.1004221713420.6768@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1004221713420.6768@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Janos Haar <janos.haar@netcenter.hu>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson wrote:
> On Thu, 22 Apr 2010, Janos Haar wrote:
> 
> I don't have a good idea that assures your data, unfortunately. One way
> would be to dd the defective drives to working ones, but that will most
> likely cause you to have data loss on the defective sectors (since md
> has no idea that these sectors should be re-created from parity).
> 

There was a thread[1] some time ago, where HPA confirmed that the RAID6
data is sufficient to write an algorithm which will be able to determine
which sector is in fact the offending one. There wasn't any interest to
incorporate this into the sync_action/repair function though :(

[1] http://www.mail-archive.com/linux-raid@vger.kernel.org/msg07327.html
