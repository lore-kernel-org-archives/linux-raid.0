From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: Re: mbr-install for Raid 1
Date: Tue, 5 Oct 2004 11:39:27 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20041005113927.04f41098@zrr.local>
References: <20041005093440.2b639e71@zrr.local>
	<41626483.60505@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41626483.60505@tls.msk.ru>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Thanks for your prompt and detailed response, I appreciate your time! I will post it on our website as well.

I done as follows and get the following:

On Tue, 05 Oct 2004 13:08:19 +0400
Michael Tokarev <mjt@tls.msk.ru> wrote:
> No, you would have to use boot=/dev/md0 in your lilo.conf,
> and install-mbr /dev/sd[abcd]1.

Now when I boot, I get

MBR FA: 

I hit A for 'Advanced', then I get:

MBR 1234A:

Then I hit '1' then I get:

MBR
MBR
MBR FA:

And nothing happens :-(

Any hints?

Thanks for your Feedback.

Zeno
