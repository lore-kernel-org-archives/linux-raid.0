From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Raid 5 to 6 reshape q
Date: Sat, 02 Jan 2010 12:08:19 +0000
Message-ID: <4B3F3733.1030804@anonymous.org.uk>
References: <625563.35920.qm@web51308.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <625563.35920.qm@web51308.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@eHardcastle.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/01/2010 08:52, Jon Hardcastle wrote:
> Hi guys, thanks for your help getting me going with this over the last week. I kicked it off last night and all is well.
> 
> The only Q i have is it seems to be abit slow? When i kicked it off it insisted that i give a backup file --backup-file that i set to /root/backupfile and now the reshape seems to be constantly accessing my md3 as well as the md4 (the one that is being reshaped) i have set the min and max that is used when i am rebuilding the array/testing
[...]
> As you can see lots of write access to md3 and low level read/write to the constituent drives of md4 
> 
> Does this seem ok? or is it slow (like i suspect!) 

Because the entire reshape has to happen "in place", every chunk/stripe 
must be backed up. This makes things slow, as Neil explains in his blog 
here at http://neil.brown.name/blog/20090817000931#2 :
> This means that all the data is copied twice, once to the backup and once to the new layout on the array. This clearly means that such a reshape will go very slowly. But that is the price we have to pay for safety. It is like insurance. You might hate having to pay it, but you would hate it much more if you didn't and found that you needed it.

So I think the answer is that you'll have to be very patient.

Cheers,

John.
