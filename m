From: maarten <maarten@ultratux.net>
Subject: Re: combining two raid systems
Date: Thu, 13 Jan 2005 23:30:01 +0100
Message-ID: <200501132330.01312.maarten@ultratux.net>
References: <200501132017.16910.maarten@ultratux.net> <200501132127.07764.maarten@ultratux.net> <eaa6dfe050113132247a79efd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <eaa6dfe050113132247a79efd@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 13 January 2005 22:22, Derek Piper wrote:
> Maarten, I'm curious as to how you get on with LVM. I've been looking

Tis working fine.

> around and have seen that LVM seems to be a Bad Idea to run it on the
> root FS, and devfs seems to be scary also, so I wasn't going to even

Possibly, but whoever said I run LVM for my root fs ?  I don't.
Not that would advice against using it, but as it happens my OS is not on LVM.
Only my data is. 

> attempt any of that. I know Robin Bowes mentioned he uses LVM in that
> way, to 'carve up' a large RAID array. I'm curious if other people do
> that too and if they've had any problems. I'm not even sure of the
> maturity of the LVM stuff, anyone got any words of wisdom?

LVM still is new to me, so no words of wisdom from me...
But it does work as expected so far.

> Derek

Maarten


