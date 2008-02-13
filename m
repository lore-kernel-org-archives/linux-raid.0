From: "Jeff Breidenbach" <jeff@jab.org>
Subject: Re: transferring RAID-1 drives via sneakernet
Date: Tue, 12 Feb 2008 19:14:36 -0800
Message-ID: <e03b90ae0802121914q595a492ft844bde202bd09a0d@mail.gmail.com>
References: <e03b90ae0802111659v2889dc52kc6eed9dfc9478f9e@mail.gmail.com>
	 <47B1633F.5030403@dgreaves.com>
	 <e03b90ae0802121050t192fba6ai5c10338844a60a05@mail.gmail.com>
	 <47B1ECD2.8070406@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47B1ECD2.8070406@redhat.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Brendan Conoboy <blc@redhat.com>
Cc: David Greaves <david@dgreaves.com>, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> It's not a RAID issue, but make sure you don't have any duplicate volume
> names.  According to Murphy's Law, if there are two / volumes, the wrong
> one will be chosen upon your next reboot.

Thanks for the tip. Since I'm not using volumes or LVM at all, I should be
safe from this particular problem.
