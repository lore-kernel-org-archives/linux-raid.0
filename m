From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID over Firewire
Date: Thu, 24 Aug 2006 07:11:22 +0100 (BST)
Message-ID: <Pine.LNX.4.56.0608240708220.6721@lion.drogon.net>
References: <44EB94BE.8080907@sauce.co.nz> <Pine.LNX.4.56.0608230832170.6721@lion.drogon.net>
 <44ECC859.5030806@sauce.co.nz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44ECC859.5030806@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 24 Aug 2006, Richard Scobie wrote:

> Gordon Henderson wrote:
>
> > While I haven't done this, I have a client who uses Firewire drives
> > (Lacie) as a backup solution and they seem to "just work", and look like
> > locally attached SCSI drives (Performance is quite good too!) I guess you
> > won't be hot pluging/unplugging them, so those issues won't bite you, but
> > I can't see a reason why a pair of them wouldn't be OK.
>
> Thanks.
>
> While I can see that hotunplugging without unmounting would be an issue,
> what is the problem with hot plugging or unplugging otherwise?

Mostly dumb user issues - unplugging before unmounting, but I have seen
issues in older kernels where the
 echo "scsi remove-single-device 0 0 0 0" > /proc/scsi/scsi
rune has crashed the server.

Gordon
