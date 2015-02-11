From: Phil Turmel <philip@turmel.org>
Subject: Re: dead RAID6 array on CentOS6.6 / kernel 3.19
Date: Tue, 10 Feb 2015 22:08:20 -0500
Message-ID: <54DAC7A4.40407@turmel.org>
References: <54DAB614.70302@athompso.net> <54DAC0E2.2070303@turmel.org> <54DAC42F.3090600@athompso.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DAC42F.3090600@athompso.net>
Sender: linux-raid-owner@vger.kernel.org
To: athompso@athompso.net, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Adam,

{ Dropped members-only lists from CC }

On 02/10/2015 09:53 PM, Adam Thompson wrote:

>> [root@muug ~]# mdadm --verbose --misc --run --readonly /dev/md127
>> mdadm: /dev/md127 does not appear to be active.
> 
> 
> Also, kernel 3.19, which I mentioned we're running, pretty much *is* my
> definition of an up-to-date kernel... how much newer do you want me to
> try, and where would you recommend I find such a thing in a bootable image?

You're right, 3.19 should be fine.  I'm stumped.  Looks like a bug.
Adding Neil ....

Phil

