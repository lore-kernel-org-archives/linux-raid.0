From: Reindl Harald <h.reindl@thelounge.net>
Subject: Re: Recover RAID6 with 4 disks removed
Date: Thu, 6 Feb 2020 20:27:59 +0100
Message-ID: <a3f21c9e-afbd-6445-514c-2549f4f27d85@thelounge.net>
References: <CAO8Scz75h0mTqePyyeehnY+706R=eUgh7DOOKyCaWWJfADRUVg@mail.gmail.com>
 <dfac6758-1539-6b63-1883-03d704c67bc4@thelounge.net>
 <20200206160220.ewhf3xlehyrwajmt@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200206160220.ewhf3xlehyrwajmt@laptop>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Nicolas KAROLAK <nicolas.karolak@ubicast.eu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Am 06.02.20 um 17:02 schrieb Nicolas KAROLAK:
> On Thu, Feb 06, 2020 at 03:07:00PM +0100, Reindl Harald wrote:
>> didn't you realize that RAID6 has redundancy to survive *exactly two*
>> failing disks no matter how many disks the array has anmd the data and
>> redundancy informations are spread ove the disks?
> 
> Not at the moment, i tested on a VM before but with 6 disks and removing 2
> and then did it on the server without thinking/realizing than 4 is different
> than 2 and that it would obsviously f**k the RAID array... (>_<')

seriously?

but even without knowing what one is doing who sane in his mind removes
more than one disk at the same time from a working array with data?

restore your backups as you had the space to make dd-images i guess you
have made backups before such an operation

https://en.wikipedia.org/wiki/RAID

RAID 5 consists of block-level striping with distributed parity. Unlike
RAID 4, parity information is distributed among the drives, requiring
all drives but one to be present to operate

RAID 6 consists of block-level striping with double distributed parity.
Double parity provides fault tolerance up to two failed drives
