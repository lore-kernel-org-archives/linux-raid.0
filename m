From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Still can't get md arrays that were started from an initrd to shutdown
Date: Tue, 18 Jul 2006 11:19:22 +0200
Message-ID: <bb145bd20607180219u5caee49dv3af20f9cd73944e5@mail.gmail.com>
References: <bb145bd20607171355x8143b0eofb0017637d749263@mail.gmail.com>
	 <Pine.LNX.4.64.0607171942271.2393@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0607171942271.2393@twinlark.arctic.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> with lvm you have to stop lvm before you can stop the arrays... i wouldn't
> be surprised if evms has the same issue...

AFAIK there's no counterpart to evms_activate.

Besides, I'm no longer using EVMS, I just included it in my testing
since this issue bit me there first.

Thanks,

Christian
