From: Carlos Carvalho <carlos@fisica.ufpr.br>
Subject: Re: RAID5/6 slow due to a member device -- how to diagnose?
Date: Thu, 3 Mar 2016 11:37:32 -0300
Message-ID: <20160303143732.GA10802@fisica.ufpr.br>
References: <20160303193026.7d08e64b@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160303193026.7d08e64b@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Roman Mamedov (rm@romanrm.net) wrote on Thu, Mar 03, 2016 at 11:30:26AM BRT:
> Let's suppose I am seeing slow write performance on a RAID5 or RAID6, and I am
> suspecting that it's because of one of its devices operating slower than
> others (maybe a soft-failing or just low-performing hard drive, in case with
> non-identical member drives). Nothing in dmesg, no timeouts or ATA errors or
> anything like that.
> 
> How would I go about diagnosing which device that is (if any) is slowing down
> the array, aside from performance-testing each individual device (which seems
> rather difficult if it's only slow on writes, not reads).

I use sar -d -p 5 |grep -v md
