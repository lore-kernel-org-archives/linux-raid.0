From: Konstantin Olchanski <olchansk@sam.triumf.ca>
Subject: Re: Anyone clueful on forcing 3ware drive discovery?
Date: Thu, 8 Sep 2005 12:34:12 -0700
Message-ID: <20050908193412.GH5304@sam.triumf.ca>
References: <200509081914.j88JEWgr008704@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200509081914.j88JEWgr008704@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 08, 2005 at 02:14:32PM -0500, Dr. Greg Wettstein wrote:
> We are using a number of 3Ware 75xx and 8xxx controller cards...
> Last week we had a 7508 kick a drive on an AEN, presumably tripped by
> a SMART event on the drive.  After the error the controller disavowed
> all knowledge of the drive and we had to power cycle the machine to
> get the controller card to recognize the drive.

I once saw a similar fault with a SATA disk on a 3ware-SATA controller-
it could not be accessed until power cycled. I assume the disk firmware
crashed (or whatever) and stopped talking on the SATA interface. 

Maybe some hot-plug hardware allows cycling power on individual disks
without physically walking/cycling/driving to the computer and doing
it the hard way by pulling the disk out (pulling a spinning disk out, bad,
bad, bad!).

-- 
Konstantin Olchanski
Data Acquisition Systems: The Bytes Must Flow!
Email: olchansk-at-triumf-dot-ca
Snail mail: 4004 Wesbrook Mall, TRIUMF, Vancouver, B.C., V6T 2A3, Canada
