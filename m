From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 09:45:06 -0500
Message-ID: <565F03F2.3070803@turmel.org>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
 <20151202010745.GC9812@www5.open-std.org>
 <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>, Dallas Clement <dallas.a.clement@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/2015 09:18 AM, Robert Kierski wrote:
> Sorry... I should have mentioned that I'm running the 3.18.4 kernel
> with a 32 core xeon and 128G of memory.  I'm not using a FS, I'm
> going directly to the raid block device.

I'm not sure if the parallelization of raid parity has been merged yet,
but I'm pretty sure it isn't in 3.18.  With one core tied up computing
parity and the rest idle, that'd be 96.875% idle.

Phil
