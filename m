From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: imsm raid is always readonly on boot
Date: Wed, 08 Feb 2012 09:30:42 +0100
Message-ID: <4F3232B2.6010605@profihost.ag>
References: <4F3111D9.2060303@profihost.ag> <20120208125729.5674f35d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120208125729.5674f35d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Am 08.02.2012 02:57, schrieb NeilBrown:
> Probably mdmon isn't running for some reason.
> 
> For these arrays the metadata is managed in user-space by mdmon.
> Until it is ready to record failures the array must remain readonly.
> On of the first things it does is switch the array to read-write, having
> arranged to catch any failure notifications.
> 
> If you 
> 
>  mdmon --all --takeover
> 
> it might just start working.  However that doesn't explain why mdmon wasn't
> started at boot.  mdadm is meant to start it.
> There are some concerns about mdmon starting this way being not "the right
> thing" from a systemd perspective and there might be some issues there that
> are causing problems.

You're correct the mdmon does not run as the root filesystem is readonly
and it cannot create a pid file... and the root filesystem stays
readonly as the mdmon is not running...

Greets

Stefan
