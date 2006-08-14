From: Henrik Holst <henrik.holst@idgmail.se>
Subject: Re: Making bootable SATA RAID1 array in Mandriva 2006
Date: Mon, 14 Aug 2006 12:34:47 +0200
Message-ID: <44E051C7.8020805@idgmail.se>
References: <44DFBB0E.90705@aol.com> <20060814081714.GI19306@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060814081714.GI19306@percy.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Luca Berra wrote:
> On Sun, Aug 13, 2006 at 07:51:42PM -0400, andy liebman wrote:
>> -- I copied the contents of /dev/sda1 (/ partition) and /dev/sda6
>> (/home partition) to /dev/sdb1 and /dev/sdb6 using rsync.
> this is not really important, but you should have used the raid devices
> as a target.

Just a question. Did you copy the file system or the block device? I am
not familiar with rsync but I can think that it is a problem to sync the
file system so the block devices become 1:1 with each other.

Henrik Holst
