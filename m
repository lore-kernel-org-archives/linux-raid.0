From: Miles Fidelman <mfidelman@meetinghouse.net>
Subject: Re: 3TB drives failure rate
Date: Sun, 28 Oct 2012 18:24:13 -0400
Message-ID: <508DB08D.20002@meetinghouse.net>
References: <11510711257.20121028131527@oudeis.org> <508D61A1.7020106@wildgooses.com> <508D65CF.1080904@gmail.com> <508DADC3.4080104@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <508DADC3.4080104@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

joystick wrote:
>
> This thing of "drives falling out of RAID" I have heard many times, 
> but really don't know what people are talking about.
> How could a drive fall out of a RAID? A RAID is nothing special, it's 
> just read/write commands given to a drive by a process called MD.
> If the drive drops out of RAID it means it would have dropped out of a 
> normal computer doing normal I/O
> Please explain

The RAID erroneously thinks that a drive has failed, and drops it from 
the array.


-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra

