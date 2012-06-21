From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Find mismatch in data blocks during raid6 repair
Date: Thu, 21 Jun 2012 13:38:38 +0100
Message-ID: <4FE315CE.9090201@anonymous.org.uk>
References: <10900468.MPSjVn2C3J@peanut>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <10900468.MPSjVn2C3J@peanut>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Buchholz <robert.buchholz@goodpoint.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/06/2012 18:41, Robert Buchholz wrote:
[...]
> When repairing a full raid6 with no missing drives (raid-devices=n+2), a
> single inconsistent data block could be detected

Yes, it could. See Neil Brown's blog post as to the many reasons why 
this isn't implemented: http://neil.brown.name/blog/20100211050355

Cheers,

John.
