From: Derek Vadala <derek@cynicism.com>
Subject: Re: Growing an Array?
Date: Mon, 11 Nov 2002 13:41:14 -0500 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021111184114.7BBDB3B807@jaded.cynicism.com>
References: <aqot4v$os5$1@cesium.transmeta.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <aqot4v$os5$1@cesium.transmeta.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11 Nov 2002, H. Peter Anvin wrote:

> Note that in large-scale data moves, like this, where you're reluctant
> to take the system offline: if you can put the new storage online
> (connected either to the same or a different server) you run the copy
> process while the data is still online, then when you close for the
> migration you can do an incremental update (rsync -aHS --delete is
> good for this; if you want to be extra paranoid at the expense of
> significantly slower execution rsync -acHS --delete.)  This is
> typically a lot quicker than copying all the data once offline.

This is exactly what I meant, sorry if I implied otherwise.

--
Derek Vadala, derek@cynicism.com, http://www.cynicism.com/~derek

