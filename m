From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: Disappointing RAID10 Performance
Date: Sun, 18 Oct 2009 15:01:39 +0400
Message-ID: <4ADAF593.2040906@msgid.tls.msk.ru>
References: <364346.70897.qm@web38808.mail.mud.yahoo.com> <4AD8BBC3.4030600@wpkg.org> 	<4AD9ECE4.3090202@shiftmail.org> <70ed7c3e0910171435s53521b47ia7e88eaf62d65eb9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910171435s53521b47ia7e88eaf62d65eb9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Asdo <asdo@shiftmail.org>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Majed B. Wrote:
> dd supports writing to multiple devices at once, but not reading from
> multiple inputs.

Count me intrigued.  I re-read linux dd manual page, POSIX docs about
dd and linux (coreutils) dd sources, and don't see the `multiple output'
thing.  Care to show how to do that?

Thanks.

/mjt
