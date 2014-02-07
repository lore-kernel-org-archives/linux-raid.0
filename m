From: David Brown <david.brown@hesbynett.no>
Subject: Re: Storage system
Date: Fri, 07 Feb 2014 17:36:11 +0100
Message-ID: <52F50B7B.8020902@hesbynett.no>
References: <20140206180909.GA2419@lazy.lzy>	<52F49433.8080904@hesbynett.no> <CAJvUf-BTjmxonub0eWGNm1YNp4zYis5Mgti9FuRiQ8RbVY3cXQ@mail.gmail.com> <52F505B3.2050902@hesbynett.no> <52F508EF.7090808@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52F508EF.7090808@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/02/14 17:25, Can Jeuleers wrote:
> On 02/07/2014 05:11 PM, David Brown wrote:
>> The only thing you can't erase are re-mapped sectors - but hopefully
>> those will be rare!
> 
> I wonder if using the Secure Erase feature destroys all sectors
> (including remapped-ones) or not.
> 

I think secure erase can be done in different ways.  On disks that have
full-disk encryption, it simply erases (or changes) the password.  For
other drives, it has to write through all sectors on the disk - I would
expect re-mapped sectors are included, but I don't know the details.


> Also, what level of trust do people on this list have that the disk's
> Secure Erase feature does what it says on the tin?


