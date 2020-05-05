From: Stefanie Leisestreichler <stefanie.leisestreichler@peter-speer.de>
Subject: Re: RAID 1 | Test Booting from /dev/sdb
Date: Tue, 5 May 2020 11:42:51 +0200
Message-ID: <be57a390-734b-c215-aa59-e07c531354a0@peter-speer.de>
References: <221092f3-5b8a-5d95-01d9-261e6449f747@peter-speer.de>
 <5EB12900.3030505@youngman.org.uk>
 <608e4d08-a99d-97f3-0476-3a880096f858@peter-speer.de>
 <5EB1333E.1010801@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5EB1333E.1010801@youngman.org.uk>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 05.05.20 11:34, Wols Lists wrote:
> No. The journal or bitmap are stored as part of the array, not the
> filesystem. sdb will have a load of "flags" set to say "these blocks
> were written to while the array was degraded". So when sda is added back
> in, these delayed writes will be copied from sdb to sda.

When sdb copies the changes it has in the blocks /var/log sits on, will 
this result in the array showing the changes made to /var/log when it 
was booted using sdb only or did I get this wrong?
