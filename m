From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bug in multipath code (Linux 2.6.x) ?
Date: Thu, 8 Apr 2004 08:37:15 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16500.33435.140991.667064@cse.unsw.edu.au>
References: <B7A4A15090CB1847A60B569AC92FB9B352D24A@EXSTORE2.zdv.uni-mainz.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dominik Kubla on Wednesday April 7
To: Dominik Kubla <kubla@uni-mainz.de>
Cc: linux-raid@vger.kernel.org, khoddam@netz.klinik.uni-mainz.de
List-Id: linux-raid.ids

On Wednesday April 7, kubla@uni-mainz.de wrote:
> Hi Neil,
> 
> It appears to me as if there might be a bug in the multipath code since
> it is impossible to activate the multipath device properly. It doesn't
> matter if one uses raidtools or mdadm. Every time i try to activate the
> mp devices, the system complains about not being able to access the
> drive. The result is a mp device with just one path.

It wouldn't surprise me if there was a bug in the multipath code.
I have no hardware to test it on and little interest in it.  I'm happy
to fix obvious bugs and I try not to break it with other changes in
md, but beyond that I just leave it alone.

I can do a simple test using two loopback devices on the same file as
the two paths and that seems to work OK, so there is probably some
interesting interaction with your particular hardware and it's driver.

So, if you can get good error messages and try to figure out what is
actually happening, then I'm happy to look at fixing it, but without
lots of details, there isn't much I can do.

NeilBrown


> 
> Hardware configuration:
> 
> Sun Fire v65x with two LSI Logic FC-HBA's connected to two disjunct
> switched fabrics.
> Fabric switches are four Brocade Silkwork 3600 and storage devices are
> two Adv. Unibyte JBODs.
> 
> Software configuration:
> 
> Debian GNU/Linux (unstable) with kernel 2.6.4.
> Two disks are setup up as individual mp devices with a RAID1 on top of
> the two mp devices.
> 
> I don't have the exact error message at the moment, but can supply it in
> case it is needed.
> 
> Regards,
>   Dominik Kubla
