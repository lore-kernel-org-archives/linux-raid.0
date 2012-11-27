From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Checksumming RAID?
Date: Tue, 27 Nov 2012 14:49:04 -0600
Message-ID: <50B52740.5000201@hardwarefreak.com>
References: <22100889.14.1354016374529.JavaMail.root@zimbra> <50B4B40B.3000807@hesbynett.no>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50B4B40B.3000807@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Roy Sigurd Karlsbakk <roy@karlsbakk.net>, Linux Raid <linux-raid@vger.kernel.org>, Bernd Schubert <bernd.schubert@fastmail.fm>
List-Id: linux-raid.ids

On 11/27/2012 6:37 AM, David Brown wrote:

> To do checksumming (and in particular, recovery), requires higher level
> knowledge of the data.  The filesystem can track when it writes a file,
> and update metadata (including, if desired, a data checksum) once it
> knows the file is correctly stored.  But I don't think it can sensibly
> be done at the block device level - the recovery procedure doesn't know
> what is old data, what is new data, or which bit is important to the
> filesystem.
> 
> So I think it can make sense to use a filesystem like ZFS or BTRFS that
> can do checksumming - that is a reasonable level to add the checksum.

You'll see CRC in XFS in the future as well.  Some of the foundation is
already laid to allow it, but IIRC it requires an on disk format change
for full implementation.  On disk format changes are a big deal and are
taken with great care.  IIRC XFS has only seen one or two in 18 years.

-- 
Stan

