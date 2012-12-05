From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Manually failing a disk during a md raid6 reshape
Date: Wed, 5 Dec 2012 14:24:55 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1212051423510.17599@uplift.swm.pp.se>
References: <50BE44A8.1040502@ejane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50BE44A8.1040502@ejane.org>
Sender: linux-raid-owner@vger.kernel.org
To: EJ Vincent <ej@ejane.org>
Cc: linux-raid mailing list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, 4 Dec 2012, EJ Vincent wrote:

> What's the best way to identify ata15.00 and is it permissible to 
> manually fail this device, without damaging and/or interrupting the 
> reshape?

using "iostat -x 5" you might see the AWAIT or similar values shoot up on 
one of the drives when this is happening, that might be a good indicator. 
Apart from that it's not that easy to go from ataXX -> sdX format.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
