From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: future hardware
Date: Sun, 22 Oct 2006 15:02:06 +1300
Message-ID: <453AD11E.80801@sauce.co.nz>
References: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000901c6f509$1bd65560$eb00000a@mine3ad5e808fe>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dan wrote:

> 
> What are other users of mdadm using with the PCI-express cards, most cost
> effective solution?

I have been successfully using a pair of Addonics AD2SA3GPX1 cards, with
  4 x 500GB in a stacked RAID0 on top of a pair of RAID1 configuration.

The cards are cheap and use the sil24 driver, which seems to be one of
the better supported.

Performance is good - read/write speeds of 140MB/s in bonnie++ as I recall.

Regards,

Richard

