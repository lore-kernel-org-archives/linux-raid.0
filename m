From: Jurriaan <thunder7@xs4all.nl>
Subject: Re: Fedora 2.0 - raid1 not working
Date: Tue, 9 Nov 2004 20:57:06 +0100
Message-ID: <20041109195706.GA21202@middle.of.nowhere>
References: <419115A5.4050905@skybuilders.com> <20041109192219.GA5822@middle.of.nowhere> <41911ACB.2070604@skybuilders.com> <20041109194127.GA17963@middle.of.nowhere> <41911F09.2070403@skybuilders.com>
Reply-To: Jurriaan <thunder7@xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <41911F09.2070403@skybuilders.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jesse Burkhardt <jesse@skybuilders.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

From: Jesse Burkhardt <jesse@skybuilders.com>
Date: Tue, Nov 09, 2004 at 02:48:25PM -0500
>    What happens in failure mode is that the computer succeeds in completing
>    its POST (power on self test) cycle but never goes on to load the OS.
> 
>    PS - Another user, [1]olchansk@sam.triumf.ca, says that kernel 2.6 is
>    broken as to raid1, but it has been patched, but not yet in the Fedora
>    version.
> 
I'm not sure if current BIOS code still requires a single 'active'
partition on a single drive to boot. If it still does, that would
explain what happens to you.

As for the kernel being at fault - perhaps, I never noticed anything,
but if even grub doesn't come on, it surely isn't the kernel's fault.

Good luck,
Jurriaan
-- 
REAL LIFE MANAGEMENT 'DILBERT QUOTATIONS':
5: Doing it right is no excuse for not meeting the schedule. No one will
   believe you solved this problem in one day! We've been working on it
   for months. Now, go act busy for a few weeks and I'll let you know
   when it's time to tell them. (R&D supervisor, Minnesota Mining and
   Manufacturing/3M Corp.)
Debian (Unstable) GNU/Linux 2.6.9-mm1 2x6078 bogomips load 1.17
