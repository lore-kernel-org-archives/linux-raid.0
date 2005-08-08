From: "Mark Cuss" <mcuss@cdlsystems.com>
Subject: Re: How to force a spare drive to take over in a RAID5?
Date: Mon, 8 Aug 2005 15:43:39 -0600
Message-ID: <012701c59c62$3db09d40$ab0e10ac@pinchy>
References: <45138.213.188.237.106.1123086677.squirrel@localhost><20050804195853.0866ade9.akpm@osdl.org><34082.213.188.237.106.1123228569.squirrel@localhost> <20050805010236.12d811ff.akpm@osdl.org> <006301c599ca$69410700$ab0e10ac@pinchy> <42F5F0B0.3050105@dgreaves.com>
Reply-To: "Mark Cuss" <mcuss@cdlsystems.com>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: david@dgreaves.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kernel 2.4.27

I've been using the old raidtools stuff and am new to mdadm - sorry if this 
is a obvisouly simply question...

After perusing the man page, is looks to me that I should use mdadm to mark 
the drive I want to remove as failed to force a rebuild on the spare drive. 
I want to double check that this is correct first though, as this md device 
contains 300 gig of production data.

Thanks for the help!

Mark

----- Original Message ----- 
From: "David Greaves" <david@dgreaves.com>
To: "Mark Cuss" <mcuss@cdlsystems.com>
Cc: <linux-raid@vger.kernel.org>
Sent: Sunday, August 07, 2005 5:29 AM
Subject: Re: How to force a spare drive to take over in a RAID5?


> Mark Cuss wrote:
>
>> Hi!
>>
>> I have a 4 drive SW RAID5 running on my machine.  One of the drives is
>> upset for some reason - I'm not sure if the drive itself is bad, but
>> that's not too important right now.  The important thing is to get the
>> RAID5 to stop using this drive and start using a spare drive that I
>> just added.
>
>
>> I did a raidhotadd to add in a new drive, sds.  Now, I would like the
>> array to stop using sdr and reconstruct all of the parity tables on
>> sds so I can pull sdr and get it replaced or whatever...
>>
>> Any ideas?
>
> Install and read the manpage for mdadm
>
> What kernel version?
>
> David
> 


