From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Known-good LSI PCIe SAS HBAs?
Date: Wed, 11 Nov 2009 11:09:54 +0000
Message-ID: <73e903670911110309p6fc1cbe6x2481b61db3f7dd6d@mail.gmail.com>
References: <73e903670911100854o1b48380apb5b0a86c44ae9dcb@mail.gmail.com>
	 <200911110001.49910.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200911110001.49910.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: tfjellstrom@shaw.ca
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 11, 2009 at 7:01 AM, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
> On Tue November 10 2009, you wrote:
>> Hi,
>>
>> I'm looking to replace a problematic Marvell PCIe SAS JBOD controller
>> from Supermicro, type AOC-SASLP-MV8. (mdadm freaks out on it and the
>> controller drops the drives - there has been discussion of the problem
>> on the list. Seems to be a mvsas driver problem but seems to surface
>> only under mdadm use.)
>>
>>...
>
> Not really an answer to your question, I got a snapshot of the in
> development driver that seems to work just fine. I haven't run smartctl on
> the controller much mind you, as it seems to freak out my onboard controller
> too (AMD SB750). I could attempt it, but I've recently just switched over to
> that hardware for my main server, and I'm reluctant to try running smartctl
> on the array, as it'd probably require a reboot to get which ever disk back
> that might get dropped.
>

That's quite interesting.
Did you discuss this on a mailing list somewhere and have a link to
that discussion? Or would you be willing to forward a message to
honorable mr. driver guy? I'd love to try the patch before buying a
new controller.

Thanks!
