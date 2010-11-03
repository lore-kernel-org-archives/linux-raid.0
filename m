From: Tim Small <tim@seoss.co.uk>
Subject: Re: Determining which spindle is out of order
Date: Wed, 03 Nov 2010 14:45:23 +0000
Message-ID: <4CD17583.6070909@seoss.co.uk>
References: <loom.20101103T115828-494@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20101103T115828-494@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Nat Makarevitch <Shelso@makarevitch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/11/10 14:13, Nat Makarevitch wrote:

> To solve this problem we put on each spindle a physical label (a tag, not a
> partition/disk label) showing its device name (sda, sdb...).
>   

As you discovered - that's not a good idea, the device names are
dynamically assigned.

> Then we simulated a crash by physically removing two spindles. Upon reboot the
> devices names changed (?!) and our labels weren't right anymore albeit we are
> pretty sure they were.
>   

Best to use the drive serial number maybe (hdparm -I or smartctl -a, or
the links under /dev/devices/by-id, and also printed on the top of the
drive etc.)?

You can also use the physical slot if that info is available and static
(this varies from controller to controller) and is available under
/dev/disk/by-path/

Cheers,

Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

