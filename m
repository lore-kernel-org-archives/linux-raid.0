From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: raid5 messed up
Date: Thu, 7 Sep 2017 16:29:49 +0100
Message-ID: <59B165ED.406@youngman.org.uk>
References: <fdbb6bf6-357c-781e-beee-d8589cbb299d@email.latech.edu>
 <d08b6aaf-208e-f4bf-7d19-139103eb14cd@turmel.org>
 <42b3f75a-d93d-f20d-579b-901a305fb508@email.latech.edu>
 <59B09036.1040600@youngman.org.uk>
 <6e5083a4-609b-daba-3326-0dbd9dda6c34@email.latech.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6e5083a4-609b-daba-3326-0dbd9dda6c34@email.latech.edu>
Sender: linux-raid-owner@vger.kernel.org
To: bishop@latech.edu, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/09/17 14:33, Thomas C. Bishop wrote:
> I see what you mean... seems it would be simple enough to find this
> spec. but not clear if supported or not.
> Seagate claims this is a "best fit applications" drive for High-Capacity
> RAID storage but never lists ERC as feature.
> http://www.seagate.com/files/www-content/partners/my%20spp%20dashboard/learn/en-us/docs/storage-solutions-guide-jul-2013-ssg1351-13-1307us.pdf
> 
> pg 30 of the brochure.
> 
>  elsewhere@seagate I read ERC is a subset of the smart control commands
> which are supported on this drive so one _might_ think it's supported.
> 
> FYI: smartctl --xall  doesn't provide an answer either.
> closest it comes is
> SMART support is:     Available - device has SMART capability.

My Barracudas explicitly say SMART is available (disabled by default on
power-up :-(, and ERC is not available. Yours mentions neither ERC, nor
the error timeout, so something's weird somewhere ... quite possibly the
drive can do it, but it's badly documented and the smartctl authors
don't know the magic incantation ... :-)

Or, like the Barracudas have a long timeout hard encoded, possibly the
Constellations have a short timeout hard encoded.

Cheers,
Wol

