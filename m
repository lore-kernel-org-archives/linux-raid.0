From: Nicolas KAROLAK <nicolas.karolak@ubicast.eu>
Subject: Re: Recover RAID6 with 4 disks removed
Date: Thu, 6 Feb 2020 17:02:20 +0100
Message-ID: <20200206160220.ewhf3xlehyrwajmt@laptop>
References: <CAO8Scz75h0mTqePyyeehnY+706R=eUgh7DOOKyCaWWJfADRUVg@mail.gmail.com>
 <dfac6758-1539-6b63-1883-03d704c67bc4@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <dfac6758-1539-6b63-1883-03d704c67bc4@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 06, 2020 at 03:07:00PM +0100, Reindl Harald wrote:
> didn't you realize that RAID6 has redundancy to survive *exactly two*
> failing disks no matter how many disks the array has anmd the data and
> redundancy informations are spread ove the disks?

Not at the moment, i tested on a VM before but with 6 disks and removing 2
and then did it on the server without thinking/realizing than 4 is different
than 2 and that it would obsviously f**k the RAID array... (>_<')

> unlikely - the started reshape did writes

That's what i was afraid of. Thank you anyway for the answer.
