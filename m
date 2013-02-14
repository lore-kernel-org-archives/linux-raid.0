From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Thu, 14 Feb 2013 18:09:39 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1302141802460.32644@uplift.swm.pp.se>
References: <20130214150128.53080@gmx.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130214150128.53080@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Dragon <Sunghost@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 14 Feb 2013, Dragon wrote:

> no i dindnt have a old version of examin from before ;(

Do you know what version of kernel and mdadm was used to create the raid5 
in the first place? You should go back to that (at least the mdadm 
version) and try the --create --assume-clean with that mdadm version. 
Several key factors have changed between versions.

Look at this thread for a person with similar problem 
<http://www.spinics.net/lists/raid/msg41732.html>, there is discussion 
about data offset etc in there, might be a good start.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
