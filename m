From: Bryan Wann <bryan@datafoundry.com>
Subject: Re: Avoiding resync of RAID1 during creation
Date: Mon, 20 Feb 2006 14:51:53 -0600
Message-ID: <43FA2BE9.6010804@datafoundry.com>
References: <43F9E65D.6040402@datafoundry.com> <5b170a7d0602201227p5cb458a5j13aecca21aa3d627@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5b170a7d0602201227p5cb458a5j13aecca21aa3d627@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Tuomas Leikola wrote:
> mdadm --assume-clean
> 
> from the man page:
> 
> It can also be used when creating a RAID1 or RAID10 if you want to
> avoid the initial resync, however this  practice - while normally safe
> - is not recommended.

What version of mdadm was that from?  From mdadm(8) in 
mdadm-1.11.0-4.fc4 on my systems:

   --assume-clean
     Tell  mdadm that the array pre-existed and is known to be clean.
     This is only really useful for Building RAID1 array.   Only  use
     this  if  you really know what you are doing.  This is currently
     only supported for --build.

I tried with --assume-clean, it still wanted to sync.  From what my man 
page was telling me, it only works with --build.  If I use --build it'll 
go ahead without syncing, but I need per-device superblocks.  Why mdadm 
didn't error when I used --assume-clean with --create, I don't know.

--bryan
