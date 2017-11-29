From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: New setup: partitions or raw devices
Date: Wed, 29 Nov 2017 17:44:39 +0100
Message-ID: <7f6abcbc-7dfa-0252-e9df-984e7e637936@thelounge.net>
References: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXj4wp-k2QQ0O8W2PDQEg9QHcWwPkOEOSzMgvtbV6b21Cw@mail.gmail.com>
Content-Language: de-CH
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



Am 29.11.2017 um 17:22 schrieb Gandalf Corvotempesta:
> Hi to all
> I have to setup some new servers, which is the best practise, currently?
> Should I use raw devices or partitions ? (one huge partition for mdadm, and then
> LVM on top of it)
> 
> Any advantage/drawbacks for both configurations?

i would make partitions for 2 reasons:

* leave some space free in case a replacement disk has
   a slighty different usebale size - some SSD's do
   this instead overprovisioning for wear leveling

* whenever you decide you replace it against SSD's
   free space will enhance the overall lifetime
