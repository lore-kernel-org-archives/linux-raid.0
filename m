From: Neil Brown <neilb@suse.de>
Subject: Re: Why is sb->size set to 0 with raid0?
Date: Thu, 22 Jul 2010 23:02:54 +1000
Message-ID: <20100722230254.4d0a7d80@notabene>
References: <slrni4e7bi.ced.Mario.Holbe@darkside.dyn.samba-tng.org>
	<20100722153456.04f751e7@notabene>
	<20100722185054.51930d15@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100722185054.51930d15@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <roman@rm.pp.ru>
Cc: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 22 Jul 2010 18:50:54 +0600
Roman Mamedov <roman@rm.pp.ru> wrote:

> On Thu, 22 Jul 2010 15:34:56 +1000
> Neil Brown <neilb@suse.de> wrote:
> 
> > For RAID0 (and linear), there is no such number.  The devices can be of
> > different sizes and in each case "all" of the available space is used.
> 
> That sounds a bit surprising, excuse my ignorance, but how a RAID0 of
> differently-sized devices is laid out? Is the "tail" of the larger device
> simply used in linear mode, adding space to the striped "heads"?
> 

% man md

search for "RAID0"

read and enjoy.

NeilBrown
