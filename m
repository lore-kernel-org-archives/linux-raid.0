From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID-6 support in kernel?
Date: Wed, 5 Jun 2002 11:28:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200206050928.g559SJ414422@mail.pronto.tv>
References: <Pine.LNX.4.33.0206031020290.30424-100000@mail.pronto.tv> <20020603113128.C13204@ucw.cz> <20020604154904.J36@toy.ucw.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020604154904.J36@toy.ucw.cz>
To: Pavel Machek <pavel@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>
Cc: Derek Vadala <derek@cynicism.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Tedd Hansen <tedd@konge.net>, Christian Vik <christian@konge.net>, Lars Christian Nygaard <lars@snart.com>
List-Id: linux-raid.ids

> RAID-1 over two RAID-5s should withstand any three failures, AFAICS.
>
> You could do RAID-5 over RAID-5. That should survive any 2 failures and
> still be reasonably efficient.

Sure, but still: Is there a good reason why RAID-6 shouldn't be implemented 
in linux?

-- 
Roy Sigurd Karlsbakk, Datavaktmester

Computers are like air conditioners.
They stop working when you open Windows.
