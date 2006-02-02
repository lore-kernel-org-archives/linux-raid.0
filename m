From: Konstantin Olchanski <olchansk@triumf.ca>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 14:38:59 -0800
Message-ID: <20060202223859.GA26059@sam.triumf.ca>
References: <43E19FAB.4000603@cogweb.net> <pan.2006.02.02.16.17.03.859560@smurf.noris.de> <Pine.GSO.4.62.0602021726010.14030@shaka.acc.umu.se> <Pine.LNX.4.56.0602021651370.19057@lion.drogon.net> <43E27716.10506@dynaconnections.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <43E27716.10506@dynaconnections.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ryan Earl" <ryan@dynaconnections.com>
Cc: Gordon Henderson <gordon@drogon.net>, Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 02, 2006 at 03:18:14PM -0600, J. Ryan Earl wrote:
> >
> > Anyone tried [to how-swap] SATA drives yet?
>
> Yes, and it does NOT work yet.  libata does not support hotplugging of 
> harddrives yet: http://linux.yyz.us/sata/features.html

Despite the claims for the opposite, hot-swap SATA does work,
albeit with caveats and depending on chipsets and drivers.

Hot-unplug and hot-plug works for me with 3ware (8506) and LSI
Megaraid (8-port SATA) controllers. Take a drive out, put it back in,
type in a magic controller dependant command to enable it, then
run mdadm --add.

With the SATA Rocketraid 1820 (hptmv.ko) hot-unplug works,
but hot plug does not (hptmv.ko reports "drive plugged in and enabled,
but Linux I/O fails with errors).

With Promise PDC20319 (4-port SATA), I hot swap by "rmmod sata_promise;
remove old disk; connect new disk; modprobe sata_promise". I am sure
this "rmmod" trick works for hot-swapping disks on any SATA controller.

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
