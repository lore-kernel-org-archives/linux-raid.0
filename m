From: Spelic <spelic@shiftmail.org>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 16:30:44 +0100
Message-ID: <4D4432A4.8080201@shiftmail.org>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
 <alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
 <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/29/2011 07:44 AM, Roberto Spadim wrote:
> faster than nbd?

NBD is fast but has one problem: if you lose network connectivity for a 
while (tcp drops) there is no recovery I am aware of. I think it unmaps 
the disk until user intervention. Or this was the situation a couple of 
years ago.
Actually for RAID this might even be a good point, but keep it in mind.
iscsi seems an obvious alternative. And you can put anything under MD I 
think, but DRBD (without MD) is probably better because it's made 
exactly for that purpose.

