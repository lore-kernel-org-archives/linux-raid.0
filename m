From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums)
 to make it more robust
Date: Fri, 20 Jul 2012 22:58:44 -0500
Message-ID: <500A28F4.6060005@hardwarefreak.com>
References: <f05fcb33-b518-426e-b308-6fac462554fd@zmail15.collab.prod.int.phx2.redhat.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f05fcb33-b518-426e-b308-6fac462554fd@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/20/2012 7:53 AM, Jaromir Capik wrote:

> I admit, that the problem could lie elsewhere ... but that doesn't 
> change anything on the fact, that the data became corrupted without
> me noticing that.

The key here I think is "without me noticing that".  Drives normally cry
out in the night, spitting errors to logs, when they encounter problems.
 You may not receive an immediate error in your application, especially
when the drive is a RAID member and the data can be shipped regardless
of the drive error.  If you never check your logs, or simply don't see
these disk errors, how will you know there's a problem?

Likewise, if the checksumming you request is implemented in md/RAID1,
and your application never sees a problem when a drive heads South, and
you never check your logs and thus don't see the checksum errors...

How is this new checksumming any better than the current situation?  The
drive is still failing and you're still unaware of it.

-- 
Stan

