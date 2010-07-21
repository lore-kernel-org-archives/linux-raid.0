From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: Missing Drives
Date: Tue, 20 Jul 2010 22:06:31 -0400
Message-ID: <4C465627.5050002@meetinghouse.net>
References: <201007210129.41566.james@howells.uk.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201007210129.41566.james@howells.uk.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

James Howells wrote:
> Basically, I have a 5 disk RAID-5 array in an Addonics external enclosure.
> Each disk is 1TB in size. Since I am running it over USB, it's takes 3-3.5
> days to resync the disks if something goes pear-shaped.
>
>    
I can't speak to your underlying problem, but if you add an internal (or 
external) bitmap to your array, it speeds up rebuild time considerably.

At create time, you can use the " --bitmap=internal " option.  I know 
you can also add a bitmap to an existing array, but I don't remember the 
magic incantation at the moment (you can probably find it by searching 
the list archives - the topic has come up before).  Or google "write 
intent bitmap."

Miles Fidelman

-- 
In theory, there is no difference between theory and practice.
In<fnord>  practice, there is.   .... Yogi Berra


