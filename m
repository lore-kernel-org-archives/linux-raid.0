From: Andre Tomt <andre@tomt.net>
Subject: Re: raid10 resync hangs in 4.2.6, 4.3
Date: Mon, 23 Nov 2015 20:48:07 +0100
Message-ID: <56536D77.9040301@tomt.net>
References: <564F6304.3040502@tomt.net> <5652DA63.9080309@intel.com>
 <5652E1CA.3050907@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5652E1CA.3050907@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>, linux-raid <linux-raid@vger.kernel.org>, John Stoffel <john@stoffel.org>
List-Id: linux-raid.ids

On 23. nov. 2015 10:52, Andre Tomt wrote:
> On 23. nov. 2015 10:20, Artur Paszkiewicz wrote:
>> Hi Andre,
>>
>> I've recently sent a patch for a similar problem, I suspect the root
>> cause is the same here. Please check out this patch:
>>
>> http://marc.info/?l=linux-raid&m=144665464232126&w=2
>
> Indeed this is where the bisect just landed me. Going to test the fix
> out later today.
>
> Thanks!
>
> And also thanks to Roy Sigurd Karlsbakk for confirming I had not gone
> completely off the rails :-)

Artur Paszkiewicz's patch fixes the crashes. I'm going to do some data 
integrity checking later today/tomorrow.

It probably should be promoted to stable as both 4.2.x and 4.3.x is 
currently very broken.
