From: David Brown <david@westcontrol.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 17:01:53 +0200
Message-ID: <ir0n05$s95$1@dough.gmane.org>
References: <595104.28955.qm@web65106.mail.ac2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <595104.28955.qm@web65106.mail.ac2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 16/05/2011 23:41, Gavin Flower wrote:
> Hi,
>
> Motivation, existing RAID-6 swap partition failed.  I am thinking I
> should recreate it in a new format, as currently it is 'Version :
> 0.90', rather than simply rebuild it.
>
> So 3 questions:
>
> (1) What further diagnostics should I run first, if any (note I am
> currently running badblocks on the drive that dropped out), and I
> have put the existing diagnostic info at the end of this email
>
>
> (2) What is the most appropriate RAID-6 format for a swap partition,
> keeping same the number of drives and overall capacity.
>
> (3) How to convert the existing /dev/md0 to the new format.
>
>

RAID-6 is a lot of overhead for a 5-drive array.  Unless you have plans 
to add more drives or resize it, you are going to get a lot faster 
performance with a raid-10,far layout at little extra space cost. 
RAID-6 is particularly slow for small writes, as the whole stripe needs 
to be read in for an update - I think that would hit swap usage pretty hard.

