From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Mon, 05 Mar 2012 14:52:04 +0000
Message-ID: <4F54D314.9060504@anonymous.org.uk>
References: <4F54B997.3060207@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F54B997.3060207@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/03/2012 13:03, Steven Haigh wrote:
> I've noticed that recently I've managed to get a ton of messages like
> this at boot:
>
> mdadm: sending ioctl 1261 to a partition!
> mdadm: sending ioctl 800c0910 to a partition!

It's probably harmless.

http://lists.debian.org/debian-kernel/2012/01/msg01105.html says "This 
warning was introduced as part of the fix for CVE-2011-4127"

https://bugzilla.redhat.com/show_bug.cgi?id=783955#c4 says "Actually, 
the warning seems a false positive to me"

Cheers,

John.

