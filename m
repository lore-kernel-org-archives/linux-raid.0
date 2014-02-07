From: Can Jeuleers <can.jeuleers@gmail.com>
Subject: Re: Storage system
Date: Fri, 07 Feb 2014 17:25:19 +0100
Message-ID: <52F508EF.7090808@gmail.com>
References: <20140206180909.GA2419@lazy.lzy>	<52F49433.8080904@hesbynett.no> <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com> <52F505B3.2050902@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F505B3.2050902@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 02/07/2014 05:11 PM, David Brown wrote:
> The only thing you can't erase are re-mapped sectors - but hopefully
> those will be rare!

I wonder if using the Secure Erase feature destroys all sectors
(including remapped-ones) or not.

Also, what level of trust do people on this list have that the disk's
Secure Erase feature does what it says on the tin?
