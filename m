From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Comments on printing out right raid type?
Date: Thu, 20 Nov 2008 12:06:59 +0000
Message-ID: <492552E3.4010407@anonymous.org.uk>
References: <alpine.DEB.1.10.0811200658030.26275@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0811200658030.26275@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/11/2008 11:59, Justin Piszcz wrote:
> Someone had submitted a patch to correct part of the problem I was 
> mentioning earlier, while it may be trivial, do you and others think it 
> would be worthwhile to print "raid6" when it is a raid6 rather than 
> printing raid5 for most messages in the kernel?

Alternatively, if the same code is used for all of RAID 4/5/6, perhaps 
the simplest thing would be for the messages just to say "raid456".

Cheers,

John.

