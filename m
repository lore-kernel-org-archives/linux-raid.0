From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: A raid in a raid.
Date: Sat, 21 Jul 2007 15:29:04 +0400
Message-ID: <46A1EE00.1090404@msgid.tls.msk.ru>
References: <11709647.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <11709647.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: mullaly <mullaly@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

mullaly wrote:
[]
> All works well until a system reboot. md2 appears to be brought up before
> md0 and md1 which causes the raid to start without two of its drives.
> 
> Is there anyway to fix this?

How about listing the arrays in proper order in mdadm.conf ?

/mjt

