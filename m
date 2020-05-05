From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: RAID 1 | Test Booting from /dev/sdb
Date: Tue, 5 May 2020 11:49:00 +0200
Message-ID: <430ad5c7-0dda-8494-2abb-b79aad39a71a@thelounge.net>
References: <221092f3-5b8a-5d95-01d9-261e6449f747@peter-speer.de>
 <5EB12900.3030505@youngman.org.uk>
 <608e4d08-a99d-97f3-0476-3a880096f858@peter-speer.de>
 <5EB1333E.1010801@youngman.org.uk>
 <be57a390-734b-c215-aa59-e07c531354a0@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <be57a390-734b-c215-aa59-e07c531354a0@peter-speer.de>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 05.05.20 um 11:42 schrieb Stefanie Leisestreichler:
> On 05.05.20 11:34, Wols Lists wrote:
>> No. The journal or bitmap are stored as part of the array, not the
>> filesystem. sdb will have a load of "flags" set to say "these blocks
>> were written to while the array was degraded". So when sda is added back
>> in, these delayed writes will be copied from sdb to sda.
> 
> When sdb copies the changes it has in the blocks /var/log sits on, will
> this result in the array showing the changes made to /var/log when it
> was booted using sdb only or did I get this wrong?

the array is just fine and the filesystem on-top never takes any notice
because it's a different layer not knowing anything about the RAID

the array is just a block device like a single disk for upper layers
