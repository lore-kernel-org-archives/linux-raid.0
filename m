From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: RE: feature suggestion to handle read errors during re-sync of
 raid5
Date: Mon, 1 Feb 2010 14:42:26 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002011440550.31777@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B65AD05.5050000@anonymous.org.uk> <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
 <4B662ED1.3060003@gmail.com> <alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se> <E15146CE216E4737A20C4EC59D414720@m5>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E15146CE216E4737A20C4EC59D414720@m5>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 1 Feb 2010, Guy Watkins wrote:

> I have always read that drives remap on failed write.
> But have not read anything new in 2+ years.

Yes, failed write is one thing, I agree that this happens. The question 
was if there is going to be re-map if there is a read that "was hard to do 
because it took several attemps before it succeeded".

My experience is that it doesn't.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
