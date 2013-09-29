From: David Brown <david.brown@hesbynett.no>
Subject: Re: Which filesystem for a hybris raid1?
Date: Sun, 29 Sep 2013 21:41:11 +0200
Message-ID: <52488257.6080105@hesbynett.no>
References: <5246E543.1030201@hanswkraus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5246E543.1030201@hanswkraus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hans Kraus <hans@hanswkraus.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/09/13 16:18, Hans Kraus wrote:
> Hi,
>
> I will move the root of my server to a hybrid raid1. Which filesystem
> should I choose: F2FS or Ext4? The /boot stays on a separate partition.
>
> Regards, Hans

F2FS is very much in development, and I don't think it is ready for 
"prime time" yet.  It is an interesting idea, but I would be sceptical 
about using it as a root fs.  I am also not sure how effective it will 
be as a filesystem on a hybrid with a hard disk as well as an SSD.

<http://lwn.net/Articles/518988/>

