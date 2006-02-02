From: dean gaudet <dean@arctic.org>
Subject: Re: Configuring combination of RAID-1 RAID-5
Date: Wed, 1 Feb 2006 21:06:58 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0602012052250.12264@twinlark.arctic.org>
References: <20060131163248.M20133@mail.uadec.mx>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060131163248.M20133@mail.uadec.mx>
Sender: linux-raid-owner@vger.kernel.org
To: Enrique Garcia Briones <egarcia@mail.uadec.mx>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 31 Jan 2006, Enrique Garcia Briones wrote:

> I have read the setting-up for the raid-5 and 1, but I would like to ask you 
> if I can set-up a combined RAID configuration as mentioned above, since all 
> the examples I found upto now just talk of one RAD configuration

you can have more than one /dev/mdN device no problem...

if you've got a raid1 root disk setup on a box with raid5/6, and you want 
to use a journalling filesystem on the raid5/6 you should seriously 
consider saving space on the root disk for an external journal for the 
raid5/6 filesystem.  it really helps metadata-heavy operations to offload 
the journal writes to the raid1 spindles.

-dean
