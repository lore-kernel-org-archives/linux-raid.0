From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: RAID 5 : recovery after failure
Date: Wed, 9 Oct 2013 10:28:37 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1310091022560.20065@uplift.swm.pp.se>
References: <CAPbD+Repm2SDpCGsR35QbW9Zq-MiCu1Fsdh4jjP_yESE3E3Exg@mail.gmail.com> <20131008210603.GA22876@cthulhu.home.robinhill.me.uk> <CAPbD+Re5TogdCTWabxoch77zzSRFfZhzuxAF=+UVn_ND2+R-3w@mail.gmail.com> <alpine.DEB.2.02.1310090853060.20065@uplift.swm.pp.se>
 <CAPbD+Rd2Ouvh0crZgujrkqTr2kCNPkQ25D3f7q96eQFDb__ddw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPbD+Rd2Ouvh0crZgujrkqTr2kCNPkQ25D3f7q96eQFDb__ddw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guillaume Betous <guillaume.betous@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 9 Oct 2013, Guillaume Betous wrote:

> Now, should I add the other drives ? How ?

Depends on what the problem is.

Is the initial drive that failed now totally unusable?

In that case, just do mdadm --manage /dev/md0 --add /dev/sd<whatever> with 
a new drive.

But you said you received a second error, was this a read error on one of 
good working drive (see other threads in archive) and so you don't have 
any read errors (the information on those bad sectors will now be lost), 
then you can resync properly.

I strongly recommend going to RAID6 to solve this problem in the future.

I recommend having

for x in /sys/block/sd[a-z] ; do echo 180 > $x/device/timeout ; done

in rc.local (or equivalent) to make sure you can handle timeouts properly 
even for consumer drives.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
