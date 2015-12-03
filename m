From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Thu, 3 Dec 2015 09:37:52 -0500
Message-ID: <566053C0.4060706@turmel.org>
References: <CAE9DZURyZKmnUmnn5ELAhLUq8nhXD1eBx4g8hDmCzS-MYLrT+Q@mail.gmail.com>
 <20151202010745.GC9812@www5.open-std.org>
 <F7761B9B1D11B64BBB666019E9378117FDDB18@CFWEX01.americas.cray.com>
 <565F03F2.3070803@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDBB9@CFWEX01.americas.cray.com>
 <565F1035.10800@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDC2A@CFWEX01.americas.cray.com>
 <565F136F.2090709@turmel.org>
 <CAE9DZUQGeGFxWigXJr4+HoWCn7+TYj4QBECLce75_zugV14wZQ@mail.gmail.com>
 <CAE9DZUR=w9gbyqm0NzqrKk-G-mT3vd9Py54uEps7fpxC4LMBhg@mail.gmail.com>
 <565FA66C.8060907@turmel.org>
 <CAE9DZUSRZ=bsga0G1UvfL3Dj-4W0ihXgOF=Ppqv=5-vz2+kAoQ@mail.gmail.com>
 <CAE9DZURYwqnMtbhRXVvdqoL5watEyiT8Ct9w1D_Fkr4kzyvPKw@mail.gmail.com>
 <565FAB29.9060405@turmel.org>
 <CAE9DZUQhwXYOA1mMOQX4UjPCBiRJuVKRf1woVmuW1RWO4WzL5Q@mail.gmail.com>
 <565FC548.1060302@turmel.org>
 <F7761B9B1D11B64BBB666019E9378117FDDF2F@CFWEX01.americas.cray.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F7761B9B1D11B64BBB666019E9378117FDDF2F@CFWEX01.americas.cray.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Kierski <rkierski@cray.com>, Dallas Clement <dallas.a.clement@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/03/2015 08:43 AM, Robert Kierski wrote:
> This is why I use Direct-IO to the bare metal block device instead of going through the FS.  Rather than discussing the real problem, we're off in the weed talking about whether the tests should be using O_SYNC and whether there is a problem introduced in the latest version of the FS.

It's not off in the weeds for Dallas, the OP.

> FS's and cache are very good at hiding the problems of those things below them and prevent you from exercising the code you're interested in debugging.

Yep, you seem to have a real problem.

Phil
