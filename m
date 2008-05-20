From: David Greaves <david@dgreaves.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Tue, 20 May 2008 08:37:38 +0100
Message-ID: <48327FC2.1010901@dgreaves.com>
References: <loom.20080519T224713-779@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20080519T224713-779@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yep. Don't panic and don't do anything else yet if you're not confident about
what you're doing.

I'll follow up with more info in a short while.

Info you can provide:
kernel version
mdadm version
cat /proc/mdstat
mdadm --examine /dev/sd[abcdef]1 (or whatever your array components are)
relevant smartctl info on the bad drive(s)
dmesg info about the drive failures

Assuming genuine hardware failure:
Do you have any spare drives that you can use to replace the components?

David


Cry wrote:
> Folks,
> 
> I had a drive fail on my 6 drive raid-5 array.  while syncing in the replacement
> drive (11 percent complete) a second drive went bad.
> 
> Any suggestions to recover as much data as possible from the array?
> 
> Joel
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

