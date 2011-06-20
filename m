From: Phil Turmel <philip@turmel.org>
Subject: Re: Issues with auto assembling or RAID10 (imsm) on boot
Date: Mon, 20 Jun 2011 15:14:33 -0400
Message-ID: <4DFF9C19.1080801@turmel.org>
References: <C70A636B101FD44999B82525C3E92AFAD36F3E@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C70A636B101FD44999B82525C3E92AFAD36F3E@otis.burlington.evertz.tv>
Sender: linux-raid-owner@vger.kernel.org
To: Sandra Escandor <sescandor@evertz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Sandra,

On 06/20/2011 03:02 PM, Sandra Escandor wrote:

[...]

> in order for the RAID to initialize. I read that you are supposed to run
> that update-initramfs command if you change your mdadm.conf, but it
> appears that it didn't really do anything. What am I missing?

You appear to be doing the right things as a far as mdadm is concerned.  The difference is initramfs vs. full root fs.  That suggests that some kernel module or other piece of the imsm infrastructure isn't getting installed in your initramfs.

Can you share your complete dmesg?  (at least up through the point where you manually assembly after boot)

Phil
