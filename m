From: Beolach <beolach@gmail.com>
Subject: Re: documentation for echo check > /dev/mdX, etc.
Date: Mon, 7 Nov 2011 10:22:39 -0700
Message-ID: <CADc_k_tCFqa72NAMGmqLTT0X7zzKitCC1bSsRHZRYzkweuRdig@mail.gmail.com>
References: <CAK2H+eckKo+enZf8s51R2Dh-Vz1X-LM5apOLKBoGceNxD4x88g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+eckKo+enZf8s51R2Dh-Vz1X-LM5apOLKBoGceNxD4x88g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Nov 4, 2011 at 11:57, Mark Knecht <markknecht@gmail.com> wrote:
> Where do I find documentation on what a command like
>
> echo check >> /sys/block/mdX/md/sync_action
>
> is doing and where it reports errors if it finds any?
>
> Thanks,
> Mark

The md(4) man page, under the title "Scrubbing and Mismatches".


Good luck,
Conway S. Smith
