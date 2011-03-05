From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Impact of missing parameter during mdadm create
Date: Sat, 05 Mar 2011 15:02:44 +0000
Message-ID: <4D725094.2010503@anonymous.org.uk>
References: <BAY148-w59357147C486E15E514067EFC50@phx.gbl>,<1299307055.4999.8.camel@tankquad> <BAY148-w429D7C51F07A94EB200573EFC50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BAY148-w429D7C51F07A94EB200573EFC50@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Viau <viaum@sheridanc.on.ca>
Cc: linux-raid@vger.kernel.org, linuxraid@kendrummond.com
List-Id: linux-raid.ids

On 05/03/2011 14:47, Mike Viau wrote:
[...]
> I am going to mark this thread as [solved] for now, the issue was not
> with the missing parameter, but with the drive missing being
> connected to the usb bus. When I get a moment later today I'll search
> around to see what others in this situations have done. If all else
> fails and I don't find anything or I just find the quick and dirty
> script fixes, then I will post a new thread looking for suggestions.

You need to get the USB drivers and usb-storage modules into your
initramfs. On CentOS 5 you do that with mkinitrd --with-usb but I don't
what other distros use.

Cheers,

John.

