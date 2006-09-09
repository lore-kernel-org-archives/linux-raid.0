From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: UUID's
Date: Sat, 09 Sep 2006 16:15:27 +1200
Message-ID: <45023FDF.3060606@sauce.co.nz>
References: <4501E9C6.10403@sauce.co.nz> <Pine.LNX.4.64.0609082011050.8584@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0609082011050.8584@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

dean gaudet wrote:
> 
> On Sat, 9 Sep 2006, Richard Scobie wrote:
> 
> 
>>If I have specified an array in mdadm.conf using UUID's:
>>
>>ARRAY /dev/md0 UUID=3aaa0122:29827cfa:5331ad66:ca767371
>>
>>and I replace a failed drive in the array, will the new drive be given the
>>previous UUID, or do I need to upate the mdadm.conf entry?
> 
> 
> once you do the "mdadm /dev/mdX -a /dev/newdrive" the new drive will have 
> the UUID.  no need to update the mdadm.conf for the UUID...
> 
> however if you're using "DEVICE foo" where foo is not "partitions" then 
> you should make sure foo includes the new drive.  ("DEVICE partitions" is 
> recommended.)

Thanks Dean,

I am setting up a Fedora 5 machine, which I configured to use RAID1 for 
all partions during the install and the resulting madadm.conf it 
generated is:

DEVICE partitions
MAILADDR root
ARRAY /dev/md3 super-minor=3
ARRAY /dev/md1 super-minor=1
ARRAY /dev/md4 super-minor=4
ARRAY /dev/md0 super-minor=0
ARRAY /dev/md2 super-minor=2

To remove all doubt about what is assembled where, I though going to:

DEVICE partitions
MAILADDR root
ARRAY /dev/md3 UUID=xyz etc.

would be more secure.

Is this correct thinking on my part?

Regards,

Richard
