From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: "bitmap" line in /proc/mdstat
Date: Fri, 14 Oct 2016 15:59:20 +0200
Message-ID: <5800E4B8.9040205@bluewin.ch>
References: <5800AE09.70608@bluewin.ch>
 <8922e2e1-b612-fa32-6932-9f4158f52fe6@turmel.org>
 <5800D045.9060602@bluewin.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5800D045.9060602@bluewin.ch>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/10/16 14:32, Ramon Hofer wrote:
> How much disk space is used for a 12 TB RAID5 bitmap?

I have remove the bitmap with

# mdadm -G /dev/md5 -b none

Comparing the array sizes from before and afterwards it appears that the 
internal bitmap does not use any disk space.
Since the internal bitmap is part of the metadata this makes total sense.
Still I would imagine if I assume that a bit per chunck is needed and I 
use 128kB chuncks on the 11720662272 blocks of the 12TB RAID5 this is:
log(11720662272)/log(2) = 34 Bytes

Or am I totally wrong?


Best regards,
Ramon
