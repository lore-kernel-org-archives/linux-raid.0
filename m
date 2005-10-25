From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: split RAID1 during backups?
Date: Tue, 25 Oct 2005 14:13:27 -0400
Message-ID: <435E75C7.7080702@steeleye.com>
References: <E1EUFcV-0005s3-00@toko.jab.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1EUFcV-0005s3-00@toko.jab.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Breidenbach <jeff@jab.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Breidenbach wrote:

> your suggestion about kernel 2.6.13 and intent logging and
> having mdadm pull a disk sounds like a winner. I'm going to to try it
> if the software looks mature enough. Should I be scared?

There have been a couple bug fixes in the bitmap stuff since 2.6.13 was 
released, but it's stable. You'll need mdadm 2.x as well.

--
Paul
