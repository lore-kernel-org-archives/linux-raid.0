From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: sector I/O error cause disk to be "faulty" in raid5
Date: Tue, 07 Jun 2011 09:53:50 +0100
Message-ID: <4DEDE71E.7090606@anonymous.org.uk>
References: <BANLkTikpcH=navhOAFA2Jw+CT+rQfpOwcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTikpcH=navhOAFA2Jw+CT+rQfpOwcg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hank peng <pengxihan@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/06/2011 14:28, hank peng wrote:
> Hi, everybody:
> In current raid5 implementation, if a r/w error occured at some
> specific sectors on a disk, the disk will be labeled as "faulty".
> Here, I want to say in most cases, this is failure indication of those
> sectors not the whole disk. Should we make some changes to be more
> reasonable?

It's already on the wishlist as a bad block map.

Cheers,

John.

