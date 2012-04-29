From: Shaya Potter <spotter@gmail.com>
Subject: Re: recovering from raid5 corruption
Date: Sun, 29 Apr 2012 19:41:50 -0400
Message-ID: <4F9DD1BE.4080109@gmail.com>
References: <4F9DC2E5.1090509@gmail.com> <20120430085257.65d19c20@notabene.brown> <4F9DCEC6.1050109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F9DCEC6.1050109@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/29/2012 07:29 PM, Shaya Potter wrote:
>
> however, now I need to figure out how to recreate the lvm appropriately.
> I see the configuration "file" in at the start of the raid array (less
> -f /dev/md0 which I'm including below)
>
> I asusme there should be a way to reuse this data to recreate the lvm?
>
> any continued advice would be appreciated, googling doesn't seem to come
> up with much if one doesn't have a backup of the lvm data.

<configuration snipped>

found an old linux journal article that seems to say what I should do, 
but not working.

http://www.linuxjournal.com/article/8874?page=0,2

root@nas:~# vgcfgrestore -f 1.cfg raid5
   Incorrect metadata area header checksum
   Incorrect metadata area header checksum
   Restore failed.
