From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Help, big error, dd first GB of a raid:-/
Date: Wed, 30 Jan 2008 13:40:24 +0100
Message-ID: <47A07038.9040001@rabbit.us>
References: <47A054D4.9030308@cgv.tugraz.at> <47A0696B.4030301@rabbit.us> <47A06F40.9010705@cgv.tugraz.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47A06F40.9010705@cgv.tugraz.at>
Sender: linux-raid-owner@vger.kernel.org
To: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lars Schimmer wrote:

> I activate the backup right now - was OpenAFS with some RW volumes -
> fairly easy to backup, but...
> If it's hard to recover raid data, I recreate the raid and forget the
> old data on it.

It is not that hard to recover the raid itself, however the ext3 on top is 
most likely FUBAR (especially after 1GB was overwritten). Since like it seems 
the data is not that important to you, just roll back to a backup and move on.
