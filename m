From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 20:51:05 -0600
Message-ID: <CAE9DZUQhwXYOA1mMOQX4UjPCBiRJuVKRf1woVmuW1RWO4WzL5Q@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <565FAB29.9060405@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 2, 2015 at 8:38 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/02/2015 09:33 PM, Dallas Clement wrote:
>
>> I'm not sure that the sync=1 has any effect in this case where I've
>> got direct=1 set (for non buffered I/O).  I think the sync=1 flag only
>> matters for buffered I/O.  I really shouldn't be setting that flag at
>> all.
>
> It's substantially different from direct=1.  O_DIRECT just bypasses the
> kernel's caches.  O_SYNC flushes the file data and filesystem metadata,
> and kills the device caches and queues.

Isn't O_SYNC only applicable for buffered I/O or going through the
kernel caches?  If I'm using O_DIRECT, seems like it should just
ignore this flag.
