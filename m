From: "David Rees" <drees76@gmail.com>
Subject: Re: Fedora 9 install using md RAID
Date: Wed, 12 Nov 2008 10:26:56 -0800
Message-ID: <72dbd3150811121026k21ee2c01g12dcfe263e3ca383@mail.gmail.com>
References: <491A5165.5080004@sauce.co.nz>
	 <1226505384.4765.70.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1226505384.4765.70.camel@firewall.xsintricity.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Nov 12, 2008 at 7:56 AM, Doug Ledford <dledford@redhat.com> wrote:
> On Wed, 2008-11-12 at 16:45 +1300, Richard Scobie wrote:
>> Slightly off topic, but I was wondering if anyone knew how I could do an
>> install of Fedora 9 WITHOUT it using dm RAID.
>>
>> I have done a number of md RAID installs of Fedora 9, but this
>> particular machine has a Silicon Image controller that the Redhat
>> installer obviously recognises and automatically proceeds to install
>> using dmraid and I would prefer to use md.
>
> At the boot prompt, pass the nodmraid option.  There are a number of
> options available, you can get the entire list by installing anaconda,
> then running anaconda --help on a working system.  Any options the
> kernel doesn't know just get passed on to anaconda.

Is nodmraid enough? For some reason on a recent system I installed F10
Preview on I seemed to have to specify both nodmraid and nompath to
get multipath from taking over...

It would be a lot easier if you could choose which you wanted during
install time instead of having to figure out boot parameters.

-Dave
