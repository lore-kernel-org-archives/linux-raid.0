From: Thiemo Nagel <thiemo.nagel@ph.tum.de>
Subject: Re: On the subject of RAID-6 corruption recovery
Date: Mon, 07 Jan 2008 10:28:14 +0100
Message-ID: <4781F0AE.7030304@ph.tum.de>
References: <4774663C.5090609@zytor.com>    <59840.88.217.65.202.1199491167.squirrel@www.e18.physik.tu-muenchen.de>    <477EC96D.80505@zytor.com> <51481.88.217.65.202.1199493668.squirrel@www.e18.physik.tu-muenchen.de> <477ED321.6000708@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <477ED321.6000708@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> What you call "pathologic" cases when it comes to real-world data are 
> very common.  It is not at all unusual to find sectors filled with only 
> a constant (usually zero, but not always), in which case your **512 
> becomes **1.

Of course it would be easy to check how many of the 512 Bytes are really 
different on a case-by-case basis and correct the exponent accordingly, 
and only perform the recovery when the corrected probability of 
introducing an error is sufficiently low.

Kind regards,

Thiemo Nagel
