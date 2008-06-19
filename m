From: Neil Brown <neilb@suse.de>
Subject: Re: Rebuilding an array with a corrupt disk.
Date: Thu, 19 Jun 2008 14:57:43 +1000
Message-ID: <18521.59207.717842.199253@notabene.brown>
References: <fa037c550806131922y475de7ew8c3a66aa06d081b1@mail.gmail.com>
	<4853634C.90508@dgreaves.com>
	<fa037c550806140354k7bcab83fs39738e165f3aba8d@mail.gmail.com>
	<4853AFCF.5050209@dgreaves.com>
	<fa037c550806150454v68089bcbg50203b454ae593e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Sean Hildebrand on Sunday June 15
Sender: linux-raid-owner@vger.kernel.org
To: Sean Hildebrand <silverwraithii@gmail.com>
Cc: David Greaves <david@dgreaves.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday June 15, silverwraithii@gmail.com wrote:
> 
> Is there no way to get mdadm to allow a certain number of read errors
> from a disk, instead of removing it from the array immediately?
> Manually unmounting, stopping, and re-assembling is somewhat of a
> chore, especially when the system locks access to the array while
> copying, despite the read error.

No, there isn't.

It might make sense to arrange that if the array is flagged as
"read-only" (mdadm -r /dev/mdX), then rather than failing a drive, any
read error is passed up to the filesystem.... I'll put it on my todo
list (which isn't much of a promise).

NeilBrown
