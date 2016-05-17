From: Erkki Seppala <flux@modeemi.cs.tut.fi>
Subject: Re: mdadm - stuck reshape operation
Date: Tue, 17 May 2016 23:01:44 +0300
Message-ID: <m49d1oko3mf.fsf@coffee.modeemi.fi>
References: <CAASHjeD2HqH=8ON_VSy1jbmR9NAK+NXQAmHjFw-PsW-gwNWB9g@mail.gmail.com>
	<22305.30340.565924.810276@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

"John Stoffel" <john@stoffel.org> writes:

> Are there any messages in the logs, or dmesg output after the stuff
> you showed?  Can you maybe 'strace' the mdadm process, or even go grab
> the latest version using git from:
>
>   git clone git://neil.brown.name/mdadm

I had a similar issue and tried to set up a reproduction in a virtual
machine - but then after trying to retry the reproduction after a
success I failed, constantly.

So I'm wondering is there some particular patch in that tree that might
affect this behavior? I'm using the mdadm 3.4 from Debian Unstable. I
would rather avoid converting my non-test array before I get some
confidence it won't stop in the middle :).

Thanks for insight,

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

