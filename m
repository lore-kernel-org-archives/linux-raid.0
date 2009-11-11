From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Bitmap did not survive reboot
Date: Wed, 11 Nov 2009 09:31:43 +0000
Message-ID: <4AFA847F.1070301@anonymous.org.uk>
References: <20091111085333854.MDRZ6968@cdptpa-omta02.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091111085333854.MDRZ6968@cdptpa-omta02.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/11/2009 08:53, Leslie Rhorer wrote:
[...]
> 	It took me less than 3 minutes total to implement the explicit mount
> routine on both servers, and unless someone can give me either a much better
> solution or a solid reason I should not take this approach

The only problem I can see is that your bitmap is not on a RAID device 
so if the disc goes you lose the bitmap. I guess you're accepting the 
risk of downtime anyway because your filesystem root is on a non-RAID 
device, but while you can (as I think you've said before) replace the 
boot disc quickly, you're exposing yourself to a long, slow resync which 
will increase your downtime by perhaps days...

Cheers,

John.

