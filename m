From: Frank van Maarseveen <frankvm@frankvm.com>
Subject: Re: mdadm segfault
Date: Sun, 8 Oct 2006 15:41:21 +0200
Message-ID: <20061008134121.GA28179@janus>
References: <20061008121442.GA27570@janus> <4528FD31.6080105@idgmail.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4528FD31.6080105@idgmail.se>
Sender: linux-raid-owner@vger.kernel.org
To: Henrik Holst <henrik.holst@idgmail.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 08, 2006 at 03:29:21PM +0200, Henrik Holst wrote:
> Frank van Maarseveen wrote:
> > Maybe it's fixed already but just in case... trying to assemble an array
> > by UUID without any mdadm.conf segfaulted, e.g.:
> > 
> > 	mdadm -A --uuid=d764947c:875b3b25:d10330b1:eec6e325 /dev/md10 -c partitions
> > 
> 
> You probably want to include version of mdadm as well as your kernel
> version.
> 
> Please post your /proc/partitions file as well.

Just tried it out on FC4 (mdadm - v1.11.0 - 11 April 2005) and it seems
fixed. Apparently I stumbled on a very old version of mdadm.

-- 
Frank
