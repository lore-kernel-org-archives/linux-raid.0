From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID 5,6 sequential writing seems slower in newer kernels
Date: Wed, 2 Dec 2015 21:34:11 -0500
Message-ID: <565FAA23.2060504@turmel.org>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAE9DZUSRZ=bsga0G1UvfL3Dj-4W0ihXgOF=Ppqv=5-vz2+kAoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dallas Clement <dallas.a.clement@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/02/2015 09:24 PM, Dallas Clement wrote:
> On Wed, Dec 2, 2015 at 8:18 PM, Phil Turmel <philip@turmel.org> wrote:
>> I suspect if you do a bisect on the kernel to pinpoint the change(s)
>> that is doing this, you'll find a patch that closes a device-specific or
>> filesystem sync bug or something that enables deep queues for a device.
>>
>> Modern software that needs file integrity guarantees make sparse use of
>> fdatasync and/or fsync and avoid sync entirely.  You'll have a more
>> believable test if you use fsync_on_close=1 or end_fsync=1.
>>
>> Phil
> 
> Hi Phil. Hmm that makes sense that something may have changed wrt to
> syncing.  Basically what I am trying to do with my fio testing is
> avoid any asynchronous or caching behavior.

I hope that if you really need this you are doing exhaustive testing on
failure modes -- I would be worried that these speed changes imply flaws
in the older kernels.
