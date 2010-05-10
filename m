From: Neil Brown <neilb@suse.de>
Subject: Re: homehost update
Date: Tue, 11 May 2010 09:40:56 +1000
Message-ID: <20100511094056.6d6b67d5@notabene.brown>
References: <20100510180635.GB2360@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100510180635.GB2360@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 May 2010 20:06:35 +0200
Piergiorgio Sartor <piergiorgio.sartor@nexgo.de> wrote:

> Hi all,
> 
> is it possible to update the "homehost" (array name) of a
> running array without stopping it and re-assembly with
> "-U hostname"?

I'm afraid not, no.  If it is an array that must be started at boot, you need
to modify the script that running "mdadm -A" - even if it is in an initrd :-(

NeilBrown


> 
> If yes, how?
> 
> Thanks,
> 
> bye,
> 

