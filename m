From: Phil Turmel <philip@turmel.org>
Subject: Re: RAID6 reshape stalls immediately
Date: Mon, 9 Nov 2015 08:38:53 -0500
Message-ID: <5640A1ED.3010205@turmel.org>
References: <84a8qtgwqk.wl-peter.chubb@nicta.com.au>
 <563CAFC1.2080708@gmail.com> <84611dw2cw.wl-peter.chubb@nicta.com.au>
 <56409F4E.5000508@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56409F4E.5000508@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anugraha Sinha <asinha.mailinglist@gmail.com>, Peter Chubb <peter.chubb@nicta.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/09/2015 08:27 AM, Anugraha Sinha wrote:

> I am looping in to Phil explicitly for some help here.
> 
> @Phil,
> Need some help here!

I don't know why it's stuck.  This has never happened to me :-).

Neil helped someone recently with a similar problem, and suggested
omitting the backup-file.  It isn't needed for --grow operations that
increase capacity.  I also recall some discussions about systemd vs.
mdmon issues -- if that applies to you.

If omitting the --backup-file fails, I would reboot into a rescue CD
with a recent kernel and mdadm version.  I recommend www.sysrescuecd.ord
for such things.  Then use mdadm --grow --continue within the rescue
environment.

Phil
