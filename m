From: Joe Landman <landman@scalableinformatics.com>
Subject: Re: RAID down, dont know why!
Date: Sun, 08 Nov 2009 09:07:21 -0500
Message-ID: <4AF6D099.5040407@scalableinformatics.com>
References: <4AF6CEFD.60309@gmail.com>
Reply-To: landman@scalableinformatics.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6CEFD.60309@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Dunn wrote:
> I just copied 4+ TiB of information to this array, restarted 5 times
> and tried to access it.... What is going on?

It looks like you have 4 failed drives. sdl,sdi,sdj,sdk

Is it possible you lost power or connectivity to those drives?

If you have lsscsi installed, what does lsscsi tell you about this?

lsscsi  | grep sd[ijkl]

Given the proximity of the drives in ordering, I'd suspect a power loss, 
or cable seating, or similar to those drives.

Reseat power/signal cables on the drive bays, and see if this helps.


Joe

-- 
Joseph Landman, Ph.D
Founder and CEO
Scalable Informatics, Inc.
email: landman@scalableinformatics.com
web  : http://scalableinformatics.com
        http://scalableinformatics.com/jackrabbit
phone: +1 734 786 8423 x121
fax  : +1 866 888 3112
cell : +1 734 612 4615
