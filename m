From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Raid 5 to 6 migration
Date: Tue, 05 Feb 2013 08:58:12 +0800
Message-ID: <51105924.5010407@fnarfbargle.com>
References: <BLU0-SMTP433B0BCF64D448CC81098D2C91C0@phx.gbl>,<510C0075.9010908@turmel.org> <COL114-W137DD8871889508BBF087BC91C0@phx.gbl> <510C07FA.4090405@turmel.org> <BLU0-SMTP45011D3540FEA010403D4ABC9010@phx.gbl> <5110005E.103@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5110005E.103@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Dominique <dcouot@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/02/13 02:39, Phil Turmel wrote:

> First item, greatest importance:  You are using Western Digital Green
> drives.  These are *unsafe* to use in raid arrays of any kind "out of
> the box".  They do *not* support SCTERC.  You *must* use a boot-up

Warning digression : How's this for odd. I have 10 WD20EARS drives in my 
machine and 9 of them support SCTERC. Firmware version is the same 
across all drives and I bought them at the same time.


