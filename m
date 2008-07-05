From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: 2.6.26-rc8 deadlock: RAID code?
Date: Sat, 5 Jul 2008 08:54:31 -0700
Message-ID: <e9c3a7c20807050854o330279f7x3d64b1ec263f8800@mail.gmail.com>
References: <20080704125551.24267.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080704125551.24267.qmail@science.horizon.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: George Spelvin <linux@horizon.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jul 4, 2008 at 5:55 AM, George Spelvin <linux@horizon.com> wrote:
> I've seen this twice before, but had to get remote logging working to
> capture the initial error; once the root file system locks up there's
> an unending stream of these messages and even syslog can't actually
> log anything.
>
> (In fact, it locked up and stopped working after capturing this here.
> I'd have to get a null modem cable and serial console to capture more.)
>
> I can do it again, but it takes a few days.
>
> Hardware: single-core Athlon 64, ECC memory (scrubbing enabled),
> 6x SATA drives on 3x SiI3132 controllers.  Root file system (where I
> believe the problem is) is ext3 over RAID-10 over all drives.  Another,
> larger file system (that I can't see why the sensors daemon would touch)
> is ext3 over RAID5 over the same drives.
>
> Kernel is 2.6.26-rc8 + EDAC patches + linuxpps support.  This problem
> was not observed in 2.6.25 kernels (with the same patches).
>
> Any ideas?  For now, I'm going to turn on frame pointers and
> CONFIG_PROVE_LOCKING to get more information.
>

Are you running with CONFIG_NUMA=n?  If so, you may be seeing the
effects of kswapd not running. See the patch at:

     http://marc.info/?l=linux-mm&m=121510360428340&w=2

--
Dan
