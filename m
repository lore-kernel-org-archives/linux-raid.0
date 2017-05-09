From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 18:28:20 +0800
Message-ID: <9306fd68-4eeb-f487-a500-27050050af98@fnarfbargle.com>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <591171BD.3060707@hesbynett.no> <87efvy73n9.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87efvy73n9.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, David Brown <david.brown@hesbynett.no>
Cc: Wols Lists <antlists@youngman.org.uk>, "Ravi (Tom) Hale" <ravi@hale.ee>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/05/17 17:58, Nix wrote:
>  md doesn't repair the corruption, even though on RAID-6 it could.

Patches are *always* welcome.

> but one wonders how many disks actually *do* this. It's hard to
> tell because sector sparing is so quiet: it's not always even reflected
> in the SMART data, AIUI.

Decent SAS drvies do it routinely *and* they tell you in the SMART data 
how long it has been since the last scrub, how long it is until the next 
scrub and how many errors it has silently corrected over the drive life. 
You get what you pay for.

Brad

