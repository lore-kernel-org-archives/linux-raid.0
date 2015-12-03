From: Weedy <weedy2887@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Thu, 3 Dec 2015 17:21:14 -0500
Message-ID: <CAFE24U2hVOxhUga6c4zbx2+w-Q=VO8A83iv7eeERWwcam+MGyA@mail.gmail.com>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
 <20151202010745.GC9812@www5.open-std.org> <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org> <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
 <565F1035.10800@turmel.org> <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
 <565F136F.2090709@turmel.org> <CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
 <F7761B9B1D11B64BBB666019E9378117FDDF77@CFWEX01.americas.cray.com> <566059E8.60804@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <566059E8.60804@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Robert Kierski <rkierski@cray.com>, Dallas Clement <dallas.a.clement@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is a bit off topic for this thread but is this tuning info on one
of the wiki's.
I mean tuning all the caches and whether you should have bitmaps on or off.

I'm going to build a new raid 5 (possibly raid 6) soon and would like
to saturate gigabit line.
I'd like to get my caches and stripes setup right for a 4 or 6 disk array.
