From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: add support for rmw writes in raid6
Date: Mon, 29 Apr 2013 17:05:39 -0700
Message-ID: <CAA9_cme5Atj2y7aetaRDfiyaBERk-rWCOkw5k7=9YrgcKzYc7w@mail.gmail.com>
References: <BA07AEDCFD3B5B4DAB0FF1D7B35E42DC5544BCFA@PRN-MBX01-4.TheFacebook.com>
	<517EC9D8.8000805@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517EC9D8.8000805@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: Kumar Sundararajan <kumar@fb.com>, NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Apr 29, 2013 at 12:28 PM, David Brown <david.brown@hesbynett.no> wrote:
> For each data block you are changing, you will need to remove the old g^i *
> Di_old then add in the new g^i * Di_new, so you can still use this
> simplification to reduce the number of multiplies.  If you want to change
> blocks "i" and "j", you thus do:
>
> Q_new = Q_old + g^i * (Di_old + Di_new) + g^j * (Dj_old + Dj_new)
>
> But as I say, I only know the maths - not the code.

The issue is where to store those intermediate Di_old + Di_new results
without doubling the size of the stripe cache.
