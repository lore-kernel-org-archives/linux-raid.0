From: David Greaves <david@dgreaves.com>
Subject: Re: Rebuilding an array with a corrupt disk.
Date: Sun, 15 Jun 2008 14:32:14 +0100
Message-ID: <485519DE.90706@dgreaves.com>
References: <fa037c550806131922y475de7ew8c3a66aa06d081b1@mail.gmail.com>	 <4853634C.90508@dgreaves.com>	 <fa037c550806140354k7bcab83fs39738e165f3aba8d@mail.gmail.com>	 <4853AFCF.5050209@dgreaves.com> <fa037c550806150454v68089bcbg50203b454ae593e0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550806150454v68089bcbg50203b454ae593e0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sean Hildebrand <silverwraithii@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sean Hildebrand wrote:
> I got all my data, save the eleven folders that read errors occurred
> in - Thankfully the data lost isn't terribly important.
Good.


> Is there no way to get mdadm to allow a certain number of read errors
> from a disk, instead of removing it from the array immediately?
> Manually unmounting, stopping, and re-assembling is somewhat of a
> chore, especially when the system locks access to the array while
> copying, despite the read error.
Not that I know of.

Since you got your data back it's moot .... but:

You couldn't add /dev/sdd1 because the raid superblock is at the end of the disk
- clearly readable though since it was read at startup.
The next thing would have been to force a recreation of the array using the new
disk.

Anyhow, glad you're sorted

David
