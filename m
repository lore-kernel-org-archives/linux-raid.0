From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Sun, 04 Mar 2007 09:31:23 -0800
Message-ID: <45EB026B.1040503@zytor.com>
References: <45E82EF8.9000106@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45E82EF8.9000106@laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Accetta wrote:
> 
> I've been considering trying something like having the re-sync algorithm
> on a whole disk array defer the copy for sector 0 to the very end of the
> re-sync operation.  Assuming the BIOS makes at least a minimal consistency
> check on sector 0 before electing to boot from the drive, this would keep
> it from selecting a partially re-sync'd drive that was not previously 
> bootable.

The only check that it will make is to look for 55 AA at the end of the MBR.

Note that typically the MBR is not part of any of your MD volumes.

	-hpa
