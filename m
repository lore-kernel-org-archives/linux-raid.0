From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 20:01:29 +0800
Message-ID: <51139799.2070004@fnarfbargle.com>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com> <51137FB8.6060003@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51137FB8.6060003@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 18:19, Adam Goryachev wrote:

> problem. Is there some way to instruct the disk (overnight) to TRIM the
> extra blank space, and do whatever it needs to tidy things up? Perhaps
> this would help, at least first thing in the morning if it isn't enough
> to get through the day. Potentially I could add a 6th SSD, reduce the
> partition size across all of them, just so there is more blank space to
> get through a full day worth of writes?

I have 6 SSD's in a RAID10, and with 3.7.x (I forget which x - 2 or 3 
from memory) md will pass the TRIM down to the underlying devices (at 
least for RAID10 and from memory 1).

I have a cronjob that runs at midnight :

#!/bin/sh
export TIME="%E real\n%U user\n%S sys\n"
for i in / /home /raid10 ; do
	/usr/bin/time /home/brad/bin/fstrim -v $i
done

Based on the run times, and the bytes trimmed count I suspect it works.
All filesystems are ext4. Two of them are passed through encryption, but 
that passes TRIM down also. I do not have the discard option on any 
mounts (that way lies severe performance issues).

Regards,
Brad
