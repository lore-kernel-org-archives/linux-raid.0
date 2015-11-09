From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 reshape stalls immediately
Date: Mon, 9 Nov 2015 17:26:31 -0500
Message-ID: <56411D97.7020705@turmel.org>
References: <84a8qtgwqk.wl-peter.chubb@nicta.com.au>
 <563CAFC1.2080708@gmail.com> <84611dw2cw.wl-peter.chubb@nicta.com.au>
 <56409F4E.5000508@gmail.com> <5640A1ED.3010205@turmel.org>
 <84lha6u90k.wl-peter.chubb@nicta.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84lha6u90k.wl-peter.chubb@nicta.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Chubb <peter.chubb@nicta.com.au>
Cc: Anugraha Sinha <asinha.mailinglist@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/09/2015 05:02 PM, Peter Chubb wrote:

> I just did
>   mdadm --grow --continue /dev/md0
> 
> and the reshape started up again.  I didn't realise that mdadm had to
> keep going to do the reshape -- it must have died when I logged off
> last time.  So many other operations are handled entirely in the
> kernel...

mdadm spawns a copy of mdmon to perform these tasks.  If the process
hierarchy is strictly enforced, and kills off spawned processes when
the highest parent dies, that's a problem for mdadm.  I recall some
discussions about this with systemd and/or cgroups.  You might want
to make sure all of your utilities have the latest fixes.

Phil

