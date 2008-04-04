From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: segfault in mdadm v2.6.4
Date: Fri, 4 Apr 2008 12:05:16 +0200
Message-ID: <bb145bd20804040305o485cbf02u2abff0311fd35079@mail.gmail.com>
References: <2C1F2D1D-8799-4E11-8CDB-1827769496F3@cloud9.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2C1F2D1D-8799-4E11-8CDB-1827769496F3@cloud9.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: brett@cloud9.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>  Apr  4 00:36:46 frank kernel: mdadm[3954]: segfault at 0 rip 412d2c rsp
> 7fffcdd18fa0 error 4

The segfault after assemble is more or less "normal" with the Debian
version right now. Of course I haven't been able to reproduce it with
any consistency since I reported the bug :(

You might want to post exact array config + mdadm commandline used.

C.
