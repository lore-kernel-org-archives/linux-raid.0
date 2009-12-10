From: Asdo <asdo@shiftmail.org>
Subject: Re: Disappointing performance of copy (MD raid + XFS)
Date: Thu, 10 Dec 2009 01:57:39 +0100
Message-ID: <4B204783.7040109@shiftmail.org>
References: <4B204334.1000605@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B204334.1000605@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: xfs@oss.sgi.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo wrote:
> and I think I have seen around 10MB/sec when they are of 500KB (this 
> transfer at 10MB/sec was in parallel with another faster one however). 
Yes I definitely confirm: right now I have just 1 rsync copy running, 
it's in a zone where files are around 500KB on average, and it's going 
at 9 MB/sec.
Stack traces of the writer process conform to what I have posted in my 
previous email, even now that the writer is the only process using the 
destination array.
