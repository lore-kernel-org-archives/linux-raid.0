From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID1, hot-swap and boot integrity
Date: Wed, 07 Mar 2007 12:48:20 -0800
Message-ID: <45EF2514.9050806@zytor.com>
References: <45E82EF8.9000106@laurelnetworks.com> <12470.45E88FAA.5020106@tmr.com> <45ECA9E9.3090507@laurelnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45ECA9E9.3090507@laurelnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Accetta <maccetta@laurelnetworks.com>
Cc: Bill Davidsen <davidsen@tmr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Accetta wrote:
> I gathered the impression somewhere, perhaps incorrectly, that the active
> flag was a function of the boot block, not the BIOS.  We use Grub in the 
> MBR and don't even have an active flag set in the partition table.  The system
> still boots.

The active flag is indeed an MBR issue.

	-hpa
