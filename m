From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Why would a recreation cause a different number of blocks??
Date: Fri, 25 Apr 2014 09:25:40 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1404250924400.19744@uplift.swm.pp.se>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail
 <53598F69.5070700@csun.edu> <alpine.DEB.2.02.1404250533040.19744@uplift.swm.pp.se> <5359EC4D.7000308@csun.edu> <alpine.DEB.2.02.1404250800190.19744@uplift.swm.pp.se> <535A049C.1010801@csun.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <535A049C.1010801@csun.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Wiegley <jeffw@csun.edu>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 24 Apr 2014, Jeff Wiegley wrote:

> Any thoughts why the recreated array would satisfy and pass cryptsetup's 
> sanity checks but the resulting decrypted data is not recognizable as 
> xfs?

Cryptsetup probably has a very small superblock which fits in one chunk, 
so if you got the order of the other drives wrong, then the fs will still 
be garbled while cryptsetup will think everything is fine.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
