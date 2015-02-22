From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Optimal chunk size for RAID5?
Date: Sun, 22 Feb 2015 17:30:47 +0500
Message-ID: <20150222173047.1ea65d67@natsu>
References: <mccemd$8pi$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <mccemd$8pi$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Christer Solskogen <christer.solskogen@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 22 Feb 2015 12:31:23 +0100
Christer Solskogen <christer.solskogen@gmail.com> wrote:

> There are so many different views on the internet

...and yet you're asking for some more? :)

> Is there even such a thing as optimal chunk size?

64K should be fine:
http://louwrentius.com/linux-raid-level-and-chunk-size-the-benchmarks.html

-- 
With respect,
Roman
