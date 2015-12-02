From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 10:51:11 -0500
Message-ID: <565F136F.2090709@turmel.org>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
 <20151202010745.GC9812@www5.open-std.org>
 <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
 <565F1035.10800@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>, Dallas Clement <dallas.a.clement@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/2015 10:44 AM, Robert Kierski wrote:
> I've tried a variety of settings... ranging from 17 to 32768.
> 
> Yes.. with stripe_cache_size set to 17, I see a C/T of rmw's.  And my TP goes in the toilet -- even with the RAM disks, I get only about 30M/s.

Ok.

You mentioned you aren't using a filesystem.  How are you testing?

Phil

ps. convention on kernel.org is to trim replies and bottom-post, or
interleave.  Please do.
