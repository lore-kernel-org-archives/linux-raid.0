From: Dallas Clement <dallas.a.clement@gmail.com>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 20:24:49 -0600
Message-ID: <CAE9DZUSRZ=bsga0G1UvfL3Dj-4W0ihXgOF=Ppqv=5-vz2+kAoQ@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <565FA66C.8060907@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Dec 2, 2015 at 8:18 PM, Phil Turmel <philip@turmel.org> wrote:
> On 12/02/2015 07:12 PM, Dallas Clement wrote:
>> All measurements computed from bandwidth averages taken on 12 disk
>> array with XFS filesytem using fio with direct=1, sync=1,
>> invalidate=1.
>
> Why do you need direct=1 and sync=1 ?  Have you checked an strace from
> the app you are trying to model that shows it uses these?
>
>> Seems incredulous!?
>
> Not with those options.  Particularly sync=1.  That causes an inode
> stats update and a hardware queue flush after every write operation.
> Support for that on various devices has changed over time.
>
> I suspect if you do a bisect on the kernel to pinpoint the change(s)
> that is doing this, you'll find a patch that closes a device-specific or
> filesystem sync bug or something that enables deep queues for a device.
>
> Modern software that needs file integrity guarantees make sparse use of
> fdatasync and/or fsync and avoid sync entirely.  You'll have a more
> believable test if you use fsync_on_close=1 or end_fsync=1.
>
> Phil

Hi Phil. Hmm that makes sense that something may have changed wrt to
syncing.  Basically what I am trying to do with my fio testing is
avoid any asynchronous or caching behavior.
