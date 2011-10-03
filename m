From: maurice <mhilarius@gmail.com>
Subject: Re: How to stress test an RAID 6 array?
Date: Mon, 03 Oct 2011 10:16:23 -0600
Message-ID: <4E89DFD7.60609@gmail.com>
References: <4E89B81D.5000800@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E89B81D.5000800@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/3/2011 7:26 AM, Marcin M. Jessa wrote:
> Hi guys.
>
> After a rather long thread with many questions about my failed RAID 
> array I'm trying to give it another shot.
> ..
>
> Now I would like to stress test the array and see whether it would 
> fail again or not. What would be the best way to do that?
FIO is a good tester and benchmark program.

http://freshmeat.net/projects/fio/

There are some example scripts packed in the distribution.
One simulates IOMeter server test and creates a decent loading.


-- 
Cheers,

Maurice Hilarius
mailto:mhilarius@gmail.com

