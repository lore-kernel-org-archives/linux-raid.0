From: Martin Wilck <mwilck@arcor.de>
Subject: Re: imsm identification problem.  mdadm 3.3
Date: Tue, 08 Oct 2013 20:23:45 +0200
Message-ID: <52544DB1.7020402@arcor.de>
References: <20131003022319.GA28770@animx.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131003022319.GA28770@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: Wakko Warner <wakko@animx.eu.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/03/2013 04:23 AM, Wakko Warner wrote:
> Please keep me in CC.
> 
> I compiled v3.3 to see if the problem was still there.  It is.  The problem. 
> I setup an imsm array with 2 volumes.  a 200mb raid10 volume, and a raid5 on
> the remaining space.  This was done from the bios.
> 
> mdadm detected the array and volumes ok, but the names are wrong.  the 200mb
> was named EFI and the other was named ani.
> 
> /dev/md127 is the imsm container.
>        126 is the volume ani. (This is about 7tb.  disks are 3tb each and
> still initializing)
>        125 is the volume EFI.
> 
> According to --examine /dev/md127,
> [EFI] UUID is ad256dcf:38ff8fed:8c27647e:24f61d81
> [ani] UUID is 9fe3c18a:0e9e2d4f:613456ca:b9989dcc
> 
> However --detail --export /dev/md125 shows the name as ani with UUID
> ad256dcf:38ff8fed:8c27647e:24f61d81 and --detail --export /dev/md126 shows
> the name EFI with UUID 9fe3c18a:0e9e2d4f:613456ca:b9989dcc.
> 
> I did manually bring these up using mdadm 3.2.5-5 (Debian).  I don't remember
> the exact commands off the top of my head, but they should be in my history if
> needed.

Do I understand correctly, this is the situation after bringing up the
array with mdadm 3.2.5, you are just looking at the state of affairs
with mdadm 3.3? If yes, I wouldn't expect any difference between the
output of mdadm 3.3 and 3.2.5. Both just reflect the current state of md
in the kernel (MD_DEVNAME is just the device name the array has under
/dev/md).

In order to see if your problem is fixed with mdadm 3.3, you must
assemble the array with 3.3 (and mdmon from 3.3 should be used as well).

Martin
