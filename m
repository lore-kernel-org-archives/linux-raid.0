From: Iain Rauch <groups@email.iain.rauch.co.uk>
Subject: Re: RAID 6 grow problem
Date: Sat, 02 Jun 2007 22:26:41 +0100
Message-ID: <C2879F21.7ED1%groups@email.iain.rauch.co.uk>
References: <Pine.LNX.4.64.0706021232040.13184@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706021232040.13184@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> For the critical section part, it may be your syntax..
> 
> When I had the problem, Neil showed me the path! :)
I don't think it is incorrect, before I thought it was supposted to specify
an actual file so I 'touch'ed one and it says file exists.

> For your issue, do you have raid5/6 GROW support enabled in the kernel?
> Also I grew mine I never used the --backup-file option.
I don't know, how would I find this out? uname -r gives me 2.6.20-15-server.


Iain


