From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Mon, 07 Jan 2008 12:10:31 +0100
Message-ID: <478208A7.2000108@ph.tum.de>
References: <4774663C.5090609@zytor.com>    <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>    <477EC96D.80505@zytor.com> <51481.88.217.65.202.1199493668.squirrel@www.e18.physik.tu-muenchen.de> <477ED321.6000708@zytor.com> <4781F0AE.7030304@ph.tum.de> <Pine.GSO.4.64.0801071055200.20667@montezuma.acc.umu.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.64.0801071055200.20667@montezuma.acc.umu.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mattias Wadenstein <maswan@acc.umu.se>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Mattias Wadenstein wrote:
> On Mon, 7 Jan 2008, Thiemo Nagel wrote:
> 
>>> What you call "pathologic" cases when it comes to real-world data are 
>>> very common.  It is not at all unusual to find sectors filled with 
>>> only a constant (usually zero, but not always), in which case your 
>>> **512 becomes **1.
>>
>> Of course it would be easy to check how many of the 512 Bytes are 
>> really different on a case-by-case basis and correct the exponent 
>> accordingly, and only perform the recovery when the corrected 
>> probability of introducing an error is sufficiently low.
> 
> What is the alternative to recovery, really? Just erroring out and 
> letting the admin deal with it, blindly assume that the parity is wrong?

Currently, 'repair' does blind recalculation of parity.  The only 
benefit of that is (correct me if I'm wrong) to ascertain repeated reads 
return identical data.

The last time I checked, there was not even a warning message.

Kind regards,

Thiemo Nagel
