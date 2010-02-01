From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: feature suggestion to handle read errors during re-sync of
 raid5
Date: Mon, 1 Feb 2010 08:15:32 +0100 (CET)
Message-ID: <alpine.DEB.1.10.1002010814080.31777@uplift.swm.pp.se>
References: <alpine.DEB.1.10.1001301331560.15329@uplift.swm.pp.se> <4B6471A1.2070407@texsoft.it> <4B6482BD.6090102@anonymous.org.uk> <alpine.DEB.1.10.1001302228540.15329@uplift.swm.pp.se> <4B65AD05.5050000@anonymous.org.uk> <alpine.DEB.1.10.1001311854530.15329@uplift.swm.pp.se>
 <4B662ED1.3060003@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B662ED1.3060003@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 31 Jan 2010, Roger Heflin wrote:

> Bit errors seem more likely the longer a sector has set since being 
> written. I would be not expect to see errors if you read the entire 
> disk, and then reread it 1x a day for a year, but if you read the disk 
> once, let it sit spinning for a year without any reads and read it 
> again, this will almost certainly get a read error.  When you keep 
> rereading it, when the bits start to go bad the disk should move it long 
> before data loss happens, but if you only read it 1x a year, it is 
> likely that when you find the data bad there will be too many bad bits, 
> beyond being able to correct it.

Are you sure that drives today remap like that (if it tries to read it and 
only succeeds on the 5th try, it'll reallocate the sector)?

Looking at "reallocated sectors" on my drives, I've never seen this 
happen. That SMART parameter has never increased unless I had a hard UNC 
and re-wrote the sector (and a lot of the times, not even that).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
