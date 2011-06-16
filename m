From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mdadm and disk failures
Date: Thu, 16 Jun 2011 07:29:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1106160728020.26305@uplift.swm.pp.se>
References: <4DF97A7B.1070901@dodtsair.com> <20110616105908.474d22bc@natsu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110616105908.474d22bc@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Mike Power <mpower@dodtsair.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 16 Jun 2011, Roman Mamedov wrote:

> At that moment, when the hard disk has new user data for that sector, it 
> can finally do the remap and put it somewhere else on a remapped good 
> sector.

Just to be clear, it won't necessarily remap the sector. It might succeed 
in writing the new data to it and determine the sector isn't really bad, 
and not remap it.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
