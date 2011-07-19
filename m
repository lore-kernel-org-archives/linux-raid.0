From: Pavel Herrmann <morpheus.ibis@gmail.com>
Subject: Re: data corruption after rebuild
Date: Tue, 19 Jul 2011 19:05:39 +0200
Message-ID: <2015932.L0f6vYYk3Y@bloomfield>
References: <2073005.NH8LALaxuD@bloomfield> <4879002.CX4iSyfhxZ@bloomfield> <20110719224819.7aa5582d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110719224819.7aa5582d@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 19 of July 2011 22:48:19 Roman Mamedov wrote:
> On Tue, 19 Jul 2011 18:35:26 +0200
> Well, this basically tells you what you already know - a part of the data
> you have was corrupted. In this case I think it's 3184 512-byte sectors,
> which is about 1.6MB total.

the number seems too low to me, I have about 2000 video files larger than 1GB 
on that array, and every one i tried has been corrupted enough to create 
almost unstoppable visual artifacts in hi-def video.


> How it got there and how to prevent that from
> happening in the future - that's a whole different question.

would ZFS in raidz2 mode be much better than raid6+ext4? I understand its not 
the topic of this list, but file-level checksummed rebuild looks like a nice 
feature


