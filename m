From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Fri, 06 Jan 2012 16:55:29 -0600
Message-ID: <4F077BE1.4050408@hardwarefreak.com>
References: <20111212115459.GC20730@fi.muni.cz> <4EE61EAE.20101@anonymous.org.uk> <20120106150823.GX25976@fi.muni.cz> <20231.9177.523012.471046@tree.ty.sabi.co.UK> <20120106201150.GB13358@fi.muni.cz>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120106201150.GB13358@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Kasprzak <kas@fi.muni.cz>
Cc: Peter Grandi <pg@lxra2.for.sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/6/2012 2:11 PM, Jan Kasprzak wrote:
> And I suspect that XFS swidth/sunit
> settings will still work with RAID-10 parameters even over plain
> LVM logical volume on top of that RAID 10, while the settings would
> be more tricky when used with interleaved LVM logical volume on top
> of several RAID-1 pairs (LVM interleaving uses LE/PE-sized stripes, IIRC).

If one is using many RAID1 pair s/he probably isn't after single large
file performance anyway, or s/he would just use RAID10.  Thus
sunit/swidth settings aren't tricky in this case.  One would use a
linear concatenation and drive parallelism with XFS allocation groups,
i.e. for a 24 drive chassis you'd setup an mdraid or lvm linear array of
12 RAID1 pairs and format with something like:

$ mkfs.xfs -d agcount=24 [device]

As long as one's workload writes files relatively evenly across 24 or
more directories, one receives fantastic concurrency/parallelism, in
this case 24 concurrent transactions, 2 to each mirror pair.  In the
case of 15K SAS drives this is far more than sufficient to saturate the
seek bandwidth of the drives.  One may need more AGs to achieve the
concurrency necessary to saturate good SSDs.

-- 
Stan
