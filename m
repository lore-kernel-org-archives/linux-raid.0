From: Fabio Muzzi <liste@kurgan.org>
Subject: Re: MD raid and different  elevators  (disk i/o schedulers)
Date: Fri, 30 Jul 2010 00:32:25 +0200
Message-ID: <4C520179.9040002@kurgan.org>
References: <4C51540E.9050005@kurgan.org> <i2sdej$hhu$2@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <i2sdej$hhu$2@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 29/07/10 19:23, Eric Shubert wrote:

> I've been running several vmware server hosts with elevator=deadline on
> raid1 for a year or so now, with no problems.

Nice to hear it, because I have just switched my newly installed vmware 
server (Debian Lenny, md raid1, vmware server) from CFQ to deadline 
because CFQ is VERY slow, causes the entire system to hang for some 
seconds every now and then, and it seems that it also crashed the whole 
machine during intense I/O from the only virtual guest I have running (a 
Win2008 with MS SQL server).


-- 

Fabio "Kurgan" Muzzi

