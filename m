From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Questions about 4k sector drives
Date: Mon, 3 May 2010 09:38:58 -0400
Message-ID: <4BDED1F2.102@cfl.rr.com>
References: <4BD42B57.9000703@kusche.de> <1272206601.7734.4.camel@faldara>	 <4BDE0512.8070502@tmr.com> <x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <x2v87f94c371005030630idaaad1e9ue3faff470bd318e1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Florian Kusche <flox@kusche.de>, linux-raid@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

On 5/3/2010 9:30 AM, Greg Freemyer wrote:
> In theory 4K physical sector drives with XP alignment will eventually
> ship and possibly have already.
> 
> The alignment maybe controlled via a jumper, or could be set in the
> factory.  Its up to the manufacturer so there is no way to predict.
> 
> These drives will need partitions/stripes etc. aligned to 31.5K, not 1MB.

The WD drives have such a jumper, but it is not set by default and WD
highly recommends NOT using it since it will only produce optimal
results with XP.

> I don't know it any those drives exist yet, or if they ever will.  But
> the kernel topology info specifically supports providing the above
> info and aiui parted uses it to choose the best partition layout.

AFAICS the kernel has a means of providing that information to user
space, and parted will use it if it is provided, but the kernel has no
means of obtaining that informati9on from the drive, so it is always
left as unknown, so parted defaults to 1 MB alignment like Windows 7.
