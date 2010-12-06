From: Tim Small <tim@seoss.co.uk>
Subject: Re: Deadlock in md barrier code? / RAID1 / LVM CoW snapshot + ext3
 / Debian 5.0 - lenny 2.6.26 kernel
Date: Mon, 06 Dec 2010 15:42:31 +0000
Message-ID: <4CFD0467.2060606@seoss.co.uk>
References: <4C938103.1010304@seoss.co.uk>	<20100918085925.5fee83ee@notabene>	<4C97BD21.1040405@seoss.co.uk>	<4C991D61.1040400@seoss.co.uk>	<20100922083039.283ccdfd@notabene>	<4CBC9774.6020500@seoss.co.uk>	<20101019171650.20c83e7e@notabene>	<4CBDC641.9090009@seoss.co.uk>	<4CBDC756.7010606@seoss.co.uk>	<4CBDF190.2000007@seoss.co.uk>	<4CBF5267.7080304@seoss.co.uk>	<20101021100429.4879a001@notabene>	<4CE56AA9.2010905@seoss.co.uk> <20101122100509.76592b59@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20101122100509.76592b59@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/21/10 23:05, Neil Brown wrote:
> Yes.  Superficially, it appears that there are still 5 outstanding read
> requests that are not being completed.   I cannot guess how OpenVZ would
> cause that, but I don't really know much about OpenVZ

Hi Neil,

I very much appreciate your help debugging this.

I opened a bug against the relevant Debian kernel.  Now that this is
pretty well characterised, I think it's probably best to just workaround
it (e.g. by setting speed_limit_max to 0 during the backups which were
tripping over this), until such time as the kernel can be replaced with
a more recent one...

Cheers,

Tim.




-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.  
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

