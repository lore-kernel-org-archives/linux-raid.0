From: Robert Schultz <rob@schultzfamily.ca>
Subject: Re: RAID 5 3-drive array failed 2 disks at once - can anything be
 saved?
Date: Thu, 19 Sep 2013 13:38:44 -0400
Message-ID: <523B36A4.30808@schultzfamily.ca>
References: <52332763.30901@schultzfamily.ca> <52347194.7010602@turmel.org> <52361B98.9030705@schultzfamily.ca> <52365AE8.5010807@turmel.org> <523A619F.90302@schultzfamily.ca> <523A8D2F.1050900@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <523A8D2F.1050900@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

Seatools tells me the drive is bad. It found bad sectors and 'repaired' 
them, then the disk passed the test. After the second failure Seatools 
found more bad sectors. I have to assume it's the disk.

  It is less than 3 months old. However I didn't register it so the 
default warranty ends in Nov. Good thing I keep receipts.

Thanks for you help.
Rob



On 13-09-19 01:35 AM, Phil Turmel wrote:
> On 09/18/2013 10:29 PM, Robert Schultz wrote:
>> That all worked beautifully. Right up until I left the BackupPC running
>> against a RAID array with a bad disk.
>>
>> It failed again after about 30 hours. The symptoms are the same.
>>
> Ah, well.  "Smart" can't catch everything.  Do consider that you might
> have some other hardware problem, though.  Power supply, data cable, etc.
>
>

