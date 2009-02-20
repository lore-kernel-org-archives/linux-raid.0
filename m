From: Sitsofe Wheeler <sitsofe@yahoo.com>
Subject: Re: General question (scheduler) with SSDs?
Date: Fri, 20 Feb 2009 19:25:44 +0000
Message-ID: <20090220192543.GA21644@silver.sucs.org>
References: <alpine.DEB.1.10.0902190837270.19552@p34.internal.lan> <20090220094356.GB26124@silver.sucs.org> <ac3eb2510902200316m387ecb45n86a2ea7c6196b01@mail.gmail.com> <20090220131209.GA21446@silver.sucs.org> <ac3eb2510902200523o619e64aas7bffac9aeca86814@mail.gmail.com> <20090220142705.GA429@silver.sucs.org> <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510902200656l11275aber128848182553726d@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Sitsofe Wheeler <sitsofe@yahoo.com>, Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 20, 2009 at 03:56:06PM +0100, Kay Sievers wrote:
> Also the whitespace after "...PHISON *" does not need to be matched.
> If the match value does not end in whitespace itself, udev will match
> against the value with all trailing whitespace ignored.

Ah, I'm not matching against only whitespace:

$ cat /sys/block/*/device/model 
ASUS-PHISON OB S
ASUS-PHISON SSD 

(the first is the builtin faster SSD, the other is the slower removable
SSD).

-- 
Sitsofe | http://sucs.org/~sits/
