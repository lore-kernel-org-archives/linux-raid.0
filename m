From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: [PATCH 001 of 6] md: Send online/offline uevents when an md array starts/stops.
Date: Thu, 2 Nov 2006 13:13:56 +0100
Message-ID: <3ae72650611020413q797cf62co66f76b058a57104b@mail.gmail.com>
References: <20061031164814.4884.patches@notabene> <1061031060046.5034@suse.de>
	 <20061031211615.GC21597@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061031211615.GC21597@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Greg KH <gregkh@suse.de>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@osdl.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On 10/31/06, Greg KH <gregkh@suse.de> wrote:
> On Tue, Oct 31, 2006 at 05:00:46PM +1100, NeilBrown wrote:
> >
> > This allows udev to do something intelligent when an
> > array becomes available.
> >
> > cc: gregkh@suse.de
> > Signed-off-by: Neil Brown <neilb@suse.de>
>
> Acked-by: Greg Kroah-Hartman <gregkh@suse.de>

I don't agree with this, and asked several times to change this to
"change" events, like device-mapper is doing it to address the same
problem. Online/offline is not supported by udev/HAL and will not work
as expected. Please fix this.

Thanks,
Kay
