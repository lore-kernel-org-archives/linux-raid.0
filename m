From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Tue, 19 Jan 2016 15:35:07 +0100
Message-ID: <bb6cce6b0d5bb6c653ef94e4a58388cf@pingofdeath.de>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
 <56429326.5030405@turmel.org>
 <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
 <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
 <569D384F.6070208@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <569D384F.6070208@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

I forgot to add some information: when I was creating the bytestrings 
from my jpg file, I did not start from 0k but from 100k of the jpg file 
(to skip the jpg header).

> Very interesting.  You could go one step further and compare the jpeg
> file contents in the first 1M against the locations found to determine
> where the chunks actually start and end on each device.  The final
> offset will be a chunk multiple before these boundaries.  Or do md5 
> sums
> of 4k blocks to reduce the amount to inspect.

How exactly can I do this? Should I create more Bytestrings and do more 
brep with them on my physical devices? I have already results from 
searching bytestrings with an offset of 64k (starting from 100k to 612k 
of my jpeg file, so 9 bytestrings at all). Should I provide a table of 
the results?

> This will help (and looks correct), but I don't remember what we did to
> try to find the beginning of your filesystem.  Did we search for a
> filesystem signature?  Please re-summarize that.

Yes, we were searching for an ext4 signature, there were some fragments 
of old file systems, but you also found two promising signatures, both 
with this timestamp: Sun, 08 Nov 2015 20:06:00 GMT (which is 
approximately the last time I mounted the filesystem)

here is a link to the archived message:

http://www.spinics.net/lists/raid/msg50433.html

the device names have changed from the archived post to now:

sdb -> sdf  Serial Number: JK1170YBHYV6MD
sdc -> sdc  Serial Number: JK1100YAG64A1T
sdd -> sde  Serial Number: JK1121YAG7YDLS
sde -> sdd  Serial Number: ML0220F30PZUVD

Thanks and best regards

Mathias
