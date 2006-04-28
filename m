From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: [PATCH 003 of 5] md: Change ENOTSUPP to EOPNOTSUPP
Date: Fri, 28 Apr 2006 15:34:48 +0200
Message-ID: <62b0912f0604280634x7df2a8a5m9022826876446cb6@mail.gmail.com>
References: <20060428124313.29510.patches@notabene>
	 <1060428025144.30770@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1060428025144.30770@suse.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> Change ENOTSUPP to EOPNOTSUPP
> Because that is what you get if a BIO_RW_BARRIER isn't supported !

Dumb question, hope someone can answer it :).

Does this mean that any version of MD up till now won't know that SATA
disks does not support barriers, and therefore won't flush SATA disks
and therefore I need to disable the disks's write cache if I want to
be 100% sure that raid arrays are not corrupted?

Or am I way off :-).
