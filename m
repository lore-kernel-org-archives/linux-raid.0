From: Tim Small <tim@seoss.co.uk>
Subject: Re: Broken RAID1 boot arrays
Date: Mon, 10 May 2010 10:47:37 +0100
Message-ID: <4BE7D639.6080602@seoss.co.uk>
References: <03.5E.29689.68E67EB4@cdptpa-omtalb.mail.rr.com> <4BE7CF2C.8030400@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE7CF2C.8030400@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Leslie Rhorer <lrhorer@satx.rr.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/05/10 10:17, John Robinson wrote:
>
> Secondly, the idea of grub1 chain-loading grub2 sounds iffy to me; use 
> either grub1 or grub2 but not both.

This is Debian's upgrade-mechanism for Grub.  It sets up grub1 to give 
you the option of either:

1. Chainloading grub2, so that you can verify that it works correctly, 
and then issue the command to remove grub1, an just-use grub2 if you're 
happy with it, or in case there's some problem with grub2.
2. Booting the kernel directly from grub1 (then you can remove grub2 
once the system has booted).

The OP should probably report this as a bug against the 
linux-image-2.6.xx package which they are using in Debian.


Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

